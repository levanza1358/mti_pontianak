import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_jabatan_controller.dart';

class AddJabatanPage extends StatelessWidget {
  const AddJabatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddJabatanController controller = Get.put(AddJabatanController());

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF667eea),
                          const Color(0xFF764ba2),
                        ],
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
                                'Tambah Jabatan',
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
                                'Tambahkan jabatan baru ke sistem',
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: -2,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Section
                        Form(
                          key: controller.jabatanFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Jabatan Field
                              Text(
                                'Nama Jabatan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.namaJabatanController,
                                validator: controller.validateNamaJabatan,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan nama jabatan',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(
                                    Icons.work_outline_rounded,
                                    color: const Color(0xFF667eea),
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF667eea),
                                      width: 2.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                              ),

                              const SizedBox(height: 24),

                              // Permissions Section
                              Text(
                                'Hak Akses',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Simple Permissions Container
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pilih hak akses yang diinginkan:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Simple checkbox rows
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Cuti',
                                        controller.permissionCuti.value,
                                        (value) =>
                                            controller.togglePermissionCuti(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Eksepsi',
                                        controller.permissionEksepsi.value,
                                        (value) =>
                                            controller.togglePermissionEksepsi(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Semua Cuti',
                                        controller.permissionAllCuti.value,
                                        (value) =>
                                            controller.togglePermissionAllCuti(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Semua Eksepsi',
                                        controller.permissionAllEksepsi.value,
                                        (value) => controller
                                            .togglePermissionAllEksepsi(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Insentif',
                                        controller.permissionInsentif.value,
                                        (value) =>
                                            controller.togglePermissionInsentif(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Semua Insentif',
                                        controller.permissionAllInsentif.value,
                                        (value) => controller
                                            .togglePermissionAllInsentif(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission ATK',
                                        controller.permissionAtk.value,
                                        (value) =>
                                            controller.togglePermissionAtk(
                                              value ?? false,
                                            ),
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Surat Keluar',
                                        controller.permissionSuratKeluar.value,
                                        (value) => controller
                                            .togglePermissionSuratKeluar(
                                              value ?? false,
                                            ),
                                        isLast: false,
                                      ),
                                    ),
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        'Permission Management Data',
                                        controller.permissionManagementData.value,
                                        (value) => controller
                                            .togglePermissionManagementData(
                                              value ?? false,
                                            ),
                                        isLast: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Submit Button
                              Obx(
                                () => Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: controller.isLoading.value
                                        ? LinearGradient(
                                            colors: [
                                              Colors.grey.shade400,
                                              Colors.grey.shade500,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: controller.isLoading.value
                                        ? [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF667eea,
                                              ).withOpacity(0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 2,
                                              offset: const Offset(0, -2),
                                            ),
                                          ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.submitJabatanForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: controller.isLoading.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.grey.shade600),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Menyimpan...',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.work_outline_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'TAMBAH JABATAN',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  letterSpacing: 1.2,
                                                  shadows: [
                                                    Shadow(
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                      blurRadius: 2,
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildSimpleCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF667eea),
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
