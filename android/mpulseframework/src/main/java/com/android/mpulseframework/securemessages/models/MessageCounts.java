package com.android.mpulseframework.securemessages.models;

/**
 * Model to store the secure messages inbox counters
 */
public class MessageCounts {

    /**
     * Stores the total read messages
     */
    private int mTotalRead;

    /**
     * Stores the total unread messages
     */
    private int mTotalUnread;

    /**
     * Stores the total deleted messages
     */
    private int mTotalDeleted;

    /**
     * Stores the total undeleted messages
     */
    private int mTotalUnDeleted;

    /**
     * Getter for the total read messages
     * @return the total read messages
     */
    public int getTotalRead() {
        return mTotalRead;
    }

    /**
     * Setter for the total read messages
     * @param totalRead the total read messages to set
     */
    public void setTotalRead(int totalRead) {
        this.mTotalRead = totalRead;
    }

    /**
     * Getter for the total unread messages
     * @return the total unread messages
     */
    public int getTotalUnread() {
        return mTotalUnread;
    }

    /**
     * Setter for the total unread messages
     * @param totalUnread the total unread messages to set
     */
    public void setTotalUnread(int totalUnread) {
        this.mTotalUnread = totalUnread;
    }

    /**
     * Getter for the total deleted messages
     * @return the total deleted messages
     */
    public int getTotalDeleted() {
        return mTotalDeleted;
    }

    /**
     * Setter for the total deleted messages
     * @param totalDeleted the total deleted messages to set
     */
    public void setTotalDeleted(int totalDeleted) {
        this.mTotalDeleted = totalDeleted;
    }

    /**
     * Getter for the total un-deleted messages
     * @return the total un-deleted messages
     */
    public int getTotalUnDeleted() {
        return mTotalUnDeleted;
    }

    /**
     * Setter for the total un-deleted messages
     * @param totalUnDeleted the total un-deleted messages to set
     */
    public void setTotalUnDeleted(int totalUnDeleted) {
        this.mTotalUnDeleted = totalUnDeleted;
    }
}
