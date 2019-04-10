package com.android.mpulseframework.admin.members;

import com.android.mpulseframework.admin.CustomFieldsModel;

import java.util.ArrayList;
import java.util.List;

public class MemberRequestModel {

    /**
     * First Name Field for Member
     */
    private String mFirstName;
    /**
     * Last Name Field for Member
     */
    private String mLastName;
    /**
     * Email Field for member
     */
    private String mEmail;

    /**
     * Phone Name Field for Member
     */
    private String mPhoneNumber;

    /**
     * List Id field for Member
     */
    private String mListId;

    /**
     * Member id field for member
     */
    private String mMemberId;

    /**
     * User can enter other fields too
     */
    private List<CustomFieldsModel> mOtherFieldsList = new ArrayList<>();

    /**
     * @return
     */
    public String getFirstName() {
        return mFirstName;
    }

    /**
     * @param firstName
     */
    public void setFirstName(String firstName) {
        this.mFirstName = firstName;
    }

    /**
     * @return
     */
    public String getLastName() {
        return mLastName;
    }

    /**
     * @param lastName
     */
    public void setLastName(String lastName) {
        this.mLastName = lastName;
    }

    /**
     * @return
     */
    public String getEmail() {
        return mEmail;
    }

    /**
     * @param email
     */
    public void setEmail(String email) {
        this.mEmail = email;
    }

    /**
     * @return
     */
    public String getPhoneNumber() {
        return mPhoneNumber;
    }

    /**
     * @param phoneNumber
     */
    public void setPhoneNumber(String phoneNumber) {
        this.mPhoneNumber = phoneNumber;
    }

    /**
     * @return
     */
    public String getListId() {
        return mListId;
    }

    /**
     * @param listId
     */
    public void setListId(String listId) {
        this.mListId = listId;
    }

    /**
     * @return
     */
    public String getMemberId() {
        return mMemberId;
    }

    /**
     * @param memberId
     */
    public void setMemberId(String memberId) {
        this.mMemberId = memberId;
    }

    /**
     * @return
     */
    public List<CustomFieldsModel> getOtherFieldsList() {
        return mOtherFieldsList;
    }

    /**
     * @param otherFieldsList
     */
    public void setOtherFieldsList(List<CustomFieldsModel> otherFieldsList) {
        this.mOtherFieldsList = otherFieldsList;
    }


}
