package com.android.mpulseframework.tracking;

import com.android.mpulseframework.MPulseAppConfig;

/**
 * Model to store the app usage tracking configuration for MPulse
 */
public class TrackAppUsageConfig extends MPulseAppConfig {

    /**
     * The device type of the device on which the app is running
     */
    private String mDeviceType;

    /**
     * The device OS of the device on which the app is running
     */
    private String mDeviceOS;

    /**
     * The app version of the app that is running
     */
    private String mAppVersion;

    /**
     * Constructor of TrackAppUsageConfig
     *
     * @param appConfig  the AppConfig object holding the MPulse application configuration {@link MPulseAppConfig}
     * @param deviceType the device type required for usage tracking
     * @param deviceOS the device OS required for usage tracking
     * @param appVersion the app version required for usage tracking
     */
    public TrackAppUsageConfig(MPulseAppConfig appConfig, String deviceType, String deviceOS, String appVersion) {
        super(appConfig);
        mDeviceType = deviceType;
        mDeviceOS = deviceOS;
        mAppVersion = appVersion;
    }

    /**
     * Getter for the device type
     *
     * @return the device type
     */
    public String getDeviceType() {
        return mDeviceType;
    }

    /**
     * Setter for the device type
     *
     * @param mDeviceType the device type to set
     */
    public void setDeviceType(String mDeviceType) {
        this.mDeviceType = mDeviceType;
    }

    /**
     * Getter for the device OS
     *
     * @return the device OS
     */
    public String getDeviceOS() {
        return mDeviceOS;
    }

    /**
     * Setter for the device OS
     *
     * @param mDeviceOS the device OS to set
     */
    public void setDeviceOS(String mDeviceOS) {
        this.mDeviceOS = mDeviceOS;
    }

    /**
     * Getter for the app version
     *
     * @return the app version
     */
    public String getAppVersion() {
        return mAppVersion;
    }

    /**
     * Setter for the app version
     *
     * @param mAppVersion the app version to set
     */
    public void setAppVersion(String mAppVersion) {
        this.mAppVersion = mAppVersion;
    }
}
