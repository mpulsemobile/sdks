package com.android.mpulseframework;

import com.android.mpulseframework.constants.MPulseConstants;

/**
 * Model to store the application configuration for MPulse
 */
public class MPulseAppConfig {

    /**
     * The application id of the app integrating the SDK
     */
    private String mAppId;

    /**
     * The account id of the app integrating the SDK
     */
    private int mAccountId;

    /**
     * The MPulse KEY_MIDDLE_WARE_URL used for API calling
     */
    private String mMPulseUrl;

    /**
     * The MPulse KEY_MIDDLE_WARE_URL used for API calling
     */
    private String mGateWayUrl;

    /**
     * The application member id of the user
     */
    private String mAppMemberId;

    /**
     * The access key for the app
     */
    private String mAccessKey;

    /**
     * The application platform (Android)
     */
    private String mPlatform = MPulseConstants.PLATFORM;

    /**
     * Constructor for AppConfig
     */
    public MPulseAppConfig() {
    }

    /**
     * Constructor for AppConfig
     *
     * @param appConfig the AppConfig object used for initialization
     */
    public MPulseAppConfig(MPulseAppConfig appConfig) {
        mAppId = appConfig.getAppId();
        mAccountId = appConfig.getAccountId();
        mPlatform = appConfig.getPlatform();
        mAppMemberId = appConfig.getAppMemberId();
        mMPulseUrl = appConfig.getMPulseUrl();
        mAccessKey = appConfig.getAccessKey();
        mGateWayUrl=appConfig.getGateWayUrl();
    }


    /**
     *
     * @return gate way url
     */
    public String getGateWayUrl() {
        return mGateWayUrl;
    }

    /**
     * Setter for gateway url
     * @param gateWayUrl
     */

    public void setGateWayUrl(String gateWayUrl) {
        this.mGateWayUrl = gateWayUrl;
    }

    /**
     * Getter for the application id
     *
     * @return the application id
     */
    public String getAppId() {
        return mAppId;
    }

    /**
     * Setter for the application id
     *
     * @param mAppId the application id to set
     */
    public void setAppId(String mAppId) {
        this.mAppId = mAppId;
    }

    /**
     * Getter for the account id
     *
     * @return the account id
     */
    public int getAccountId() {
        return mAccountId;
    }

    /**
     * Setter for the account id
     *
     * @param mAccountId the account id to set
     */
    public void setAccountId(int mAccountId) {
        this.mAccountId = mAccountId;
    }

    /**
     * Getter for the MPulse KEY_MIDDLE_WARE_URL
     *
     * @return the MPulse KEY_MIDDLE_WARE_URL
     */
    public String getMPulseUrl() {
        return mMPulseUrl;
    }

    /**
     * Setter for the MPulse KEY_MIDDLE_WARE_URL
     *
     * @param mMPulseUrl the MPulse KEY_MIDDLE_WARE_URL to set
     */
    public void setMPulseUrl(String mMPulseUrl) {
        this.mMPulseUrl = mMPulseUrl;
    }

    /**
     * Getter for the application member id
     *
     * @return the application member id
     */
    public String getAppMemberId() {
        return mAppMemberId;
    }

    /**
     * Setter for the application member id
     *
     * @param mAppMemberId the application member id to set
     */
    public void setAppMemberId(String mAppMemberId) {
        this.mAppMemberId = mAppMemberId;
    }

    /**
     * Getter for the access key
     *
     * @return the access key
     */
    public String getAccessKey() {
        return mAccessKey;
    }

    /**
     * Setter for the access key
     *
     * @param mAccessKey the access key to set
     */
    public void setAccessKey(String mAccessKey) {
        this.mAccessKey = mAccessKey;
    }

    /**
     * Getter for the platform
     *
     * @return the platform
     */
    public String getPlatform() {
        return mPlatform;
    }

    /**
     * Setter for the platform
     *
     * @param mPlatform the platform to set
     */
    public void setPlatform(String mPlatform) {
        this.mPlatform = mPlatform;
    }
}
