package com.android.mpulseframework.pushnotifications;

import com.android.mpulseframework.constants.MPulseConstants;

public class TrackPushNotificationConfig  {


    /**
     * Tracking Id for notification
     */
    private String trackingId;

    /**
     * Delivery time stamp of push notification
     */
    private String deliveryTimeStamp;

    /**
     * Time stamp when user clicked on notification
     */
    private String actionTimeStamp;

    /**
     * base url for track push notifiation
     */
    private String url;

    /**
     * action for track push notifiation
     */
    private String action="0";

    /**
     * App id for track push notification
     */

    private String appId;

    /**
     * platForm for push notification and by default is android
     */
    private String platform=MPulseConstants.PLATFORM;

    /**
     * Account id for track push notification
     */
    private String accountId;

    /**
     * Account id for track push notification
     */
    private String messageId;

    /**
     *
     * @return
     */
    public String getMessageId() {
        return messageId;
    }

    /**
     *
     * @param messageId
     */

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    /**
     *
     * @return
     */

    public String getTrackingId() {
        return trackingId;
    }

    /**
     *
     * @param trackingId
     */

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    /**
     *
     * @return
     */
    public String getDeliveryTimeStamp() {
        return deliveryTimeStamp;
    }

    /**
     *
     * @param deliveryTimeStamp
     */
    public void setDeliveryTimeStamp(String deliveryTimeStamp) {
        this.deliveryTimeStamp = deliveryTimeStamp;
    }

    /**
     *
     * @return
     */

    public String getActionTimeStamp() {
        return actionTimeStamp;
    }

    /**
     *
     * @param actionTimeStamp
     */

    public void setActionTimeStamp(String actionTimeStamp) {
        this.actionTimeStamp = actionTimeStamp;
    }

    /**
     *
     * @return
     */

    public String getUrl() {
        return url;
    }

    /**
     *
     * @param url
     */

    public void setUrl(String url) {
        this.url = url;
    }

    /**
     *
     * @return
     */

    public String getAction() {
        return action;
    }

    /**
     *
     * @param action
     */
    public void setAction(String action) {
        this.action = action;
    }

    /**
     *
     * @return
     */

    public String getAppId() {
        return appId;
    }

    /**
     *
     * @param appId
     */
    public void setAppId(String appId) {
        this.appId = appId;
    }

    /**
     *
     * @return
     */

    public String getPlatform() {
        return platform;
    }

    /**
     *
     * @param platform
     */

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    /**
     *
     * @return
     */
    public String getAccountId() {
        return accountId;
    }

    /**
     *
     * @param accountId
     */

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

}
