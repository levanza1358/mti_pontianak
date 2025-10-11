// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_jabatan_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';

class EditJabatanPage extends StatelessWidget {
  const EditJabatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditJabatanController());
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = tokens.updateGradient;
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
                  controller: controller,
                  tokens: tokens,
                  accentGradient: accentGradient,
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
                    return _JabatanList(
                      controller: controller,
                      tokens: tokens,
                      accent: accent,
                      accentAlt: accentAlt,
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
    required this.controller,
    required this.tokens,
    required this.accentGradient,
    required this.theme,
  });

  final EditJabatanController controller;
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
                  'Edit Data Jabatan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Pilih jabatan lalu ubah hak aksesnya',
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
            icon: Icons.refresh_rounded,
            onTap: controller.refreshData,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _JabatanList extends StatelessWidget {
  const _JabatanList({
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.accentAlt,
  });

  final EditJabatanController controller;
  final AppTokens tokens;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingList.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        );
      }

      final list = controller.jabatanList;
      if (list.isEmpty) {
        return _EmptyState(
          tokens: tokens,
          accent: accent,
          message: 'Belum ada data jabatan',
          description: 'Tambahkan jabatan baru sebelum melakukan pengeditan.',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: AppSpacing.section),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final jabatan = list[index];
          return _JabatanCard(
            jabatan: jabatan,
            controller: controller,
            tokens: tokens,
            accent: accent,
            accentAlt: accentAlt,
          );
        },
      );
    });
  }
}

class _JabatanCard extends StatelessWidget {
  const _JabatanCard({
    required this.jabatan,
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.accentAlt,
  });

  final Map<String, dynamic> jabatan;
  final EditJabatanController controller;
  final AppTokens tokens;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    final nama = (jabatan['nama'] ?? 'Nama tidak tersedia').toString();

    final permissions = <_PermissionInfo>[
      _PermissionInfo('Cuti', jabatan['permissionCuti'] ?? false),
      _PermissionInfo('Eksepsi', jabatan['permissionEksepsi'] ?? false),
      _PermissionInfo('Semua Cuti', jabatan['permissionAllCuti'] ?? false),
      _PermissionInfo(
        'Semua Eksepsi',
        jabatan['permissionAllEksepsi'] ?? false,
      ),
      _PermissionInfo('Insentif', jabatan['permissionInsentif'] ?? false),
      _PermissionInfo(
        'Semua Insentif',
        jabatan['permissionAllInsentif'] ?? false,
      ),
      _PermissionInfo('ATK', jabatan['permissionAtk'] ?? false),
      _PermissionInfo(
        'Surat Keluar',
        jabatan['permissionSuratKeluar'] ?? false,
      ),
      _PermissionInfo(
        'Management Data',
        jabatan['permissionManagementData'] ?? false,
      ),
    ];

    return InkWell(
      onTap: () => controller.selectJabatan(jabatan),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
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
                          'Ketuk untuk mengedit hak akses jabatan ini',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: tokens.textMuted),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: permissions
                    .map(
                      (permission) => _PermissionBadge(
                        info: permission,
                        accent: accent,
                        tokens: tokens,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionInfo {
  const _PermissionInfo(this.label, this.enabled);

  final String label;
  final bool enabled;
}

class _PermissionBadge extends StatelessWidget {
  const _PermissionBadge({
    required this.info,
    required this.accent,
    required this.tokens,
  });

  final _PermissionInfo info;
  final Color accent;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final background =
        info.enabled ? accent.withAlpha((0.18 * 255).round()) : tokens.surface;
    final borderColor = info.enabled
        ? accent.withAlpha((0.38 * 255).round())
        : tokens.borderSubtle;
    final icon = info.enabled ? Icons.check_rounded : Icons.close_rounded;
    final iconColor = info.enabled ? accent : tokens.textMuted;
    final textColor = info.enabled ? accent : tokens.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            info.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
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

  final EditJabatanController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Form(
        key: controller.editJabatanFormKey,
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
                            'Edit Jabatan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Mengedit: ${controller.currentJabatanName.value}',
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
                    label: 'Nama Jabatan',
                    tokens: tokens,
                    child: TextFormField(
                      controller: controller.namaJabatanController,
                      validator: controller.validateNamaJabatan,
                      decoration: _inputDecoration(
                        tokens: tokens,
                        theme: theme,
                        accent: accent,
                        hintText: 'Masukkan nama jabatan',
                        icon: Icons.workspace_premium_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  Text(
                    'Hak Akses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Aktifkan hak akses yang dimiliki oleh jabatan ini.',
                    style: TextStyle(fontSize: 13, color: tokens.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PermissionToggle(
                    title: 'Pengajuan Cuti',
                    subtitle: 'Akses untuk fitur cuti pribadi',
                    value: controller.permissionCuti,
                    onChanged: controller.togglePermissionCuti,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Pengajuan Eksepsi',
                    subtitle: 'Akses untuk fitur eksepsi pribadi',
                    value: controller.permissionEksepsi,
                    onChanged: controller.togglePermissionEksepsi,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Semua Data Cuti',
                    subtitle: 'Mengelola data cuti seluruh pegawai',
                    value: controller.permissionAllCuti,
                    onChanged: controller.togglePermissionAllCuti,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Semua Data Eksepsi',
                    subtitle: 'Mengelola data eksepsi seluruh pegawai',
                    value: controller.permissionAllEksepsi,
                    onChanged: controller.togglePermissionAllEksepsi,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Data Insentif',
                    subtitle: 'Akses modul insentif dan verifikasinya',
                    value: controller.permissionInsentif,
                    onChanged: controller.togglePermissionInsentif,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Semua Data Insentif',
                    subtitle: 'Mengelola seluruh data insentif',
                    value: controller.permissionAllInsentif,
                    onChanged: controller.togglePermissionAllInsentif,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'ATK',
                    subtitle: 'Akses modul data ATK',
                    value: controller.permissionAtk,
                    onChanged: controller.togglePermissionAtk,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Surat Keluar',
                    subtitle: 'Pengelolaan surat keluar organisasi',
                    value: controller.permissionSuratKeluar,
                    onChanged: controller.togglePermissionSuratKeluar,
                    tokens: tokens,
                    accent: accent,
                  ),
                  _PermissionToggle(
                    title: 'Management Data',
                    subtitle: 'Akses halaman manajemen data pegawai',
                    value: controller.permissionManagementData,
                    onChanged: controller.togglePermissionManagementData,
                    tokens: tokens,
                    accent: accent,
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
                    onPressed: isBusy ? null : controller.updateJabatan,
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
                    onPressed: isBusy ? null : controller.deleteJabatan,
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
                            'Hapus Jabatan',
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

class _PermissionToggle extends StatelessWidget {
  const _PermissionToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.tokens,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final RxBool value;
  final ValueChanged<bool> onChanged;
  final AppTokens tokens;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.borderSubtle),
        ),
        child: SwitchListTile.adaptive(
          value: value.value,
          onChanged: onChanged,
          activeColor: accent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: tokens.textSecondary),
          ),
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
  });

  final String label;
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
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.tokens,
    required this.accent,
    required this.message,
    required this.description,
  });

  final AppTokens tokens;
  final Color accent;
  final String message;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: tokens.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: tokens.textSecondary),
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

InputDecoration _inputDecoration({
  required AppTokens tokens,
  required ThemeData theme,
  required Color accent,
  required String hintText,
  IconData? icon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: tokens.textSecondary),
    filled: true,
    fillColor: theme.inputDecorationTheme.fillColor ?? tokens.surface,
    prefixIcon: icon == null ? null : Icon(icon, color: accent),
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
