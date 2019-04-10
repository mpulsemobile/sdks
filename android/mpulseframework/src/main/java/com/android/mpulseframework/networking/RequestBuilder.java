package com.android.mpulseframework.networking;

import java.util.List;
import java.util.Map;

/**
 * The interface used to build an API request
 */
public interface RequestBuilder {

    /**
     * Used to set the tag for the API request
     *
     * @param tag the tag to set on the API request
     * @return the RequestBuilder
     */
    RequestBuilder setTag(String tag);

    /**
     * Used to add a header to the API request
     *
     * @param key   the key for the request header
     * @param value the value of the request header
     * @return the RequestBuilder
     */
    RequestBuilder addHeader(String key, String value);

    /**
     * Used to add a map containing headers for the API request
     *
     * @param headerMap a map of headers to add to the API request
     * @return the RequestBuilder
     */
    RequestBuilder addHeaders(Map<String, String> headerMap);

    /**
     * Used to add a query parameter to the API request
     *
     * @param key   the key for the query parameter
     * @param value the value of the query parameter
     * @return the RequestBuilder
     */
    RequestBuilder addQueryParameter(String key, String value);

    /**
     * Used to add a map containing query parameters for the API request
     *
     * @param queryParameterMap a map of query parameters to add to the API request
     * @return the RequestBuilder
     */
    RequestBuilder addQueryParameters(Map<String, String> queryParameterMap);

    /**
     * Used to add a path parameter to the API request
     *
     * @param value the value of the path parameter
     * @return the RequestBuilder
     */
    RequestBuilder addPathParameter(String value);

    /**
     * Used to add a list containing path parameters for the API request
     *
     * @param pathParameterList a list containing path parameters for the API request
     * @return the RequestBuilder
     */
    RequestBuilder addPathParameters(List<String> pathParameterList);
}
