package com.android.mpulseframework.networking.executor;

import android.os.Handler;
import android.os.Looper;

import java.util.concurrent.Executor;

/**
 * The Executor used to execute tasks on the main thread
 */
public class MainThreadExecutor implements Executor {

    /**
     * The handler object to post the task on the main thread
     */
    private final Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public void execute(Runnable runnable) {
        handler.post(runnable);
    }
}
