import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';

class LoginController extends GetxController {
  // Form controllers
  final TextEditingController nrpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<Map<String, dynamic>>();
  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;
  var userPermissions = Rxn<Map<String, dynamic>>();

  // Form key for validation
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    nrpController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedNrp = prefs.getString('saved_nrp');
      final savedPassword = prefs.getString('saved_password');
      final remember = prefs.getBool('remember_me') ?? false;

      if (remember && savedNrp != null && savedPassword != null) {
        nrpController.text = savedNrp;
        passwordController.text = savedPassword;
        rememberMe.value = true;

        // Auto login if remember me is checked
        await autoLogin(savedNrp, savedPassword);
      }
    } catch (e) {
      // Clear any potentially corrupt saved data
      await clearSavedLogin();
    }
  }

  // Auto login function
  Future<void> autoLogin(String nrp, String password) async {
    try {
      final user = await SupabaseService.instance.loginWithNRP(
        nrp: nrp,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        await loadUserPermissions(user['jabatan']);
        isLoggedIn.value = true;
        Get.offAllNamed('/home');
      }
    } catch (e) {
      // Clear saved data if auto login fails
      await clearSavedLogin();
    }
  }

  // Save login data to SharedPreferences
  Future<void> saveLoginData(String nrp, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe.value) {
        await prefs.setString('saved_nrp', nrp);
        await prefs.setString('saved_password', password);
        await prefs.setBool('remember_me', true);
      } else {
        await clearSavedLogin();
      }
    } catch (e) {
      Get.snackbar(
        'Warning',
        'Gagal menyimpan data login',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Clear saved login data
  Future<void> clearSavedLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_nrp');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    } catch (e) {
      Get.snackbar(
        'Warning',
        'Gagal menghapus data login tersimpan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Load user permissions from jabatan table
  Future<void> loadUserPermissions(String? jabatanName) async {
    if (jabatanName == null || jabatanName.isEmpty) {
      userPermissions.value = null;
      return;
    }

    try {
      final result = await SupabaseService.instance.client
          .from('jabatan')
          .select(
            'permissionCuti, permissionEksepsi, permissionAllCuti, permissionAllEksepsi, permissionInsentif, permissionAtk, permissionAllInsentif, permissionSuratKeluar, permissionManagementData',
          )
          .eq('nama', jabatanName)
          .maybeSingle();

      userPermissions.value = result;
    } catch (e) {
      userPermissions.value = null;
    }
  }

  // Login method
  Future<void> login() async {
    if (loginFormKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    try {
      final user = await SupabaseService.instance.loginWithNRP(
        nrp: nrpController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        currentUser.value = user;
        await loadUserPermissions(user['jabatan']);
        isLoggedIn.value = true;

        // Save login data if remember me is checked
        await saveLoginData(nrpController.text.trim(), passwordController.text);

        // Clear form only if not remembering
        if (!rememberMe.value) {
          nrpController.clear();
          passwordController.clear();
        }

        // Navigate to home
        Get.offAllNamed('/home');

        Get.snackbar(
          'Berhasil',
          'Login berhasil! Selamat datang ${user['name']}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'NRP atau password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      isLoading.value = true;

      currentUser.value = null;
      userPermissions.value = null;
      isLoggedIn.value = false;

      // Clear saved login data
      await clearSavedLogin();
      rememberMe.value = false;

      // Navigate to login
      Get.offAllNamed('/login');

      Get.snackbar(
        'Berhasil',
        'Logout berhasil',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout gagal: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validation functions
  String? validateNrp(String? value) {
    if (value == null || value.isEmpty) {
      return 'NRP tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'NRP minimal 3 karakter';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Helper methods to check permissions
  bool hasPermission(String permissionKey) {
    final permissions = userPermissions.value;
    if (permissions == null) return false;
    return permissions[permissionKey] ?? false;
  }

  bool get hasPermissionManagementData =>
      hasPermission('permissionManagementData');
  bool get hasPermissionCuti => hasPermission('permissionCuti');
  bool get hasPermissionEksepsi => hasPermission('permissionEksepsi');
  bool get hasPermissionAllCuti => hasPermission('permissionAllCuti');
  bool get hasPermissionAllEksepsi => hasPermission('permissionAllEksepsi');
  bool get hasPermissionInsentif => hasPermission('permissionInsentif');
  bool get hasPermissionAtk => hasPermission('permissionAtk');
  bool get hasPermissionAllInsentif => hasPermission('permissionAllInsentif');
  bool get hasPermissionSuratKeluar => hasPermission('permissionSuratKeluar');
}
