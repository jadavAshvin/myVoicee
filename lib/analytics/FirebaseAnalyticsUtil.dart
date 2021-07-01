import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsUtil {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsUtil _instance =
      FirebaseAnalyticsUtil._internal();

  FirebaseAnalyticsUtil._internal();

  static FirebaseAnalyticsUtil get instance => _instance;

  void hitEvent(String action, EventParamsBuilder builder) {
    analytics.logEvent(
        name: action, parameters: builder == null ? null : builder.build());
  }
}

class EventParamsBuilder {
  Map<String, dynamic> bundle = Map();

  void labelAndValue(String label, dynamic value) {
    bundle.putIfAbsent(label, () => value);
  }

  Map<String, dynamic> build() {
    return bundle;
  }
}
