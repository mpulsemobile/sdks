package com.android.mpulseframework.securemessages.inbox;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.android.mpulseframework.callbacks.MPulseInboxViewListener;
import com.android.mpulseframework.constants.MPulseConstants;
import com.android.mpulseframework.securemessages.SecureMessagesConfig;
import com.android.mpulseframework.utils.MPulseUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * Custom Browser View class used to browse app and handle callbacks
 */
public class MPulseInboxView extends WebView {

    /**
     * Listener object to get callback for events when inbox is loading {@link MPulseInboxViewListener}
     */
    private MPulseInboxViewListener mInboxViewListener;

    /**
     * The secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     */
    private SecureMessagesConfig mConfig;

    /**
     * Constructor of MPulseInboxView
     *
     * @param context the Context the view is running in, through which it can access the current theme, resources, etc.
     */
    public MPulseInboxView(Context context) {
        super(context);
        setUpWebView();
    }

    /**
     * Constructor of MPulseInboxView
     *
     * @param context the Context the view is running in, through which it can access the current theme, resources, etc.
     * @param attrs   the attributes of the XML tag that is inflating the view.    This value may be null.
     */
    public MPulseInboxView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setUpWebView();
    }

    /**
     * Constructor of MPulseInboxView
     *
     * @param context      the Context the view is running in, through which it can access the current theme, resources, etc.
     * @param attrs        the attributes of the XML tag that is inflating the view.    This value may be null.
     * @param defStyleAttr an attribute in the current theme that contains a reference to a style resource that supplies default values for the view. Can be 0 to not look for defaults.
     */
    public MPulseInboxView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setUpWebView();
    }

    /**
     * Used to set the properties and values of the web view
     */
    private void setUpWebView() {
        setWebViewClient(new MPulseInboxWebViewClient());
        setWebChromeClient(new MPulseInboxWebChromeClient());
        configureWebViewSettings();
    }

    /**
     * Used to configure the web settings
     */
    @SuppressLint("SetJavaScriptEnabled")
    private void configureWebViewSettings() {
        WebSettings settings = getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setAppCacheEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setBuiltInZoomControls(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setSupportMultipleWindows(false); // to enable opening links which require opening a new tab
        settings.setLoadsImagesAutomatically(true);
        settings.setBuiltInZoomControls(true);
    }

    /**
     * Setter for the SecureMessageConfig object {@link SecureMessagesConfig}
     * @param config the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     */
    public void setSecureMessageConfig(SecureMessagesConfig config) {
        mConfig = config;
    }

    /**
     * Sets the MPulseInboxViewListener object {@link MPulseInboxViewListener}
     *
     * @param inboxViewListener the listener object to get callback for events when inbox is loading {@link MPulseInboxViewListener}
     */
    public void setInboxViewListener(MPulseInboxViewListener inboxViewListener) {
        this.mInboxViewListener = inboxViewListener;
    }

    /**
     * Used to load the KEY_MIDDLE_WARE_URL to get the inbox for the user
     */
    public void loadInbox() {
        MPulseInboxUrl inboxUrl = new MPulseInboxUrl.InboxUrlBuilder(mConfig.getMPulseUrl())
                .addPathParameter(MPulseConstants.URL_API)
                .addPathParameter(String.valueOf(mConfig.getAccountId()))
                .addPathParameter(MPulseConstants.URL_SECURE_MESSAGES)
                .addQueryParameters(getQueryMap(mConfig))
                .build();
        loadUrl(inboxUrl.getUrl(), getHeadersMap(mConfig));
        if (mInboxViewListener != null) {
            mInboxViewListener.onPageLoadStarted();
        }
    }

    /**
     * Builds and returns the map containing the query parameters for the API request
     *
     * @param config the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @return the map containing the query parameters for the API request
     */
    private Map<String, String> getQueryMap(SecureMessagesConfig config) {
        Map<String, String> queryMap = new HashMap<>();
        queryMap.put(MPulseConstants.KEY_REQ, MPulseUtils.getBase64Request(config));
        return queryMap;
    }

    /**
     * Builds and returns the map containing the headers for the API request
     *
     * @param config the secure messages configuration object that stores the configuration related to getting secure messages {@link SecureMessagesConfig}
     * @return the map containing the header parameters for the API request
     */
    private Map<String, String> getHeadersMap(SecureMessagesConfig config) {
        Map<String, String> headerMap = new HashMap<>();
        headerMap.put(MPulseConstants.KEY_HEADER_USER_AGENT_FROM, MPulseConstants.USER_AGENT_SDK);
        headerMap.put(MPulseConstants.KEY_HEADER_ACCESS_KEY, config.getAccessKey());
        return headerMap;
    }

    /**
     * Custom WebViewClient to listen for page load events
     */
    private class MPulseInboxWebViewClient extends WebViewClient {

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            if (mInboxViewListener != null) {
                mInboxViewListener.onPageLoadStarted();
            }
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            if (mInboxViewListener != null) {
                mInboxViewListener.onPageLoadFinished();
            }
            super.onPageFinished(view, url);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            view.loadUrl(url);
            return false;
        }
    }

    /**
     * Custom WebChromeClient to listen for progress update events
     */
    private class MPulseInboxWebChromeClient extends WebChromeClient {

        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            if (mInboxViewListener != null) {
                mInboxViewListener.onProgressChanged(view, newProgress);
            }
            super.onProgressChanged(view, newProgress);
        }
    }
}
