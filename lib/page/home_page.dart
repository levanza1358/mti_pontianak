import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.find<LoginController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                children: [
                  // KERENUI Header Section
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, -2),
                          spreadRadius: 0,
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
                                const SizedBox(height: 4),
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
                        const SizedBox(height: 12),

                        // Menu Cards in KERENUI Layout with Permission Check
                        ..._buildPermissionBasedMenus(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.onPrimary.withOpacity(0.3),
            ),
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

  // Build permission-based menu list
  List<Widget> _buildPermissionBasedMenus(BuildContext context) {
    final LoginController authController = Get.find<LoginController>();
    final List<Widget> menus = [];

    // Manajemen Data - Show if user has any management permission
    if (authController.hasPermissionManagementData) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Manajemen Data',
          subtitle: 'Kelola data pegawai dan sistem',
          icon: Icons.storage_rounded,
          color: const Color(0xFF667eea),
          onTap: () => Get.toNamed('/data-management'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Pengajuan Cuti - Show if user has cuti permission
    if (authController.hasPermissionCuti) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Pengajuan Cuti',
          subtitle: 'Ajukan dan kelola permohonan cuti',
          icon: Icons.event_available_rounded,
          color: const Color(0xFF4facfe),
          onTap: () => Get.toNamed('/cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Kalender Cuti - Show if user has cuti permission (view calendar)
    if (authController.hasPermissionCuti) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Kalender Cuti',
          subtitle: 'Lihat jadwal cuti dalam kalender',
          icon: Icons.calendar_month_rounded,
          color: const Color(0xFF00d2ff),
          onTap: () => Get.toNamed('/calendar-cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Pengajuan Eksepsi - Show if user has cuti permission (similar to cuti)
    if (authController.hasPermissionCuti) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Pengajuan Eksepsi',
          subtitle: 'Ajukan dan kelola eksepsi kehadiran',
          icon: Icons.schedule_rounded,
          color: const Color(0xFFf093fb),
          onTap: () => Get.toNamed('/eksepsi'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Semua Data Cuti - Show if user has permission to view all
    if (authController.hasPermissionAllCuti) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Semua Data Cuti',
          subtitle: 'Lihat semua pengajuan cuti',
          icon: Icons.list_alt_rounded,
          color: const Color(0xFF10b981),
          onTap: () => Get.toNamed('/all-cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Semua Data Eksepsi - Show if user has permission to view all eksepsi
    if (authController.hasPermissionAllEksepsi) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Semua Data Eksepsi',
          subtitle: 'Lihat semua pengajuan eksepsi',
          icon: Icons.fact_check_rounded,
          color: const Color(0xFF22c55e),
          onTap: () => Get.toNamed('/all-eksepsi'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Data Insentif - Show if user has insentif permission
    if (authController.hasPermissionInsentif) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Data Insentif',
          subtitle: 'Kelola insentif premi dan lembur',
          icon: Icons.attach_money_rounded,
          color: const Color(0xFF38b2ac),
          onTap: () => Get.toNamed('/insentif'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Surat Keluar - Show if user has surat keluar permission
    if (authController.hasPermissionSuratKeluar) {
      menus.add(
        _buildKerenUIMenuCard(
          context: context,
          title: 'Surat Keluar',
          subtitle: 'Buat dan kelola surat keluar',
          icon: Icons.mail_rounded,
          color: const Color(0xFF60a5fa),
          onTap: () => Get.toNamed('/surat-keluar'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }

    // Always show these menus (no permission required)
    menus.add(
      _buildKerenUIMenuCard(
        context: context,
        title: 'Laporan',
        subtitle: 'Lihat laporan dan statistik sistem',
        icon: Icons.assessment_rounded,
        color: const Color(0xFFfa709a),
        onTap: () => _showComingSoon(context, 'Laporan'),
      ),
    );
    menus.add(const SizedBox(height: 8));

    menus.add(
      _buildKerenUIMenuCard(
        context: context,
        title: 'Pengaturan',
        subtitle: 'Konfigurasi dan preferensi sistem',
        icon: Icons.settings_rounded,
        color: const Color(0xFF8360c3),
        onTap: () => _showComingSoon(context, 'Pengaturan'),
      ),
    );
    menus.add(const SizedBox(height: 8));

    menus.add(
      _buildKerenUIMenuCard(
        context: context,
        title: 'Bantuan',
        subtitle: 'Panduan penggunaan dan dukungan',
        icon: Icons.help_rounded,
        color: const Color(0xFF11998e),
        onTap: () => _showComingSoon(context, 'Bantuan'),
      ),
    );

    return menus;
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1),
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
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final theme = Theme.of(context);

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.construction_rounded,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              feature,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          'Fitur $feature sedang dalam pengembangan dan akan segera hadir!',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
