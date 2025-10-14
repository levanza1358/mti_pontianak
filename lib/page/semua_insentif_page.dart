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

      // ===== Floating Upload Button (pilih Premi / Lembur) =====
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton.extended(
          onPressed: () => _showUploadTypeChooser(ctx),
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload'),
        ),
      ),

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
              // ========== HEADER ==========
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
                      offset: const Offset(0, 6),
                    ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Back
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Title
                              const Expanded(child: _HeaderTitle()),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // ===== TabBar (tetap di header) =====
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
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              tabs: const [
                                Tab(text: 'Insentif Premi'),
                                Tab(text: 'Insentif Lembur'),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // ===== Navigator Bulan & Tahun (DIPINDAH ke bawah tab) =====
                          Obx(() {
                            final years = controller.availableYears.toList()
                              ..sort((a, b) => b.compareTo(a));
                            return Row(
                              children: [
                                Expanded(
                                  child: _MonthNav(
                                    label: controller.monthYearLabel,
                                    onPrev: controller.prevMonth,
                                    onNext: controller.nextMonth,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                _YearDropdown(
                                  years: years,
                                  value: controller.selectedYear.value,
                                  onChanged: controller.changeYear,
                                  dropdownBg: t.card,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // ===== Konten utama: Expanded untuk cegah overflow =====
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TabBarView(
                    controller: controller.tabController,
                    children: [
                      _InsentifTab(
                        title: 'Total Insentif Premi',
                        monthLabel: controller.monthYearLabel,
                        total: controller.totalPremiForFilter,
                        items: controller.filteredPremiList,
                        typeLabel: 'Premi',
                      ),
                      _InsentifTab(
                        title: 'Total Insentif Lembur',
                        monthLabel: controller.monthYearLabel,
                        total: controller.totalLemburForFilter,
                        items: controller.filteredLemburList,
                        typeLabel: 'Lembur',
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Pilih jenis upload via bottom sheet dari FAB =====
  void _showUploadTypeChooser(BuildContext context) {
    final t = Theme.of(context).extension<AppTokens>()!;
    showModalBottomSheet(
      context: context,
      backgroundColor: t.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Upload Insentif Premi'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showUploadSheet(context, jenis: 'Premi');
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Upload Insentif Lembur'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showUploadSheet(context, jenis: 'Lembur');
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  // ==== Bottom-sheet upload (jenis ditentukan dari pilihan sebelumnya) ====
  void _showUploadSheet(BuildContext context, {required String jenis}) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final months = List<int>.generate(12, (i) => i + 1);

    int tahun = controller.selectedYear.value;
    int bulan = controller.selectedMonth.value;

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
                  children: [
                    const Icon(Icons.upload_file),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Upload Data $jenis dari Excel',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

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
}

// ====== Small widgets ======

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}

class _MonthNav extends StatelessWidget {
  const _MonthNav({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44), // tinggi nyaman
      child: Container(
        width: double.infinity, // <-- full width
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Label di tengah
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 44), // ruang utk tombol
              child: Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Tombol prev di kiri
            Align(
              alignment: Alignment.centerLeft,
              child: _circleIconButton(
                icon: Icons.chevron_left,
                onTap: onPrev,
              ),
            ),
            // Tombol next di kanan
            Align(
              alignment: Alignment.centerRight,
              child: _circleIconButton(
                icon: Icons.chevron_right,
                onTap: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
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
}

class _YearDropdown extends StatelessWidget {
  const _YearDropdown({
    required this.years,
    required this.value,
    required this.onChanged,
    required this.dropdownBg,
  });

  final List<int> years;
  final int value;
  final void Function(int year) onChanged;
  final Color dropdownBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
          const SizedBox(width: AppSpacing.sm),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              dropdownColor: dropdownBg,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: years
                  .map(
                      (y) => DropdownMenuItem<int>(value: y, child: Text('$y')))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InsentifTab extends StatelessWidget {
  const _InsentifTab({
    required this.title,
    required this.monthLabel,
    required this.total,
    required this.items,
    required this.typeLabel,
  });

  final String title;
  final String monthLabel;
  final int total;
  final List<Map<String, dynamic>> items;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final accent = t.insentifGradient.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistik ringkas
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
            child: _StatBlock(
              title: title,
              subtitle: monthLabel,
              totalText: _formatCurrency(total),
              countText: '${items.length} Data',
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'Belum ada data untuk $monthLabel',
                  style: TextStyle(
                      color: t.textSecondary, fontStyle: FontStyle.italic),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final insentif = items[index];
                return _InsentifCard(
                  data: insentif,
                  typeLabel: typeLabel,
                  accent: accent,
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatCurrency(int nominal) {
    final s = nominal.toString();
    final withDots = s.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $withDots';
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.title,
    required this.subtitle,
    required this.totalText,
    required this.countText,
  });

  final String title;
  final String subtitle;
  final String totalText;
  final String countText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ($subtitle)',
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          totalText,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          countText,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _InsentifCard extends StatelessWidget {
  const _InsentifCard({
    required this.data,
    required this.typeLabel,
    required this.accent,
  });

  final Map<String, dynamic> data;
  final String typeLabel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final accentAlt = t.insentifGradient.last;

    final vBulan = data['bulan'];
    String monthText = '-';
    String monthLabel = '-';
    try {
      final dt = DateTime.parse('$vBulan');
      monthText = '${dt.month}';
      monthLabel = DateFormat('MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {}

    final int nominal = (data['nominal'] ?? 0) as int;

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
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge bulan
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
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Info utama
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama'] ?? '-',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: t.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: 6,
                    children: [
                      Text('NRP: ${data['nrp'] ?? '-'}',
                          style: TextStyle(color: t.textSecondary)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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
                            fontSize: 12,
                          ),
                        ),
                      ),
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
                  ),
                ],
              ),
            ),

            // Nominal
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                border: Border.all(color: accent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _formatCurrency(nominal),
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),

            // Hapus
            IconButton(
              tooltip: 'Hapus data',
              icon: Icon(Icons.delete_outline_rounded, color: t.textSecondary),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: Get.context!,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus data ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await Get.find<SemuaInsentifController>().deleteInsentifItem(
                    item: data,
                    jenis: typeLabel,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int nominal) {
    final s = nominal.toString();
    final withDots = s.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $withDots';
  }
}
