package com.android.mpulseframework.pushnotifications;

import com.android.mpulseframework.MPulseAppConfig;

/**
 * Model to store the push notification configuration for MPulse
 */
public class PushNotificationsConfig extends MPulseAppConfig {

    /**
     * The FCM device token required for push notifications
     */
    private String mDeviceToken;

    /**
     * Constructor of PushNotificationsConfig
     *
     * @param appConfig   the AppConfig object holding the MPulse application configuration {@link MPulseAppConfig}
     * @param deviceToken the FCM device token required for push notifications
     */
    public PushNotificationsConfig(MPulseAppConfig appConfig, String deviceToken) {
        super(appConfig);
        mDeviceToken = deviceToken;
    }

    /**
     * Getter for the FCM device token
     *
     * @return the FCM device token
     */
    public String getDeviceToken() {
        return mDeviceToken;
    }

    /**
     * Setter for the FCM device token
     *
     * @param mDeviceToken the FCM device token to set
     */
    public void setDeviceToken(String mDeviceToken) {
        this.mDeviceToken = mDeviceToken;
    }
}
