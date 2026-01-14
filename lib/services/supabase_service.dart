import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => client.auth;

  // Auth Methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static User? get currentUser => auth.currentUser;
  static Session? get currentSession => auth.currentSession;

  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // Database Methods
  static Future<List<Map<String, dynamic>>> getFoodEntries({
    required String userId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await client
        .from('food_entries')
        .select()
        .eq('user_id', userId)
        .gte('logged_at', startOfDay.toIso8601String())
        .lt('logged_at', endOfDay.toIso8601String())
        .order('logged_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createFoodEntry({
    required String userId,
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    String? imageUrl,
    List<Map<String, dynamic>>? ingredients,
    int servings = 1,
  }) async {
    final response = await client.from('food_entries').insert({
      'user_id': userId,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'servings': servings,
      'logged_at': DateTime.now().toIso8601String(),
    }).select().single();

    return response;
  }

  static Future<void> deleteFoodEntry(String id) async {
    await client.from('food_entries').delete().eq('id', id);
  }

  static Future<List<Map<String, dynamic>>> getWeightLogs({
    required String userId,
    int limit = 100,
  }) async {
    final response = await client
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createWeightLog({
    required String userId,
    required double weight,
    String? note,
  }) async {
    final response = await client.from('weight_logs').insert({
      'user_id': userId,
      'weight': weight,
      'note': note,
      'logged_at': DateTime.now().toIso8601String(),
    }).select().single();

    return response;
  }

  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    String? name,
    int? dailyCalorieGoal,
    int? dailyProteinGoal,
    int? dailyCarbsGoal,
    int? dailyFatGoal,
    double? currentWeight,
    double? goalWeight,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (dailyCalorieGoal != null) updates['daily_calorie_goal'] = dailyCalorieGoal;
    if (dailyProteinGoal != null) updates['daily_protein_goal'] = dailyProteinGoal;
    if (dailyCarbsGoal != null) updates['daily_carbs_goal'] = dailyCarbsGoal;
    if (dailyFatGoal != null) updates['daily_fat_goal'] = dailyFatGoal;
    if (currentWeight != null) updates['current_weight'] = currentWeight;
    if (goalWeight != null) updates['goal_weight'] = goalWeight;

    final response = await client
        .from('users')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return response;
  }

  // Storage Methods
  static Future<String> uploadFoodImage({
    required String userId,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final path = '$userId/$fileName';
    await client.storage.from('food_images').uploadBinary(
      path,
      fileBytes as dynamic,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: false,
      ),
    );

    return client.storage.from('food_images').getPublicUrl(path);
  }
}
