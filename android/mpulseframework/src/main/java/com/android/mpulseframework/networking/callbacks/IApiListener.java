package com.android.mpulseframework.networking.callbacks;

import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;

/**
 * This interface gives response and error callbacks for the API
 */
public interface IApiListener<T> {

    /**
     * Called on success of the API
     *
     * @param response the API response of type T
     */
    void onSuccess(ApiResponse<T> response);

    /**
     * Called when an API call fails
     *
     * @param error the error object containing the error code and message
     */
    void onError(ApiError error);
}
