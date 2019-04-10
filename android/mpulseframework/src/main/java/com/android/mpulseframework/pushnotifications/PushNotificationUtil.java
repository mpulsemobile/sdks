package com.android.mpulseframework.pushnotifications;

import com.android.mpulseframework.callbacks.RegisterPushNotificationListener;
import com.android.mpulseframework.callbacks.TrackPushNotificationListener;
import com.android.mpulseframework.callbacks.UnregisterPushNotificationListener;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.networking.models.Response;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * This class handles all operations related to sending the FCM device token for push notifications
 */
public class PushNotificationUtil {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(PushNotificationUtil.class);

    /**
     * The listener object required to give callback on success or failure of push notification registration {@link RegisterPushNotificationListener}
     */
    private RegisterPushNotificationListener mRegisterPushNotificationListener;

    /**
     * The listener object required to give callback on success or failure of push notification un-registration {@link RegisterPushNotificationListener}
     */
    private UnregisterPushNotificationListener mUnregisterPushNotificationListener;

    /**
     * The listener object required to give callback on success or failure of push notification tracking(clicking) {@link TrackPushNotificationListener}
     */
    private TrackPushNotificationListener mTrackPushNotificationListener;

    /**
     * Used to call the API to register member for push notifications
     *
     * @param config   the push notification configuration object that stores the configuration related to registering member for push notifications {@link PushNotificationsConfig}
     * @param listener the listener to give callback on success or failure of push notification registration {@link RegisterPushNotificationListener}
     */
    public void registerMemberForMPulsePushNotification(PushNotificationsConfig config, RegisterPushNotificationListener listener) {
        mRegisterPushNotificationListener = listener;
        ApiManager.get(config.getMPulseUrl())
                .addPathParameter(MPulseConstants.URL_PUSH_NOTIFICATION)
                .addQueryParameters(getQueryMap(config))
                .addHeaders(getHeadersMap(MPulseConstants.ACTION_REGISTER))
                .setTag(MPulseConstants.URL_PUSH_NOTIFICATION)
                .build()
                .execute(mRegisterForPushNotificationApiListener);
    }

    /**
     * Used to call the API to unregister member for push notifications
     *
     * @param config   the push notification configuration object that stores the configuration related to un-registering member for push notifications {@link PushNotificationsConfig}
     * @param listener the listener to give callback on success or failure of push notification un-registration {@link UnregisterPushNotificationListener}
     */
    public void unregisterMemberForMPulsePushNotification(PushNotificationsConfig config, UnregisterPushNotificationListener listener) {
        mUnregisterPushNotificationListener = listener;
        ApiManager.get(config.getMPulseUrl())
                .addPathParameter(MPulseConstants.URL_PUSH_NOTIFICATION)
                .addQueryParameters(getQueryMap(config))
                .addHeaders(getHeadersMap(MPulseConstants.ACTION_REGISTER))
                .setTag(MPulseConstants.URL_PUSH_NOTIFICATION)
                .build()
                .execute(mUnregisterForPushNotificationApiListener);
    }

    /**
     * Used to call the API to unregister member for push notifications
     *
     * @param config   the track push notification configuration object that stores all the information for track push notifications {@link PushNotificationsConfig}
     * @param listener the listener to give callback on success or failure of track push notification {@link TrackPushNotificationListener}
     */
    public void trackPushNotification(TrackPushNotificationConfig config, TrackPushNotificationListener listener) {
        mTrackPushNotificationListener = listener;
        ApiManager.post(config.getUrl())
                .addPathParameter(MPulseConstants.DEVICE_REQUEST)
                .addPathParameter(MPulseConstants.TRACK_PUSH_NOTIFICATION)
                .addJSONObjectBody(getJsonObjectForTrackNotification(config))
                .addHeaders(getTrackNotificationHeadersMap())
                .build()
                .execute(mTrackPushNotificationApiListener);
    }


    /**
     * Builds and returns the map containing the query parameters for the API request
     *
     * @param config the push notification configuration object that stores the configuration related to registering member for push notifications {@link PushNotificationsConfig}
     * @return the map containing the query parameters for the API request
     */
    private Map<String, String> getQueryMap(PushNotificationsConfig config) {
        Map<String, String> queryMap = new HashMap<>();
        queryMap.put(MPulseConstants.KEY_APP_ID, config.getAppId());
        queryMap.put(MPulseConstants.KEY_PLATFORM, config.getPlatform());
        queryMap.put(MPulseConstants.KEY_DEVICE_TOKEN, config.getDeviceToken());
        queryMap.put(MPulseConstants.KEY_APP_MEMBER_ID, config.getAppMemberId());
        queryMap.put(MPulseConstants.KEY_ACCOUNT_ID, String.valueOf(config.getAccountId()));
        queryMap.put(MPulseConstants.KEY_VERSION, MPulseConstants.VERSION);
        return queryMap;
    }

    /**
     * Builds and returns the Json containing the Data for the API request
     *
     * @param config the tract push notification configuration object that stores data for track push notifications {@link TrackPushNotificationConfig}
     * @return the JsonObject containing the parameters for the API request
     */
    private JSONObject getJsonObjectForTrackNotification(TrackPushNotificationConfig config) {
        JSONObject jsonObject=new JSONObject();
        try {

            jsonObject.put(MPulseConstants.KEY_TRACKING_ID, config.getTrackingId());
            jsonObject.put(MPulseConstants.KEY_MESSAGE_ID, config.getMessageId());
            jsonObject.put(MPulseConstants.KEY_DELIVERY_TIME_STAMP, config.getDeliveryTimeStamp());
            jsonObject.put(MPulseConstants.KEY_ACTION_TIME_STAMP, config.getActionTimeStamp());
            jsonObject.put(MPulseConstants.KEY_HEADER_ACTION, config.getAction());
            jsonObject.put(MPulseConstants.KEY_APP_ID_TRACK.toLowerCase(), config.getAppId());
            jsonObject.put(MPulseConstants.KEY_PLATFORM, config.getPlatform());
            jsonObject.put(MPulseConstants.ACCOUNT_ID.toLowerCase(), config.getAccountId());
        }
        catch (Exception e){
            LOGGER.error("onSuccess " + e.getMessage());
        }

        return jsonObject;
    }


    /**
     * Builds and returns the map containing the headers for the API Track notification
     *
     * @return the map containing the header parameters for the API Track notification
     */
    private Map<String, String> getTrackNotificationHeadersMap() {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_CONTENT_TYPE, MPulseConstants.KEY_HEADER_CONTENT_TYPE_JSON);
        return headerMap;
    }


    /**
     * Builds and returns the map containing the headers for the API request
     *
     * @param action the action value for the action header
     * @return the map containing the header parameters for the API request
     */
    private Map<String, String> getHeadersMap(String action) {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_USER_AGENT, MPulseConstants.USER_AGENT_MOBILE);
        headerMap.put(MPulseConstants.KEY_HEADER_ACTION, action);
        return headerMap;
    }

    /**
     * The API listener that receives callback on success or failure of the API request
     */
    private IApiListener<String> mRegisterForPushNotificationApiListener = new IApiListener<String>() {

        @Override
        public void onSuccess(ApiResponse<String> response) {
            LOGGER.error("onSuccess " + response.getResult());
            if (mRegisterPushNotificationListener != null) {
                if (response.isSuccess()) {
                    mRegisterPushNotificationListener.onMemberRegistrationSuccess(new Response<>(response.getResult(), response.getResponseCode()));
                } else {
                    mRegisterPushNotificationListener.onMemberRegistrationError(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (mRegisterPushNotificationListener != null) {
                mRegisterPushNotificationListener.onMemberRegistrationError(error);
            }
        }
    };

    /**
     * The API listener that receives callback on success or failure of the API request
     */
    private IApiListener<String> mUnregisterForPushNotificationApiListener = new IApiListener<String>() {

        @Override
        public void onSuccess(ApiResponse<String> response) {
            LOGGER.error("onSuccess " + response.getResult());
            if (mUnregisterPushNotificationListener != null) {
                if (response.isSuccess()) {
                    mUnregisterPushNotificationListener.onMemberUnRegistrationSuccess(new Response<>(response.getResult(), response.getResponseCode()));
                } else {
                    mUnregisterPushNotificationListener.onMemberUnRegistrationError(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (mUnregisterPushNotificationListener != null) {
                mUnregisterPushNotificationListener.onMemberUnRegistrationError(error);
            }
        }
    };


    /**
     * The API listener that receives callback on success or failure of the Track Notification API request
     */
    private IApiListener<String> mTrackPushNotificationApiListener = new IApiListener<String>() {

        @Override
        public void onSuccess(ApiResponse<String> response) {
            LOGGER.error("onSuccess " + response.getResult());
            if (mTrackPushNotificationListener != null) {
                if (response.isSuccess()) {
                    mTrackPushNotificationListener.onTrackPushNotificationSuccess();
                } else {
                    mTrackPushNotificationListener.onTrackPushNotificationFailure(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (mTrackPushNotificationListener != null) {
                mTrackPushNotificationListener.onTrackPushNotificationFailure(error);
            }
        }
    };
}
