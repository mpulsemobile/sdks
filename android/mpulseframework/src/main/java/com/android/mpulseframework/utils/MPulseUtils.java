package com.android.mpulseframework.utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Base64;

import com.android.mpulseframework.MPulseAppConfig;
import com.android.mpulseframework.admin.MPulseApiConfig;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.constants.MPulseExceptionMessages;
import com.android.mpulseframework.exceptions.MPulseException;
import com.android.mpulseframework.securemessages.SecureMessagesConfig;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.Locale;

/**
 * This class contains the utility functions used in the SDK
 */
public class MPulseUtils {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(MPulseUtils.class);

    /**
     * Used to read and parse the MPulse configuration file and return an AppConfig object {@link MPulseAppConfig}
     *
     * @param context the context required to read the configuration file
     * @return the AppConfig object {@link MPulseAppConfig}
     * @throws MPulseException if there is an error while reading the mpulseServices-Info.json file
     */
    public static MPulseAppConfig getAppConfig(Context context) throws MPulseException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(context.getAssets().open(MPulseConstants.MPULSE_CONFIG_FILE_NAME)))) {
            String mLine;
            StringBuilder builder = new StringBuilder();
            while ((mLine = reader.readLine()) != null) {
                builder.append(mLine);
            }
            return parseAppConfig(builder.toString());
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            if (e instanceof FileNotFoundException){
                throw new MPulseException(MPulseExceptionMessages.MISSING_MPULSE_INFO_JSON_FILE);
            }
        }
        return new MPulseAppConfig();
    }

    /**
     * Used to parse the MPulse configuration file content
     *
     * @param appConfigString the MPulse configuration file content
     * @return the parsed AppConfig object {@link MPulseAppConfig}
     * @throws MPulseException if there is an error while reading the mpulseServices-Info.json file
     */
    private static MPulseAppConfig parseAppConfig(String appConfigString) throws MPulseException {
        MPulseAppConfig appConfig = new MPulseAppConfig();
        try {
            JSONObject json = new JSONObject(appConfigString);
            if (json.isNull(MPulseConstants.KEY_JSON_APP_ID)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_APP_ID);
            }
            if (json.isNull(MPulseConstants.KEY_JSON_ACCOUNT_ID)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_ACCOUNT_ID);
            }
            if (json.isNull(MPulseConstants.KEY_JSON_MPULSE_URL)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_MPULSE_URL);
            }
            if (json.isNull(MPulseConstants.KEY_JSON_ACCESS_KEY)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_ACCESS_KEY);
            }
            if (json.isNull(MPulseConstants.KEY_GATEWAY_URL)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_GATEWAY_URL);
            }
            appConfig.setAppId(json.getString(MPulseConstants.KEY_JSON_APP_ID));
            appConfig.setAccountId(json.getInt(MPulseConstants.KEY_JSON_ACCOUNT_ID));
            appConfig.setMPulseUrl(getFormattedMPulseUrl(json.getString(MPulseConstants.KEY_JSON_MPULSE_URL)));
            appConfig.setAccessKey(json.getString(MPulseConstants.KEY_JSON_ACCESS_KEY));
            appConfig.setGateWayUrl(getFormattedMPulseUrl(json.getString(MPulseConstants.KEY_GATEWAY_URL)));
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
        }
        return appConfig;
    }

    /**
     * Builds the formatted MPulse KEY_MIDDLE_WARE_URL
     *
     * @param url the MPulse KEY_MIDDLE_WARE_URL received from the mpulseServices-Info.json file
     * @return the formatted KEY_MIDDLE_WARE_URL
     */
    private static String getFormattedMPulseUrl(String url) {
        int index = url.indexOf("//");
        if (index > -1) {
            url = url.substring(index + 2);
        }
        return url;
    }

    /**
     * Build and return the token required to unregister from PN
     *
     * @param deviceToken the device token to unregister
     * @param appMemberId the app member id of the member to unregister
     * @return the token required to unregister from PN
     */
    public static String getUnregisterPNToken(String deviceToken, String appMemberId) {
        return String.format(Locale.getDefault(), MPulseConstants.FORMAT_TOKEN_UNREGISTER_PN, deviceToken, appMemberId);
    }

    /**
     * Build and return the base 64 encoded request required to get the secure messages
     *
     * @param config the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @return base 64 encoded request required to get the secure messages
     */
    public static String getBase64Request(SecureMessagesConfig config) {
        String req = String.format(Locale.getDefault(), MPulseConstants.FORMAT_REQ, MPulseConstants.KEY_APP_ID, config.getAppId(), MPulseConstants.KEY_PLATFORM, config.getPlatform(), MPulseConstants.KEY_APP_MEMBER_ID, config.getAppMemberId(), MPulseConstants.KEY_ACCOUNT_ID, config.getAccountId());
        return encodeBase64(req);
    }

    /**
     * Used to return a base 64 encoded string
     *
     * @param text the string to encode
     * @return the base 64 encoded string
     */
    private static String encodeBase64(String text) {
        try {
            byte[] data = text.getBytes("UTF-8");
            return Base64.encodeToString(data, Base64.DEFAULT);
        } catch (UnsupportedEncodingException e) {
            LOGGER.error(e.getMessage());
            return null;
        }
    }

    /**
     * Returns the device type on which the app is running
     * @return the device type on which the app is running
     */
    public static String getDeviceType(){
        return Build.MODEL;
    }

    /**
     * Returns the device OS on which the app is running
     * @return the device OS on which the app is running
     */
    public static String getDeviceOS(){
        return Build.VERSION.RELEASE;
    }

    /**
     * Returns the app version of the app that is running
     * @param context the context in which the app is running
     * @return the app version of the app that is running
     */
    public static String getAppVersion(Context context){
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return info.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            LOGGER.error(e.getMessage());
            return "";
        }
    }



    /**
     * Used to read and parse the MPulse configuration file and return an AppConfig object {@link MPulseApiConfig}
     *
     * @param context the context required to read the configuration file
     * @return the AppConfig object {@link MPulseApiConfig}
     * @throws MPulseException if there is an error while reading the mpulseServices-Info.json file
     */
    public static MPulseApiConfig getApiConfig(Context context) throws MPulseException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(context.getAssets().open(MPulseConstants.MPULSE_CP_API_CONFIG_FILE_NAME)))) {
            String mLine;
            StringBuilder builder = new StringBuilder();
            while ((mLine = reader.readLine()) != null) {
                builder.append(mLine);
            }
            return parseApiConfig(builder.toString());
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            if (e instanceof FileNotFoundException){
                throw new MPulseException(MPulseExceptionMessages.MISSING_MPULSE_INFO_JSON_FCP_FILE);
            }
        }
        return new MPulseApiConfig();
    }

    /**
     * Used to parse the MPulse configuration file content
     *
     * @param appConfigString the MPulse configuration file content
     * @return the parsed AppConfig object {@link MPulseApiConfig}
     * @throws MPulseException if there is an error while reading the mpulseServices-Info.json file
     */
    private static MPulseApiConfig parseApiConfig(String appConfigString) throws MPulseException {
        MPulseApiConfig appConfig = new MPulseApiConfig();
        try {
            JSONObject json = new JSONObject(appConfigString);
            if (json.isNull(MPulseConstants.CLIENT_SECRET)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_CLIENT_SECRET);
            }
            if (json.isNull(MPulseConstants.KEY_MIDDLE_WARE_URL)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_URL);
            }
            if (json.isNull(MPulseConstants.ACCOUNT_ID)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_ACCOUNTID);
            }
            if (json.isNull(MPulseConstants.CLIENT_ID)) {
                throw new MPulseException(MPulseExceptionMessages.MISSING_CLIENT_ID);
            }
            appConfig.setClientSecret(json.getString(MPulseConstants.CLIENT_SECRET));
            appConfig.setUrl(getFormattedMPulseUrl(json.getString(MPulseConstants.KEY_MIDDLE_WARE_URL)));
            appConfig.setAccountId((json.getString(MPulseConstants.ACCOUNT_ID)));
            appConfig.setClientId(json.getString(MPulseConstants.CLIENT_ID));
        } catch (JSONException e) {
            LOGGER.error(e.getMessage());
        }
        return appConfig;
    }
}
