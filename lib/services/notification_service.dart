import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../utils/love_utils.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleMonthlyAnniversary() async {
    await _plugin.cancel(1);
    await _plugin.zonedSchedule(
      1,
      'Kỷ niệm tình yêu ❤️',
      _message(),
      _next12th(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'love_channel',
          'Love Anniversary',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _next12th() {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, 12, 9);

    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(tz.local, now.year, now.month + 1, 12, 9);
    }
    return scheduled;
  }

  static String _message() {
    final months = LoveUtils.monthsInLove();
    return 'Hôm nay là kỷ niệm $months tháng yêu nhau của Nguyên Khôi & Khánh Vy 💕';
  }
}
