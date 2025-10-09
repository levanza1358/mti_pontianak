// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/theme/app_spacing.dart';
import '../controller/login_controller.dart';
import '../controller/update_checker_controller.dart';
import '../controller/home_controller.dart';
import 'settings_page.dart';
import '../theme/app_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Pindahkan deklarasi fungsi ke atas sebelum build
  Widget _buildInfoChip(IconData icon, String text) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.colorScheme.onPrimary, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build permission-based menu list dipindahkan ke HomeController

  Widget _buildKerenUIMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: t.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: t.borderSubtle, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: t.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: t.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: t.textPrimary.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.find<LoginController>();
    // Auto-check update once when Home is shown
    try {
      final update = Get.put(UpdateCheckerController(), permanent: true);
      // Schedule microtask to avoid setState during build warnings
      Future.microtask(() => update.checkOnHomeOnce());
    } catch (_) {}
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: t.homeGradient
                .map((c) => c.withOpacity(isDark ? 0.08 : 0.14))
                .toList(),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // KERENUI Header Section (isolated from repaints)
                RepaintBoundary(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: t.homeGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: t.shadowColor,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MTI Pontianak',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  authController.currentUser.value != null
                                      ? 'Halo, ${authController.currentUser.value!['name'] ?? 'User'}'
                                      : 'Halo, User',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onPrimary
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimary.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.waving_hand,
                                color: theme.colorScheme.onPrimary,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        if (authController.currentUser.value != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.badge_rounded,
                                  'NRP: ${authController.currentUser.value!['nrp'] ?? '-'}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoChip(
                                  Icons.work_rounded,
                                  authController
                                          .currentUser
                                          .value!['jabatan'] ??
                                      '-',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Settings and Logout Section
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logout ListTile
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
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
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
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
                                      color: theme.textTheme.bodyMedium?.color
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
                                      borderRadius: BorderRadius.circular(8),
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

                // Dashboard Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineSmall?.color,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Menu Cards in KERENUI Layout with Permission Check
                      ...Get.put(HomeController()).buildPermissionBasedMenus(
                        context,
                        _buildKerenUIMenuCard,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Settings entry
                      _buildKerenUIMenuCard(
                        context: context,
                        title: 'Pengaturan',
                        subtitle: 'Tema & pembaruan aplikasi',
                        icon: Icons.settings,
                        color: const Color(0xFF06B6D4),
                        onTap: () => Get.to(const SettingsPage()),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ...existing code...
}
