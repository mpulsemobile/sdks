package com.android.mpulseframework.networking.executor;

import com.android.mpulseframework.networking.ApiRequest;
import com.android.mpulseframework.networking.constants.ApiConstants;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.networking.models.ApiResponse;
import com.android.mpulseframework.utils.logs.MPulseLogger;
import com.android.mpulseframework.utils.logs.MPulseLoggerFactory;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * The Runnable on which the API call is made
 */
public class ApiRunnable implements Runnable {

    private static final MPulseLogger LOGGER = MPulseLoggerFactory.createLogger(ApiRunnable.class);

    /**
     * The ApiRequest to execute
     */
    private final ApiRequest request;

    /**
     * Constructor of ApiRunnable
     *
     * @param request the ApiRequest to execute
     */
    ApiRunnable(ApiRequest request) {
        this.request = request;
    }

    @Override
    public void run() {
        executeRequest();
    }

    /**
     * Used to make the API call
     */
    private void executeRequest() {
        try {
            CookieHandler.setDefault(new CookieManager(null, CookiePolicy.ACCEPT_ALL));
            URL url = new URL(request.getUrl());
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setReadTimeout(60 * 1000);
            connection.setConnectTimeout(60 * 1000);
            addHeaders(connection);
            connection.setRequestMethod(request.getMethod().getValue());
            switch (request.getMethod()){
                case POST:
                    connection.setDoOutput(true);
                    OutputStream os = connection.getOutputStream();
                    if(request.getRequestJsonString()!=null) {
                        os.write(request.getRequestJsonString().getBytes());
                    }
                    if (request.getUrlEncodedParamsString() != null){
                        BufferedWriter writer = new BufferedWriter(
                                new OutputStreamWriter(os, "UTF-8"));
                        writer.write(request.getUrlEncodedParamsString());
                        writer.flush();
                        writer.close();
                    }
                    os.flush();
                    os.close();
                    break;
            }
            int responseCode = connection.getResponseCode();
            if (responseCode < HttpURLConnection.HTTP_BAD_REQUEST) {
                ApiResponse apiResponse = new ApiResponse(responseCode);
                handleApiResponse(apiResponse, connection.getInputStream());
                request.deliverResponse(apiResponse);
            } else {
                ApiError apiError = new ApiError(responseCode);
                handleErrorResponse(apiError, connection.getErrorStream());
                request.deliverError(apiError);
            }
        } catch (IOException e) {
            ApiError apiError = new ApiError(ApiConstants.ERROR_MESSAGE_INTERNET, 0);
            request.deliverError(apiError);
            LOGGER.error(e.getMessage());
        }
    }

    /**
     * Parses the API response stream
     *
     * @param response the ApiResponse object to parse the stream to
     * @param stream   the input stream to parse
     */
    @SuppressWarnings("unchecked")
    private void handleApiResponse(ApiResponse response, InputStream stream) {
        StringBuilder builder = new StringBuilder();
        String inputLine;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream))) {
            while ((inputLine = reader.readLine()) != null) {
                builder.append(inputLine);
            }
            response.setResult(builder.toString());
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            response.setApiError(new ApiError(e));
        }
    }

    /**
     * Parses the API error stream
     *
     * @param error  the ApiError object to parse the stream to
     * @param stream the error stream to parse
     */
    private void handleErrorResponse(ApiError error, InputStream stream) {
        StringBuilder builder = new StringBuilder();
        String inputLine;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream))) {
            while ((inputLine = reader.readLine()) != null) {
                builder.append(inputLine);
            }
            error.setErrorMessage(builder.toString());
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            error.setErrorMessage(e.getMessage());
            error.setErrorCode(0);
        }
    }

    /**
     * Adds the requests headers to the connection object
     *
     * @param connection the connection object to add the headers to
     */
    private void addHeaders(HttpURLConnection connection) {
        Map<String, List<String>> headers = request.getHeaders();
        if (headers == null) {
            return;
        }
        Set<Map.Entry<String, List<String>>> entries = headers.entrySet();
        for (Map.Entry<String, List<String>> entry : entries) {
            String name = entry.getKey();
            List<String> list = entry.getValue();
            if (list == null) {
                continue;
            }
            for (String value : list) {
                connection.addRequestProperty(name, value);
            }
        }
    }
}
