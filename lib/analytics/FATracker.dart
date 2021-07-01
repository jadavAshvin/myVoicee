import '../analytics/FAEvent.dart';
import '../analytics/FirebaseAnalyticsUtil.dart';
import '../analytics/Tracker.dart';

class FATracker with Tracker<FAEvents> {
  @override
  void track(FAEvents event) {
    var builder = EventParamsBuilder();
    var name = event.eventName;
    if (event.attrs != null) {
      event.attrs.forEach((key, value) {
        builder.labelAndValue(key, value);
      });
    }
    FirebaseAnalyticsUtil.instance.hitEvent(name, builder);
  }
}
