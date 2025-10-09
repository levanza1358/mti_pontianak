import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_jabatan_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class AddJabatanPage extends StatelessWidget {
  const AddJabatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddJabatanController controller = Get.put(AddJabatanController());
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
                        colors: accentGradient,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: t.shadowColor,
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
                            color: theme.colorScheme.onPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.onPrimary.withOpacity(0.3),
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
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tambah Jabatan',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Tambahkan jabatan baru ke sistem',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
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

                  const SizedBox(height: AppSpacing.lg),

                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: t.shadowColor,
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: t.borderSubtle,
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
                                  color: t.textPrimary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextFormField(
                                controller: controller.namaJabatanController,
                                validator: controller.validateNamaJabatan,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan nama jabatan',
                                  hintStyle: TextStyle(
                                    color: t.textSecondary,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: theme.inputDecorationTheme.fillColor,
                                  prefixIcon: Icon(
                                    Icons.work_outline_rounded,
                                    color: accent,
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: t.borderSubtle,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: t.borderSubtle,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: accent,
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

                              const SizedBox(height: AppSpacing.section),

                              // Permissions Section
                              Text(
                                'Hak Akses',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: t.textPrimary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Simple Permissions Container
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: t.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: t.borderSubtle,
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
                                        color: t.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.lg),

                                    // Simple checkbox rows
                                    Obx(
                                      () => _buildSimpleCheckbox(
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                                        t,
                                        accent,
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
                              const SizedBox(height: AppSpacing.section),

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
                                        : LinearGradient(
                                            colors: accentGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: controller.isLoading.value
                                        ? [
                                            BoxShadow(
                                              color: t.textSecondary.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: t.shadowColor,
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.08),
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
                                      foregroundColor: theme.colorScheme.onPrimary,
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
                                                      AlwaysStoppedAnimation<Color>(
                                                    t.textSecondary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: AppSpacing.md),
                                              Text(
                                                'Menyimpan...',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: t.textSecondary,
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
                                              const SizedBox(width: AppSpacing.md),
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
    AppTokens t,
    Color accent,
    String title,
    bool value,
    ValueChanged<bool?> onChanged, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: accent,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: t.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
