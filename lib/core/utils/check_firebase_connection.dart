import 'package:http/http.dart' as http;
import 'package:todo_app_with_notifications/core/service/firebase_options.dart';

Future<bool> checkFirebaseConnection() async {
  try {
    final uri = Uri.parse(DefaultFirebaseOptions().firebaseTestLink);
    final response = await http.get(uri).timeout(const Duration(seconds: 5));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; // reachable
    }
    return false; // any other status = unreachable
  } catch (e) {
    return false;
  }
}
