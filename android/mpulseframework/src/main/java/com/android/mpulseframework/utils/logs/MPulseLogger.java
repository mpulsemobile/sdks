package com.android.mpulseframework.utils.logs;


import android.util.Log;


/**
 * Logger class used to create logs for the App
 */
public class MPulseLogger {

    /**
     * The tag for the logs
     */
    private static final String TAG = MPulseLogger.class.getSimpleName();

    /**
     * The class name of the class from which the logs are print
     */
    private final String mClassName;

    /**
     * Determines is logging is enabled
     */
    private final boolean mLoggable;

    /**
     * Determines if the app is running in debug mode
     */
    private static boolean sIsDebug;

    /**
     * Constructor for the MPulseLogger
     *
     * @param mClassName the name of the class from which the logs are to be print
     */
    MPulseLogger(String mClassName) {
        this.mClassName = mClassName;
        boolean androidLog;
        try {
            Class.forName("android.util.Log");
            androidLog = true;
        } catch (ClassNotFoundException e) {
            // android logger not available, probably a test environment.
            androidLog = false;
        }
        this.mLoggable = sIsDebug && androidLog;
    }

    /**
     * To print the formatted debug message on console
     *
     * @param format    String format
     * @param arguments Arguments
     */
    public void debug(String format, Object... arguments) {
        if (mLoggable) {
            try {
                Log.d(mClassName, String.format(format, arguments));
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the formatted error message on console
     *
     * @param format    String format
     * @param arguments Arguments
     */
    public void error(String format, Object... arguments) {
        if (mLoggable) {
            try {
                Log.e(mClassName, String.format(format, arguments));
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the formatted information message on console
     *
     * @param format    String format
     * @param arguments Arguments
     */
    public void info(String format, Object... arguments) {
        if (mLoggable) {
            try {
                Log.i(mClassName, String.format(format, arguments));
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the formatted warning message on console
     *
     * @param format    String format
     * @param arguments Arguments
     */
    public void warn(String format, Object... arguments) {
        if (mLoggable) {
            try {
                Log.w(mClassName, String.format(format, arguments));
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the debug message on console
     *
     * @param message String message
     */
    public void debug(String message) {
        if (mLoggable) {
            try {
                Log.d(mClassName, message);
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the error message on console
     *
     * @param message String message
     */
    public void error(String message) {
        if (mLoggable) {
            try {
                Log.e(mClassName, message);
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the information message on console
     *
     * @param message String message
     */
    public void info(String message) {
        if (mLoggable) {
            try {
                Log.i(mClassName, message);
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * To print the warning message on console
     *
     * @param message String message
     */
    public void warn(String message) {
        if (mLoggable) {
            try {
                Log.w(mClassName, message);
            } catch (Exception e) {
                Log.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * Getter for isDebug
     *
     * @return the value of isDebug
     */
    public static boolean isDebug() {
        return sIsDebug;
    }

    /**
     * Setter for isDebug
     *
     * @param isDebug the isDebug value to set
     */
    public static void setIsDebug(boolean isDebug) {
        sIsDebug = isDebug;
    }
}
