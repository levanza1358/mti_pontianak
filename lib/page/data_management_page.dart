import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_jabatan_page.dart';

class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // Header Section with Content
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4facfe).withOpacity(0.3),
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
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
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
                              const Text(
                                'Manajemen Data',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kelola data sistem dengan mudah',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Home Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.offAllNamed('/home'),
                            icon: const Icon(
                              Icons.home,
                              color: Colors.white,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
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
                                color: const Color(0xFF4facfe).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF4facfe),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Pilih menu untuk mengelola data sistem',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
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
                              const SizedBox(height: 16),

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
                              const SizedBox(height: 16),

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
                              const SizedBox(height: 16),

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
                              const SizedBox(height: 16),

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
