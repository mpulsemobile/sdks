package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.networking.models.ApiError;

public interface MPulseUploadEventListener {


    /**
     * Called when Event Created successfully
     */
    void onUploadEventSuccess();

    /**
     * Called when there is an error while fetching the inbox counter
     *
     * @param error the error object containing the error code and message
     */
    void onUploadEventFailure(ApiError error);

}
