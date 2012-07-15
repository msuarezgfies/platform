/**
 * 
 */
package org.wso2.carbon.hosting.mgt.service;


import org.apache.axis2.AxisFault;
import org.wso2.carbon.core.multitenancy.transports.TenantTransportInDescription;
import org.wso2.carbon.hosting.mgt.openstack.db.OpenstackDAO;
import org.wso2.carbon.hosting.mgt.utils.FileUploadData;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.wso2.carbon.core.multitenancy.TenantAxisConfiguration;

import org.wso2.carbon.core.AbstractAdmin;
import org.wso2.carbon.hosting.mgt.clients.AutoscaleServiceClient;
import org.wso2.carbon.hosting.mgt.utils.PHPAppsWrapper;
import org.wso2.carbon.hosting.mgt.utils.PHPCartridgeConstants;
import org.wso2.carbon.utils.multitenancy.MultitenantUtils;


/**
 * @author wso2
 *
 */
public class ApplicationManagementService extends AbstractAdmin{

    private static final Log log = LogFactory.getLog(ApplicationManagementService.class);
    public static final String FILE_DEPLOYMENT_FOLDER = "phpapps";
    AutoscaleServiceClient client;
    HashMap<String, String> imageIdtoNameMap;
    HashMap<Integer, String> tenantToPublicIpMap;
    OpenstackDAO openstackDAO;

    public ApplicationManagementService(){
        imageIdtoNameMap = new HashMap<String, String>();
    }

    public void initAutoscaler() throws AxisFault {
        client = new AutoscaleServiceClient(System.getProperty(PHPCartridgeConstants.AUTOSCALER_SERVICE_URL));
        client.init(true);
    }
    /**
         * Upload a File
         *
         * @param fileUploadDataList Array of data representing the PHP apps(.zip) that are to be uploaded
         * @return true - if upload was successful
         * @throws org.apache.axis2.AxisFault If an error occurs while uploading
         */
    public boolean uploadWebapp(FileUploadData[] fileUploadDataList ) throws AxisFault {

        File phpAppsDir = new File(getWebappDeploymentDirPath());

        if (!phpAppsDir.exists() && !phpAppsDir.mkdirs()) {
            log.warn("Could not create directory " + phpAppsDir.getAbsolutePath());
        }

        for (FileUploadData uploadData : fileUploadDataList) {
            String fileName = uploadData.getFileName();
            File destFile = new File(phpAppsDir, fileName);
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(destFile);
                uploadData.getDataHandler().writeTo(fos);
            } catch (IOException e) {
                handleException("Error occurred while uploading the PHP application " + fileName, e);
            } finally {
                try {
                    if (fos != null) {
                        fos.flush();
                        fos.close();
                    }
                } catch (IOException e) {
                    log.warn("Could not close file " + destFile.getAbsolutePath());
                }
            }

            log.info("Uploaded files" );
        }
        return true;
    }


    private void handleException(String msg, Exception e) throws AxisFault {
        log.error(msg, e);
        throw new AxisFault(msg, e);
    }


    protected String getWebappDeploymentDirPath() {
        return getAxisConfig().getRepository().getPath() + File.separator + FILE_DEPLOYMENT_FOLDER;
    }

    /**
     * Retrieve and display the applications
     */
    public String[] listPhpApplications() {

        log.info("Listing php apps");
        String phpAppPath = getWebappDeploymentDirPath();
        File phpAppDirectory = new File(phpAppPath);
        String[] children;

        if(!phpAppDirectory.exists()){
            // This return any files that ends with '.zip'.
            FilenameFilter filter = new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    return name.endsWith(".zip");
                }
            };
            children = phpAppDirectory.list(filter);
        }else {
            children = null;
        }
        return children;

    }

    public PHPAppsWrapper getPagedPhpAppsSummary(String phpAppSearchString, int pageNumber){
         PHPAppsWrapper phpAppsWrapper = new PHPAppsWrapper();
        phpAppsWrapper.setPhpapps(listPhpApplications());
        String[] phpApps= listPhpApplications();
        phpAppsWrapper.setPhpapps(phpApps);
        phpAppsWrapper.setEndPoints(getEndPoints(phpApps));
        phpAppsWrapper.setNumberOfPages(1);
        return phpAppsWrapper;
    }

    private String[] getEndPoints(String[] phpApps) {
        String[] endPoints;
        if(phpApps != null){
            endPoints = new String[phpApps.length];
            for(int i = 0; i < endPoints.length; i++){
                endPoints[i] = "https://" + "<tenant_ip>" + "/t/" + "tenant_id/" + phpApps[i];
            }
        }   else {
            endPoints = null;
        }
        return endPoints;
    }


    public void deleteAllPhpApps(){
        deleteApps(listPhpApplications());
    }

    public void deletePhpApps(String[] phpAppFileNames){
        deleteApps(phpAppFileNames);
    }

    private void deleteApps(String phpApps[]){
        File phpAppFile;
        for (String phpApp : phpApps) {
            phpAppFile = new File(getWebappDeploymentDirPath() + File.separator + phpApp);
            phpAppFile.delete();
        }
    }

    public String startInstance(String image){
        int tenantId = MultitenantUtils.getTenantId(getConfigContext());
        try {
            initAutoscaler();
        } catch (Exception e) {
            String msg = "Error while initializing Autoscaler";
            log.error(msg, e);
        }
        String publicIp = "";
        openstackDAO = new OpenstackDAO();
        try{
            String privateIp = client.startInstance(System.getProperty("php.domain"), imageIdtoNameMap.get(image));
            log.info("Started Instance private ip is " + privateIp);
            publicIp = openstackDAO.getPublicIp(privateIp);
        }catch (Exception e){
            String msg = "Error while calling auto scaler to start instance";
            log.error(msg);
        }

        return publicIp;
    }

    private boolean isInstanceUp(String tenant){
        return false;
    }

    public String[] getImages(){
        String imageNames[];
        String[] apps = listPhpApplications();
        if(apps == null || apps.length == 0 || !isInstanceUp("tenant")){
            String imageIdsString = System.getProperty(PHPCartridgeConstants.OPENSTACK_INSTANCE_IMAGE_IDS);
            String[] imagesToNameArray = imageIdsString.split(",");
            for (String image : imagesToNameArray) {
                String imageArray[] = image.split(":");
                imageIdtoNameMap.put(imageArray[0], imageArray[1]);
            }
            imageNames = imageIdtoNameMap.keySet().toArray(new String[imageIdtoNameMap.size()]);
        } else {
            imageNames = null;
        }
        return imageNames;
    }

}
