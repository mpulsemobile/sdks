package com.android.mpulseframework.networking.models;

/**
 * The API response model that stores the details of the API response
 *
 * @param <T> the type of the API response
 */
public class Response<T> {

    /**
     * The result object of the API response.
     * It would be the error message in case the API fails
     */
    private T mResponse;

    /**
     * The response code of the API
     */
    private int mResponseCode;

    /**
     * Constructor of ApiResponse
     *
     * @param mResponse the response of the API
     * @param mResponseCode the response code of the API
     */
    public Response(T mResponse, int mResponseCode) {
        this.mResponse = mResponse;
        this.mResponseCode = mResponseCode;
    }

    /**
     * Getter for the API result object
     *
     * @return the API result object
     */
    public T getResponse() {
        return mResponse;
    }

    /**
     * Setter for the API result object
     *
     * @param mResponse the API result object to set
     */
    public void setResponse(T mResponse) {
        this.mResponse = mResponse;
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
}
