package com.android.mpulseframework.callbacks;

import android.webkit.WebView;

/**
 * Used to handle callback from MPulseInboxView
 */
public interface MPulseInboxViewListener {

    /**
     * Called when the url has started loading
     */
    void onPageLoadStarted();

    /**
     * Called when progress in updated in web view
     *
     * @param view     the web view in which the progress is updated
     * @param progress the progress value
     */
    void onProgressChanged(WebView view, int progress);

    /**
     * Called when the url has completed loading
     */
    void onPageLoadFinished();
}
