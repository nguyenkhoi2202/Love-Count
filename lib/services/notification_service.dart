import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../utils/love_utils.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// ================================
  /// INIT + REQUEST PERMISSION (iOS)
  /// ================================
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // 🔔 iOS MUST request permission explicitly
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// =====================================
  /// PUBLIC API – CALL 1 LẦN KHI APP MỞ
  /// =====================================
  Future<void> scheduleDailyLoveNotifications() async {
    await init();

    // iOS không cho schedule vô hạn → schedule trước 30 ngày
    await _plugin.cancelAll();
    await _scheduleNext30Days();
  }

  /// ================================
  /// CORE SCHEDULER
  /// ================================
  Future<void> _scheduleNext30Days() async {
    final now = tz.TZDateTime.now(tz.local);
    final milestoneDate = LoveUtils.nextMilestoneDate();

    for (int i = 0; i < 30; i++) {
      final day = now.add(Duration(days: i));

      final scheduledTime = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        11, // ⏰ 10:51 sáng
        04,
      );

      if (scheduledTime.isBefore(now)) continue;

      // ====== DAILY REMINDER ======
      final daysLeft = milestoneDate == null
          ? 0
          : milestoneDate.difference(day).inDays;

      await _plugin.zonedSchedule(
        1000 + i,
        '💖 Nhắc nhở tình yêu',
        daysLeft > 0
            ? 'Còn $daysLeft ngày nữa là đến ngày đặc biệt ❤️'
            : 'Hôm nay là ngày đặc biệt ❤️',
        scheduledTime,
        _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // ====== SPECIAL DAY EXTRA NOTIFICATION ======
      if (milestoneDate != null && _isSameDay(day, milestoneDate)) {
        await _plugin.zonedSchedule(
          2000 + i,
          '🎉 NGÀY ĐẶC BIỆT ❤️',
          'Hôm nay là ngày kỉ niệm yêu nhau của Khôi và Vy 💕',
          scheduledTime.add(const Duration(minutes: 1)),
          _notificationDetails(isSpecial: true),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  /// ================================
  /// NOTIFICATION STYLE
  /// ================================
  NotificationDetails _notificationDetails({bool isSpecial = false}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'love_channel',
        'Love Notifications',
        channelDescription: 'Daily love reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        interruptionLevel: isSpecial
            ? InterruptionLevel.timeSensitive
            : InterruptionLevel.active,
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
