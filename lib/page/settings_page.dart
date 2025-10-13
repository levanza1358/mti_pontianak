// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../theme/app_tokens.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';
import '../controller/login_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version.isEmpty ? '' : info.version;
      });
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();
    final LoginController authController = Get.find<LoginController>();
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: isDark ? 0 : 4,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? t.insentifGradient : t.homeGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 2),
            // Text(
            //   'Tema & Pembaruan Aplikasi',
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.white70,
            //   ),
            // ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              final selected = themeC.mode.value;
              final accent = t.insentifGradient.first;
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => themeC.setMode(ThemeMode.light),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected == ThemeMode.light
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: selected == ThemeMode.light
                                ? [
                                    BoxShadow(
                                      color: t.shadowColor,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Light Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected == ThemeMode.light
                                  ? accent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => themeC.setMode(ThemeMode.dark),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected == ThemeMode.dark
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: selected == ThemeMode.dark
                                ? [
                                    BoxShadow(
                                      color: t.shadowColor,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected == ThemeMode.dark
                                  ? accent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar now handles the header; removing old header Card.

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: isDark ? 0 : 3,
                      shadowColor: isDark
                          ? t.shadowColor
                          : t.shadowColor.withOpacity(0.25),
                      color: t.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: t.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    t.updateGradient.first.withOpacity(0.15),
                                    t.updateGradient.last.withOpacity(0.15),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: t.borderSubtle),
                              ),
                              child: Icon(
                                Icons.system_update_rounded,
                                color: t.updateGradient.first,
                                size: 20,
                              ),
                            ),
                            title: const Text('Update Aplikasi'),
                            subtitle: const Text(
                              'Cek versi terbaru dan pasang pembaruan',
                            ),
                            trailing: _version.isEmpty
                                ? null
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: t.updateGradient.first
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'v$_version',
                                      style: TextStyle(
                                        color: t.updateGradient.first,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                            onTap: () => Get.toNamed('/update-checker'),
                          ),
                          Divider(height: 1, color: t.borderSubtle),
                          // Change Password
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    t.insentifGradient.first.withOpacity(0.15),
                                    t.insentifGradient.last.withOpacity(0.15),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: t.borderSubtle),
                              ),
                              child: Icon(
                                Icons.lock_reset_rounded,
                                color: t.insentifGradient.first,
                                size: 20,
                              ),
                            ),
                            title: const Text('Ubah Password'),
                            subtitle: const Text('Ganti kata sandi akun Anda'),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                            ),
                            onTap: _showChangePasswordDialog,
                          ),
                          Divider(height: 1, color: t.borderSubtle),
                          // Slot Demo entry

                          Divider(height: 1, color: t.borderSubtle),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: t.borderSubtle),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            subtitle: Text(
                              'Keluar dari aplikasi',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                            ),
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: theme.dialogBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  content: Text(
                                    'Apakah Anda yakin ingin logout?',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        'Batal',
                                        style: TextStyle(
                                          color: theme
                                              .textTheme.bodyMedium?.color
                                              ?.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        authController.logout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final LoginController authController = Get.find<LoginController>();
    final isDark = theme.brightness == Brightness.dark;

    final formKey = GlobalKey<FormState>();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Text(
            'Ubah Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
              fontSize: 20,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newPassController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    hintText: 'Masukkan password baru',
                    prefixIcon: const Icon(Icons.lock_open_rounded),
                    filled: true,
                    fillColor: isDark ? t.surface : t.card,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: t.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Password tidak boleh kosong';
                    if (v.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPassController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    hintText: 'Ulangi password baru',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    filled: true,
                    fillColor: isDark ? t.surface : t.card,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: t.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Konfirmasi tidak boleh kosong';
                    if (v != newPassController.text.trim()) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState?.validate() != true) return;
                      setState(() => isLoading = true);
                      final userId = authController.currentUser.value?['id'];
                      if (userId == null) {
                        Get.snackbar(
                          'Error',
                          'Pengguna tidak terdeteksi. Silakan login ulang.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                        setState(() => isLoading = false);
                        return;
                      }

                      try {
                        // Update password di tabel users
                        await SupabaseService.instance.client
                            .from('users')
                            .update({
                          'password': newPassController.text.trim(),
                        }).eq('id', userId);

                        // Sinkronkan password tersimpan bila Remember Me aktif
                        if (authController.rememberMe.value) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            'saved_password',
                            newPassController.text.trim(),
                          );
                        }

                        Get.back();
                        Get.snackbar(
                          'Berhasil',
                          'Password berhasil diubah.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 3),
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Gagal mengubah password: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        );
      }),
      barrierDismissible: false,
    );
  }
}
