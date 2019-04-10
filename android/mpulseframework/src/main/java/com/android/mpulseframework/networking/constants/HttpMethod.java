package com.android.mpulseframework.networking.constants;

/**
 * Enum to denote the HTTP Method type
 */
public enum HttpMethod {
    /**
     * Constant for HTTP GET method
     */
    GET("GET"),

    /**
     * Constant for HTTP POST method
     */
    POST("POST");

    /**
     * Stores the method name
     */
    private final String mMethod;

    /**
     * The constructor of the enum
     *
     * @param method the method name
     */
    HttpMethod(String method) {
        mMethod = method;
    }

    /**
     * Returns the value of the HTTP Method, that is the method name
     *
     * @return the method name
     */
    public String getValue() {
        return mMethod;
    }
}