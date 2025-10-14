// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mti_pontianak/controller/semua_insentif_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class SemuaInsentifPage extends GetView<SemuaInsentifController> {
  const SemuaInsentifPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SemuaInsentifController());
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final primaryGradient = t.insentifGradient;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: primaryGradient
                .map((c) => c.withOpacity(isDark ? 0.08 : 0.14))
                .toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: t.shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -10,
                      child: Container(
                        width: 180,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -20,
                      child: Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Back
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.25)),
                                ),
                                child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Title
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Semua Data Insentif',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Insentif Premi & Lembur (Tanpa Filter User)',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: AppSpacing.md),

                              // === NEW: Navigator Bulan <  September 2025  > ===
                              Obx(() {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.25)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Prev month
                                      _circleIconButton(
                                        icon: Icons.chevron_left,
                                        onTap: controller.prevMonth,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      // Label month-year
                                      Text(
                                        controller.monthYearLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      // Next month
                                      _circleIconButton(
                                        icon: Icons.chevron_right,
                                        onTap: controller.nextMonth,
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const SizedBox(width: AppSpacing.md),

                              // Tahun dropdown (tetap ada)
                              Obx(() {
                                final years = controller.availableYears.toList()
                                  ..sort((a, b) => b.compareTo(a));
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.xs),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.25)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: Colors.white70, size: 16),
                                      const SizedBox(width: AppSpacing.sm),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: controller.selectedYear.value,
                                          dropdownColor: t.card,
                                          icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                          items: years
                                              .map((y) => DropdownMenuItem<int>(
                                                  value: y, child: Text('$y')))
                                              .toList(),
                                          onChanged: (v) {
                                            if (v != null) {
                                              controller.changeYear(v);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const SizedBox(width: AppSpacing.md),

                              // Upload
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.25)),
                                ),
                                child: IconButton(
                                  tooltip: 'Upload Excel',
                                  onPressed: () => _showUploadSheet(context),
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // TabBar
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: controller.tabController,
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: primaryGradient.first,
                              unselectedLabelColor:
                                  Colors.white.withOpacity(0.85),
                              labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                              tabs: const [
                                Tab(text: 'Insentif Premi'),
                                Tab(text: 'Insentif Lembur'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [_buildPremiTab(theme), _buildLemburTab(theme)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tombol bulat kecil untuk navigasi bulan
  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.28)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  void _showUploadSheet(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final months = List<int>.generate(12, (i) => i + 1);
    String jenis = 'Premi';
    int tahun = controller.selectedYear.value;
    int bulan = controller.selectedMonth.value; // default bulan terpilih

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          final years = controller.availableYears.toList()
            ..sort((a, b) => b.compareTo(a));
          if (!years.contains(tahun)) years.insert(0, tahun);
          return Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.upload_file),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Upload Data Insentif dari Excel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Jenis
                Row(
                  children: [
                    const Text('Jenis'),
                    const SizedBox(width: AppSpacing.md),
                    DropdownButton<String>(
                      value: jenis,
                      items: const [
                        DropdownMenuItem(value: 'Premi', child: Text('Premi')),
                        DropdownMenuItem(
                            value: 'Lembur', child: Text('Lembur')),
                      ],
                      onChanged: (v) => setState(() => jenis = v ?? 'Premi'),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Tahun
                Row(
                  children: [
                    const Text('Tahun'),
                    const SizedBox(width: AppSpacing.md),
                    DropdownButton<int>(
                      value: tahun,
                      items: years
                          .map((y) => DropdownMenuItem<int>(
                                value: y,
                                child: Text('$y'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => tahun = v ?? tahun),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Bulan
                Row(
                  children: [
                    const Text('Bulan'),
                    const SizedBox(width: AppSpacing.md),
                    DropdownButton<int>(
                      value: bulan,
                      items: months
                          .map((m) => DropdownMenuItem<int>(
                                value: m,
                                child: Text(DateFormat('MMMM', 'id_ID')
                                    .format(DateTime(2000, m, 1))),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => bulan = v ?? bulan),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.insentifGradient.first,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                        horizontal: AppSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await controller.pickAndImportExcel(
                        jenis: jenis,
                        tahun: tahun,
                        bulan: bulan,
                        context: ctx,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Pilih File & Upload'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildPremiTab(ThemeData theme) {
    final t = theme.extension<AppTokens>()!;
    final accent = t.insentifGradient.first;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final total = controller.filteredPremiList.fold<int>(
        0,
        (sum, item) => sum + ((item['nominal'] ?? 0) as int),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: t.insentifGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Insentif Premi (${controller.monthYearLabel})',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    controller.formatCurrency(total),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${controller.filteredPremiList.length} Data',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // List Insentif Premi
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredPremiList.length,
              itemBuilder: (context, index) {
                final insentif = controller.filteredPremiList[index];
                return _insentifItemCard(
                  insentif: insentif,
                  index: index,
                  theme: theme,
                  t: t,
                  accent: accent,
                  typeLabel: 'Premi',
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLemburTab(ThemeData theme) {
    final t = theme.extension<AppTokens>()!;
    final accent = t.insentifGradient.first;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final total = controller.filteredLemburList.fold<int>(
        0,
        (sum, item) => sum + ((item['nominal'] ?? 0) as int),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: t.insentifGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Insentif Lembur (${controller.monthYearLabel})',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    controller.formatCurrency(total),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${controller.filteredLemburList.length} Data',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // List Insentif Lembur
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredLemburList.length,
              itemBuilder: (context, index) {
                final insentif = controller.filteredLemburList[index];
                return _insentifItemCard(
                  insentif: insentif,
                  index: index,
                  theme: theme,
                  t: t,
                  accent: accent,
                  typeLabel: 'Lembur',
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _insentifItemCard({
    required Map<String, dynamic> insentif,
    required int index,
    required ThemeData theme,
    required AppTokens t,
    required Color accent,
    String? typeLabel,
  }) {
    final accentAlt = t.insentifGradient.last;

    final String monthText = (() {
      final v = insentif['bulan'];
      if (v is String && v.isNotEmpty) {
        try {
          final dt = DateTime.parse(v);
          return '${dt.month}';
        } catch (_) {}
      }
      return '${index + 1}';
    })();

    final String monthLabel = (() {
      final v = insentif['bulan'];
      if (v is String && v.isNotEmpty) {
        try {
          final dt = DateTime.parse(v);
          return DateFormat('MMMM yyyy', 'id_ID').format(dt);
        } catch (_) {}
      }
      return '-';
    })();

    final int nominal = (insentif['nominal'] ?? 0) as int;

    return Card(
      elevation: 0,
      color: t.card,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        side: BorderSide(color: t.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.15),
                        accentAlt.withOpacity(0.15)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accent.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    monthText,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insentif['nama'] ?? '-',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: t.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Text(
                            'NRP: ${insentif['nrp'] ?? '-'}',
                            style: TextStyle(color: t.textSecondary),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          if (typeLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: t.chipBg,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: t.borderSubtle),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                    color: t.chipFg,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    border: Border.all(color: accent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    controller.formatCurrency(nominal),
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  tooltip: 'Hapus data',
                  icon: Icon(Icons.delete_outline_rounded,
                      color: t.textSecondary),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: Get.context!,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: const Text(
                              'Apakah Anda yakin ingin menghapus data ini?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Batal')),
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Hapus')),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      final jenis = typeLabel ?? '';
                      await Get.find<SemuaInsentifController>()
                          .deleteInsentifItem(
                        item: insentif,
                        jenis: jenis,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: t.chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: t.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month, size: 14),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        monthLabel,
                        style: TextStyle(
                          color: t.chipFg,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
