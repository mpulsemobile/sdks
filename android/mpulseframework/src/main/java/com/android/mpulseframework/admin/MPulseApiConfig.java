package com.android.mpulseframework.admin;

public class MPulseApiConfig {

    /**
    * MPulse CLIENT SECRET
    * */
    private String mClientSecret;
    /**
     *  MPulse KEY_MIDDLE_WARE_URL used for API calling
     */
    private String mUrl;

    /**
     * Account Id
     */
    private String mAccountId;

    /**
     * Client Id
     */
    private String mClientId;

    public String getClientSecret() {
        return mClientSecret;
    }

    public void setClientSecret(String mClientSecret) {
        this.mClientSecret = mClientSecret;
    }

    public String getUrl() {
        return mUrl;
    }

    public void setUrl(String mUrl) {
        this.mUrl = mUrl;
    }

    public String getAccountId() {
        return mAccountId;
    }

    public void setAccountId(String mAccountId) {
        this.mAccountId = mAccountId;
    }

    public String getClientId() {
        return mClientId;
    }

    public void setClientId(String mClientId) {
        this.mClientId = mClientId;
    }
}
