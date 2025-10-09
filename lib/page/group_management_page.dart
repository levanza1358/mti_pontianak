import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/group_management_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';

class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupManagementController());
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _HeaderCard(
                      tokens: tokens,
                      theme: theme,
                      accentGradient: accentGradient,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _TabSelector(
                      controller: controller,
                      tokens: tokens,
                      accent: accent,
                      accentAlt: accentAlt,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      _AddGroupTab(
                        controller: controller,
                        tokens: tokens,
                        theme: theme,
                        accent: accent,
                        accentAlt: accentAlt,
                      ),
                      _EditGroupTab(
                        controller: controller,
                        tokens: tokens,
                        theme: theme,
                        accent: accent,
                        accentAlt: accentAlt,
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
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.tokens,
    required this.theme,
    required this.accentGradient,
  });

  final AppTokens tokens;
  final ThemeData theme;
  final List<Color> accentGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: accentGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                  'Manajemen Group',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Kelola daftar group dan lakukan pembaruan data',
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
        ],
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  const _TabSelector({
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.accentAlt,
  });

  final GroupManagementController controller;
  final AppTokens tokens;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tokens.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: tokens.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: controller.tabController,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: tokens.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, accentAlt],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            icon: Icon(Icons.add_circle_outline_rounded),
            text: 'Tambah Group',
          ),
          Tab(icon: Icon(Icons.edit_outlined), text: 'Edit Group'),
        ],
      ),
    );
  }
}

class _AddGroupTab extends StatelessWidget {
  const _AddGroupTab({
    required this.controller,
    required this.tokens,
    required this.theme,
    required this.accent,
    required this.accentAlt,
  });

  final GroupManagementController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Container(
        decoration: _cardDecoration(tokens),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.addGroupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _GradientIconContainer(
                    icon: Icons.group_add_rounded,
                    accent: accent,
                    accentAlt: accentAlt,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tambah Group Baru',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: tokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Isi nama group untuk menambahkan entri baru.',
                          style: TextStyle(
                            fontSize: 13,
                            color: tokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.section),
              _LabeledField(
                label: 'Nama Group',
                tokens: tokens,
                child: TextFormField(
                  controller: controller.addNamaGroupController,
                  validator: controller.validateNamaGroup,
                  decoration: _inputDecoration(
                    tokens: tokens,
                    theme: theme,
                    accent: accent,
                    hintText: 'Masukkan nama group',
                    icon: Icons.group_rounded,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              Obx(() {
                final isLoading = controller.isLoadingAdd.value;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : controller.submitAddForm,
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
                    child: isLoading
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
                            'Simpan Group',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditGroupTab extends StatelessWidget {
  const _EditGroupTab({
    required this.controller,
    required this.tokens,
    required this.theme,
    required this.accent,
    required this.accentAlt,
  });

  final GroupManagementController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showEditForm.value) {
        return _EditGroupForm(
          controller: controller,
          tokens: tokens,
          theme: theme,
          accent: accent,
          accentAlt: accentAlt,
        );
      }
      return _GroupListView(
        controller: controller,
        tokens: tokens,
        theme: theme,
        accent: accent,
        accentAlt: accentAlt,
      );
    });
  }
}

class _EditGroupForm extends StatelessWidget {
  const _EditGroupForm({
    required this.controller,
    required this.tokens,
    required this.theme,
    required this.accent,
    required this.accentAlt,
  });

  final GroupManagementController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Container(
        decoration: _cardDecoration(tokens),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.editGroupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _GradientIconContainer(
                    icon: Icons.edit_rounded,
                    accent: accent,
                    accentAlt: accentAlt,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Group',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Mengedit: ${controller.currentGroupName.value}',
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _MutedIconButton(
                    icon: Icons.close_rounded,
                    onTap: controller.resetToList,
                    tokens: tokens,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.section),
              _LabeledField(
                label: 'Nama Group',
                tokens: tokens,
                child: TextFormField(
                  controller: controller.editNamaGroupController,
                  validator: controller.validateNamaGroup,
                  decoration: _inputDecoration(
                    tokens: tokens,
                    theme: theme,
                    accent: accent,
                    hintText: 'Masukkan nama group',
                    icon: Icons.group_rounded,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              Obx(() {
                final isLoading = controller.isLoadingEdit.value;
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.resetToList,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: tokens.textSecondary,
                          side: BorderSide(color: tokens.borderSubtle),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : controller.updateGroup,
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
                        child: isLoading
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
                                'Update Group',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupListView extends StatelessWidget {
  const _GroupListView({
    required this.controller,
    required this.tokens,
    required this.theme,
    required this.accent,
    required this.accentAlt,
  });

  final GroupManagementController controller;
  final AppTokens tokens;
  final ThemeData theme;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: _cardDecoration(tokens),
          child: Row(
            children: [
              _GradientIconContainer(
                icon: Icons.group_work_outlined,
                accent: accent,
                accentAlt: accentAlt,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Group',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Pilih group untuk melakukan pengeditan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
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

            final list = controller.groupList;
            if (list.isEmpty) {
              return _EmptyState(
                tokens: tokens,
                accent: accent,
                message: 'Belum ada data group',
                description:
                    'Tambahkan group baru terlebih dahulu sebelum melakukan pengeditan.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: AppSpacing.section / 2),
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final group = list[index];
                return _GroupTile(
                  group: group,
                  controller: controller,
                  tokens: tokens,
                  accent: accent,
                  accentAlt: accentAlt,
                  theme: theme,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.controller,
    required this.tokens,
    required this.accent,
    required this.accentAlt,
    required this.theme,
  });

  final Map<String, dynamic> group;
  final GroupManagementController controller;
  final AppTokens tokens;
  final Color accent;
  final Color accentAlt;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final name = (group['nama'] ?? 'Tanpa nama').toString();
    final idValue = group['id'];

    return InkWell(
      onTap: () => controller.selectGroup(group),
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: _cardDecoration(tokens),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GradientIconContainer(
                icon: Icons.group_rounded,
                accent: accent,
                accentAlt: accentAlt,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'ID: $idValue',
                      style: TextStyle(
                        fontSize: 12,
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
                    onPressed: () => controller.selectGroup(group),
                    icon: Icon(Icons.edit_rounded, color: accent),
                    tooltip: 'Edit group',
                  ),
                  IconButton(
                    onPressed: () => controller.deleteGroup(group['id'], name),
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    tooltip: 'Hapus group',
                  ),
                ],
              ),
            ],
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

class _GradientIconContainer extends StatelessWidget {
  const _GradientIconContainer({
    required this.icon,
    required this.accent,
    required this.accentAlt,
  });

  final IconData icon;
  final Color accent;
  final Color accentAlt;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 24,
      ),
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
            style: TextStyle(fontSize: 13, color: tokens.textSecondary),
            textAlign: TextAlign.center,
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

class _MutedIconButton extends StatelessWidget {
  const _MutedIconButton({
    required this.icon,
    required this.onTap,
    required this.tokens,
  });

  final IconData icon;
  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: tokens.textSecondary),
      tooltip: 'Tutup',
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
    focusedErrorBorder: OutlineInputBorder(
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
