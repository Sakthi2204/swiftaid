package com.example.swiftaid;

import android.app.Application;

import io.radar.sdk.Radar;

public class MainApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize Radar SDK with your API key
        Radar.initialize(this, "prj_test_pk_56e8168df8db7ce3c5e065f98ac5530b8aa9ef83");
    }
}
