package com.android.mpulseframework.networking;

import android.net.Uri;

import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.constants.ApiConstants;
import com.android.mpulseframework.networking.constants.HttpMethod;
import com.android.mpulseframework.networking.executor.ApiExecutorSupplier;
import com.android.mpulseframework.networking.executor.ApiRequestQueue;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Future;

/**
 * Used to store the details for the API request
 */
public class ApiRequest {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(ApiRequest.class);

    /**
     * The HTTP method for the API request {@link HttpMethod}
     */
    private HttpMethod mMethod;

    /**
     * The KEY_MIDDLE_WARE_URL of the API request
     */
    private String mUrl;

    /**
     * The tag of the API request
     */
    private String mTag;

    /**
     * A map of headers for the API request
     */
    private Map<String, List<String>> mHeadersMap = new HashMap<>();

    /**
     * A map of query parameters for the API request
     */
    private Map<String, List<String>> mQueryParameterMap = new HashMap<>();

    /**
     * A list of path parameters for the API request
     */
    private List<String> mPathParameterList = new ArrayList<>();

    /**
     * JSON string containing the request body
     */
    private String mRequestJsonString;

    /**
     * A map of UrlEncodedFormBody type for the API request
     */

    private HashMap<String, String> mUrlEncodedFormBodyParameterMap = new HashMap<>();

    /**
     * A future object to manage the API call
     */
    private Future future;

    /**
     * To determine if the API request has been cancelled
     */
    private boolean isCancelled;

    /**
     * To determine if the API request has been delivered
     */
    private boolean isDelivered;

    /**
     * The API listener to give callback on success or failure of the API
     */
    private IApiListener mApiListener;

    /**
     * Constructor of ApiRequest
     *
     * @param builder the GetRequestBuilder to build to ApiRequest {@link GetRequestBuilder}
     */
    ApiRequest(GetRequestBuilder builder) {
        this.mMethod = builder.mMethod;
        this.mUrl = builder.mUrl;
        this.mTag = builder.mTag;
        this.mHeadersMap = builder.mHeadersMap;
        this.mQueryParameterMap = builder.mQueryParameterMap;
        this.mPathParameterList = builder.mPathParameterList;
    }

    /**
     * Constructor of ApiRequest
     *
     * @param builder the PostRequestBuilder to build to ApiRequest {@link PostRequestBuilder}
     */
    ApiRequest(PostRequestBuilder builder) {
        this.mMethod = builder.mMethod;
        this.mUrl = builder.mUrl;
        this.mTag = builder.mTag;
        this.mHeadersMap = builder.mHeadersMap;
        this.mQueryParameterMap = builder.mQueryParameterMap;
        this.mPathParameterList = builder.mPathParameterList;
        this.mRequestJsonString = builder.mRequestJsonString;
        this.mUrlEncodedFormBodyParameterMap = builder.mUrlEncodedFormBodyParameterMap;
    }

    /**
     * Used to execute the API request
     *
     * @param apiListener the API listener to give callback on success or failure of the API
     */
    public void execute(IApiListener apiListener) {
        this.mApiListener = apiListener;
        ApiRequestQueue.getInstance().addRequest(this);
    }

    /**
     * Used to build the KEY_MIDDLE_WARE_URL from the path and query parameters and return it
     *
     * @return the KEY_MIDDLE_WARE_URL for the API request
     */
    public String getUrl() {
        String[] urlParts = mUrl.split("/");
        for (int i = urlParts.length - 1; i > 0; i--) {
            mPathParameterList.add(0, urlParts[i]);
        }
        mUrl = urlParts[0];
        Uri.Builder urlBuilder = new Uri.Builder();
        urlBuilder.scheme(ApiConstants.URL_SCHEME)
                .authority(mUrl);
        for (String path : mPathParameterList) {
            urlBuilder.appendPath(path);
        }
        if (mQueryParameterMap != null) {
            Set<Map.Entry<String, List<String>>> entries = mQueryParameterMap.entrySet();
            for (Map.Entry<String, List<String>> entry : entries) {
                String name = entry.getKey();
                List<String> list = entry.getValue();
                if (list != null) {
                    for (String value : list) {
                        urlBuilder.appendQueryParameter(name, value);
                    }
                }
            }
        }
        return urlBuilder.build().toString();
    }

    /**
     * Setter for the API tag
     *
     * @return the API tag
     */
    public String getTag() {
        return mTag;
    }

    /**
     * Getter for the HttpMethod object {@link HttpMethod}
     *
     * @return the HttpMethod {@link HttpMethod}
     */
    public HttpMethod getMethod() {
        return mMethod;
    }

    /**
     * Getter for the request JSON string
     *
     * @return the request JSON string
     */
    public String getRequestJsonString() {
        return mRequestJsonString;
    }


    /**
     *This method is Converting HaspMap of UrlEncodingParams into String
     * */
    public String getUrlEncodedParamsString() {
        if (mUrlEncodedFormBodyParameterMap == null) {
            return null;
        }
        StringBuilder result = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String, String> entry : mUrlEncodedFormBodyParameterMap.entrySet()) {
            if (first)
                first = false;
            else
                result.append("&");
            try {
                result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
                result.append("=");
                result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                return null;
            }
        }
        return result.toString();
    }

    /**
     * Used to cancel the API request
     */
    public void cancel() {
        try {
            isCancelled = true;
            if (future != null) {
                future.cancel(true);
            }
            if (!isDelivered) {
                deliverError(new ApiError());
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Getter for isCancelled
     *
     * @return isCancelled
     */
    public boolean isCanceled() {
        return isCancelled;
    }

    /**
     * Setter for the future object
     *
     * @param future the future object to set
     */
    public void setFuture(Future future) {
        this.future = future;
    }

    /**
     * Used to destroy the ApiRequest object
     */
    public void destroy() {
        mApiListener = null;
    }

    /**
     * Used to finish the API request
     */
    private void finish() {
        destroy();
        ApiRequestQueue.getInstance().finish(this);
    }

    /**
     * Used to deliver an API error
     *
     * @param error the ApiError object containing the error details {@link ApiError}
     */
    public synchronized void deliverError(ApiError error) {
        try {
            if (!isDelivered) {
                if (isCancelled) {
                    error.setErrorMessage(ApiConstants.ERROR_MESSAGE_CANCELLED);
                    error.setErrorCode(0);
                }
                deliverErrorResponse(error);
            }
            isDelivered = true;
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Used to deliver API response
     *
     * @param response the ApiResponse object containing the API response details {@link ApiResponse}
     */
    public void deliverResponse(final ApiResponse response) {
        try {
            isDelivered = true;
            if (!isCancelled) {
                ApiExecutorSupplier.getInstance().forMainThreadTasks().execute(new Runnable() {
                    public void run() {
                        deliverSuccessResponse(response);
                    }
                });
            } else {
                ApiExecutorSupplier.getInstance().forMainThreadTasks().execute(new Runnable() {
                    public void run() {
                        ApiError apiError = new ApiError(ApiConstants.ERROR_MESSAGE_CANCELLED, 0);
                        response.setApiError(apiError);
                        deliverErrorResponse(apiError);
                    }
                });
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Used to deliver an API response in case the API succeeds
     *
     * @param response the ApiResponse object containing the API response details {@link ApiResponse}
     */
    private void deliverSuccessResponse(ApiResponse response) {
        if (mApiListener != null) {
            mApiListener.onSuccess(response);
        }
        finish();
    }

    /**
     * Used to deliver an error response in case the API fails
     *
     * @param apiError the ApiError object containing the error details {@link ApiError}
     */
    private void deliverErrorResponse(ApiError apiError) {
        if (mApiListener != null) {
            mApiListener.onError(apiError);
        }
        finish();
    }

    /**
     * Getter for the map of headers for the API request
     *
     * @return the map of headers for the API request
     */
    public Map<String, List<String>> getHeaders() {
        return mHeadersMap;
    }

    /**
     * The request builder for a POST request
     */
    public static class PostRequestBuilder implements RequestBuilder {

        /**
         * The HTTP method for the API request which will be GET for this builder {@link HttpMethod}
         */
        private HttpMethod mMethod = HttpMethod.POST;

        /**
         * The KEY_MIDDLE_WARE_URL of the API request
         */
        private String mUrl;

        /**
         * The tag of the API request
         */
        private String mTag;

        /**
         * A map of headers for the API request
         */
        private Map<String, List<String>> mHeadersMap = new HashMap<>();

        /**
         * A map of query parameters for the API request
         */
        private Map<String, List<String>> mQueryParameterMap = new HashMap<>();

        /**
         * A list of path parameters for the API request
         */
        private List<String> mPathParameterList = new ArrayList<>();

        /**
         * JSON string containing the request body
         */
        private String mRequestJsonString;

        private HashMap<String, String> mUrlEncodedFormBodyParameterMap = new HashMap<>();

        /**
         * Constructor of the PostRequestBuilder
         *
         * @param url the KEY_MIDDLE_WARE_URL for the POST request
         */
        PostRequestBuilder(String url) {
            this.mUrl = url;
        }

        @Override
        public PostRequestBuilder setTag(String tag) {
            mTag = tag;
            return this;
        }

        @Override
        public PostRequestBuilder addQueryParameter(String key, String value) {
            List<String> list = mQueryParameterMap.get(key);
            if (list == null) {
                list = new ArrayList<>();
                mQueryParameterMap.put(key, list);
            }
            if (!list.contains(value)) {
                list.add(value);
            }
            return this;
        }

        @Override
        public PostRequestBuilder addQueryParameters(Map<String, String> queryParameterMap) {
            if (queryParameterMap != null) {
                for (HashMap.Entry<String, String> entry : queryParameterMap.entrySet()) {
                    addQueryParameter(entry.getKey(), entry.getValue());
                }
            }
            return this;
        }

        @Override
        public PostRequestBuilder addPathParameter(String value) {
            mPathParameterList.add(value);
            return this;
        }

        @Override
        public PostRequestBuilder addPathParameters(List<String> pathParameterList) {
            if (pathParameterList != null) {
                mPathParameterList.addAll(pathParameterList);
            }
            return this;
        }

        @Override
        public PostRequestBuilder addHeader(String key, String value) {
            List<String> list = mHeadersMap.get(key);
            if (list == null) {
                list = new ArrayList<>();
                mHeadersMap.put(key, list);
            }
            if (!list.contains(value)) {
                list.add(value);
            }
            return this;
        }

        @Override
        public PostRequestBuilder addHeaders(Map<String, String> headerMap) {
            if (headerMap != null) {
                for (HashMap.Entry<String, String> entry : headerMap.entrySet()) {
                    addHeader(entry.getKey(), entry.getValue());
                }
            }
            return this;
        }

        /**
         * Used to add a JSON object containing the request parameters
         *
         * @param jsonObject the JSON object containing the request parameters
         * @return the RequestBuilder
         */
        public PostRequestBuilder addJSONObjectBody(JSONObject jsonObject) {
            if (jsonObject != null) {
                mRequestJsonString = jsonObject.toString();
            }
            return this;
        }

        /**
         * Used to add a JSON array containing the request parameters
         *
         * @param jsonArray the JSON array containing the request parameters
         * @return the RequestBuilder
         */
        public PostRequestBuilder addJSONArrayBody(JSONArray jsonArray) {
            if (jsonArray != null) {
                mRequestJsonString = jsonArray.toString();
            }
            return this;
        }

        public PostRequestBuilder addUrlEncodedFormBodyParameter(String key, String value) {
            mUrlEncodedFormBodyParameterMap.put(key, value);
            return this;
        }

        public PostRequestBuilder addUrlEncodedFormBodyParameters(Map<String, String> urlEncodedFormBodyParameterMap) {
            if (urlEncodedFormBodyParameterMap != null) {
                mUrlEncodedFormBodyParameterMap.putAll(urlEncodedFormBodyParameterMap);
            }
            return this;
        }

        /**
         * Builds and returns an ApiRequest object from the PostRequestBuilder {@link ApiRequest}
         *
         * @return the ApiRequest object from the PostRequestBuilder {@link ApiRequest}
         */
        public ApiRequest build() {
            return new ApiRequest(this);
        }
    }

    /**
     * The request builder for a GET request
     */
    public static class GetRequestBuilder implements RequestBuilder {

        /**
         * The HTTP method for the API request which will be GET for this builder {@link HttpMethod}
         */
        private HttpMethod mMethod = HttpMethod.GET;

        /**
         * The KEY_MIDDLE_WARE_URL of the API request
         */
        private String mUrl;

        /**
         * The tag of the API request
         */
        private String mTag;

        /**
         * A map of headers for the API request
         */
        private Map<String, List<String>> mHeadersMap = new HashMap<>();

        /**
         * A map of query parameters for the API request
         */
        private Map<String, List<String>> mQueryParameterMap = new HashMap<>();

        /**
         * A list of path parameters for the API request
         */
        private List<String> mPathParameterList = new ArrayList<>();

        /**
         * Constructor of the GetRequestBuilder
         *
         * @param url the KEY_MIDDLE_WARE_URL for the GET request
         */
        GetRequestBuilder(String url) {
            this.mUrl = url;
        }

        @Override
        public GetRequestBuilder setTag(String tag) {
            mTag = tag;
            return this;
        }

        @Override
        public GetRequestBuilder addQueryParameter(String key, String value) {
            List<String> list = mQueryParameterMap.get(key);
            if (list == null) {
                list = new ArrayList<>();
                mQueryParameterMap.put(key, list);
            }
            if (!list.contains(value)) {
                list.add(value);
            }
            return this;
        }

        @Override
        public GetRequestBuilder addQueryParameters(Map<String, String> queryParameterMap) {
            if (queryParameterMap != null) {
                for (HashMap.Entry<String, String> entry : queryParameterMap.entrySet()) {
                    addQueryParameter(entry.getKey(), entry.getValue());
                }
            }
            return this;
        }

        @Override
        public GetRequestBuilder addPathParameter(String value) {
            mPathParameterList.add(value);
            return this;
        }

        @Override
        public GetRequestBuilder addPathParameters(List<String> pathParameterList) {
            if (pathParameterList != null) {
                mPathParameterList.addAll(pathParameterList);
            }
            return this;
        }

        @Override
        public GetRequestBuilder addHeader(String key, String value) {
            List<String> list = mHeadersMap.get(key);
            if (list == null) {
                list = new ArrayList<>();
                mHeadersMap.put(key, list);
            }
            if (!list.contains(value)) {
                list.add(value);
            }
            return this;
        }

        @Override
        public GetRequestBuilder addHeaders(Map<String, String> headerMap) {
            if (headerMap != null) {
                for (HashMap.Entry<String, String> entry : headerMap.entrySet()) {
                    addHeader(entry.getKey(), entry.getValue());
                }
            }
            return this;
        }

        /**
         * Builds and returns an ApiRequest object from the GetRequestBuilder {@link ApiRequest}
         *
         * @return the ApiRequest object from the GetRequestBuilder {@link ApiRequest}
         */
        public ApiRequest build() {
            return new ApiRequest(this);
        }
    }

    @Override
    public String toString() {
        return "ApiRequest{" +
                ", mMethod=" + mMethod +
                ", mUrl=" + mUrl +
                '}';
    }
}
