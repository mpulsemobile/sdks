package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.networking.models.ApiError;

public interface MPulseAddOrUpdateMembersListener {

    /**
     * Called when Member added or updated successfully
     */
    void onAddUpdateMemberSuccess();

    /**
     * Called when there is an error while fetching the inbox counter
     *
     * @param error the error object containing the error code and message
     */
    void onAddUpdateMemberFailure(ApiError error);
}
