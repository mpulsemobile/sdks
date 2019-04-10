package com.android.mpulseframework.admin.members;

import android.text.TextUtils;

import com.android.mpulseframework.admin.CustomFieldsModel;
import com.android.mpulseframework.admin.MPulseAdminConstants;
import com.android.mpulseframework.admin.MPulseApiConfig;
import com.android.mpulseframework.admin.MPulseApiConstant;
import com.android.mpulseframework.callbacks.MPulseAddOrUpdateMembersListener;
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

public class MPulseMembersUtil {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(MPulseMembersUtil.class);
    private MPulseAddOrUpdateMembersListener iMemberListener;


    /**
     * This method will add/update members
     * @param accessToken required for authentication of user
     * @param config contains some basic information like url , client secret ,client id
     * @param listener is used for provide call back to user whether member added/updated successfully or not
     */
    public void addMembers(MemberRequestModel request,String accessToken, MPulseApiConfig config, MPulseAddOrUpdateMembersListener listener) {
        this.iMemberListener = listener;
        ApiManager.post(config.getUrl())
                .addPathParameter(MPulseApiConstant.SDK)
                .addPathParameter(MPulseApiConstant.ACCOUNTS)
                .addPathParameter(config.getAccountId())
                .addPathParameter(MPulseApiConstant.MEMBER_END_POINT)
                .addJSONObjectBody(getJSONBody(request))
                .addHeaders(getHeadersMap(accessToken))
                .build()
                .execute(IMemberResponseListener);
    }

    /**
     * Builds and returns the JSON body containing the requestModel parameters for the API requestModel
     *
     * @return the Json object for sending params in body for add/update members
     * Will have to create json format like this
     * <p>
     * {
     * "body":{
     * "member"{
     * "firstname":"abc",
     * "lastname":"abc",
     * "email":"abc@abc.com",
     * "mobilephone":"123456789"
     * },
     * "listid":"1234"
     * }
     * }
     */
    private JSONObject getJSONBody(MemberRequestModel requestModel) {
        try {
            JSONObject jsonBodyObject = new JSONObject();
            if (!TextUtils.isEmpty(requestModel.getListId())) {
                jsonBodyObject.put(MPulseAdminConstants.LIST_ID, requestModel.getListId());
            }
            JSONObject jsonMemberObject = new JSONObject();
            if (!TextUtils.isEmpty(requestModel.getFirstName())) {
                jsonMemberObject.put(MPulseAdminConstants.FIRST_NAME, requestModel.getFirstName());
            }
            if (!TextUtils.isEmpty(requestModel.getLastName())) {
                jsonMemberObject.put(MPulseAdminConstants.LAST_NAME, requestModel.getLastName());
            }
            if (!TextUtils.isEmpty(requestModel.getEmail())) {
                jsonMemberObject.put(MPulseAdminConstants.EMAIL, requestModel.getEmail());
            }
            if (!TextUtils.isEmpty(requestModel.getPhoneNumber())) {
                jsonMemberObject.put(MPulseAdminConstants.PHONE_NUMBER, requestModel.getPhoneNumber());
            }
            if (!TextUtils.isEmpty(requestModel.getMemberId())) {
                jsonMemberObject.put(MPulseAdminConstants.MEMBER_ID, requestModel.getMemberId());
            }

            if (requestModel.getOtherFieldsList() != null && requestModel.getOtherFieldsList().size() > 0) {
                for (CustomFieldsModel customFields : requestModel.getOtherFieldsList()) {
                    jsonMemberObject.put(customFields.getKey(), customFields.getValue());
                }
            }
            jsonBodyObject.put(MPulseAdminConstants.MEMBER, jsonMemberObject);

            JSONObject jsonObject = new JSONObject();
            jsonObject.put(MPulseAdminConstants.BODY, jsonBodyObject);

            return jsonObject;
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
            return null;
        }
    }

    /**
     * Builds and returns the map containing the headers for the API mRequestModel
     *
     * @param requestToken is pass in header for authenticity
     * @return the map containing the header parameters for the API mRequestModel
     */
    private Map<String, String> getHeadersMap(String requestToken) {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_USER_AGENT, MPulseConstants.USER_AGENT_MOBILE);
        headerMap.put(MPulseConstants.KEY_HEADER_CONTENT_TYPE, MPulseConstants.KEY_HEADER_CONTENT_TYPE_JSON);
        headerMap.put(MPulseConstants.ACCESS_TOKEN, requestToken);
        return headerMap;
    }

    /**
     * The API listener that receives callback on success or failure of the API request
     */
    private IApiListener<String> IMemberResponseListener = new IApiListener<String>() {

        /**
        *@param response contains data in json format when user has successfully added/updated member
        * */
        @Override
        public void onSuccess(ApiResponse<String> response) {
            //LOGGER.error("onSuccess " + response.getResult().toString());
            if (iMemberListener != null) {
                if (response.isSuccess()) {
                    iMemberListener.onAddUpdateMemberSuccess();
                } else {
                    iMemberListener.onAddUpdateMemberFailure(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        /**
        *@param error contains information why user failed to add/update members
        * */
        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (iMemberListener != null) {
                iMemberListener.onAddUpdateMemberFailure(error);
            }
        }
    };


}
