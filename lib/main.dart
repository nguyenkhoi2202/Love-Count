import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService.init();
  //await NotificationService.scheduleMonthlyAnniversary();
  runApp(const LoveApp());
}

class LoveApp extends StatelessWidget {
  const LoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
