package com.android.mpulseframework.admin.login;

import com.android.mpulseframework.admin.MPulseAdminConstants;
import com.android.mpulseframework.admin.MPulseApiConfig;
import com.android.mpulseframework.admin.MPulseApiConstant;
import com.android.mpulseframework.callbacks.ILoginListener;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.networking.ApiManager;
import com.android.mpulseframework.networking.callbacks.IApiListener;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.networking.models.Response;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MPulseLoginUtil {

    private MPulseApiConfig mPulseApiConfig;
    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(MPulseLoginUtil.class);
    private ILoginListener iLoginListener;


    /**
    * Constructor for Login util
     * @param apiConfig contains necessary information like url , client secret , client id ,account id
      */
    public MPulseLoginUtil(MPulseApiConfig apiConfig) {
        mPulseApiConfig = apiConfig;
    }


    /**
    *  doLogin method is used for authenticated user
     * @param  username field contains of username of user
     * @param password password of user
     * @param listener is used for provide callback to user
    * */
    public void doLogin(String username, String password,ILoginListener listener) {
        this.iLoginListener = listener;
        ApiManager.post(mPulseApiConfig.getUrl())
                .addPathParameter(MPulseApiConstant.LOGIN_END_POINT)
                .addUrlEncodedFormBodyParameters(addQueryParameter(username, password))
                .addHeaders(getHeadersMap())
                .build()
                .execute(mLoginResponseApiListener);
    }

    /**
    * addQueryParameter is used for creating required parameters for login api
    * @param userName is username of user
    * @param password is password of user
    * Additional parameters are also passed for authenticate user
    * */
    private Map<String, String> addQueryParameter(String userName, String password) {
        Map<String, String> map = new HashMap<>();
        map.put(MPulseAdminConstants.KEY_GRANT_TYPE, MPulseAdminConstants.KEY_PASSWORD);
        map.put(MPulseAdminConstants.KEY_USERNAME, userName);
        map.put(MPulseAdminConstants.KEY_PASSWORD, password);
        map.put(MPulseAdminConstants.KEY_CLIENTID, mPulseApiConfig.getClientId());
        map.put(MPulseAdminConstants.KEY_CLIENT_SECRET, mPulseApiConfig.getClientSecret());
        return map;
    }

    /**
     * Builds and returns the map containing the headers for the API request
     *
     * @return the map containing the header parameters for the API request
     */
    private Map<String, String> getHeadersMap() {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_CONTENT_TYPE, MPulseConstants.KEY_HEADER_CONTENT_TYPE_fORM_URLENCODED);
        return headerMap;
    }

    /**
     * mLoginResponseApiListener will receive
     * callback When user is successfully logged in or failed
     */
    private IApiListener<String> mLoginResponseApiListener = new IApiListener<String>() {

        /**
        *@param response contains necessary data for another api when user is successfully logged in
        *
        * */
        @Override
        public void onSuccess(ApiResponse<String> response) {
            //LOGGER.error("onSuccess " + response.getResult().toString());
            if (iLoginListener != null) {
                if (response.isSuccess()) {
                    iLoginListener.onLoginSuccess(new Response<>((parseLoginData(response)), response.getResponseCode()));
                } else {
                    iLoginListener.onLoginFailure(new ApiError(response.getResult(), response.getResponseCode()));
                }
            }
        }

        /**
        *@param error contains error information why user failed to logged in
        *
        * */
        @Override
        public void onError(ApiError error) {
            LOGGER.error("onError " + error.getErrorMessage());
            if (iLoginListener != null) {
                iLoginListener.onLoginFailure(error);
            }
        }
    };

    /**
    * parseLoginData method Will parse login response and put data into
     *@link LoginResponseModel
     * @return LoginResponseModel
    **/
    private LoginResponseModel parseLoginData(ApiResponse<String> response)  {
        LoginResponseModel loginResponse = new LoginResponseModel();
        try {
            JSONObject jsonObject = new JSONObject(response.getResult());
            loginResponse.setAccessToken(jsonObject.getString(MPulseAdminConstants.ACCESS_TOKEN));
            loginResponse.setTokenType(jsonObject.getString(MPulseAdminConstants.TOKEN_TYPE));
            loginResponse.setExpiresIn(jsonObject.getString(MPulseAdminConstants.EXPIRES_IN));
            loginResponse.setRefreshToken(jsonObject.getString(MPulseAdminConstants.REFRESH_TOKEN));
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
        }
        return loginResponse;
    }


}
