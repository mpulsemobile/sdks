package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.Response;

/**
 * Interface to give call back on success or failure of push notification registration
 */
public interface RegisterPushNotificationListener {

    /**
     * Called when the member has been successfully registered for push notifications
     * @param response the API response object
     */
    void onMemberRegistrationSuccess(Response<String> response);

    /**
     * Called when there is an error while registering member for push notifications
     *
     * @param error the error object containing the error code and message
     */
    void onMemberRegistrationError(ApiError error);
}
