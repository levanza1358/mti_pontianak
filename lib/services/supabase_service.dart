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
      // ignore: avoid_print
      print('Supabase testConnection error: $e');
      return false;
    }
  }

  // =========================
  // AUTH
  // =========================
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

  // =========================
  // USERS TABLE
  // =========================
  Future<Map<String, dynamic>?> loginWithNRP({
    required String nrp,
    required String password,
  }) async {
    try {
      final response = await client
          .from('users')
          .select('id, nrp, name, jabatan, sisa_cuti, updated_at')
          .eq('nrp', nrp)
          .eq('password', password)
          .maybeSingle();

      return response;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<Map<String, dynamic>?> updateUserProfile({
    required String userId,
    String? name,
    String? jabatan,
  }) async {
    try {
      final updateData = <String, dynamic>{};
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

  Future<bool> changePassword({
    required String userId,
    required String newPassword,
  }) async {
    try {
      await client
          .from('users')
          .update({'password': newPassword}).eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // GENERIC DB HELPERS
  // =========================
  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    try {
      final response = await client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
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

  // =========================
  // INSENTIF
  // =========================

  // Ambil list Premi (urut terbaru berdasarkan bulan → created_at)
  Future<List<Map<String, dynamic>>> getInsentifPremi({String? userId}) async {
    try {
      var query = client.from('insentif_premi').select('*');
      if (userId != null && userId.isNotEmpty) {
        query = query.eq('users_id', userId);
      }
      final response = await query
          .order('bulan', ascending: false) // bulan: DATE
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Ambil list Lembur (kalau kamu punya tabelnya, skema sama)
  Future<List<Map<String, dynamic>>> getInsentifLembur({String? userId}) async {
    try {
      var query = client.from('insentif_lembur').select('*');
      if (userId != null && userId.isNotEmpty) {
        query = query.eq('users_id', userId);
      }
      final response = await query
          .order('bulan', ascending: false)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // === Batch lookup users by daftar NRP (pakai inFilter untuk kompatibilitas versi lama)
  Future<Map<String, Map<String, dynamic>>> getUsersByNRPs(
      List<String> nrps) async {
    final unique = nrps.where((e) => e.trim().isNotEmpty).toSet().toList();
    if (unique.isEmpty) return {};

    final res = await client
        .from('users')
        .select('id, name, nrp')
        .inFilter('nrp', unique); // <— perbaikan dari .in_() ke .inFilter()

    final list = List<Map<String, dynamic>>.from(res);
    return {for (final u in list) (u['nrp'] ?? '').toString(): u};
  }

  // === Upsert insentif (premi/lembur) berbasis unique(users_id, bulan)
  Future<void> upsertInsentif({
    required String table, // 'insentif_premi' | 'insentif_lembur'
    required List<Map<String, dynamic>> rows,
  }) async {
    if (rows.isEmpty) return;
    await client.from(table).upsert(
          rows,
          onConflict: 'users_id,bulan', // bulan: DATE
        );
  }
}
