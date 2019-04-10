package com.android.mpulseframework.callbacks;

import com.android.mpulseframework.networking.models.ApiError;

public interface MPulseLoginListener {

    void onLoginSuccess();

    void onError(ApiError error);
}
