import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleModelNotifier extends StateNotifier<String?> {
  RoleModelNotifier() : super(null) {
    _loadImage();
  }

  static const _key = 'role_model_image_path';

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key);
  }

  Future<void> setImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
    state = path;
  }

  Future<void> removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = null;
  }
}

final roleModelProvider = StateNotifierProvider<RoleModelNotifier, String?>((ref) {
  return RoleModelNotifier();
});
