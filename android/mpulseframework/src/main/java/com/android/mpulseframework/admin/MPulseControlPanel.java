package com.android.mpulseframework.admin;

import android.content.Context;

import com.android.mpulseframework.admin.event.MPulseEventUtil;
import com.android.mpulseframework.admin.event.UploadEventRequestModel;
import com.android.mpulseframework.admin.login.LoginResponseModel;
import com.android.mpulseframework.admin.login.MPulseLoginUtil;
import com.android.mpulseframework.admin.members.MPulseMembersUtil;
import com.android.mpulseframework.admin.members.MemberRequestModel;
import com.android.mpulseframework.callbacks.ILoginListener;
import com.android.mpulseframework.callbacks.MPulseAddOrUpdateMembersListener;
import com.android.mpulseframework.callbacks.MPulseLoginListener;
import com.android.mpulseframework.callbacks.MPulseUploadEventListener;
import com.android.mpulseframework.constants.MPulseExceptionMessages;
import com.android.mpulseframework.exceptions.MPulseException;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.Response;
import com.android.mpulseframework.utils.MPulseUtils;

public class MPulseControlPanel {

    /**
     * The singleton instance of MPulse
     */
    private static MPulseControlPanel sInstance;

    /**
     * The MPulseApiConfig object that stores the application configuration for MPulse {@link MPulseApiConfig}
     */
    private MPulseApiConfig mApiConfig;

    /**
     * When login is success, Login Data will be stored here
     */
    private LoginResponseModel mLoginResponse;

    /**
     * When login is success, Login Data will be stored here
     */
    private MPulseAddOrUpdateMembersListener iAddUpdateMemberListener;

    /**
     * This listener is used for give call back to user
     * whether user has successfully login or not
     */
    private MPulseLoginListener iLoginListener;

    /**
     * This listener is used for give call back to user
     * whether user has successfully uploaded event or not
     */
    private MPulseUploadEventListener iUploadEventListener;


    /**
     * private constructor will be called only from this class
     */
    private MPulseControlPanel(Context context) throws MPulseException {
        mApiConfig = MPulseUtils.getApiConfig(context);
    }

    /**
     * Singleton instance is created for {{@link MPulseControlPanel}}
     */
    public static MPulseControlPanel getInstance(Context context) throws MPulseException {
        if (sInstance == null) {
            synchronized (MPulseControlPanel.class) {
                sInstance = new MPulseControlPanel(context);
            }
        }
        return sInstance;
    }

    /**
     * User can logged in from here
     *
     * @param username
     * @param password
     * @param loginListener
     */
    public void login(String username, String password, MPulseLoginListener loginListener) {
        this.iLoginListener = loginListener;
        new MPulseLoginUtil(mApiConfig).doLogin(username, password, mLoginResponseApiListener);
    }

    /**
     * The Login API listener that receives callback on success or failure of Login API request
     */
    private ILoginListener mLoginResponseApiListener = new ILoginListener() {

        public void onLoginSuccess(Response<LoginResponseModel> response) {
            mLoginResponse = response.getResponse();
            if (iLoginListener != null) {
                iLoginListener.onLoginSuccess();
            }
        }

        @Override
        public void onLoginFailure(ApiError error) {
            if (iLoginListener != null) {
                iLoginListener.onError(error);
            }
        }
    };

    /**
     * This method is used to add members
     *
     * @param requestModel  contains data for add members , User will have to pass information in {@link MemberRequestModel} and call this method
     * @param iAddUpdateMemberListener is used for callback to user whether
     *member is added/updated successfully or failed to add/update
     */
    public void addMembers(MemberRequestModel requestModel, MPulseAddOrUpdateMembersListener iAddUpdateMemberListener) throws MPulseException {
        if (mLoginResponse == null) {
            throw new MPulseException(MPulseExceptionMessages.USER_SHOULD_LOG_IN);
        }
        this.iAddUpdateMemberListener = iAddUpdateMemberListener;
        new MPulseMembersUtil().addMembers(requestModel,mLoginResponse.getAccessToken(), mApiConfig, mMemberAddUpdateApiListener);
    }

     /**
     * This method is used to update members's info
     *
     * @param requestModel contains data for update members
     * @param iAddUpdateMemberListener is used for provide callback to user, User should implement this listener for callback
     */
    public void updateMembers(MemberRequestModel requestModel, MPulseAddOrUpdateMembersListener iAddUpdateMemberListener) throws MPulseException {
        if (mLoginResponse == null) {
            throw new MPulseException(MPulseExceptionMessages.USER_SHOULD_LOG_IN);
        }
        this.iAddUpdateMemberListener = iAddUpdateMemberListener;
        new MPulseMembersUtil().addMembers(requestModel,mLoginResponse.getAccessToken(), mApiConfig, mMemberAddUpdateApiListener);
    }

    /**
     * The mMemberAddUpdateApiListener that receives callback on success or failure of Add/Update Member API
     */
    private MPulseAddOrUpdateMembersListener mMemberAddUpdateApiListener = new MPulseAddOrUpdateMembersListener() {

        /**
        *onAddUpdateMemberSuccess will get call back if member add/update success
*/
        public void onAddUpdateMemberSuccess() {
            if (iAddUpdateMemberListener != null) {
                iAddUpdateMemberListener.onAddUpdateMemberSuccess();
            }
        }

        /**
        * onAddUpdateMemberFailure will get call back when
        *add/update member failed
        *@param error will contain data for cause of add/update member failed
        *
*/
        @Override
        public void onAddUpdateMemberFailure(ApiError error) {
            if (iAddUpdateMemberListener != null) {
                iAddUpdateMemberListener.onAddUpdateMemberFailure(error);
            }
        }
    };


    /**
    *Trigger Event method is used for triggering the event
    * @param request model contains data for triggering events
    * @param listener is used for callbacks , Whether events has been triggered successfully or failed
    */
    public void triggerEvent(UploadEventRequestModel request, MPulseUploadEventListener listener) throws MPulseException {
        if (mLoginResponse == null) {
            throw new MPulseException(MPulseExceptionMessages.USER_SHOULD_LOG_IN);
        }
        this.iUploadEventListener = listener;
        new MPulseEventUtil().addEvent(request,mLoginResponse.getAccessToken(), mApiConfig, mUploadEventApiListener);
    }


    /**
     * The mUploadEventApiListener that receives callback on success or failure of Upload Event API
     */
    private MPulseUploadEventListener mUploadEventApiListener = new MPulseUploadEventListener() {

        /**
        * onUploadEventSuccess will get callback When event triggered successfully
        * */
        public void onUploadEventSuccess() {
            if (iUploadEventListener != null) {
                iUploadEventListener.onUploadEventSuccess();
            }
        }

        /**
        * onUploadEventFailure will have callback when Event triggered failed
        * @param error  contains data, cause of event triggered failure
*/
        @Override
        public void onUploadEventFailure(ApiError error) {
            if (iUploadEventListener != null) {
                iUploadEventListener.onUploadEventFailure(error);
            }
        }
    };

}
