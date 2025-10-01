import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_jabatan_controller.dart';

class EditJabatanPage extends StatelessWidget {
  const EditJabatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditJabatanController controller = Get.put(EditJabatanController());
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
              // Header Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
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
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Data Jabatan',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pilih dan edit jabatan yang tersedia',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: controller.refreshData,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        tooltip: 'Refresh Data',
                      ),
                    ),
                  ],
                ),
              ),
              // List Jabatan atau Edit Form
              Expanded(
                child: Obx(
                  () => controller.isDataFound.value
                      ? _buildEditForm(controller)
                      : _buildJabatanList(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionIndicator({
    required String label,
    required bool hasPermission,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: hasPermission
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981).withOpacity(0.1),
                  const Color(0xFF059669).withOpacity(0.05),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6B7280).withOpacity(0.08),
                  const Color(0xFF4B5563).withOpacity(0.04),
                ],
              ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasPermission
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFF6B7280).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: hasPermission
            ? [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: hasPermission
                  ? const Color(0xFF10B981)
                  : const Color(0xFF6B7280),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              hasPermission ? Icons.check_rounded : Icons.close_rounded,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: hasPermission
                  ? const Color(0xFF065F46)
                  : const Color(0xFF4B5563),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 0.5),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJabatanList(EditJabatanController controller) {
    return Obx(() {
      if (controller.isLoadingList.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'Memuat data jabatan...',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        );
      }

      if (controller.jabatanList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_off_outlined, size: 64, color: Color(0xFF64748B)),
              const SizedBox(height: 16),
              Text(
                'Tidak ada data jabatan',
                style: TextStyle(fontSize: 18, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan jabatan baru terlebih dahulu',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Jabatan (${controller.jabatanList.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Text(
                  'Diurutkan A-Z',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List
          Expanded(
            child: RefreshIndicator(
              color: Colors.orange,
              onRefresh: controller.refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: controller.jabatanList.length,
                itemBuilder: (context, index) {
                  final jabatan = controller.jabatanList[index];
                  return _buildJabatanCard(jabatan, controller);
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildJabatanCard(
    Map<String, dynamic> jabatan,
    EditJabatanController controller,
  ) {
    final bool hasCutiPermission = jabatan['permissionCuti'] ?? false;
    final bool hasEksepsiPermission = jabatan['permissionEksepsi'] ?? false;
    final bool hasAllCutiPermission = jabatan['permissionAllCuti'] ?? false;
    final bool hasAllEksepsiPermission =
        jabatan['permissionAllEksepsi'] ?? false;
    final bool hasInsentifPermission = jabatan['permissionInsentif'] ?? false;
    final bool hasAllInsentifPermission =
        jabatan['permissionAllInsentif'] ?? false;
    final bool hasAtkPermission = jabatan['permissionAtk'] ?? false;
    final bool hasSuratKeluarPermission =
        jabatan['permissionSuratKeluar'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: () => controller.selectJabatan(jabatan),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama jabatan
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF667eea).withOpacity(0.8),
                            const Color(0xFF667eea).withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        jabatan['nama'] ?? 'Nama tidak tersedia',
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
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Color(0xFF667eea),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Permissions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF667eea).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF667eea).withOpacity(0.8),
                                  const Color(0xFF667eea).withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Permissions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A5568),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPermissionIndicator(
                            label: 'Cuti',
                            hasPermission: hasCutiPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Eksepsi',
                            hasPermission: hasEksepsiPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Semua Cuti',
                            hasPermission: hasAllCutiPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Semua Eksepsi',
                            hasPermission: hasAllEksepsiPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Insentif',
                            hasPermission: hasInsentifPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Semua Insentif',
                            hasPermission: hasAllInsentifPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'ATK',
                            hasPermission: hasAtkPermission,
                          ),
                          _buildPermissionIndicator(
                            label: 'Surat Keluar',
                            hasPermission: hasSuratKeluarPermission,
                          ),
                        ],
                      ),
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

  Widget _buildEditForm(EditJabatanController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: -2,
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.editJabatanFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF667eea).withOpacity(0.1),
                        const Color(0xFF764ba2).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF667eea).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667eea).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: controller.resetToList,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Jabatan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                controller.currentJabatanName.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF667eea),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Jabatan Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: controller.namaJabatanController,
                    validator: controller.validateNamaJabatan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Jabatan',
                      hintText: 'Masukkan nama jabatan baru',
                      hintStyle: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        color: const Color(0xFF667eea),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF667eea).withOpacity(0.8),
                              const Color(0xFF667eea).withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.work_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF667eea),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFEF4444),
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFEF4444),
                          width: 2,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 24),

                // Permissions Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF667eea).withOpacity(0.08),
                        const Color(0xFF764ba2).withOpacity(0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF667eea).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF667eea,
                                  ).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Hak Akses Jabatan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Permission Cuti
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Cuti',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola data cuti',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionCuti.value,
                            onChanged: (value) =>
                                controller.togglePermissionCuti(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission Eksepsi
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Eksepsi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola data eksepsi',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionEksepsi.value,
                            onChanged: (value) => controller
                                .togglePermissionEksepsi(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission All Cuti
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Semua Cuti',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola semua data cuti',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionAllCuti.value,
                            onChanged: (value) => controller
                                .togglePermissionAllCuti(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission All Eksepsi
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Semua Eksepsi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola semua data eksepsi',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionAllEksepsi.value,
                            onChanged: (value) => controller
                                .togglePermissionAllEksepsi(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission Insentif
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Insentif',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola data insentif',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionInsentif.value,
                            onChanged: (value) => controller
                                .togglePermissionInsentif(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission All Insentif
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Semua Insentif',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola semua data insentif',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionAllInsentif.value,
                            onChanged: (value) => controller
                                .togglePermissionAllInsentif(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission ATK
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission ATK',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola data ATK',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionAtk.value,
                            onChanged: (value) =>
                                controller.togglePermissionAtk(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Permission Surat Keluar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => CheckboxListTile(
                            title: const Text(
                              'Permission Surat Keluar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            subtitle: const Text(
                              'Akses untuk mengelola surat keluar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            value: controller.permissionSuratKeluar.value,
                            onChanged: (value) => controller
                                .togglePermissionSuratKeluar(value ?? false),
                            activeColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Update Button
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateJabatan,
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ).copyWith(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey.withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                }),
                          ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: controller.isLoading.value
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.withOpacity(0.5),
                                    Colors.grey.withOpacity(0.3),
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: controller.isLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Memperbarui...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'PERBARUI JABATAN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.resetToList,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        side: BorderSide(
                          color: const Color(0xFF6B7280).withOpacity(0.3),
                          width: 1.5,
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'BATAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                          color: const Color(0xFF6B7280),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
