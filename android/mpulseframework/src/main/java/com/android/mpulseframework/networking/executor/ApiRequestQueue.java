package com.android.mpulseframework.networking.executor;

import com.android.mpulseframework.networking.ApiRequest;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * This class manages all the API requests that are currently running
 */
public class ApiRequestQueue {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(ApiRequestQueue.class);

    /**
     * Set to store all the current running API requests
     */
    private final Set<ApiRequest> mCurrentRequests =
            Collections.newSetFromMap(new ConcurrentHashMap<ApiRequest, Boolean>());

    /**
     * The singleton instance of the ApiRequestQueue class
     */
    private static ApiRequestQueue sInstance = null;

    /**
     * Returns the singleton instance of the ApiRequestQueue
     *
     * @return the singleton instance of the ApiRequestQueue
     */
    public static ApiRequestQueue getInstance() {
        if (sInstance == null) {
            synchronized (ApiRequestQueue.class) {
                if (sInstance == null) {
                    sInstance = new ApiRequestQueue();
                }
            }
        }
        return sInstance;
    }

    /**
     * Request filter interface used to filter requests based on the request tag
     */
    public interface RequestFilter {

        /**
         * Applies the request filter on the basis of the request tag
         *
         * @param request the ApiRequest object to filter
         * @return true if the tag matches, else false
         */
        boolean apply(ApiRequest request);
    }

    /**
     * Cancels and API request based on the request filter
     *
     * @param filter the request filter on the basis of which to cancel the request
     */
    private void cancel(RequestFilter filter) {
        try {
            for (Iterator<ApiRequest> iterator = mCurrentRequests.iterator(); iterator.hasNext(); ) {
                ApiRequest request = iterator.next();
                if (filter.apply(request)) {
                    request.cancel();
                    if (request.isCanceled()) {
                        request.destroy();
                        iterator.remove();
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Cancel all API requests currently running
     */
    public void cancelAll() {
        try {
            for (Iterator<ApiRequest> iterator = mCurrentRequests.iterator(); iterator.hasNext(); ) {
                ApiRequest request = iterator.next();
                request.cancel();
                if (request.isCanceled()) {
                    request.destroy();
                    iterator.remove();
                }
            }
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Cancel an API request on the basis of the given tag
     *
     * @param tag the tag on the basis of which to cancel the API request
     */
    public void cancelRequestWithGivenTag(final String tag) {
        try {
            if (tag == null) {
                return;
            }
            cancel(new RequestFilter() {
                @Override
                public boolean apply(ApiRequest request) {
                    return isRequestWithTheGivenTag(request, tag);
                }
            });
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Adds an API request to the set of running requests
     *
     * @param request the ApiRequest object to add
     */
    public void addRequest(ApiRequest request) {
        try {
            mCurrentRequests.add(request);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
        try {
            request.setFuture(ApiExecutorSupplier.getInstance()
                    .forNetworkTasks()
                    .submit(new ApiRunnable(request)));
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Used to remove a given request from the set of running requests
     *
     * @param request the ApiRequest object to remove
     */
    public void finish(ApiRequest request) {
        try {
            mCurrentRequests.remove(request);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }


    /**
     * Checks if the request matches a given tag
     *
     * @param request the ApiRequest whose tag is to be compared
     * @param tag     the tag against which to compare
     * @return true if the given tag matches the tag of the ApiRequest, else returns false
     */
    private boolean isRequestWithTheGivenTag(ApiRequest request, String tag) {
        return request.getTag() != null && request.getTag().equals(tag);
    }
}
