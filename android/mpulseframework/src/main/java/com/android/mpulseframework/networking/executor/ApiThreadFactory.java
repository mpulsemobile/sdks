package com.android.mpulseframework.networking.executor;

import android.os.Process;

import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import java.util.concurrent.ThreadFactory;

/**
 * The ThreadFactory used to create new background threads as required
 */
public class ApiThreadFactory implements ThreadFactory {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(ApiThreadFactory.class);

    @Override
    public Thread newThread(final Runnable runnable) {
        Runnable wrapperRunnable = new Runnable() {
            @Override
            public void run() {
                try {
                    Process.setThreadPriority(Process.THREAD_PRIORITY_BACKGROUND);
                } catch (Throwable t) {
                    LOGGER.error(t.getMessage());
                }
                runnable.run();
            }
        };
        return new Thread(wrapperRunnable);
    }
}
