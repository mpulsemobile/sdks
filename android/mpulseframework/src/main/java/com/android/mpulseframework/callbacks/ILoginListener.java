package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.admin.login.LoginResponseModel;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.Response;

public interface ILoginListener {

    /**
     * Called when the Login successfully
     *
     * @param response the API response object
     */
    void onLoginSuccess(Response<LoginResponseModel> response);

    /**
     * Called when there is an error while fetching the inbox counter
     *
     * @param error the error object containing the error code and message
     */
    void onLoginFailure(ApiError error);
}
