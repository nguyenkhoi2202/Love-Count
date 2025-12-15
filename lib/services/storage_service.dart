import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/important_day.dart';

class StorageService {
  static const _keyStartDate = 'start_date';
  static const _keyImportantDays = 'important_days';

  Future<void> saveStartDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyStartDate, date.toIso8601String());
  }

  Future<DateTime?> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyStartDate);
    return value != null ? DateTime.parse(value) : null;
  }

  Future<void> saveImportantDays(List<ImportantDay> days) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = days.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList(_keyImportantDays, jsonList);
  }

  Future<List<ImportantDay>> getImportantDays() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyImportantDays) ?? [];
    return list.map((e) => ImportantDay.fromJson(jsonDecode(e))).toList();
  }
}
