package com.android.mpulseframework.utils.logs;

/**
 * This class is used to construct and return an instance of the Logger class {@link java.util.logging.Logger}
 */
public class MPulseLoggerFactory {

    /**
     * Returns an instance of the Logger class {@link java.util.logging.Logger}
     *
     * @param clazz the class name for which the Logger is required
     * @return an instance of the Logger class {@link java.util.logging.Logger}
     */
    public static MPulseLogger createLogger(Class<?> clazz) {
        return new MPulseLogger(clazz.getSimpleName());
    }
}
