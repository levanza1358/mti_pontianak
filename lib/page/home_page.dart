// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/theme/app_spacing.dart';
import '../controller/login_controller.dart';
import '../controller/home_controller.dart';
import '../controller/update_checker_controller.dart';
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

  // Kartu gabungan: kiri Pengajuan Cuti, kanan Kalender Cuti
  Widget _buildCutiDualAccessCard(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Kiri: Pengajuan Cuti
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed('/cuti'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4facfe).withOpacity(0.8),
                                const Color(0xFF4facfe).withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.event_available_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengajuan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Cuti',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Divider vertikal di tengah
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: t.borderSubtle,
              ),
              // Kanan: Kalender Cuti
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed('/calendar-cuti'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF00d2ff).withOpacity(0.8),
                                const Color(0xFF00d2ff).withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kalender',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Lihat jadwal cuti',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    final HomeController homeController = Get.find<HomeController>();
    final UpdateCheckerController updateChecker = Get.find<UpdateCheckerController>();
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    // Jalankan auto cek update sekali setelah halaman Home dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateChecker.checkOnHomeOnce();
    });

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
                                          .currentUser.value!['jabatan'] ??
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

                // Logout removed from Home; accessible via Settings

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
                      ...homeController.buildPermissionBasedMenus(
                        context,
                        _buildKerenUIMenuCard,
                        cutiDualCardBuilder: _buildCutiDualAccessCard,
                      ),

                      // Fitur "Semua Data" dihapus sesuai permintaan pengguna
                      const SizedBox(height: AppSpacing.md),
                      // Settings entry dengan dua aksi (kiri: Simulasi, kanan: Pengaturan)
                      _buildSettingsDualAccessCard(context),
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

  Widget _buildSettingsDualAccessCard(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Kiri: Simulasi (Slot Demo)
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed('/slot-demo'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFF59E0B).withOpacity(0.8),
                                const Color(0xFFF59E0B).withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.casino_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mni Game',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Judi Slot Palsu',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Divider vertikal di tengah
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: t.borderSubtle,
              ),
              // Kanan: Pengaturan
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(const SettingsPage()),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF06B6D4).withOpacity(0.8),
                                const Color(0xFF06B6D4).withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengaturan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Aplikasi',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
