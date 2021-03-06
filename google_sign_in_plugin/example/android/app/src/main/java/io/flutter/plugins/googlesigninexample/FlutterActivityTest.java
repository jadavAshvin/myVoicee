// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlesigninexample;

import androidx.test.rule.ActivityTestRule;

import org.junit.Rule;
import org.junit.runner.RunWith;

import dev.flutter.plugins.e2e.FlutterRunner;
import io.flutter.embedding.android.FlutterActivity;

@RunWith(FlutterRunner.class)
public class FlutterActivityTest {
    @Rule
    public ActivityTestRule<FlutterActivity> rule = new ActivityTestRule<>(FlutterActivity.class);
}
