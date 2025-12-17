import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/love_utils.dart';
import '../utils/quote_utils.dart';
import '../utils/background_utils.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String quote;

  @override
  void initState() {
    super.initState();
    quote = QuoteUtils.randomQuote();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.scheduleDailyLoveNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = LoveUtils.daysInLove();
    final months = LoveUtils.monthsInLove();
    final nextMilestone = LoveUtils.daysToNextMilestone();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(BackgroundUtils.getBackgroundByDay()),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.45),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nguyên Khôi ❤️ Khánh Vy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Icon(Icons.favorite, color: Colors.pinkAccent, size: 90)
                    .animate(
                      onPlay: (controller) =>
                          controller.repeat(), // lặp liên tục
                    )
                    //.fadeIn(duration: 400.ms)
                    .scaleXY(
                      begin: 1,
                      end: 1.15,
                      duration: 600.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scaleXY(
                      begin: 1.15,
                      end: 1,
                      duration: 600.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 16),
                Text(
                  '$days ngày yêu nhau',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$months tháng bên nhau',
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                if (nextMilestone > 0)
                  Text(
                    'Còn $nextMilestone ngày nữa đến cột mốc tiếp theo 💕',
                    style: const TextStyle(color: Colors.white70),
                  ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () async {
                //     await NotificationService.requestPermissionAndScheduleFixedAlarm();

                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Báo thức đã được đặt ❤️')),
                //     );
                //   },
                //   child: const Text('Đặt báo thức đặc biệt'),
                // ),
                // Phần Random quote
                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
