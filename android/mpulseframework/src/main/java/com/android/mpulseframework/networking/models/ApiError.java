package com.android.mpulseframework.networking.models;

/**
 * The API Error model to store the API error details
 */
public class ApiError {

    /**
     * The error message containing the reason for the API error
     */
    private String mErrorMessage;

    /**
     * The API error code
     */
    private int mErrorCode = 0;

    /**
     * Constructor for ApiError
     */
    public ApiError() {
    }

    /**
     * Constructor for ApiError
     *
     * @param throwable the throwable in case there was an exception during the API call
     */
    public ApiError(Throwable throwable) {
        mErrorMessage = throwable.getMessage();
    }

    /**
     * Constructor for ApiError
     *
     * @param mErrorMessage the error message containing the reason for the API error
     */
    public ApiError(String mErrorMessage) {
        this.mErrorMessage = mErrorMessage;
    }

    /**
     * Constructor for ApiError
     *
     * @param mErrorCode the error code for the API error
     */
    public ApiError(int mErrorCode) {
        this.mErrorCode = mErrorCode;
    }

    /**
     * Constructor for ApiError
     *
     * @param mErrorMessage the error message containing the reason for the API error
     * @param mErrorCode    the error code for the API error
     */
    public ApiError(String mErrorMessage, int mErrorCode) {
        this.mErrorMessage = mErrorMessage;
        this.mErrorCode = mErrorCode;
    }

    /**
     * Getter for the API error code
     *
     * @return the API error code
     */
    public int getErrorCode() {
        return this.mErrorCode;
    }

    /**
     * Setter for the API error code
     *
     * @param errorCode the API error code to set
     */
    public void setErrorCode(int errorCode) {
        this.mErrorCode = errorCode;
    }

    /**
     * Getter for the API error message
     *
     * @return the API error message
     */
    public String getErrorMessage() {
        return mErrorMessage;
    }

    /**
     * Setter for the API error message
     *
     * @param errorMessage the API error message to set
     */
    public void setErrorMessage(String errorMessage) {
        this.mErrorMessage = errorMessage;
    }
}
