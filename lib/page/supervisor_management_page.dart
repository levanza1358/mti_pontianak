import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/supervisor_management_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';

class SupervisorManagementPage extends StatelessWidget {
  const SupervisorManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupervisorManagementController());
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = tokens.insentifGradient;
    final accent = accentGradient.first;
    final accentAlt = accentGradient.last;

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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _buildHeaderCard(
                  theme: theme,
                  tokens: tokens,
                  accentGradient: accentGradient,
                  onRefresh: controller.refreshData,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildTabSelector(
                  controller: controller,
                  theme: theme,
                  tokens: tokens,
                  accent: accent,
                  accentAlt: accentAlt,
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Obx(() {
                    final selected = controller.selectedTab.value;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: selected == 0
                          ? _buildAddSupervisorTab(
                              key: const ValueKey('add-tab'),
                              controller: controller,
                              theme: theme,
                              tokens: tokens,
                              accent: accent,
                              accentAlt: accentAlt,
                            )
                          : _buildEditSupervisorTab(
                              key: const ValueKey('edit-tab'),
                              controller: controller,
                              theme: theme,
                              tokens: tokens,
                              accent: accent,
                              accentAlt: accentAlt,
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard({
    required ThemeData theme,
    required AppTokens tokens,
    required List<Color> accentGradient,
    required VoidCallback onRefresh,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: accentGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tokens.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.28),
              ),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manajemen Supervisor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tambah dan kelola supervisor dengan mudah.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.28),
              ),
            ),
            child: IconButton(
              onPressed: onRefresh,
              icon: Icon(
                Icons.refresh_rounded,
                color: theme.colorScheme.onPrimary,
              ),
              tooltip: 'Muat ulang data',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector({
    required SupervisorManagementController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
  }) {
    return Obx(() {
      final selected = controller.selectedTab.value;
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: tokens.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: tokens.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _TabButton(
              label: 'Tambah Supervisor',
              index: 0,
              isSelected: selected == 0,
              onTap: () => controller.selectedTab.value = 0,
              accent: accent,
              accentAlt: accentAlt,
              theme: theme,
              tokens: tokens,
            ),
            _TabButton(
              label: 'Edit Supervisor',
              index: 1,
              isSelected: selected == 1,
              onTap: () => controller.selectedTab.value = 1,
              accent: accent,
              accentAlt: accentAlt,
              theme: theme,
              tokens: tokens,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddSupervisorTab({
    required Key key,
    required SupervisorManagementController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
  }) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: _cardDecoration(tokens),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Supervisor Baru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Isi detail di bawah untuk menambahkan supervisor ke sistem.',
              style: TextStyle(fontSize: 14, color: tokens.textSecondary),
            ),
            const SizedBox(height: AppSpacing.section),
            _buildFormField(
              label: 'Nama Supervisor',
              controller: controller.namaSupervisorController,
              hint: 'Masukkan nama supervisor',
              theme: theme,
              tokens: tokens,
              accent: accent,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildFormField(
              label: 'Jabatan Supervisor',
              controller: controller.jabatanSupervisorController,
              hint: 'Masukkan jabatan supervisor',
              theme: theme,
              tokens: tokens,
              accent: accent,
              icon: Icons.work_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDropdownField(
              label: 'Jenis Supervisor',
              hint: 'Pilih jenis supervisor',
              selectedValue: controller.selectedJenisSupervisor,
              options: controller.jenisSupervisorList,
              onChanged: (value) =>
                  controller.selectedJenisSupervisor.value = value,
              theme: theme,
              tokens: tokens,
              accent: accent,
            ),
            const SizedBox(height: AppSpacing.section),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                return ElevatedButton(
                  onPressed: isLoading ? null : controller.addSupervisor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : const Text(
                          'Tambah Supervisor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditSupervisorTab({
    required Key key,
    required SupervisorManagementController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
  }) {
    return Obx(() {
      if (controller.showEditForm.value) {
        return _buildEditForm(
          key: key,
          controller: controller,
          theme: theme,
          tokens: tokens,
          accent: accent,
          accentAlt: accentAlt,
        );
      }
      return _buildSupervisorList(
        key: key,
        controller: controller,
        theme: theme,
        tokens: tokens,
        accent: accent,
      );
    });
  }

  Widget _buildEditForm({
    required Key key,
    required SupervisorManagementController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
  }) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: _cardDecoration(tokens),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.showEditForm.value = false,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back_rounded, color: accent),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Obx(
                    () => Text(
                      'Edit Supervisor: ${controller.currentSupervisorName.value}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.section),
            _buildFormField(
              label: 'Nama Supervisor',
              controller: controller.editNamaSupervisorController,
              hint: 'Masukkan nama supervisor',
              theme: theme,
              tokens: tokens,
              accent: accent,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildFormField(
              label: 'Jabatan Supervisor',
              controller: controller.editJabatanSupervisorController,
              hint: 'Masukkan jabatan supervisor',
              theme: theme,
              tokens: tokens,
              accent: accent,
              icon: Icons.work_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDropdownField(
              label: 'Jenis Supervisor',
              hint: 'Pilih jenis supervisor',
              selectedValue: controller.selectedEditJenisSupervisor,
              options: controller.jenisSupervisorList,
              onChanged: (value) =>
                  controller.selectedEditJenisSupervisor.value = value,
              theme: theme,
              tokens: tokens,
              accent: accent,
            ),
            const SizedBox(height: AppSpacing.section),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                final isLoading = controller.isLoadingEdit.value;
                return ElevatedButton(
                  onPressed: isLoading ? null : controller.updateSupervisor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentAlt,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : const Text(
                          'Update Supervisor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupervisorList({
    required Key key,
    required SupervisorManagementController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
  }) {
    return Column(
      key: key,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: tokens.shadowColor,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Supervisor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              IconButton(
                onPressed: controller.refreshData,
                icon: Icon(Icons.refresh_rounded, color: accent),
                tooltip: 'Muat ulang data',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingList.value) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              );
            }

            if (controller.supervisorList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_off_outlined,
                      size: 48,
                      color: tokens.textMuted,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Belum ada data supervisor',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tambahkan supervisor untuk mulai mengelola tim.',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.section / 2),
              itemCount: controller.supervisorList.length,
              itemBuilder: (context, index) {
                final supervisor = controller.supervisorList[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index == controller.supervisorList.length - 1
                        ? 0
                        : AppSpacing.md,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: tokens.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: tokens.borderSubtle),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supervisor['nama'] ?? 'Nama tidak tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: tokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Jabatan: ${supervisor['jabatan'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: tokens.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Jenis: ${supervisor['jenis'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: tokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                controller.selectSupervisor(supervisor),
                            icon: Icon(Icons.edit_outlined, color: accent),
                            tooltip: 'Edit supervisor',
                          ),
                          IconButton(
                            onPressed: () {
                              final id = supervisor['id'];
                              if (id != null) {
                                controller.deleteSupervisor(id);
                              }
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            tooltip: 'Hapus supervisor',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(
            theme: theme,
            tokens: tokens,
            accent: accent,
            hint: hint,
            icon: icon,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required RxString selectedValue,
    required List<String> options,
    required void Function(String value) onChanged,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Obx(() {
          final value = selectedValue.value.isEmpty
              ? null
              : selectedValue.value;
          return DropdownButtonFormField<String>(
            value: value,
            decoration: _inputDecoration(
              theme: theme,
              tokens: tokens,
              accent: accent,
              hint: hint,
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: accent),
            dropdownColor: tokens.card,
            items: options
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(color: tokens.textPrimary),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          );
        }),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: tokens.textSecondary),
      filled: true,
      fillColor: theme.inputDecorationTheme.fillColor ?? tokens.surface,
      prefixIcon: icon == null ? null : Icon(icon, color: accent),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: tokens.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: tokens.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 2),
      ),
    );
  }

  BoxDecoration _cardDecoration(AppTokens tokens) {
    return BoxDecoration(
      color: tokens.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tokens.borderSubtle),
      boxShadow: [
        BoxShadow(
          color: tokens.shadowColor,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.accentAlt,
    required this.theme,
    required this.tokens,
  });

  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accent;
  final Color accentAlt;
  final ThemeData theme;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [accent, accentAlt],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : tokens.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : tokens.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
