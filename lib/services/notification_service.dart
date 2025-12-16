import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../utils/love_utils.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // 1️⃣ Init timezone
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    // 2️⃣ Init notification
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);

    // 3️⃣ REQUEST PERMISSION BẮT BUỘC (iOS)
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> scheduleMonthlyAnniversary() async {
    // ❗ BẮT BUỘC xoá lịch cũ
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
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _next12th() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, 16, 11);

    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(tz.local, now.year, now.month + 1, 16, 11);
    }
    return scheduled;
  }

  static String _message() {
    final months = LoveUtils.monthsInLove();
    return 'Hôm nay là kỷ niệm $months tháng yêu nhau của Nguyên Khôi & Khánh Vy 💕';
  }
}
