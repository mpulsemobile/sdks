package com.android.mpulseframework.admin.event;

import android.text.TextUtils;
import android.util.Log;

import com.android.mpulseframework.admin.CustomFieldsModel;
import com.android.mpulseframework.admin.MPulseAdminConstants;
import com.android.mpulseframework.admin.MPulseApiConfig;
import com.android.mpulseframework.admin.MPulseApiConstant;
import com.android.mpulseframework.callbacks.MPulseUploadEventListener;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MPulseEventUtil {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(MPulseEventUtil.class);
    private MPulseUploadEventListener iMemberListener;

    /**
     * This method will upload Event
     *
     * @param accessToken required for identification
     * @param config contains some information like url , client secret ,client id
     * @param listener is used to provide call back to user whether user has successfully triggered events or not
     */
    public void addEvent(UploadEventRequestModel requestModel,String accessToken,
    MPulseApiConfig config, MPulseUploadEventListener listener) {
        this.iMemberListener = listener;
        ApiManager.post(config.getUrl())
                .addPathParameter(MPulseApiConstant.SDK)
                .addPathParameter(MPulseApiConstant.ACCOUNTS)
                .addPathParameter(config.getAccountId())
                .addPathParameter(MPulseApiConstant.UPLOAD_EVENT_END_POINT)
                .addJSONObjectBody(getJSONBody(requestModel))
                .addHeaders(getHeadersMap(accessToken))
                .build()
                .execute(IUploadEventResponseListener);
    }

    /**
    * @param requestModel contains necessary data for triggering event
     * @return the Json object for sending params in body for upload events
     * Will have to create json format like this
     * Below is the json format
     * {"body":{"listid":"1000","events":{"name":"test","event":{"appmemberid":"sikh","timezone":"Asia\/Kolkata","name":"test","scheduled_on":"+00:00","evaluation_scope":"no_rule"}}}}
     */
    private JSONObject getJSONBody(UploadEventRequestModel requestModel) {
        try {
            JSONObject jsonObject = new JSONObject();
            JSONObject jsonBodyObject = new JSONObject();
            JSONObject jsonEventsObject = new JSONObject();
            JSONObject jsonEventObject = new JSONObject();
            if(!TextUtils.isEmpty(requestModel.getListId())) {
                jsonBodyObject.put(MPulseAdminConstants.LIST_ID, requestModel.getListId());
            }
            if(!TextUtils.isEmpty(requestModel.getEventName())) {
                jsonEventsObject.put(MPulseAdminConstants.NAME, requestModel.getEventName());
            }
            if(!TextUtils.isEmpty(requestModel.getTimeZone())) {
                jsonEventObject.put(MPulseAdminConstants.TIMEZONE, requestModel.getTimeZone());
            }
            if(!TextUtils.isEmpty(requestModel.getScheduledOn())) {
                jsonEventObject.put(MPulseAdminConstants.SCHEDULE_ON, requestModel.getScheduledOn());
            }
            if(!TextUtils.isEmpty(requestModel.getEvaluationScope())) {
                jsonEventObject.put(MPulseAdminConstants.EVALUATION_SCOPE, requestModel.getEvaluationScope());
            }
            if(!TextUtils.isEmpty(requestModel.getCorrelationId())) {
                jsonEventObject.put(MPulseAdminConstants.CORRELATION_ID, requestModel.getCorrelationId());
            }
            if(!TextUtils.isEmpty(requestModel.getMemberId())) {
                jsonEventObject.put(MPulseAdminConstants.MEMBER_ID, requestModel.getMemberId());
            }

            jsonEventsObject.put(MPulseAdminConstants.EVENT, jsonEventObject);
            jsonBodyObject.put(MPulseAdminConstants.EVENTS, jsonEventsObject);
            jsonObject.put(MPulseAdminConstants.BODY, jsonBodyObject);

            for(CustomFieldsModel request:requestModel.getFieldsModelList()){
                jsonEventObject.put(request.getKey(), request.getValue());
            }

            Log.e("event json",jsonObject.toString());
            return jsonObject;
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
            return null;
        }
    }

    /**
     * Builds and returns the map containing the headers for the API mRequestModel
     *
     * @param accessToken is used to pass in header for authenticate
     * @return the map containing the header parameters for the API mRequestModel
     */
    private Map<String, String> getHeadersMap(String accessToken) {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_USER_AGENT, MPulseConstants.USER_AGENT_MOBILE);
        headerMap.put(MPulseConstants.KEY_HEADER_CONTENT_TYPE, MPulseConstants.KEY_HEADER_CONTENT_TYPE_JSON);
        headerMap.put(MPulseConstants.ACCESS_TOKEN, accessToken);
        return headerMap;
    }

    /**
     * UploadEventResponseListener will receives callback of success or failure of upload event api
     */
    private IApiListener<String> IUploadEventResponseListener = new IApiListener<String>() {

        /**
        * onSuccess will get call back when event is triggered successfully
        *@param response contains data after successfully uploading event
        * */
        @Override
        public void onSuccess(ApiResponse<String> response) {
            //LOGGER.error("onSuccess " + response.getResult().toString());
            if (iMemberListener != null) {
                if (response.isSuccess()) {
                    iMemberListener.onUploadEventSuccess();
                } else {
                    iMemberListener.onUploadEventFailure(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }
        /**
        *@param error contains information why event couldn't be triggered
        *
        * */

        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (iMemberListener != null) {
                iMemberListener.onUploadEventFailure(error);
            }
        }
    };


}
