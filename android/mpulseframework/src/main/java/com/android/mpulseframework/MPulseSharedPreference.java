package com.android.mpulseframework;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * The Shared Preference class of the application
 */
public class MPulseSharedPreference {

    /**
     * The interface storing the preference keys
     */
    public interface PreferenceKeys {
        String KEY_IS_FIRST_TIME = "com.android.mpulseframework.key.is.first.time";
    }

    /**
     * The preference name
     */
    private static final String PREF_NAME = "com.android.mpulseframework.pref";

    /**
     * The singleton instance of the MPulseSharedPrefernce class {@link MPulseSharedPreference}
     */
    private static MPulseSharedPreference sInstance;

    /**
     * The SharedPreference class instance
     */
    private SharedPreferences mPreferences;

    /**
     * Protected constructor. use {@link #getInstance()} instead.
     * @param context context.
     */
    private MPulseSharedPreference(Context context) {
        mPreferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
    }

    /**
     * Get singleton instance of MPulseSharedPreference store create new if needed
     * @param context Context
     * @return singleton instance
     */
    static MPulseSharedPreference initialize(Context context) {
        if (sInstance == null) {
            synchronized (MPulseSharedPreference.class) {
                sInstance = new MPulseSharedPreference(context);
            }
        }
        return sInstance;
    }

    /**
     * Get singleton instance of MPulseSharedPreference store create new if needed
     * @return singleton instance
     */
    public static MPulseSharedPreference getInstance() {
        if (sInstance == null) {
            throw new IllegalStateException("To get instance first you need to initialize the app preferences");
        }
        return sInstance;
    }

    /**
     * Returns the preference object
     * @return the preference object
     */
    public SharedPreferences getPreferences() {
        return mPreferences;
    }

    /**
     * Clears the shared preference editor
     */
    public void clearEditor() {
        mPreferences.edit().clear().apply();
    }

    /**
     * Returns an integer value from the preference
     * @param key the key against which the value is to be fetched
     * @param defaultValue the default value in case the key does not exist
     * @return an integer value from the preference
     */
    public int getInt(String key, int defaultValue) {
        return mPreferences.getInt(key, defaultValue);
    }

    /**
     * Sets an integer value in the preference
     * @param key the key against which the value is to be stored
     * @param value the value to be stored
     */
    public void setInt(String key, int value) {
        mPreferences.edit().putInt(key, value).apply();
    }

    /**
     * Returns a long value from the preference
     * @param key the key against which the value is to be fetched
     * @param defaultValue the default value in case the key does not exist
     * @return a long value from the preference
     */
    public long getLong(String key, long defaultValue) {
        return mPreferences.getLong(key, defaultValue);
    }

    /**
     * Sets a long value in the preference
     * @param key the key against which the value is to be stored
     * @param value the value to be stored
     */
    public void setLong(String key, long value) {
        mPreferences.edit().putLong(key, value).apply();
    }

    /**
     * Returns a boolean value from the preference
     * @param key the key against which the value is to be fetched
     * @param defaultValue the default value in case the key does not exist
     * @return a boolean value from the preference
     */
    public boolean getBoolean(String key, boolean defaultValue) {
        return mPreferences.getBoolean(key, defaultValue);
    }

    /**
     * Sets a boolean value in the preference
     * @param key the key against which the value is to be stored
     * @param value the value to be stored
     */
    public void setBoolean(String key, boolean value) {
        mPreferences.edit().putBoolean(key, value).apply();
    }

    /**
     * Returns a string value from the preference
     * @param key the key against which the value is to be fetched
     * @param defaultValue the default value in case the key does not exist
     * @return a string value from the preference
     */
    public String getString(String key, String defaultValue) {
        return mPreferences.getString(key, defaultValue);
    }

    /**
     * Sets a string value in the preference
     * @param key the key against which the value is to be stored
     * @param value the value to be stored
     */
    public void setString(String key, String value) {
        mPreferences.edit().putString(key, value).apply();
    }
}