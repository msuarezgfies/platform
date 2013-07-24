<!--
/*
* Copyright (c) 2008, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
-->
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="org.wso2.carbon.ui.util.CharacterEncoder" %>
<%@ page import="org.wso2.carbon.identity.entitlement.ui.EntitlementPolicyConstants" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.wso2.carbon.identity.entitlement.ui.PolicyEditorConstants" %>
<%@ page import="org.wso2.carbon.identity.entitlement.common.PolicyEditorEngine" %>
<%@ page import="org.wso2.carbon.identity.entitlement.common.dto.PolicyEditorDataHolder" %>
<%@ page import="java.util.Set" %>
<%@ page import="org.wso2.balana.utils.policy.dto.BasicRuleDTO" %>
<%@ page import="org.wso2.balana.utils.policy.dto.BasicTargetDTO" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<jsp:useBean id="entitlementPolicyBean" type="org.wso2.carbon.identity.entitlement.ui.EntitlementPolicyBean"
             class="org.wso2.carbon.identity.entitlement.ui.EntitlementPolicyBean" scope="session"/>
<jsp:setProperty name="entitlementPolicyBean" property="*" />

<%
    BasicRuleDTO basicRuleDTO = null;
    PolicyEditorDataHolder holder = PolicyEditorEngine.getInstance().getPolicyEditorData();
    Set<String> functionIds = holder.getRuleFunctions();
    Set<String> preFunctionIds = holder.getPreFunctionMap().keySet();
    Set<String> targetFunctionIds = holder.getTargetFunctions();
    Set<String> ruleEffects = holder.getRuleEffectMap().keySet();
    Set<String> subjectIds =  holder.getCategoryAttributeIdMap().get(PolicyEditorConstants.SOA_CATEGORY_SUBJECT);
    Set<String> environmentIds = holder.getCategoryAttributeIdMap().get(PolicyEditorConstants.SOA_CATEGORY_ENVIRONMENT);
    Set<String> algorithmNames = holder.getRuleCombiningAlgorithms().keySet();
    Set<String> availableCategories = holder.getCategoryMap().keySet();

    String BUNDLE = "org.wso2.carbon.identity.entitlement.ui.i18n.Resources";
    ResourceBundle resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale());

    List<BasicRuleDTO> basicRuleDTOs = entitlementPolicyBean.getBasicRuleDTOs();
    BasicTargetDTO basicTargetDTO = entitlementPolicyBean.getBasicTargetDTO();

    String selectedAttributeDataType = request.getParameter("selectedAttributeDataType");
    String selectedAttributeId = request.getParameter("selectedAttributeId");
    String category = request.getParameter("category");

    String ruleId = CharacterEncoder.getSafeText(request.getParameter("ruleId"));
    if(ruleId != null && ruleId.trim().length() > 0 && !ruleId.trim().equals("null") ) {
        basicRuleDTO = entitlementPolicyBean.getBasicRuleElement(ruleId);
    }

    // Why null  TODO
    if("null".equals(selectedAttributeId)){
        selectedAttributeId = null;
    }

    if("null".equals(selectedAttributeDataType)){
        selectedAttributeDataType = null;
    }

    String selectedAttributeNames = "";

    String selectedCategory = request.getParameter("policyApplied");
    if(selectedCategory == null || selectedCategory.trim().length() == 0){
        selectedCategory =  PolicyEditorConstants.SOA_CATEGORY_RESOURCE;
    }

    String selectedSubjectNames = "";
    String selectedResourceNames = "";
    String selectedActionNames = "";
    String selectedEnvironmentNames = "";
    String selectedResourceId="";
    String selectedResourceDataType="";
    String selectedSubjectId="";
    String selectedSubjectDataType="";
    String selectedActionId="";
    String selectedActionDataType="";
    String selectedEnvironmentId="";
    String selectedEnvironmentDataType="";

    String resourceNames = "";
    String environmentNames = "";
    String subjectNames = "";
    String actionNames = "";
    String functionOnResources = "";
    String functionOnSubjects = "";
    String functionOnActions = "";
    String functionOnEnvironment = "";
    String preFunctionOnResources = "";
    String preFunctionOnSubjects = "";
    String preFunctionOnActions = "";
    String preFunctionOnEnvironment = "";
    String resourceDataType = "";
    String subjectDataType = "";
    String actionDataType = "";
    String environmentDataType = "";
    String resourceId= "";
    String subjectId = "";
    String actionId = "";
    String environmentId = "";
    String ruleDescription = "";
    String ruleEffect = "";

    String resourceNamesTarget = "";
    String environmentNamesTarget = "";
    String subjectNamesTarget = "";
    String actionNamesTarget = "";

    String functionOnResourcesTarget = "";
    String functionOnSubjectsTarget = "";
    String functionOnActionsTarget = "";
    String functionOnEnvironmentTarget = "";

    String preFunctionOnSubjectsTarget = "";
    String preFunctionOnActionsTarget = "";
    String preFunctionOnEnvironmentTarget = "";
    String preFunctionOnResourcesTarget = "";

    String resourceDataTypeTarget = "";
    String subjectDataTypeTarget = "";
    String actionDataTypeTarget = "";
    String environmentDataTypeTarget = "";

    String resourceIdTarget = "";
    String subjectIdTarget = "";
    String actionIdTarget = "";
    String environmentIdTarget = "";

    int noOfSelectedAttributes = 1;
    /**
     *  Get posted resources from jsp pages and put then in to a String object
     */
    while(true) {
        String attributeName  = request.getParameter("attributeValue" + noOfSelectedAttributes);
        if (attributeName == null || attributeName.trim().length() < 1) {
            break;
        }
        if(selectedAttributeNames.equals("")) {
            selectedAttributeNames = attributeName.trim();
        } else {
            selectedAttributeNames = selectedAttributeNames + "," + attributeName.trim();
        }
        noOfSelectedAttributes ++;
    }


    if(category != null){
        if (EntitlementPolicyConstants.RESOURCE_ELEMENT.equals(category)){
            selectedResourceNames = selectedAttributeNames;
            selectedResourceId = selectedAttributeId;
            selectedResourceDataType = selectedAttributeDataType;
        } else if (EntitlementPolicyConstants.SUBJECT_ELEMENT.equals(category)){
            selectedSubjectNames = selectedAttributeNames;
            selectedSubjectId = selectedAttributeId;
            selectedSubjectDataType = selectedAttributeDataType;
        } else if (EntitlementPolicyConstants.ACTION_ELEMENT.equals(category)){
            selectedActionNames = selectedAttributeNames;
            selectedActionId = selectedAttributeId;
            selectedActionDataType = selectedAttributeDataType;
        } else if (EntitlementPolicyConstants.ENVIRONMENT_ELEMENT.equals(category)){
            selectedEnvironmentNames = selectedAttributeNames;
            selectedEnvironmentId = selectedAttributeId;
            selectedEnvironmentDataType = selectedAttributeDataType;
        }
    }
    /**
     * Assign current BasicRule Object Values to variables to show on UI
     */
    if(basicRuleDTO != null){

        ruleEffect = basicRuleDTO.getRuleEffect();
        ruleId = basicRuleDTO.getRuleId();
        ruleDescription = basicRuleDTO.getRuleDescription();

        resourceNames =  basicRuleDTO.getResourceList();
        subjectNames = basicRuleDTO.getSubjectList();
        actionNames = basicRuleDTO.getActionList();
        environmentNames = basicRuleDTO.getEnvironmentList();

        functionOnActions = basicRuleDTO.getFunctionOnActions();
        functionOnResources = basicRuleDTO.getFunctionOnResources();
        functionOnSubjects = basicRuleDTO.getFunctionOnSubjects();
        functionOnEnvironment = basicRuleDTO.getFunctionOnEnvironment();

        if(selectedResourceDataType != null && selectedResourceDataType.trim().length() > 0){
            resourceDataType = selectedResourceDataType;
        } else {
            resourceDataType = basicRuleDTO.getResourceDataType();
        }

        if(selectedSubjectDataType != null && selectedSubjectDataType.trim().length() > 0){
            subjectDataType = selectedSubjectDataType;
        } else {
            subjectDataType = basicRuleDTO.getSubjectDataType();
        }

        if(selectedActionDataType != null && selectedActionDataType.trim().length() > 0){
            actionDataType = selectedActionDataType;
        } else {
            actionDataType = basicRuleDTO.getActionDataType();
        }

        if(selectedEnvironmentDataType != null && selectedEnvironmentDataType.trim().length() > 0){
            environmentDataType = selectedEnvironmentDataType;
        } else {
            environmentDataType = basicRuleDTO.getEnvironmentDataType();
        }

        if(selectedResourceId != null && selectedResourceId.trim().length() > 0){
            resourceId = selectedResourceId;
        } else {
            resourceId = basicRuleDTO.getResourceId();
        }

        if(selectedSubjectId != null && selectedSubjectId.trim().length() > 0){
            subjectId = selectedSubjectId;
        } else {
            subjectId = basicRuleDTO.getSubjectId();
        }

        if(selectedActionId != null && selectedActionId.trim().length() > 0){
            actionId = selectedActionId;
        } else {
            actionId = basicRuleDTO.getActionId();
        }

        if(selectedEnvironmentId != null && selectedEnvironmentId.trim().length() > 0){
            environmentId = selectedEnvironmentId;
        } else {
            environmentId = basicRuleDTO.getEnvironmentId();
        }

        if(selectedResourceNames != null && selectedResourceNames.trim().length() > 0){
            if(resourceNames != null && resourceNames.trim().length() > 0){
                resourceNames = resourceNames + ","  + selectedResourceNames;
            } else {
                resourceNames = selectedResourceNames;
            }
        }

        if(selectedSubjectNames != null && selectedSubjectNames.trim().length() > 0){
            if(subjectNames != null && subjectNames.trim().length() > 0){
                subjectNames = subjectNames + ","  + selectedSubjectNames;
            } else {
                subjectNames = selectedSubjectNames;
            }
        }

        if(selectedActionNames != null && selectedActionNames.trim().length() > 0){
            if(actionNames != null && actionNames.trim().length() > 0){
                actionNames = actionNames + ","  + selectedActionNames;
            } else {
                actionNames = selectedActionNames;
            }
        }

        if(selectedEnvironmentNames != null && selectedEnvironmentNames.trim().length() > 0){
            if(environmentNames != null && environmentNames.trim().length() > 0){
                environmentNames = environmentNames + ","  + selectedEnvironmentNames;
            } else {
                environmentNames = selectedEnvironmentNames;
            }
        }

    }

    /**
     * Assign current BasicTarget Object Values to variables to show on UI.
     */
    if(basicTargetDTO != null){

        resourceNamesTarget =  basicTargetDTO.getResourceList();
        subjectNamesTarget = basicTargetDTO.getSubjectList();
        actionNamesTarget = basicTargetDTO.getActionList();
        environmentNamesTarget = basicTargetDTO.getEnvironmentList();

        functionOnActionsTarget = basicTargetDTO.getFunctionOnActions();
        functionOnResourcesTarget = basicTargetDTO.getFunctionOnResources();
        functionOnSubjectsTarget = basicTargetDTO.getFunctionOnSubjects();
        functionOnEnvironmentTarget = basicTargetDTO.getFunctionOnEnvironment();

        resourceDataTypeTarget  = basicTargetDTO.getResourceDataType();
        subjectDataTypeTarget  = basicTargetDTO.getSubjectDataType();
        actionDataTypeTarget  = basicTargetDTO.getActionDataType();
        environmentDataTypeTarget  = basicTargetDTO.getEnvironmentDataType();

        resourceIdTarget = basicTargetDTO.getResourceId();
        subjectIdTarget = basicTargetDTO.getSubjectId();
        actionIdTarget = basicTargetDTO.getActionId();
        environmentIdTarget = basicTargetDTO.getEnvironmentId();

        if(basicRuleDTO == null) {
            if(selectedResourceNames != null && selectedResourceNames.trim().length() > 0){
                if(resourceNamesTarget != null && resourceNamesTarget.trim().length() > 0){
                    resourceNamesTarget = resourceNamesTarget + ","  + selectedResourceNames;
                } else {
                    resourceNamesTarget = selectedResourceNames;
                }
            }

            if(selectedSubjectNames != null && selectedSubjectNames.trim().length() > 0){
                if(subjectNamesTarget != null && subjectNamesTarget.trim().length() > 0){
                    subjectNamesTarget = subjectNamesTarget + ","  + selectedSubjectNames;
                } else {
                    subjectNamesTarget = selectedSubjectNames;
                }
            }

            if(selectedActionNames != null && selectedActionNames.trim().length() > 0){
                if(actionNamesTarget != null && actionNamesTarget.trim().length() > 0){
                    actionNamesTarget = actionNamesTarget + ","  + selectedActionNames;
                } else {
                    actionNamesTarget = selectedActionNames;
                }
            }

            if(selectedEnvironmentNames != null && selectedEnvironmentNames.trim().length() > 0){
                if(environmentNamesTarget != null && environmentNamesTarget.trim().length() > 0){
                    environmentNamesTarget = environmentNamesTarget + ","  + selectedEnvironmentNames;
                } else {
                    environmentNamesTarget = selectedEnvironmentNames;
                }
            }

            if(selectedResourceDataType != null && selectedResourceDataType.trim().length() > 0){
                resourceDataTypeTarget = selectedResourceDataType;
            }

            if(selectedSubjectDataType != null && selectedSubjectDataType.trim().length() > 0){
                subjectDataTypeTarget  = selectedSubjectDataType;
            }

            if(selectedActionDataType != null && selectedActionDataType.trim().length() > 0){
                actionDataTypeTarget  = selectedActionDataType;
            }

            if(selectedEnvironmentDataType != null && selectedEnvironmentDataType.trim().length() > 0){
                environmentDataTypeTarget  = selectedEnvironmentDataType;
            }

            if(selectedResourceId != null && selectedResourceId.trim().length() > 0){
                resourceIdTarget = selectedResourceId;
            }

            if(selectedSubjectId != null && selectedSubjectId.trim().length() > 0){
                subjectIdTarget = selectedSubjectId;
            }

            if(selectedActionId != null && selectedActionId.trim().length() > 0){
                actionIdTarget = selectedActionId;
            }

            if(selectedEnvironmentId != null && selectedEnvironmentId.trim().length() > 0){
                environmentIdTarget = selectedEnvironmentId;
            }
        }
    }

%>



<fmt:bundle basename="org.wso2.carbon.identity.entitlement.ui.i18n.Resources">
<carbon:breadcrumb
        label="create.basic.policy"
        resourceBundle="org.wso2.carbon.identity.entitlement.ui.i18n.Resources"
        topPage="false"
        request="<%=request%>" />
<script type="text/javascript" src="../carbon/admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../carbon/admin/js/cookies.js"></script>
<script type="text/javascript" src="resources/js/main.js"></script>
<!--Yahoo includes for dom event handling-->
<script src="../yui/build/yahoo-dom-event/yahoo-dom-event.js" type="text/javascript"></script>
<script src="../entitlement/js/create-basic-policy.js" type="text/javascript"></script>
<link href="../entitlement/css/entitlement.css" rel="stylesheet" type="text/css" media="all"/>

<script type="text/javascript">

    function preSubmit(){

        var ruleElementOrder = new Array();
        var tmp = jQuery("#dataTable tbody tr input");
        for (var j = 0; j < tmp.length; j++) {
            ruleElementOrder.push(tmp[j].value);
        }
        jQuery('#mainTable > tbody:last').append('<tr><td><input type="hidden" name="ruleElementOrder" id="ruleElementOrder" value="' + ruleElementOrder +'"/></td></tr>') ;
    }


    function submitForm() {
        if(doValidationPolicyNameOnly()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=basic-policy-finish";
            document.dataForm.submit();
        }
    }

    function doCancel() {
        location.href  = 'index.jsp';
    }

    function doValidation() {

        var value = document.getElementsByName("policyName")[0].value;
        if (value == '') {
            CARBON.showWarningDialog('<fmt:message key="policy.name.is.required"/>');
            return false;
        }

        value = document.getElementsByName("ruleId")[0].value;
        if (value == '') {
            CARBON.showWarningDialog('<fmt:message key="rule.id.is.required"/>');
            return false;
        }

        return true;
    }

    function doValidationPolicyNameOnly() {

        var value = document.getElementsByName("policyName")[0].value;
        if (value == '') {
            CARBON.showWarningDialog('<fmt:message key="policy.name.is.required"/>');
            return false;
        }

        return true;
    }

    function doUpdate(){
        if(doValidation()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=basic-policy-editor&completedRule=true&updateRule=true";
            document.dataForm.submit();
        }
    }

    function doCancelRule(){
        if(doValidation()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=basic-policy-editor&ruleId=";
            document.dataForm.submit();
        }
    }

    function deleteRule(ruleId) {
        preSubmit();
        document.dataForm.action = "basic-policy-update.jsp?nextPage=delete-rule-entry&ruleId="
                + ruleId + "&returnPage=basic-policy-editor";
        document.dataForm.submit();
    }

    function editRule(ruleId){
        preSubmit();
        document.dataForm.action = "basic-policy-update.jsp?nextPage=basic-policy-editor&editRule=true&ruleId=" + ruleId;
        document.dataForm.submit();
    }

    function doAdd() {
        if(doValidation()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=basic-policy-editor&completedRule=true";
            document.dataForm.submit();
        }
    }

    function selectAttributes(attributeType){
        if(doValidationPolicyNameOnly()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=select-attribute-values&updateRule=true&category="
                    + attributeType + "&returnPage=basic-policy-editor.jsp";
            document.dataForm.submit();
        }
    }


    function selectAttributesForTarget(attributeType){
        if(doValidationPolicyNameOnly()){
            preSubmit();
            document.dataForm.action = "basic-policy-update.jsp?nextPage=select-attribute-values&ruleId=&attributeType="
                    + attributeType  + "&returnPage=basic-policy-editor.jsp";
            document.dataForm.submit();
        }
    }


    function updownthis(thislink,updown){
        var sampleTable = document.getElementById('dataTable');
        var clickedRow = thislink.parentNode.parentNode;
        var addition = -1;
        if(updown == "down"){
            addition = 1;
        }
        var otherRow = sampleTable.rows[clickedRow.rowIndex + addition];
        var numrows = jQuery("#dataTable tbody tr").length;
        if(numrows <= 1){
            return;
        }
        if(clickedRow.rowIndex == 1 && updown == "up"){
            return;
        } else if(clickedRow.rowIndex == numrows && updown == "down"){
            return;
        }
        var rowdata_clicked = new Array();
        for(var i=0;i<clickedRow.cells.length;i++){
            rowdata_clicked.push(clickedRow.cells[i].innerHTML);
            clickedRow.cells[i].innerHTML = otherRow.cells[i].innerHTML;
        }
        for(i=0;i<otherRow.cells.length;i++){
            otherRow.cells[i].innerHTML =rowdata_clicked[i];
        }
    }

    function getCategoryType() {
        document.dataForm.submit();
    }
</script>



<div id="middle">
<h2><fmt:message key="create.entitlement.policy"/></h2>
<div id="workArea">
<form id="dataForm" name="dataForm" method="post" action="">
<table  id="mainTable"  class="styledLeft noBorders">

    <tr>
        <td class="leftCol-med"><fmt:message key='policy.name'/><span class="required">*</span></td>
        <%
            if(entitlementPolicyBean.getPolicyName() != null) {
        %>
        <td><input type="text" name="policyName" id="policyName" value="<%=entitlementPolicyBean.getPolicyName()%>" class="text-box-big"/></td>
        <%
        } else {
        %>
        <td><input type="text" name="policyName" id="policyName" class="text-box-big"/></td>
        <%
            }
        %>
    </tr>

    <%
        if(holder.isShowRuleAlgorithms()){
    %>
    <tr>
        <td><fmt:message key="rule.combining.algorithm"/></td>
        <td>
            <select id="algorithmName" name="algorithmName" class="text-box-big">
                <%
                    for (String algorithmName : algorithmNames) {
                        if(algorithmName.equals(entitlementPolicyBean.getAlgorithmName())){
                %>
                <option value="<%=algorithmName%>" selected="selected"><%=entitlementPolicyBean.getAlgorithmName()%></option>
                <%
                } else {
                %>
                <option value="<%=algorithmName%>"><%=algorithmName%></option>
                <%
                        }
                    }
                %>
            </select>
        </td>
    </tr>
    <%
        }
    %>
    <%
        if(holder.isShowPolicyDescription()){
    %>
    <tr>
        <td class="leftCol-small" style="vertical-align:top !important"><fmt:message key='policy.description'/></td>
        <%
            if(entitlementPolicyBean.getPolicyDescription() != null) {
        %>
        <td><textarea name="policyDescription" id="policyDescription" value="<%=entitlementPolicyBean.getPolicyDescription()%>" class="text-box-big"><%=entitlementPolicyBean.getPolicyDescription()%></textarea></td>
        <%
        } else {
        %>
        <td><textarea type="text" name="policyDescription" id="policyDescription" class="text-box-big"></textarea></td>
        <%
            }
        %>
    </tr>
    <%
        }
    %>
    <tr>
        <td class="leftCol-small">
            This policy is based on
        </td>
        <td>
            <select id="policyApplied" name="policyApplied" <%if(entitlementPolicyBean.isEditPolicy()){%> disabled="disabled" <%}%>
                    onchange="getCategoryType();">
                <%
                    for (String availableCategory : availableCategories) {
                        if(availableCategory != null && availableCategory.equals(selectedCategory)){
                %>
                <option value="<%=availableCategory%>" selected="selected" ><%=availableCategory%></option>
                <%
                } else {
                %>
                <option value="<%=availableCategory%>" ><%=availableCategory%></option>
                <%
                        }
                    }
                %>
            </select>
    
            <%--<div class="sectionHelp">--%>
                <%--Depending on the selection, you will be given different options to define rules.--%>
            <%--</div>--%>
        </td>
    </tr>

    <tr>
        <td class="leftCol-small">
            <%=selectedCategory%>
        </td>
        <td>
        <%
            if(PolicyEditorConstants.SOA_CATEGORY_USER.equals(selectedCategory)) {
        %>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="subjectIdTarget" name="subjectIdTarget" class="leftCol-small">
                            <%
                                for (String id : subjectIds) {
                                    if (id.equals(subjectIdTarget)) {
                            %>
                            <option value="<%=id%>" selected="selected"><%=id%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=id%>"><%=id%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnSubjectsTarget" name="functionOnSubjectsTarget" class="leftCol-small">
                            <%
                                for (String functionId : targetFunctionIds) {
                                    if (functionId.equals(functionOnSubjectsTarget)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (subjectNamesTarget != null && subjectNamesTarget.trim().length() > 0) {
                        %>
                        <input type="text" name="subjectNamesTarget" id="subjectNamesTarget"
                               value="<%=subjectNamesTarget%>" class="text-box-big"/>
                        <%
                            } else {
                        %>
                        <input type="text" name="subjectNamesTarget" id="subjectNamesTarget" class="text-box-big"/>
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Subject Names" class='icon-link' onclick='selectAttributes("Subject");'
                           style='background-image:url(images/user-store.gif); float:right;'></a>
                    </td>
                </tr>
            </table>
        <%
            } else if(PolicyEditorConstants.SOA_CATEGORY_ACTION.equals(selectedCategory)) {
        %>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnActionsTarget" name="functionOnActionsTarget" class="leftCol-small">
                            <%
                                for (String functionId : targetFunctionIds) {
                                    if (functionId.equals(functionOnActionsTarget)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (actionNamesTarget != null && actionNamesTarget.trim().length() > 0) {

                        %>
                        <input type="text" name="actionNamesTarget" id="actionNamesTarget" value="<%=actionNamesTarget%>"
                               class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" name="actionNamesTarget" id="actionNamesTarget" class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Action Names" class='icon-link' onclick='selectAttributes("Action");'
                           style='background-image:url(images/actions.png); float:right;'></a>
                    </td>

                    <td>
                        <input type="hidden" name="actionIdTarget" id="actionIdTarget" value="<%=actionIdTarget%>" />
                    </td>
                </tr>
            </table>
        <%
            } else if(PolicyEditorConstants.SOA_CATEGORY_RESOURCE.equals(selectedCategory)) {
        %>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnResourcesTarget" name="functionOnResourcesTarget" class="leftCol-small">
                            <%
                                for (String functionId : targetFunctionIds) {
                                    if (functionId.equals(functionOnResourcesTarget)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (resourceNamesTarget != null && resourceNamesTarget.trim().length() > 0) {

                        %>
                        <input type="text" size="60" name="resourceNamesTarget" id="resourceNamesTarget"
                               value="<%=resourceNamesTarget%>" class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" size="60" name="resourceNamesTarget" id="resourceNamesTarget"
                               class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Resources Names" class='icon-link' onclick='selectAttributes("Resource");'
                           style='background-image:url(images/registry.gif); float:right;'></a>
                    </td>
                    <td>
                        <input type="hidden" name="resourceIdTarget" id="resourceIdTarget" value="<%=resourceIdTarget%>" />
                    </td>
                </tr>
            </table>
        <%
            } else if(PolicyEditorConstants.SOA_CATEGORY_ENVIRONMENT.equals(selectedCategory)) {
        %>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="environmentIdTarget" name="environmentIdTarget" class="leftCol-small">
                            <%
                                for (String id : environmentIds) {
                                    if (id.equals(environmentIdTarget)) {
                            %>
                            <option value="<%=id%>" selected="selected"><%=id%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=id%>"><%=id%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnEnvironmentTarget" name="functionOnEnvironmentTarget" class="leftCol-small">
                            <%
                                for (String functionId : targetFunctionIds) {
                                    if (functionId.equals(functionOnEnvironmentTarget)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (environmentNamesTarget != null && environmentNamesTarget.trim().length() > 0) {

                        %>
                        <input type="text" name="environmentNamesTarget" id="environmentNamesTarget"
                               value="<%=environmentNamesTarget%>" class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" name="environmentNamesTarget" id="environmentNamesTarget" class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Environment Names" class='icon-link' onclick='selectAttributes("Environment");'
                           style='background-image:url(images/calendar.jpg); float:right;'></a>
                    </td>
                </tr>
            </table>
        <%
            }
        %>
    </td>
    </tr>

    <tr>
    <td colspan="2" style="margin-top:10px;">
    <h2 class="trigger  <%if(basicRuleDTO == null){%>active<%} %>"><a href="#"><fmt:message key="add.new.entitlement.rule"/></a></h2>
    <div class="toggle_container" id="newRuleLinkRow">
    <table class="noBorders" id="ruleTable" style="width: 100%">
        <tr>
        <td class="formRow" style="padding:0 !important">
        <table class="normal" cellspacing="0">
        <%
            if(holder.isShowRuleId()){
        %>
            <tr>
                <td class="leftCol-small"><fmt:message key='rule.name'/><span class="required">*</span>
                </td>
                <td>
                    <%
                        if (ruleId != null && ruleId.trim().length() > 0 && !ruleId.trim().equals("null")) {
                    %>
                    <input type="text" name="ruleId" id="ruleId" class="text-box-big"
                           value="<%=basicRuleDTO.getRuleId()%>"/>
                    <%
                    } else {
                    %>
                    <input type="text" name="ruleId" id="ruleId" class="text-box-big"/>
                    <%
                        }
                    %>
                </td>
            </tr>
        <%
            }
        %>

        <%
            if(holder.isShowRuleEffect()){
        %>
            <tr>
                <td><fmt:message key="rule.effect"/></td>
                <td>
                    <select id="ruleEffect" name="ruleEffect" class="leftCol-small">
                        <%
                            if (ruleEffects != null) {
                                for (String effect : ruleEffects) {
                                    if (effect.equals(ruleEffect)) {

                        %>
                        <option value="<%=effect%>" selected="selected"><%=ruleEffect%>
                        </option>
                        <%
                        } else {

                        %>
                        <option value="<%=effect%>"><%=effect%>
                        </option>
                        <%
                                    }
                                }
                            }
                        %>
                    </select>
                </td>
            </tr>
        <%
            }
        %>

        <%
            if(holder.isShowRuleDescription()){
        %>
        <tr>
            <td class="leftCol-small" style="vertical-align:top !important"><fmt:message key='policy.description'/></td>
            <%
                if(ruleDescription != null) {
            %>
            <td><input name="ruleDescription" id="ruleDescription" value="<%=ruleDescription%>" class="text-box-big"/></td>
            <%
            } else {
            %>
            <td><input type="text" name="ruleDescription" id="ruleDescription" class="text-box-big" /></td>
            <%
                }
            %>
        </tr>
        <%
            }
        %>

            <tr>
            <% if(PolicyEditorConstants.SOA_CATEGORY_RESOURCE.equals(selectedCategory)) {%>
                <td><fmt:message key='child.resource.names'/></td>
            <% } else { %>
                <td><fmt:message key='resource.names'/></td>
            <% } %>
            <td>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="preFunctionOnResources" name="preFunctionOnResources" class="leftCol-small">
                            <%
                                for (String preFunctionId : preFunctionIds) {
                                    if (preFunctionId.equals(preFunctionOnResources)) {
                            %>
                            <option value="<%=preFunctionId%>" selected="selected"><%=preFunctionId%>
                            </option>
                            <%
                                    } else {
                            %>
                            <option value="<%=preFunctionId%>"><%=preFunctionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnResources" name="functionOnResources" class="leftCol-small">
                            <%
                                for (String functionId : functionIds) {
                                    if (functionId.equals(functionOnResources)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionOnResources%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (resourceNames != null && !resourceNames.equals("")) {

                        %>
                        <input type="text" size="60" name="resourceNames" id="resourceNames"
                               value="<%=resourceNames%>" class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" size="60" name="resourceNames" id="resourceNames"
                               class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Resources Names" class='icon-link' onclick='selectAttributes("Resource");'
                           style='background-image:url(images/registry.gif); float:right;'></a>
                    </td>
                    <td>
                        <input type="hidden" name="resourceId" id="resourceId" value="<%=resourceId%>" />
                    </td>

                    <td>
                        <input type="hidden" name="resourceDataType" id="resourceDataType" value="<%=resourceDataType%>" />
                    </td>
                </tr>
            </table>
            </td>
            </tr>

            <tr>
            <td class="leftCol-small"><fmt:message key='roles.users'/></td>
            <td>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="subjectId" name="subjectId" class="leftCol-small">
                            <%
                                for (String id : subjectIds) {
                                    if (id.equals(subjectId)) {
                            %>
                            <option value="<%=id%>" selected="selected"><%=id%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=id%>"><%=id%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="preFunctionOnSubjects" name="preFunctionOnSubjects" class="leftCol-small">
                            <%
                                for (String preFunctionId : preFunctionIds) {
                                    if (preFunctionId.equals(preFunctionOnSubjects)) {
                            %>
                            <option value="<%=preFunctionId%>" selected="selected"><%=preFunctionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=preFunctionId%>"><%=preFunctionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnSubjects" name="functionOnSubjects" class="leftCol-small">
                            <%
                                for (String functionId : functionIds) {
                                    if (functionId.equals(functionOnSubjects)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionOnSubjects%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (subjectNames != null && !subjectNames.equals("")) {

                        %>
                        <input type="text" name="subjectNames" id="subjectNames"
                               value="<%=subjectNames%>" class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" name="subjectNames" id="subjectNames" class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Subject Names" class='icon-link' onclick='selectAttributes("Subject");'
                           style='background-image:url(images/user-store.gif); float:right;'></a>
                    </td>

                    <td>
                        <input type="hidden" name="subjectDataType" id="subjectDataType" value="<%=subjectDataType%>" />
                    </td>
                </tr>
            </table>
            </td>
            </tr>


            <tr>
            <td class="leftCol-small"><fmt:message key='action.names'/></td>
            <td>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="preFunctionOnActions" name="preFunctionOnActions" class="leftCol-small">
                            <%
                            for (String preFunctionId : preFunctionIds) {
                                if (preFunctionId.equals(preFunctionOnActions)) {
                            %>
                            <option value="<%=preFunctionId%>" selected="selected"><%=preFunctionId%></option>
                            <%
                                } else {
                            %>
                            <option value="<%=preFunctionId%>"><%=preFunctionId%></option>
                            <%
                                }
                            }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnActions" name="functionOnActions" class="leftCol-small">
                            <%
                                for (String functionId : functionIds) {
                                    if (functionId.equals(functionOnActions)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionOnActions%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (actionNames != null && !actionNames.equals("")) {

                        %>
                        <input type="text" name="actionNames" id="actionNames" value="<%=actionNames%>"
                               class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" name="actionNames" id="actionNames" class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Action Names" class='icon-link' onclick='selectAttributes("Action");'
                           style='background-image:url(images/actions.png); float:right;'></a>
                    </td>

                    <td>
                        <input type="hidden" name="actionId" id="actionId" value="<%=actionId%>" />
                    </td>

                    <td>
                        <input type="hidden" name="actionDataType" id="actionDataType" value="<%=actionDataType%>" />
                    </td>
                </tr>
            </table>
            </td>
            </tr>

            <tr>
            <td class="leftCol-small"><fmt:message key='environment.names'/></td>
            <td>
            <table class="normal" style="padding-left:0px !important">
                <tr>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="environmentId" name="environmentId" class="leftCol-small">
                            <%
                                for (String id : environmentIds) {
                                    if (id.equals(environmentId)) {
                            %>
                            <option value="<%=id%>" selected="selected"><%=id%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=id%>"><%=id%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="preFunctionOnEnvironment" name="preFunctionOnEnvironment" class="leftCol-small">
                            <%
                                for (String preFunctionId : preFunctionIds) {
                                    if (preFunctionId.equals(preFunctionOnEnvironment)) {
                            %>
                            <option value="<%=preFunctionId%>" selected="selected"><%=preFunctionId%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=preFunctionId%>"><%=preFunctionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <select id="functionOnEnvironment" name="functionOnEnvironment" class="leftCol-small">
                            <%
                                for (String functionId : functionIds) {
                                    if (functionId.equals(functionOnEnvironment)) {
                            %>
                            <option value="<%=functionId%>" selected="selected"><%=functionOnEnvironment%>
                            </option>
                            <%
                            } else {
                            %>
                            <option value="<%=functionId%>"><%=functionId%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td style="padding-left:0px !important;padding-right:0px !important">
                        <%
                            if (environmentNames != null && !environmentNames.equals("")) {

                        %>
                        <input type="text" name="environmentNames" id="environmentNames" value="<%=environmentNames%>"
                               class="text-box-big"/>
                        <%
                        } else {
                        %>
                        <input type="text" name="environmentNames" id="environmentNames" class="text-box-big"/>

                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a title="Select Environment Names" class='icon-link' onclick='selectAttributes("Environment");'
                           style='background-image:url(images/calendar.jpg); float:right;'></a>
                    </td>

                    <td>
                        <input type="hidden" name="environmentDataType" id="environmentDataType" value="<%=environmentDataType%>" />
                    </td>
                </tr>
            </table>
            </td>
            </tr>
        </table>
        </td>
        </tr>

        <tr>
        <td colspan="2" class="buttonRow">
            <%
                if (basicRuleDTO != null && basicRuleDTO.isCompletedRule()) {
            %>
            <input class="button" type="button" value="<fmt:message key='update'/>"
                   onclick="doUpdate();"/>

            <input class="button" type="button" value="<fmt:message key='cancel'/>"
                   onclick="doCancelRule();"/>

            <%
            } else {
            %>

            <input class="button" type="button" value="<fmt:message key='add'/>"
                   onclick="doAdd();"/>
            <%
                }
            %>
        </td>
        </tr>

    </table>
    </div>
    </td>
    </tr>

    <tr>
    <td colspan="2">
        <table id="dataTable" style="width: 100%;margin-top:10px;">
            <thead>
            <tr>
                <th><fmt:message key="rule.id"/></th>
                <th><fmt:message key="rule.effect"/></th>
                <th><fmt:message key="action"/></th>
            </tr>
            </thead>
            <%
                if (basicRuleDTOs != null && basicRuleDTOs.size() > 0) {
                    List<BasicRuleDTO> orderedBasicRuleDTOs = new ArrayList<BasicRuleDTO>();
                    String ruleElementOrder = entitlementPolicyBean.getRuleElementOrder();
                    if(ruleElementOrder != null){
                        String[] orderedRuleIds = ruleElementOrder.split(EntitlementPolicyConstants.ATTRIBUTE_SEPARATOR);
                        for(String orderedRuleId : orderedRuleIds){
                            for(BasicRuleDTO orderedBasicRuleElementDTO : basicRuleDTOs) {
                                if(orderedRuleId.trim().equals(orderedBasicRuleElementDTO.getRuleId())){
                                    orderedBasicRuleDTOs.add(orderedBasicRuleElementDTO);
                                }
                            }
                        }
                    }

                    if(orderedBasicRuleDTOs.size() < 1){
                        orderedBasicRuleDTOs = basicRuleDTOs;
                    }
                    for (BasicRuleDTO ruleElementDTO : orderedBasicRuleDTOs) {
                        if(ruleElementDTO.isCompletedRule()){
            %>
            <tr>

                <td>
                    <a class="icon-link" onclick="updownthis(this,'up')" style="background-image:url(../admin/images/up-arrow.gif)"></a>
                    <a class="icon-link" onclick="updownthis(this,'down')" style="background-image:url(../admin/images/down-arrow.gif)"></a>
                    <input type="hidden" value="<%=ruleElementDTO.getRuleId()%>"/>
                    <%=ruleElementDTO.getRuleId()%>
                </td>
                <td><%=ruleElementDTO.getRuleEffect()%></td>
                <td>
                    <a href="#" onclick="editRule('<%=ruleElementDTO.getRuleId()%>')"
                       class="icon-link" style="background-image:url(images/edit.gif);"><fmt:message
                            key="edit"/></a>
                    <a href="#" onclick="deleteRule('<%=ruleElementDTO.getRuleId()%>')"
                       class="icon-link" style="background-image:url(images/delete.gif);"><fmt:message
                            key="delete"/></a>
                </td>
            </tr>
            <%
                    }
                }
            } else {
            %>
            <tr class="noRuleBox">
                <td colspan="3"><fmt:message key="no.rule.defined"/><br/></td>
            </tr>
            <%
                }
            %>
        </table>
    </td>
    </tr>
    <tr>
        <td class="buttonRow" colspan="2">
            <input type="button" onclick="submitForm();" value="<fmt:message key="finish"/>"  class="button"/>
            <input type="button" onclick="doCancel();" value="<fmt:message key="cancel" />" class="button"/>
        </td>
    </tr>
</table>
</form>
</div>
</div>
</fmt:bundle>