package com.android.mpulseframework.tracking;

import com.android.mpulseframework.MPulseSharedPreference;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.securemessages.SecureMessagesConfig;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * This class handles all operations related to sending the SDK usage tracking data
 */
public class TrackAppUsageUtil {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(TrackAppUsageUtil.class);

    /**
     * Used to call the API to track app usage of the SDK
     *
     * @param config the app tracking configuration object that stores the app usage tracking configuration for MPulse {@link TrackAppUsageConfig}
     */
    public void trackAppUsage(TrackAppUsageConfig config) {
        ApiManager.post(config.getMPulseUrl())
                .addPathParameter(MPulseConstants.URL_API)
                .addPathParameter(String.valueOf(config.getAccountId()))
                .addPathParameter(MPulseConstants.URL_TRACK)
                .addPathParameter(MPulseConstants.URL_INSTALLATION)
                .addJSONObjectBody(getJSONBody(config))
                .addHeaders(getHeadersMap(config))
                .setTag(MPulseConstants.URL_TRACK)
                .build()
                .execute(mTrackAppUsageApiListener);
    }

    /**
     * Builds and returns the JSON body containing the request parameters for the API request
     *
     * @param config the app tracking configuration object that stores the app usage tracking configuration for MPulse {@link TrackAppUsageConfig}
     * @return the map containing the header parameters for the API request
     */
    private JSONObject getJSONBody(TrackAppUsageConfig config) {
        try {
            JSONObject object = new JSONObject();
            object.put(MPulseConstants.KEY_APP_ID_TRACK, config.getAppId());
            object.put(MPulseConstants.KEY_APP_MEMBER_ID_TRACK, config.getAppMemberId());
            object.put(MPulseConstants.KEY_ACCOUNT_ID_TRACK, config.getAccountId());
            object.put(MPulseConstants.KEY_DEVICE_TYPE_TRACK, config.getDeviceType());
            object.put(MPulseConstants.KEY_APP_VERSION_TRACK, config.getAppVersion());
            object.put(MPulseConstants.KEY_OS_TRACK, config.getDeviceOS());
            return object;
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
            return null;
        }
    }

    /**
     * Builds and returns the map containing the headers for the API request
     *
     * @param config the app tracking configuration object that stores the app usage tracking configuration for MPulse {@link TrackAppUsageConfig}
     * @return the map containing the header parameters for the API request
     */
    private Map<String, String> getHeadersMap(TrackAppUsageConfig config) {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_USER_AGENT_FROM, MPulseConstants.USER_AGENT_SDK);
        headerMap.put(MPulseConstants.KEY_HEADER_ACCESS_KEY, config.getAccessKey());
        headerMap.put(MPulseConstants.KEY_HEADER_CONTENT_TYPE, MPulseConstants.KEY_HEADER_CONTENT_TYPE_JSON);
        return headerMap;
    }


    /**
     * The API listener that receives callback on success or failure of the API request
     */
    private IApiListener<String> mTrackAppUsageApiListener = new IApiListener<String>() {

        @Override
        public void onSuccess(ApiResponse<String> response) {
            LOGGER.error("onSuccess " + response.getResult());
            MPulseSharedPreference.getInstance().setBoolean(MPulseSharedPreference.PreferenceKeys.KEY_IS_FIRST_TIME, false);
        }

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
        }
    };
}
