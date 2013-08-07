/*
 * Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 * 
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.wso2.carbon.registry.subscription.test;

import static org.testng.Assert.assertTrue;

import java.io.IOException;
import java.rmi.RemoteException;

import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import org.wso2.carbon.authenticator.stub.LoginAuthenticationExceptionException;
import org.wso2.carbon.automation.api.clients.registry.InfoServiceAdminClient;
import org.wso2.carbon.automation.core.ProductConstant;
import org.wso2.carbon.automation.core.utils.UserInfo;
import org.wso2.carbon.automation.core.utils.UserListCsvReader;
import org.wso2.carbon.automation.core.utils.environmentutils.EnvironmentBuilder;
import org.wso2.carbon.automation.core.utils.environmentutils.ManageEnvironment;
import org.wso2.carbon.registry.core.exceptions.RegistryException;
import org.wso2.carbon.registry.info.stub.RegistryExceptionException;
import org.wso2.carbon.registry.info.stub.beans.xsd.SubscriptionBean;
import org.wso2.carbon.registry.subscription.test.util.JMXSubscription;
import org.wso2.carbon.registry.subscription.test.util.ManagementConsoleSubscription;

import javax.management.InstanceNotFoundException;
import javax.management.ListenerNotFoundException;

public class RootLevelCollectionSubscriptionTestCase {

    private ManageEnvironment environment;
    private final int userID = ProductConstant.ADMIN_USER_ID;
    private UserInfo userInfo;
    private JMXSubscription jmxSubscription = new JMXSubscription();

    private static final String COLLCTION_PATH = "/_system";

    @BeforeClass
    public void initialize() throws RemoteException, LoginAuthenticationExceptionException {
        userInfo = UserListCsvReader.getUserInfo(userID);
        EnvironmentBuilder builder = new EnvironmentBuilder().greg(userID);
        environment = builder.build();
    }

    /**
     * Add subscription to a root level collection and send notification via
     * Management Console
     *
     * @throws Exception
     */
    @Test(groups = "wso2.greg", description = "Get Management Console Notification")
    public void testConsoleSubscription() throws Exception {
        assertTrue(ManagementConsoleSubscription.init(COLLCTION_PATH, "CollectionUpdated",
                                                      environment, userInfo));
    }

    /**
     * Add subscription to a root level collection and send notification via JMX
     *
     * @throws Exception
     */
    @Test(groups = "wso2.greg", description = "Get JMX Notification", dependsOnMethods = "testConsoleSubscription")
    public void testJMXSubscription() throws Exception {
        assertTrue(jmxSubscription.init(COLLCTION_PATH, "CollectionUpdated", environment, userInfo));
    }

    @AfterClass()
    public void clean() throws RegistryException, RegistryExceptionException, IOException,
                               ListenerNotFoundException, InstanceNotFoundException {
        InfoServiceAdminClient infoServiceAdminClient =
                new InfoServiceAdminClient(environment.getGreg().getProductVariables()
                                                   .getBackendUrl(), userInfo.getUserName(),
                                           userInfo.getPassword());

        String sessionID = environment.getGreg().getSessionCookie();
        SubscriptionBean sBean = infoServiceAdminClient.getSubscriptions(COLLCTION_PATH, sessionID);
        infoServiceAdminClient.unsubscribe(COLLCTION_PATH,
                                           sBean.getSubscriptionInstances()[0].getId(), sessionID);
        infoServiceAdminClient.unsubscribe(COLLCTION_PATH,
                                           sBean.getSubscriptionInstances()[1].getId(), sessionID);
        jmxSubscription.disconnect();
        jmxSubscription = null;
        environment = null;
        jmxSubscription = null;
    }
}
