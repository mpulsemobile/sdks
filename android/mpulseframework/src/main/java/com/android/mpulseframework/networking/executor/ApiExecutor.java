package com.android.mpulseframework.networking.executor;

import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * The API Executor that extends the ThreadPoolExecutor.
 * It is used to run a background task
 */
public class ApiExecutor extends ThreadPoolExecutor {

    /**
     * Constructor of the ApiExecutor class
     *
     * @param maxNumThreads the maximum number of threads that can run
     * @param threadFactory the ThreadFactory to use
     */
    ApiExecutor(int maxNumThreads, ThreadFactory threadFactory) {
        super(maxNumThreads, maxNumThreads, 0, TimeUnit.MILLISECONDS,
                new PriorityBlockingQueue<Runnable>(), threadFactory);
    }

    @Override
    public Future<?> submit(Runnable task) {
        FutureTask<ApiRunnable> futureTask = new FutureTask<ApiRunnable>(task, null);
        execute(futureTask);
        return futureTask;
    }
}
