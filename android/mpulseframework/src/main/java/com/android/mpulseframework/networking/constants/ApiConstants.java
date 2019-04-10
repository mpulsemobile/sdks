package com.android.mpulseframework.networking.constants;

/**
 * Interface containing constants used while API calling
 */
public interface ApiConstants {

    /**
     * Constant to denote the error message when an API request is cancelled by user
     */
    String ERROR_MESSAGE_CANCELLED = "Request cancelled by user";

    /**
     * Constant to denote the error message when there is a network connectivity problem
     */
    String ERROR_MESSAGE_INTERNET = "Internet connection appears to be offline, please connect and try again";

    /**
     * The URL scheme for the API call
     */
    String URL_SCHEME = "https";
}
