import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_data_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';

class EditDataPage extends StatelessWidget {
  const EditDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditDataController());
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = tokens.homeGradient;
    final accent = accentGradient.first;
    final accentAlt = accentGradient.last;
    final overlayFactor = isDark ? 0.08 : 0.14;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: accentGradient
                .map((color) => color.withAlpha((overlayFactor * 255).round()))
                .toList(),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _HeaderCard(
                  tokens: tokens,
                  accentGradient: accentGradient,
                  theme: theme,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SearchField(
                  controller: controller,
                  tokens: tokens,
                  accent: accent,
                  theme: theme,
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Obx(() {
                    if (controller.isDataFound.value) {
                      return _EditForm(
                        controller: controller,
                        tokens: tokens,
                        theme: theme,
                        accent: accent,
                        accentAlt: accentAlt,
                      );
                    }

                    if (controller.isLoadingList.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      );
                    }

                    final list = controller.filteredPegawaiList;
                    if (list.isEmpty) {
                      return _EmptyState(tokens: tokens, accent: accent);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.section,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final pegawai = list[index];
                        return _PegawaiCard(
                          pegawai: pegawai,
                          controller: controller,
                          tokens: tokens,
                          accent: accent,
                          accentAlt: accentAlt,
                        );
                      },
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
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.tokens,
    required this.accentGradient,
    required this.theme,
  });

  final AppTokens tokens;
  final List<Color> accentGradient;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: accentGradient,
        ),
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
          _GlassIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Get.back(),
            theme: theme,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Data Pegawai',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ubah dan kelola data pegawai dengan cepat',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onPrimary.withAlpha(
                      (0.88 * 255).round(),
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _GlassIconButton(
            icon: Icons.home_rounded,
            onTap: () => Get.offAllNamed('/home'),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withAlpha((0.18 * 255).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onPrimary.withAlpha((0.28 * 255).round()),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.theme,
  });

  final EditDataController controller;
  final AppTokens tokens;
  final Color accent;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: 'Cari berdasarkan nama atau NRP',
        hintStyle: TextStyle(color: tokens.textSecondary, fontSize: 15),
        filled: true,
        fillColor: tokens.card,
        prefixIcon: Icon(Icons.search_rounded, color: accent, size: 22),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller.searchController,
          builder: (_, value, __) {
            if (value.text.trim().isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: controller.clearSearch,
              icon: Icon(Icons.clear_rounded, color: tokens.textSecondary),
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: tokens.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: tokens.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tokens, required this.accent});

  final AppTokens tokens;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: tokens.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tidak ditemukan hasil pencarian',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Periksa kembali kata kunci yang digunakan',
            style: TextStyle(fontSize: 13, color: tokens.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PegawaiCard extends StatelessWidget {
  const _PegawaiCard({
    required this.pegawai,
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.accentAlt,
  });

  final Map<String, dynamic> pegawai;
  final EditDataController controller;
  final AppTokens tokens;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    final nama = (pegawai['name'] ?? 'Nama tidak tersedia').toString();
    final nrp = (pegawai['nrp'] ?? '-').toString();
    final jabatan = (pegawai['jabatan'] ?? '-').toString();
    final status = pegawai['status']?.toString();

    return InkWell(
      onTap: () => controller.selectPegawai(pegawai),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tokens.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: tokens.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, accentAlt],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: tokens.shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'NRP: $nrp',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Jabatan: $jabatan',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.textSecondary,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.controller,
    required this.tokens,
    required this.theme,
    required this.accent,
    required this.accentAlt,
  });

  final EditDataController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Form(
        key: controller.editDataFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: _cardDecoration(tokens),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  _GlassIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: controller.resetToList,
                    theme: theme,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Data Pegawai',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Mengedit: ${controller.currentUserName.value}',
                            style: TextStyle(
                              fontSize: 14,
                              color: tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              decoration: _cardDecoration(tokens),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LabeledField(
                    label: 'Nama Lengkap',
                    tokens: tokens,
                    child: TextFormField(
                      controller: controller.nameController,
                      validator: controller.validateName,
                      decoration: _inputDecoration(
                        tokens: tokens,
                        theme: theme,
                        accent: accent,
                        hintText: 'Masukkan nama lengkap',
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'NRP (Tidak dapat diubah)',
                    tokens: tokens,
                    child: TextFormField(
                      controller: controller.nrpController,
                      enabled: false,
                      decoration: _disabledDecoration(
                        tokens,
                        theme,
                        Icons.badge_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'Jabatan',
                    tokens: tokens,
                    child: Obx(() {
                      final jabatanItems = controller.jabatanList;
                      final selected = controller.selectedJabatan.value;
                      final matches = jabatanItems
                          .where(
                            (jabatan) =>
                                (jabatan['nama'] ?? '').toString().trim() ==
                                (selected ?? ''),
                          )
                          .length;
                      return DropdownButtonFormField<String>(
                        value: matches == 1 ? selected : null,
                        validator: controller.validateJabatan,
                        decoration: _inputDecoration(
                          tokens: tokens,
                          theme: theme,
                          accent: accent,
                          hintText: controller.isLoadingJabatan.value
                              ? 'Memuat data jabatan...'
                              : 'Pilih jabatan',
                          icon: Icons.work_outline_rounded,
                        ),
                        items: jabatanItems
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: (item['nama'] ?? '').toString(),
                                child: Text((item['nama'] ?? '').toString()),
                              ),
                            )
                            .toList(),
                        onChanged: controller.isLoadingJabatan.value
                            ? null
                            : (value) {
                                if (value != null) {
                                  controller.selectedJabatan.value = value;
                                }
                              },
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'Status',
                    tokens: tokens,
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value,
                        validator: controller.validateStatus,
                        decoration: _inputDecoration(
                          tokens: tokens,
                          theme: theme,
                          accent: accent,
                          hintText: 'Pilih status',
                          icon: Icons.assignment_ind_outlined,
                        ),
                        items: controller.statusOptions
                            .map(
                              (status) => DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedStatus.value = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'Group',
                    tokens: tokens,
                    child: Obx(() {
                      final groups = controller.groupList;
                      return DropdownButtonFormField<String>(
                        value: controller.selectedGroup.value,
                        validator: controller.validateGroup,
                        decoration: _inputDecoration(
                          tokens: tokens,
                          theme: theme,
                          accent: accent,
                          hintText: controller.isLoadingGroup.value
                              ? 'Memuat data group...'
                              : 'Pilih group',
                          icon: Icons.group_outlined,
                        ),
                        items: groups
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: (item['nama'] ?? '').toString(),
                                child: Text((item['nama'] ?? '').toString()),
                              ),
                            )
                            .toList(),
                        onChanged: controller.isLoadingGroup.value
                            ? null
                            : (value) {
                                controller.selectedGroup.value = value;
                              },
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'Status Group',
                    tokens: tokens,
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedStatusGroup.value,
                        validator: controller.validateStatusGroup,
                        decoration: _inputDecoration(
                          tokens: tokens,
                          theme: theme,
                          accent: accent,
                          hintText: 'Pilih status group',
                          icon: Icons.account_tree_outlined,
                        ),
                        items: controller.statusGroupOptions
                            .map(
                              (statusGroup) => DropdownMenuItem<String>(
                                value: statusGroup,
                                child: Text(statusGroup),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedStatusGroup.value = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledField(
                    label: 'Password Baru (Opsional)',
                    subtitle: 'Kosongkan jika tidak ingin mengubah password',
                    tokens: tokens,
                    child: Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: _inputDecoration(
                          tokens: tokens,
                          theme: theme,
                          accent: accent,
                          hintText: 'Masukkan password baru',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: tokens.textSecondary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            Obx(() {
              final isBusy = controller.isLoading.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: isBusy ? null : controller.updatePegawai,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isBusy
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: isBusy ? null : controller.deletePegawai,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isBusy
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onError,
                              ),
                            ),
                          )
                        : const Text(
                            'Hapus Pegawai',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    required this.tokens,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final Widget child;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
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
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 12, color: tokens.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration({
  required AppTokens tokens,
  required ThemeData theme,
  required Color accent,
  required String hintText,
  IconData? icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: tokens.textSecondary),
    filled: true,
    fillColor: theme.inputDecorationTheme.fillColor ?? tokens.surface,
    prefixIcon: icon == null ? null : Icon(icon, color: accent),
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: tokens.borderSubtle),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: tokens.borderSubtle),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: accent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
    ),
  );
}

InputDecoration _disabledDecoration(
  AppTokens tokens,
  ThemeData theme,
  IconData icon,
) {
  return InputDecoration(
    filled: true,
    fillColor: tokens.surface,
    prefixIcon: Icon(icon, color: tokens.textSecondary),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: tokens.borderSubtle),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: tokens.borderSubtle),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: tokens.borderSubtle),
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
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
