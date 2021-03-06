// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlesigninexample;

import androidx.test.rule.ActivityTestRule;

import org.junit.Rule;
import org.junit.runner.RunWith;

import dev.flutter.plugins.e2e.FlutterRunner;

@RunWith(FlutterRunner.class)
public class EmbeddingV1ActivityTest {
    @Rule
    public ActivityTestRule<EmbeddingV1Activity> rule =
            new ActivityTestRule<>(EmbeddingV1Activity.class);
}
