package com.android.mpulse;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.android.mpulseframework.MPulseHandler;
import com.android.mpulseframework.admin.CustomFieldsModel;
import com.android.mpulseframework.admin.MPulseControlPanel;
import com.android.mpulseframework.admin.event.MPulseEventUtil;
import com.android.mpulseframework.admin.event.UploadEventRequestModel;
import com.android.mpulseframework.admin.members.MemberRequestModel;
import com.android.mpulseframework.callbacks.TrackPushNotificationListener;
import com.android.mpulseframework.exceptions.MPulseException;
import com.android.mpulseframework.networking.models.ApiError;
import com.android.mpulseframework.utils.logs.MPulseLogger;

import java.util.List;

public class MainActivity extends AppCompatActivity implements TrackPushNotificationListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        MPulseLogger.setIsDebug(true);
    }

    @Override
    public void onTrackPushNotificationSuccess() {

    }

    @Override
    public void onTrackPushNotificationFailure(ApiError error) {


    }
}
