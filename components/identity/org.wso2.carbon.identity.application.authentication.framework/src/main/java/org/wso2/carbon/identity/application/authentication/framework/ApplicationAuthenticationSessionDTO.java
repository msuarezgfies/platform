package org.wso2.carbon.identity.application.authentication.framework;

public class ApplicationAuthenticationSessionDTO {

	private String callerPath;
	private String callerSessionKey;
	private String queryParams;

	public String getCallerPath() {
		return callerPath;
	}

	public void setCallerPath(String callerPath) {
		this.callerPath = callerPath;
	}

	public String getCallerSessionKey() {
		return callerSessionKey;
	}

	public void setCallerSessionKey(String callerSessionKey) {
		this.callerSessionKey = callerSessionKey;
	}

	public String getQueryParams() {
		return queryParams;
	}

	public void setQueryParams(String queryParams) {
		this.queryParams = queryParams;
	}
}
