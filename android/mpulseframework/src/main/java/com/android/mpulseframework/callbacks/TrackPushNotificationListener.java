package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.admin.login.LoginResponseModel;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.Response;

public interface TrackPushNotificationListener {

        /**
         * Called when Push Notification call successfully
         *
         */
        void onTrackPushNotificationSuccess();

        /**
         * Called when there is an error while tracking push notification
         *
         * @param error the error object containing the error code and message
         */
        void onTrackPushNotificationFailure(ApiError error);

}
