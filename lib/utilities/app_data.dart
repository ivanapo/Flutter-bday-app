import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstStartup() async {
  final prefs = await SharedPreferences.getInstance();
  bool? setting = prefs.getBool('isFirstStartup');

  return false;
}
