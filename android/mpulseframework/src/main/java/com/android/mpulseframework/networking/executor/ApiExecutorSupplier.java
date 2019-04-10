package com.android.mpulseframework.networking.executor;

import java.util.concurrent.Executor;

/**
 * This class supplies the Executor to the SDK
 */
public class ApiExecutorSupplier {

    /**
     * Constant to hold the default maximum number of threads that can run
     */
    private static final int DEFAULT_MAX_NUM_THREADS = 2 * Runtime.getRuntime().availableProcessors() + 1;

    /**
     * The ApiExecutor instance to run tasks on the background thread
     */
    private final ApiExecutor mNetworkExecutor;

    /**
     * The Executor instance to run tasks on the main thread
     */
    private final Executor mMainThreadExecutor;

    /**
     * The ApiExecutorSupplier instance
     */
    private static ApiExecutorSupplier sInstance = null;

    /**
     * Returns the singleton instance of the ApiExecutorSupplier
     *
     * @return the singleton instance of the ApiExecutorSupplier
     */
    public static ApiExecutorSupplier getInstance() {
        if (sInstance == null) {
            synchronized (ApiExecutorSupplier.class) {
                if (sInstance == null) {
                    sInstance = new ApiExecutorSupplier();
                }
            }
        }
        return sInstance;
    }

    /**
     * Constructor of the ApiExecutorSupplier
     */
    private ApiExecutorSupplier() {
        mNetworkExecutor = new ApiExecutor(DEFAULT_MAX_NUM_THREADS, new ApiThreadFactory());
        mMainThreadExecutor = new MainThreadExecutor();
    }

    /**
     * Returns the ApiExecutor instance to run tasks on the background thread
     *
     * @return the ApiExecutor instance to run tasks on the background thread
     */
    ApiExecutor forNetworkTasks() {
        return mNetworkExecutor;
    }

    /**
     * Returns the Executor instance to run tasks on the main thread
     *
     * @return the Executor instance to run tasks on the main thread
     */
    public Executor forMainThreadTasks() {
        return mMainThreadExecutor;
    }

    /**
     * Destroys the singleton instance of the ApiExecutorSupplier class
     */
    public static void destroy() {
        if (sInstance != null) {
            sInstance = null;
        }
    }
}
