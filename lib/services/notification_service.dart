import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../utils/love_utils.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initAndScheduleDaily() async {
    if (_initialized) return;
    _initialized = true;

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

    await _scheduleNext30Days();
  }

  static Future<void> _scheduleNext30Days() async {
    final now = tz.TZDateTime.now(tz.local);
    final milestoneDate = LoveUtils.nextMilestoneDate();

    for (int i = 0; i < 30; i++) {
      final day = now.add(Duration(days: i));
      final scheduledTime = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        10, // ⏰ 7:00 sáng
        51,
      );

      if (scheduledTime.isBefore(now)) continue;

      final daysLeft = LoveUtils.startLoveDate
          .add(Duration(days: LoveUtils.milestones.last))
          .difference(day)
          .inDays;

      // 🔔 THÔNG BÁO HẰNG NGÀY
      await _plugin.zonedSchedule(
        1000 + i,
        '💖 Nhắc nhở tình yêu',
        'Còn ${LoveUtils.daysToNextMilestone()} ngày nữa là kỉ niệm ${LoveUtils.daysToNextMilestone()} ngày yêu nhau ❤️',
        scheduledTime,
        _details(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // 🎉 NẾU LÀ NGÀY ĐẶC BIỆT
      if (milestoneDate != null &&
          day.year == milestoneDate.year &&
          day.month == milestoneDate.month &&
          day.day == milestoneDate.day) {
        await _plugin.zonedSchedule(
          2000 + i,
          '🎉 NGÀY ĐẶC BIỆT ❤️',
          'Hôm nay là ngày kỉ niệm yêu nhau của Khôi và Vy 💕',
          scheduledTime.add(const Duration(minutes: 1)),
          _details(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'love_channel',
        'Love Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }
}
