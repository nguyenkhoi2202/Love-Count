import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  /// 🔔 BÁO THỨC NGÀY CỐ ĐỊNH (SET CỨNG)
  static Future<void> scheduleFixedAlarm() async {
    // 🔒 SET CỨNG NGÀY Ở ĐÂY
    final alarmTime = tz.TZDateTime(
      tz.local,
      2025, // năm
      12, // tháng
      17, // ngày
      10, // giờ
      0, // phút
    );

    await _plugin.zonedSchedule(
      100, // id cố định
      '⏰ Báo thức tình yêu',
      'Dậy đi, hôm nay là ngày đặc biệt ❤️',
      alarmTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          fullScreenIntent: true, // giống alarm
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
