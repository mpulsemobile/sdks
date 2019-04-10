package com.android.mpulseframework;

import android.content.Context;
import android.text.TextUtils;

import com.android.mpulseframework.callbacks.TrackPushNotificationListener;
import com.android.mpulseframework.callbacks.InboxCounterListener;
import com.android.mpulseframework.callbacks.MPulseInboxViewListener;
import com.android.mpulseframework.callbacks.RegisterPushNotificationListener;
import com.android.mpulseframework.callbacks.UnregisterPushNotificationListener;
import com.android.mpulseframework.constants.MPulseExceptionMessages;
import com.android.mpulseframework.exceptions.MPulseException;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.pushnotifications.PushNotificationUtil;
import com.android.mpulseframework.pushnotifications.PushNotificationsConfig;
import com.android.mpulseframework.pushnotifications.TrackPushNotificationConfig;
import com.android.mpulseframework.securemessages.SecureMessagesConfig;
import com.android.mpulseframework.securemessages.SecureMessagesUtil;
import com.android.mpulseframework.securemessages.inbox.MPulseInboxView;
import com.android.mpulseframework.tracking.TrackAppUsageConfig;
import com.android.mpulseframework.tracking.TrackAppUsageUtil;
import com.android.mpulseframework.utils.MPulseUtils;

/**
 * This class is responsible for all tasks related to MPulse
 */
public class MPulseHandler {

    /**
     * The singleton instance of MPulse
     */
    private static MPulseHandler sInstance;

    /**
     * The MPulseAppConfig object that stores the application configuration for MPulse {@link MPulseAppConfig}
     */
    private MPulseAppConfig mAppConfig;

    /**
     * Private constructor of MPulse
     *
     * @param context     the context of the calling class required to configure the required classes
     * @param appMemberId the MPulse member id of the user
     * @throws MPulseException if there is an error while initialization
     */
    private MPulseHandler(Context context, String appMemberId) throws MPulseException {
        mAppConfig = MPulseUtils.getAppConfig(context);
        mAppConfig.setAppMemberId(appMemberId);
        MPulseSharedPreference.initialize(context);
        trackAppUsage(context);
    }

    /**
     * Used to configure the MPulse SDK.
     * This method must be called before calling any other methods of this class
     *
     * @param context     the context of the calling class
     * @param appMemberId the MPulse member id of the user
     * @throws MPulseException if there is an error while initialization
     */

    public static void configure(Context context, String appMemberId) throws MPulseException {
        if (context == null) {
            throw new MPulseException(MPulseExceptionMessages.NULL_CONTEXT);
        }
        if (TextUtils.isEmpty(appMemberId)) {
            throw new MPulseException(MPulseExceptionMessages.EMPTY_APP_MEMBER_ID);
        }
        if (sInstance == null) {
            synchronized (MPulseHandler.class) {
                sInstance = new MPulseHandler(context, appMemberId);
            }
        }
    }

    /**
     * Get singleton instance of MPulse and create new if needed
     *
     * @return the singleton instance
     */
    public static MPulseHandler getInstance() {
        if (sInstance == null) {
            throw new IllegalStateException("To get instance first you need to configure MPulse");
        }
        return sInstance;
    }

    /**
     * Used to destroy the MPulse instance and cancel all running API calls
     */
    public void destroy() {
        ApiManager.cancelAll();
        ApiManager.destroy();
        mAppConfig = null;
        sInstance = null;
    }

    /**
     * Used to register MPulse member for push notifications
     *
     * @param deviceToken the FCM device token
     * @param listener    the listener to get callback on success or failure of registration
     * @throws MPulseException if the user passes a null or empty deviceToken
     */
    public void registerForPushNotification(String deviceToken, RegisterPushNotificationListener listener) throws MPulseException {
        if (TextUtils.isEmpty(deviceToken)) {
            throw new MPulseException(MPulseExceptionMessages.EMPTY_DEVICE_TOKEN);
        }
        PushNotificationsConfig config = new PushNotificationsConfig(mAppConfig, deviceToken);
        new PushNotificationUtil().registerMemberForMPulsePushNotification(config, listener);
    }

    /**
     * Used to unregister MPulse member for push notifications
     *
     * @param deviceToken the FCM device token
     * @param listener    the listener to get callback on success or failure of un-registration
     * @throws MPulseException if the user passes a null or empty deviceToken
     */
    public void unregisterForPushNotification(String deviceToken, UnregisterPushNotificationListener listener) throws MPulseException {
        if (TextUtils.isEmpty(deviceToken)) {
            throw new MPulseException(MPulseExceptionMessages.EMPTY_DEVICE_TOKEN);
        }
        PushNotificationsConfig config = new PushNotificationsConfig(mAppConfig, MPulseUtils.getUnregisterPNToken(deviceToken, mAppConfig.getAppMemberId()));
        new PushNotificationUtil().unregisterMemberForMPulsePushNotification(config, listener);
    }

    /**
     * Used to get secure messages inbox view
     *
     * @param context  the context that the view will run in
     * @param listener the listener to get callback for events when inbox is loading {@link MPulseInboxViewListener}
     */
    public MPulseInboxView getInboxView(Context context, MPulseInboxViewListener listener) {
        SecureMessagesConfig config = new SecureMessagesConfig(mAppConfig);
        return new SecureMessagesUtil().getInboxView(context, config, listener);
    }

    /**
     * Used to fetch the inbox counter
     *
     * @param listener the listener to give callback on success or failure of fetching the inbox counter
     */
    public void getInboxMessageCount(InboxCounterListener listener) {
        SecureMessagesConfig config = new SecureMessagesConfig(mAppConfig);
        new SecureMessagesUtil().getMessageCount(config, listener);
    }

    /**
     *
     * @param trackingId will receive in push notification, and will used for track push notification
     *                   when user click on notification
     * @param messageId will receive in push notification , will be used to track push notification
     *                        when user click on push notification
     * @param actionTimeStamp  2018-10-16 09:40:00 Current Time stamp when user will clicking on push notification
     * @param listener is used to give call back to user to feedback whether tracking of notification is success or not
     */
    public void trackPushNotification(String trackingId,String messageId,String actionTimeStamp,
                                      TrackPushNotificationListener listener){

        TrackPushNotificationConfig config=new TrackPushNotificationConfig();
        config.setAccountId(String.valueOf(mAppConfig.getAccountId()));
        config.setAction("0");
        config.setActionTimeStamp(actionTimeStamp);
        config.setAppId(mAppConfig.getAppId());
        config.setPlatform(mAppConfig.getPlatform());
        config.setDeliveryTimeStamp(actionTimeStamp); // delivery time stamp will be same as action time stamp
        config.setTrackingId(trackingId);
        config.setUrl(mAppConfig.getGateWayUrl());
        config.setMessageId(messageId);

        new PushNotificationUtil().trackPushNotification(config,listener);

    }

    private void trackAppUsage(Context context){
        if (MPulseSharedPreference.getInstance().getBoolean(MPulseSharedPreference.PreferenceKeys.KEY_IS_FIRST_TIME, true)) {
            TrackAppUsageConfig config = new TrackAppUsageConfig(mAppConfig,
                    MPulseUtils.getDeviceType(),
                    MPulseUtils.getDeviceOS(),
                    MPulseUtils.getAppVersion(context));
            new TrackAppUsageUtil().trackAppUsage(config);
        }
    }
}
