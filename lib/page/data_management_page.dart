import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_jabatan_page.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = t.homeGradient;
    final accent = accentGradient.first;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: accentGradient
                .map((c) => c.withOpacity(isDark ? 0.08 : 0.14))
                .toList(),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section with Content
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: accentGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: t.shadowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Back Button
                        Container(
                          margin: const EdgeInsets.only(right: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        // Title Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manajemen Data',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Kelola data sistem dengan mudah',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      theme.colorScheme.onPrimary.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Home Button
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.offAllNamed('/home'),
                            icon: Icon(
                              Icons.home,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: t.card,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: t.shadowColor,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Pilih menu untuk mengelola data sistem',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: t.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Tambah Pegawai Card
                              _buildKerenUIMenuCard(
                                context: context,
                                title: 'Tambah Pegawai',
                                subtitle: 'Menambahkan pegawai baru ke sistem',
                                icon: Icons.person_add_rounded,
                                color: const Color(0xFF4facfe),
                                onTap: () =>
                                    Get.toNamed('/data-management/add-pegawai'),
                              ),
                               const SizedBox(height: AppSpacing.lg),

                               // Tambah Jabatan Card
                               _buildKerenUIMenuCard(
                                context: context,
                                title: 'Tambah Jabatan',
                                subtitle: 'Menambahkan jabatan baru ke sistem',
                                icon: Icons.work_outline_rounded,
                                color: const Color(0xFF00f2fe),
                                onTap: () =>
                                    Get.toNamed('/data-management/add-jabatan'),
                              ),
                               const SizedBox(height: AppSpacing.lg),

                              // Edit Data Card
                              _buildKerenUIMenuCard(
                                context: context,
                                title: 'Edit Data',
                                subtitle: 'Mengubah data yang sudah ada',
                                icon: Icons.edit_rounded,
                                color: const Color(0xFF4facfe),
                                onTap: () =>
                                    Get.toNamed('/data-management/edit'),
                              ),
                               const SizedBox(height: AppSpacing.lg),

                              // Edit Data Jabatan Card
                              _buildKerenUIMenuCard(
                                context: context,
                                title: 'Edit Jabatan',
                                subtitle: 'Mengubah data jabatan',
                                icon: Icons.work_history_rounded,
                                color: const Color(0xFF00f2fe),
                                onTap: () =>
                                    Get.to(() => const EditJabatanPage()),
                              ),
                               const SizedBox(height: AppSpacing.lg),

                              // Group Management Card
                              _buildKerenUIMenuCard(
                                context: context,
                                title: 'Manajemen Group',
                                subtitle: 'Tambah, edit, dan kelola data group',
                                icon: Icons.groups_rounded,
                                color: const Color(0xFF10b981),
                                onTap: () => Get.toNamed('/group-management'),
                              ),
                              const SizedBox(height: 16),

                              // Supervisor Management Card
                              _buildKerenUIMenuCard(
                                context: context,
                                title: 'Manajemen Supervisor',
                                subtitle: 'Kelola data supervisor Penunjang & Logistik',
                                icon: Icons.supervisor_account_rounded,
                                color: const Color(0xFF8b5cf6),
                                onTap: () => Get.toNamed('/supervisor-management'),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
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
            blurRadius: 16,
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: t.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: t.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
