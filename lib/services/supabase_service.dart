import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      await client.from('users').select('nrp').limit(1);
      return true;
    } catch (e) {
      // Surface error in logs to help diagnose release issues
      // ignore: avoid_print
      print('Supabase testConnection error: $e');
      return false;
    }
  }

  // Auth methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Custom authentication methods for users table
  Future<Map<String, dynamic>?> loginWithNRP({
    required String nrp,
    required String password,
  }) async {
    try {
      // Query users table with NRP and password
      final response = await client
          .from('users')
          .select('id, nrp, name, jabatan, sisa_cuti, updated_at')
          .eq('nrp', nrp)
          .eq('password', password)
          .maybeSingle();

      return response;
    } catch (e) {
      // Propagate error to caller so UI can show actual reason
      rethrow;
    }
  }

  // Get user by NRP
  Future<Map<String, dynamic>?> getUserByNRP(String nrp) async {
    try {
      final response = await client
          .from('users')
          .select('id, nrp, name, jabatan, sisa_cuti, updated_at')
          .eq('nrp', nrp)
          .maybeSingle();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create new user
  Future<Map<String, dynamic>?> createUser({
    required String nrp,
    required String password,
    required String name,
    String? jabatan,
  }) async {
    try {
      final response = await client
          .from('users')
          .insert({
            'nrp': nrp,
            'password': password,
            'name': name,
            'jabatan': jabatan,
          })
          .select('id, nrp, name, jabatan, updated_at')
          .single();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>?> updateUserProfile({
    required String userId,
    String? name,
    String? jabatan,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (jabatan != null) updateData['jabatan'] = jabatan;

      if (updateData.isEmpty) return null;

      final response = await client
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select('id, nrp, name, jabatan, updated_at')
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String userId,
    required String newPassword,
  }) async {
    try {
      await client
          .from('users')
          .update({'password': newPassword})
          .eq('id', userId);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Database operations example
  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    try {
      final response = await client.from(tableName).select();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertData(String tableName, Map<String, dynamic> data) async {
    try {
      await client.from(tableName).insert(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateData(
    String tableName,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    try {
      await client.from(tableName).update(data).eq(column, value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteData(
    String tableName,
    String column,
    dynamic value,
  ) async {
    try {
      await client.from(tableName).delete().eq(column, value);
    } catch (e) {
      rethrow;
    }
  }

  // Insentif methods
  Future<List<Map<String, dynamic>>> getInsentifPremi() async {
    try {
      final response = await client
          .from('insentif_premi')
          .select()
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInsentifLembur() async {
    try {
      final response = await client
          .from('insentif_lembur')
          .select()
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }
}
