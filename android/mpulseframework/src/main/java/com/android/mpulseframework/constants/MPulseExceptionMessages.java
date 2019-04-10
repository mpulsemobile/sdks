package com.android.mpulseframework.constants;

/**
 * Interface storing the MPulse exception messages used in the MPulse SDK
 */
public interface MPulseExceptionMessages {

    /**
     * The constant for description of exception if the context is null
     */
    String NULL_CONTEXT = "You cannot pass a null context";

    /**
     * The constant for description of exception if the app member id is either null or empty
     */
    String EMPTY_APP_MEMBER_ID = "You cannot pass a null or empty app member id";

    /**
     * The constant for description of exception if the device token is either null or empty
     */
    String EMPTY_DEVICE_TOKEN = "You cannot pass a null or empty device token";

    /**
     * The constant for description of exception if the mpulseServices-Info.json file is missing from the assets folder
     */
    String MISSING_MPULSE_INFO_JSON_FILE = "mpulseServices-Info.json file not found. Add file to your app module's assets folder";


    /**
     * The constant for description of exception if the mpulseServices-Info.json file is missing from the assets folder
     */
    String MISSING_MPULSE_INFO_JSON_FCP_FILE = "mpulseServices-Info-cp.json file not found. Add file to your app module's assets folder";



    /**
     * The constant for description of exception if the APP_ID is missing from the mpulseServices-Info.json file
     */
    String MISSING_APP_ID = "APP_ID is missing from your mpulseServices-Info.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCOUNT_ID is missing from the mpulseServices-Info.json file
     */
    String MISSING_ACCOUNT_ID = "ACCOUNT_ID is missing from your mpulseServices-Info.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the MPULSE_URL is missing from the mpulseServices-Info.json file
     */
    String MISSING_MPULSE_URL = "MPULSE_URL is missing from your mpulseServices-Info.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCESS_KEY is missing from the mpulseServices-Info.json file
     */
    String MISSING_ACCESS_KEY = "ACCESS_KEY is missing from your mpulseServices-Info.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCESS_KEY is missing from the mpulseServices-Info.json file
     */
    String MISSING_GATEWAY_URL = "GATEWAY URL is missing from your mpulseServices-Info.json file. Please contact mPulse";


    /**
     * The constant for description of exception if the APP_ID is missing from the mpulseServices-Info.json file
     */
    String MISSING_CLIENT_SECRET = "CLIENT_SECRET is missing from your mpulseServices-Info-cp.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCOUNT_ID is missing from the mpulseServices-Info.json file
     */
    String MISSING_URL = "MIDDLEWARE_URL is missing from your mpulseServices-Info-cp.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the MPULSE_URL is missing from the mpulseServices-Info.json file
     */
    String MISSING_ACCOUNTID = "ACCOUNT_ID is missing from your mpulseServices-Info-cp.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCESS_KEY is missing from the mpulseServices-Info.json file
     */
    String MISSING_CLIENT_ID = "CLIENT_ID is missing from your mpulseServices-Info-cp.json file. Please contact mPulse";

    /**
     * The constant for description of exception if the ACCESS_TOKEN is missing from the LOGIN RESPONSE MODEL
     */
    String USER_SHOULD_LOG_IN = "User should be logged-in";


}
