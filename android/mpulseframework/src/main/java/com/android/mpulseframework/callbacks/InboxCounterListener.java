package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.Response;
import com.android.mpulseframework.securemessages.models.MessageCounts;

/**
 * Interface to give call back on success or failure of fetching inbox counter
 */
public interface InboxCounterListener {

    /**
     * Called when the inbox counter has been fetched successfully
     * @param response the API response object
     */
    void onInboxCounterFetchSuccess(Response<MessageCounts> response);

    /**
     * Called when there is an error while fetching the inbox counter
     *
     * @param error the error object containing the error code and message
     */
    void onInboxCounterFetchError(ApiError error);
}
