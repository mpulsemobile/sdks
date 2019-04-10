package com.android.mpulseframework.admin.event;

import com.android.mpulseframework.admin.CustomFieldsModel;

import java.util.ArrayList;
import java.util.List;

public class UploadEventRequestModel {

    /**
     * the name of the Event in the mPulse Platform
     */
    private String eventName;
    /**
     * scheduledOn the date string at which event has to be triggered
     * Accepted formats: YYYY-MM-DD HH:MM | +HH:MM.
     * It Supports scheduling messages at a specified date and time(YYYY-MM-DD HH:MM) or relative to when the request is processed(+HH:MM).
     * -Valid values for HH:Integers in the range from 0 to 24.
     * -Value values for MM: Integers in the range from0 to 59.
     * -If `scheduled_on` = “2018-01-01 09:30”, then the message will be scheduled for January 1, 2018 at 9:30 AM.
     * -If `scheduled_on` = “+02:30”, then the message will be schedule for 2 hours and 30 minutes after the Event Instance is processed.
     * -If `scheduled_on` = “+00:00”, then the message will be sent immediately after the request is processed
     */
    private String scheduledOn;
    /**
     * The scope of the event
     * Accepted values:no_rule | with_rule | all.
     * -no_rule: Only messages with Custom Event triggers thatonly specify an Event Definition Name will be considered for processing.
     * -with_rule: Only messages with Custom Event triggers that specify both an Event Definition Name and a rule based on an Event Attribute will be considered for processing.
     * -all: All messages with Custom Event triggers for the given Event Definition Name will be considered for processing.
     */
    private String evaluationScope;

    /**
     * the timezone of the event
     */
    private String timeZone;

    /**
     * memberID id of the member receiving the event
     */
    private String memberId;
    /**
     * correlationID the tag of the event. The value provided can be used to retrieve information using the Message Delivery Report API about Messages that were scheduled because of an Event
     */
    private String correlationId;


    /**
     * List id for event
     */
    private String listId;

    /**
     * customAttributes attributes of the event that are set as "Required" in event definition on control panel. It is used in the rule for the Custom Event triggered message you want to schedule
     */
    private List<CustomFieldsModel> fieldsModelList = new ArrayList<>();

    /**
     * @return
     */
    public String getEventName() {
        return eventName;
    }

    /**
     * @param eventName
     */
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    /**
     * @return
     */
    public String getScheduledOn() {
        return scheduledOn;
    }

    /**
     * @param scheduledOn
     */
    public void setScheduledOn(String scheduledOn) {
        this.scheduledOn = scheduledOn;
    }

    /**
     * @return
     */
    public String getEvaluationScope() {
        return evaluationScope;
    }

    /**
     * @param evaluationScope
     */
    public void setEvaluationScope(String evaluationScope) {
        this.evaluationScope = evaluationScope;
    }

    /**
     * @return
     */
    public String getTimeZone() {
        return timeZone;
    }

    /**
     * @param timeZone
     */
    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    /**
     * @return
     */
    public String getMemberId() {
        return memberId;
    }

    /**
     * @param memberId
     */
    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    /**
     * @return
     */
    public String getCorrelationId() {
        return correlationId;
    }

    /**
     * @param correlationId
     */
    public void setCorrelationId(String correlationId) {
        this.correlationId = correlationId;
    }

    /**
     * @return
     */
    public String getListId() {
        return listId;
    }

    /**
     * @param listId
     */
    public void setListId(String listId) {
        this.listId = listId;
    }

    /**
     * @return
     */
    public List<CustomFieldsModel> getFieldsModelList() {
        return fieldsModelList;
    }

    /**
     * @param fieldsModelList
     */
    public void setFieldsModelList(List<CustomFieldsModel> fieldsModelList) {
        this.fieldsModelList = fieldsModelList;
    }
}
