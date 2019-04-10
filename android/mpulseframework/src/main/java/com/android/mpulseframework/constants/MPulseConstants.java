package com.android.mpulseframework.constants;

/**
 * Interface storing the constants used in the MPulse SDK
 */
public interface MPulseConstants {

    /**
     * The constant for the platform value
     */
    String PLATFORM = "android";

    /**
     * The constant for the key for app id
     */
    String KEY_APP_ID = "appId";


    /**
     * The constant for the key for platform
     */
    String KEY_PLATFORM = "platform";

    /**
     * The constant for the key for device token
     */
    String KEY_DEVICE_TOKEN = "deviceToken";

    /**
     * The constant for the key for app member id
     */
    String KEY_APP_MEMBER_ID = "appmemberid";

    /**
     * The constant for the key for account id
     */
    String KEY_ACCOUNT_ID = "accountId";

    /**
     * The constant for the key for req
     */
    String KEY_REQ = "req";

    /**
     * The constant for the key for app id for the counter API
     */
    String KEY_APP_ID_COUNTER = "appid";

    /**
     * The constant for the key for version
     */
    String KEY_VERSION = "version";

    /**
     * The constant for the key for app id for the tracking API
     */
    String KEY_APP_ID_TRACK = "APP_ID";

    /**
     * The constant for the key for device id for the tracking API
     */
    String KEY_DEVICE_TYPE_TRACK = "DEVICE_TYPE";

    /**
     * The constant for the key for app version for the tracking API
     */
    String KEY_APP_VERSION_TRACK = "APP_VERSION";

    /**
     * The constant for the key for app member id for the tracking API
     */
    String KEY_APP_MEMBER_ID_TRACK = "APP_MEMBER_ID";

    /**
     * The constant for the key for account id for the tracking API
     */
    String KEY_ACCOUNT_ID_TRACK = "ACCOUNT_ID";

    /**
     * The constant for the key for OS for the tracking API
     */
    String KEY_OS_TRACK = "OS";

    /**
     * The constant for the value of key version
     */
    String VERSION = "1.0";

    /**
     * The constant for the path of KEY_MIDDLE_WARE_URL for registering for push notifications
     */
    String URL_PUSH_NOTIFICATION = "pnregister";

    /**
     * The constant for the path for tracking for push notifications
     */
    String TRACK_PUSH_NOTIFICATION = "pn_clicked";

    /**
     * The constant for the path for tracking for push notifications
     */
    String DEVICE_REQUEST = "device_requests";

    /**
     * The constant for the path of api
     */
    String URL_API = "api";

    /**
     * The constant for the path of KEY_MIDDLE_WARE_URL for getting secure messages
     */
    String URL_SECURE_MESSAGES = "webview";

    /**
     * The constant for the path of KEY_MIDDLE_WARE_URL for getting inbox counter
     */
    String URL_COUNTER = "counter";

    /**
     * The constant for the path of KEY_MIDDLE_WARE_URL for tracking SDK installations
     */
    String URL_TRACK = "track";

    /**
     * The constant for the path of KEY_MIDDLE_WARE_URL for tracking SDK installations
     */
    String URL_INSTALLATION = "installation";

    /**
     * The constant for the JSON key for app id
     */
    String KEY_JSON_APP_ID = "APP_ID";

    /**
     * The constant for the JSON key for account id
     */
    String KEY_JSON_ACCOUNT_ID = "ACCOUNT_ID";

    /**
     * The constant for the JSON key for MPulse KEY_MIDDLE_WARE_URL
     */
    String KEY_JSON_MPULSE_URL = "MPULSE_URL";

    /**
     * The constant for the JSON key for MPulse access key
     */
    String KEY_JSON_ACCESS_KEY = "ACCESS_KEY";

    /**
     * The constant for the JSON key for MPulse gateway url
     */
    String KEY_GATEWAY_URL = "GATEWAY_URL";

    /**
     * The constant for the MPulse configuration file name
     */
    String MPULSE_CONFIG_FILE_NAME = "mpulseServices-Info.json";

    /**
     * The constant for the MPulse Control panel configuration file name
     */
    String MPULSE_CP_API_CONFIG_FILE_NAME = "mpulseServices-Info-cp.json";


    /**
     * The constant for the format for token for un-registering push notifications
     */
    String FORMAT_TOKEN_UNREGISTER_PN = "%s_%s";

    /**
     * The constant for the format for req for secure messages API
     */
    String FORMAT_REQ = "%s=%s&%s=%s&%s=%s&%s=%d";

    /**
     * The constant for the header key for user agent from
     */
    String KEY_HEADER_USER_AGENT_FROM = "User-Agent-From";

    /**
     * The constant for the header key for user agent from
     */
    String KEY_HEADER_USER_AGENT = "User-Agent";

    /**
     * The constant for the header key for access key
     */
    String KEY_HEADER_ACCESS_KEY = "Access-Key";

    /**
     * The constant for the header key for action
     */
    String KEY_HEADER_ACTION = "action";

    /**
     * The constant for the header key for content type
     */
    String KEY_HEADER_CONTENT_TYPE = "content-type";

    /**
     * The constant for the header key for value of content type
     */
    String KEY_HEADER_CONTENT_TYPE_JSON = "application/json";

    String KEY_HEADER_CONTENT_TYPE_fORM_URLENCODED="application/x-www-form-urlencoded";

    /**
     * The constant for the header key value user agent from
     */
    String USER_AGENT_SDK = "sdk";

    /**
     * The constant for the header key value user agent from
     */
    String USER_AGENT_MOBILE = "mobile";

    /**
     * The constant for the header key value register for action
     */
    String ACTION_REGISTER = "register";

    /**
     * The constant for the header key value unregister for action
     */
    String ACTION_UNREGISTER = "unregister";

    /**
     * The constant for the JSON key for total read messages
     */
    String KEY_JSON_TOTAL_READ = "read";

    /**
     * The constant for the JSON key for total unread messages
     */
    String KEY_JSON_TOTAL_UNREAD = "unread";

    /**
     * The constant for the JSON key for total deleted messages
     */
    String KEY_JSON_TOTAL_DELETED = "deleted";

    /**
     * The constant for the JSON key for total un-deleted messages
     */
    String KEY_JSON_TOTAL_UN_DELETED = "undeleted";

    /**
     * The constant for the key for client secret
     */

    String CLIENT_SECRET = "CLIENT_SECRET";
    /**
     * The constant for the key for Url
     */

    String KEY_MIDDLE_WARE_URL = "MIDDLEWARE_URL";
    /**
     * The constant for the key for Account Id
     */

    String ACCOUNT_ID = "ACCOUNT_ID";

    /**
     * The constant for the key for Client Id
     */
    String CLIENT_ID = "CLIENT_ID";

    /**
     * The constant for the key for ACCESS TOKEN
     */
    String ACCESS_TOKEN = "Access-Token";

    /**
     * The constant for the key for tracking id
     */
    String KEY_TRACKING_ID = "trackingId";

    /**
     * The constant for the key for message id
     */
    String KEY_MESSAGE_ID = "message_id";

    /**
     * The constant for the key for delivery time stamp id
     */
    String KEY_DELIVERY_TIME_STAMP = "deliveryTimeStamp";

    /**
     * The constant for the key for delivery time stamp id
     */
    String KEY_ACTION_TIME_STAMP = "actionTimeStamp";





}
