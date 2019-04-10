package com.android.mpulseframework.networking;

import com.android.mpulseframework.networking.executor.ApiExecutorSupplier;
import com.android.mpulseframework.networking.executor.ApiRequestQueue;

/**
 * This class is used as an entry point for making any API calls
 */
public class ApiManager {

    /**
     * Used to create a GET request
     *
     * @param url the KEY_MIDDLE_WARE_URL for the GET request
     * @return the RequestBuilder for the GET request {@link com.android.mpulseframework.networking.ApiRequest.GetRequestBuilder}
     */
    public static ApiRequest.GetRequestBuilder get(String url) {
        return new ApiRequest.GetRequestBuilder(url);
    }

    /**
     * Used to create a POST request
     *
     * @param url the KEY_MIDDLE_WARE_URL for the GET request
     * @return the RequestBuilder for the POST request {@link com.android.mpulseframework.networking.ApiRequest.PostRequestBuilder}
     */
    public static ApiRequest.PostRequestBuilder post(String url) {
        return new ApiRequest.PostRequestBuilder(url);
    }

    /**
     * Used to cancel an API request with the given tag
     *
     * @param tag the tag of the API request to cancel
     */
    public static void cancel(String tag) {
        ApiRequestQueue.getInstance().cancelRequestWithGivenTag(tag);
    }

    /**
     * Used to cancel all API requests
     */
    public static void cancelAll() {
        ApiRequestQueue.getInstance().cancelAll();
    }

    /**
     * Used to destroy the ApiManager instance
     */
    public static void destroy() {
        ApiExecutorSupplier.destroy();
    }
}
