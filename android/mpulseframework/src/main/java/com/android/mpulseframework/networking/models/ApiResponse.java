package com.android.mpulseframework.networking.models;

import javax.net.ssl.HttpsURLConnection;

/**
 * The API response model that stores the details of the API response
 *
 * @param <T> the type of the API response
 */
public class ApiResponse<T> {

    /**
     * The result object of the API response
     */
    private T mResult;

    /**
     * The response code of the API
     */
    private int mResponseCode;

    /**
     * The API error object {@link ApiError}
     */
    private ApiError mApiError;

    /**
     * Constructor of ApiResponse
     *
     * @param mResponseCode the response code of the API
     */
    public ApiResponse(int mResponseCode) {
        this.mResponseCode = mResponseCode;
    }

    /**
     * Getter for the API result object
     *
     * @return the API result object
     */
    public T getResult() {
        return mResult;
    }

    /**
     * Setter for the API result object
     *
     * @param mResult the API result object to set
     */
    public void setResult(T mResult) {
        this.mResult = mResult;
    }

    /**
     * Getter for the API response code
     *
     * @return the API response to
     */
    public int getResponseCode() {
        return mResponseCode;
    }

    /**
     * Setter for the API response code
     *
     * @param mResponseCode the API response code to set
     */
    public void setResponseCode(int mResponseCode) {
        this.mResponseCode = mResponseCode;
    }

    /**
     * Getter for the API error object {@link ApiError}
     *
     * @return the API error object {@link ApiError}
     */
    public ApiError getApiError() {
        return mApiError;
    }

    /**
     * Setter for the API error object {@link ApiError}
     *
     * @param mApiError the API error object to set {@link ApiError}
     */
    public void setApiError(ApiError mApiError) {
        this.mApiError = mApiError;
    }

    /**
     * Checks if the API call was successful
     *
     * @return true if the API call was successful, else returns false
     */
    public boolean isSuccess() {
        return mResponseCode >= HttpsURLConnection.HTTP_OK && mResponseCode < HttpsURLConnection.HTTP_BAD_REQUEST;
    }
}
