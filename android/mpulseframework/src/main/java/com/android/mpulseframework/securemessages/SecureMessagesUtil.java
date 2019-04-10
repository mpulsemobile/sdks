package com.android.mpulseframework.securemessages;

import android.content.Context;

import com.android.mpulseframework.callbacks.InboxCounterListener;
import com.android.mpulseframework.callbacks.MPulseInboxViewListener;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.networking.models.Response;
import com.android.mpulseframework.securemessages.inbox.MPulseInboxView;
import com.android.mpulseframework.securemessages.models.MessageCounts;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * This class handles all operations related to getting the secure messages
 */
public class SecureMessagesUtil {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(SecureMessagesUtil.class);

    /**
     * The listener object required to give callback on success or failure of fetching the inbox counter {@link InboxCounterListener}
     */
    private InboxCounterListener mInboxCounterListener;

    /**
     * Used to call the API to get secure messages
     *
     * @param context the context of the calling class
     * @param config   the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @param listener the listener to get callback for events when inbox is loading {@link MPulseInboxViewListener}
     */
    public MPulseInboxView getInboxView(Context context, SecureMessagesConfig config, MPulseInboxViewListener listener) {
        MPulseInboxView webView = new MPulseInboxView(context);
        webView.setSecureMessageConfig(config);
        webView.setInboxViewListener(listener);
        return webView;
    }

    /**
     * Used to call the API to fetch the inbox counter
     *
     * @param config   the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @param listener the listener to give callback on success or failure of fetching the inbox counter {@link InboxCounterListener}
     */
    public void getMessageCount(SecureMessagesConfig config, InboxCounterListener listener) {
        mInboxCounterListener = listener;
        ApiManager.get(config.getMPulseUrl())
                .addPathParameter(MPulseConstants.URL_COUNTER)
                .addQueryParameters(getQueryMap(config))
                .setTag(MPulseConstants.URL_COUNTER)
                .build()
                .execute(mFetchInboxCounterApiListener);
    }

    /**
     * Builds and returns the map containing the query parameters for the API request
     *
     * @param config the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @return the map containing the query parameters for the API request
     */
    private Map<String, String> getQueryMap(SecureMessagesConfig config) {
        Map<String, String> queryMap = new HashMap<>();
        queryMap.put(MPulseConstants.KEY_APP_ID_COUNTER, config.getAppId());
        queryMap.put(MPulseConstants.KEY_PLATFORM, config.getPlatform());
        queryMap.put(MPulseConstants.KEY_APP_MEMBER_ID, config.getAppMemberId());
        queryMap.put(MPulseConstants.KEY_VERSION, MPulseConstants.VERSION);
        return queryMap;
    }

    /**
     * Parses the JSON inbox counters response and returns the InboxCounter model containing the inbox counters {@link MessageCounts}
     * @param inboxCountersJSON the JSON response to parse
     * @return the parsed InboxCounter model containing the inbox counters {@link MessageCounts}
     */
    private MessageCounts parseInboxCounters(String inboxCountersJSON){
        MessageCounts counters = new MessageCounts();
        try {
            JSONObject inboxCountersJsonObject = new JSONObject(inboxCountersJSON);
            if (!inboxCountersJsonObject.isNull(MPulseConstants.KEY_JSON_TOTAL_READ)){
                counters.setTotalRead(inboxCountersJsonObject.getInt(MPulseConstants.KEY_JSON_TOTAL_READ));
            }
            if (!inboxCountersJsonObject.isNull(MPulseConstants.KEY_JSON_TOTAL_UNREAD)){
                counters.setTotalUnread(inboxCountersJsonObject.getInt(MPulseConstants.KEY_JSON_TOTAL_UNREAD));
            }
            if (!inboxCountersJsonObject.isNull(MPulseConstants.KEY_JSON_TOTAL_DELETED)){
                counters.setTotalDeleted(inboxCountersJsonObject.getInt(MPulseConstants.KEY_JSON_TOTAL_DELETED));
            }
            if (!inboxCountersJsonObject.isNull(MPulseConstants.KEY_JSON_TOTAL_UN_DELETED)){
                counters.setTotalUnDeleted(inboxCountersJsonObject.getInt(MPulseConstants.KEY_JSON_TOTAL_UN_DELETED));
            }
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
        }
        return counters;
    }

    /**
     * The API listener that receives callback on success or failure of the API request
     */
    private IApiListener<String> mFetchInboxCounterApiListener = new IApiListener<String>() {

        @Override
        public void onSuccess(ApiResponse<String> response) {
            LOGGER.error("onSuccess " + response.getResult());
            if (mInboxCounterListener != null) {
                if (response.isSuccess()) {
                    mInboxCounterListener.onInboxCounterFetchSuccess(new Response<>(parseInboxCounters(response.getResult()), response.getResponseCode()));
                } else {
                    mInboxCounterListener.onInboxCounterFetchError(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (mInboxCounterListener != null) {
                mInboxCounterListener.onInboxCounterFetchError(error);
            }
        }
    };
}
