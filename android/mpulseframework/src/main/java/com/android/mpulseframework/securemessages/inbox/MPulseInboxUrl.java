package com.android.mpulseframework.securemessages.inbox;

import android.net.Uri;

import com.android.mpulseframework.networking.constants.ApiConstants;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Used to store the details for the secure messages inbox URL
 */
class MPulseInboxUrl {

    /**
     * The KEY_MIDDLE_WARE_URL of the secure messages KEY_MIDDLE_WARE_URL
     */
    private String mUrl;

    /**
     * A map of query parameters for the secure messages URL
     */
    private Map<String, List<String>> mQueryParameterMap = new HashMap<>();

    /**
     * A list of path parameters for the secure messages URL
     */
    private List<String> mPathParameterList = new ArrayList<>();

    /**
     * Constructor of InboxUrl
     *
     * @param builder the GetRequestBuilder to build to InboxUrl
     */
    MPulseInboxUrl(InboxUrlBuilder builder) {
        this.mUrl = builder.mUrl;
        this.mQueryParameterMap = builder.mQueryParameterMap;
        this.mPathParameterList = builder.mPathParameterList;
    }

    /**
     * Used to build the URL from the path and query parameters and return it
     *
     * @return the KEY_MIDDLE_WARE_URL for the secure messages KEY_MIDDLE_WARE_URL
     */
    String getUrl() {
        String[] urlParts = mUrl.split("/");
        for (int i = urlParts.length - 1; i > 0; i--) {
            mPathParameterList.add(0, urlParts[i]);
        }
        mUrl = urlParts[0];
        Uri.Builder urlBuilder = new Uri.Builder();
        urlBuilder.scheme(ApiConstants.URL_SCHEME)
                .authority(mUrl);
        for (String path : mPathParameterList) {
            urlBuilder.appendEncodedPath(path);
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
     * Builder class to build the MPulse secure messages inbox URL
     */
    static class InboxUrlBuilder {
        /**
         * The KEY_MIDDLE_WARE_URL of the secure messages KEY_MIDDLE_WARE_URL
         */
        private String mUrl;

        /**
         * A map of query parameters for the secure messages URL
         */
        private Map<String, List<String>> mQueryParameterMap = new HashMap<>();

        /**
         * A list of path parameters for the secure messages URL
         */
        private List<String> mPathParameterList = new ArrayList<>();

        /**
         * Constructor of the InboxUrlBuilder
         *
         * @param url the URL for the GET request
         */
        InboxUrlBuilder(String url) {
            this.mUrl = url;
        }

        /**
         * Used to add a query parameter to the secure messages URL
         *
         * @param key   the key for the query parameter
         * @param value the value of the query parameter
         * @return the RequestBuilder
         */
        InboxUrlBuilder addQueryParameter(String key, String value) {
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

        /**
         * Used to add a map containing query parameters for the secure messages URL
         *
         * @param queryParameterMap a map of query parameters to add to the secure messages URL
         * @return the RequestBuilder
         */
        InboxUrlBuilder addQueryParameters(Map<String, String> queryParameterMap) {
            if (queryParameterMap != null) {
                for (HashMap.Entry<String, String> entry : queryParameterMap.entrySet()) {
                    addQueryParameter(entry.getKey(), entry.getValue());
                }
            }
            return this;
        }

        /**
         * Used to add a path parameter to the secure messages URL
         *
         * @param value the value of the path parameter
         * @return the RequestBuilder
         */
        InboxUrlBuilder addPathParameter(String value) {
            mPathParameterList.add(value);
            return this;
        }

        /**
         * Used to add a list containing path parameters for the secure messages URL
         *
         * @param pathParameterList a list containing path parameters for the secure messages URL
         * @return the RequestBuilder
         */
        InboxUrlBuilder addPathParameters(List<String> pathParameterList) {
            if (pathParameterList != null) {
                mPathParameterList.addAll(pathParameterList);
            }
            return this;
        }

        /**
         * Builds and returns an InboxUrl object from the InboxUrlBuilder {@link MPulseInboxUrl}
         *
         * @return the InboxUrl object from the InboxUrlBuilder {@link MPulseInboxUrl}
         */
        MPulseInboxUrl build() {
            return new MPulseInboxUrl(this);
        }
    }
}
