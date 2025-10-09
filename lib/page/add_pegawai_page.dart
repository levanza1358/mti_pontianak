import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_pegawai_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class AddPegawaiPage extends StatelessWidget {
  const AddPegawaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPegawaiController());
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
                  _buildHeader(theme, controller, accentGradient),
                  const SizedBox(height: AppSpacing.lg),
                  _buildInfoBanner(t, accent),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFormCard(theme, t, accent, controller),
                  const SizedBox(height: AppSpacing.section),
                  _buildSubmitButton(theme, t, accentGradient, accent, controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    AddPegawaiController controller,
    List<Color> accentGradient,
  ) {
    return Container(
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
            color: const Color(0x40000000),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, -2),
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
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onPrimary,
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
                  'Tambah Pegawai',
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
                  'Tambahkan data pegawai baru ke sistem',
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
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => controller.pickProfileImage(),
              icon: Icon(
                Icons.photo_camera,
                color: theme.colorScheme.onPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(AppTokens t, Color accent) {
    return Container(
      width: double.infinity,
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
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.info_outline, color: accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Pastikan data pegawai yang dimasukkan sudah benar dan lengkap.',
              style: TextStyle(fontSize: 14, color: t.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(
    ThemeData theme,
    AppTokens t,
    Color accent,
    AddPegawaiController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
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
        border: Border.all(color: t.borderSubtle, width: 1),
      ),
      child: Form(
        key: controller.pegawaiFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabeledField(
              t,
              'Nama Lengkap',
              TextFormField(
                controller: controller.nameController,
                decoration: _inputDecoration(
                  theme,
                  t,
                  accent,
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline_rounded,
                ),
                validator: controller.validateName,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'NRP',
              TextFormField(
                controller: controller.nrpController,
                decoration: _inputDecoration(
                  theme,
                  t,
                  accent,
                  hint: 'Masukkan NRP',
                  icon: Icons.badge_outlined,
                ),
                validator: controller.validateNrp,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'Password',
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: _inputDecoration(
                    theme,
                    t,
                    accent,
                    hint: 'Masukkan password',
                    icon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: accent,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                  validator: controller.validatePassword,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'Jabatan',
              Obx(
                () {
                  final items = controller.jabatanList
                      .map((jabatan) {
                        final label = (jabatan['nama'] ?? '').toString();
                        return DropdownMenuItem<String>(
                          value: label,
                          child: Text(label.isEmpty ? '-' : label),
                        );
                      })
                      .toList();
                  return DropdownButtonFormField<String>(
                    value: controller.selectedJabatan.value,
                    decoration: _inputDecoration(
                      theme,
                      t,
                      accent,
                      hint: 'Pilih jabatan',
                      icon: Icons.work_outline_rounded,
                    ),
                    isExpanded: true,
                    items: items,
                    onChanged: (value) => controller.selectedJabatan.value = value,
                    validator: controller.validateJabatan,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'Status',
              DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
                decoration: _inputDecoration(
                  theme,
                  t,
                  accent,
                  hint: 'Pilih status',
                  icon: Icons.assignment_turned_in_outlined,
                ),
                isExpanded: true,
                items: controller.statusOptions
                    .map((status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => controller.selectedStatus.value = value,
                validator: controller.validateStatus,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'Group',
              Obx(() {
                if (controller.isLoadingGroup.value) {
                  return _buildLoadingField(
                    t,
                    accent,
                    Icons.group_outlined,
                    'Memuat data group...',
                  );
                }
                final items = controller.groupList
                    .map((group) {
                      final label = (group['nama'] ?? '').toString();
                      return DropdownMenuItem<String>(
                        value: label,
                        child: Text(label.isEmpty ? '-' : label),
                      );
                    })
                    .toList();
                return DropdownButtonFormField<String>(
                  value: controller.selectedGroup.value,
                  decoration: _inputDecoration(
                    theme,
                    t,
                    accent,
                    hint: 'Pilih group',
                    icon: Icons.group_outlined,
                  ),
                  isExpanded: true,
                  items: items,
                  onChanged: (value) => controller.selectedGroup.value = value,
                  validator: controller.validateGroup,
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLabeledField(
              t,
              'Status Group',
              DropdownButtonFormField<String>(
                value: controller.selectedStatusGroup.value,
                decoration: _inputDecoration(
                  theme,
                  t,
                  accent,
                  hint: 'Pilih status group',
                  icon: Icons.admin_panel_settings_outlined,
                ),
                isExpanded: true,
                items: controller.statusGroupOptions
                    .map((statusGroup) => DropdownMenuItem<String>(
                          value: statusGroup,
                          child: Text(statusGroup),
                        ))
                    .toList(),
                onChanged: (value) => controller.selectedStatusGroup.value = value,
                validator: controller.validateStatusGroup,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    ThemeData theme,
    AppTokens t,
    List<Color> accentGradient,
    Color accent,
    AddPegawaiController controller,
  ) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: controller.isLoading.value
              ? LinearGradient(
                  colors: [
                    t.textSecondary.withOpacity(0.4),
                    t.textSecondary.withOpacity(0.6),
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
          onPressed:
              controller.isLoading.value ? null : controller.submitPegawaiForm,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      color: theme.colorScheme.onPrimary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Text(
                      'TAMBAH PEGAWAI',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    ThemeData theme,
    AppTokens t,
    Color accent, {
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: t.textSecondary, fontSize: 16),
      filled: true,
      fillColor: theme.inputDecorationTheme.fillColor ?? t.surface,
      prefixIcon: Icon(icon, color: accent, size: 22),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: t.borderSubtle, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: t.borderSubtle, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  Widget _buildLabeledField(AppTokens t, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: t.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  Widget _buildLoadingField(
    AppTokens t,
    Color accent,
    IconData icon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSubtle, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: t.textSecondary),
          ),
        ],
      ),
    );
  }
}
