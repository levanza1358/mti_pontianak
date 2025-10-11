// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/controller/insentif_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';
import 'package:intl/intl.dart';

class InsentifPage extends GetView<InsentifController> {
  const InsentifPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InsentifController());
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
              // Header as gradient card like Home
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
                    // Decorative bubbles
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
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Row(
                            children: [
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Data Insentif',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Data Insentif Premi & Lembur',
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
                                          icon: const Icon(Icons.arrow_drop_down,
                                              color: Colors.white),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                          items: years
                                              .map((y) => DropdownMenuItem<int>(
                                                  value: y, child: Text('$y')))
                                              .toList(),
                                          onChanged: (v) => v != null
                                              ? controller.changeYear(v)
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // TabBar like CutiPage inside header card
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
              // TabBarView follows header TabBar
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

  Widget _buildPremiTab(ThemeData theme) {
    final t = theme.extension<AppTokens>()!;
    final accent = t.insentifGradient.first;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistics
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
                    'Total Insentif Premi',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    controller.formatCurrency(
                      controller.filteredPremiList.fold<int>(
                        0,
                        (sum, item) => sum + ((item['nominal'] ?? 0) as int),
                      ),
                    ),
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

            // List Insentif
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

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistics
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
                    'Total Insentif Lembur',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    controller.formatCurrency(
                      controller.filteredLemburList.fold<int>(
                        0,
                        (sum, item) => sum + ((item['nominal'] ?? 0) as int),
                      ),
                    ),
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

            // List Insentif
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
    // Ambil angka bulan dari field 'bulan'; fallback ke nomor urut jika tidak tersedia
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
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.12),
                        accentAlt.withOpacity(0.12)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: accent.withOpacity(0.25)),
                  ),
                  child: Text(
                    controller.formatCurrency(insentif['nominal']),
                    style:
                        TextStyle(color: accent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md - 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor ?? t.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: t.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: t.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        insentif['bulan'] != null
                            ? DateFormat('MMMM yyyy')
                                .format(DateTime.parse(insentif['bulan']))
                            : '-',
                        style: TextStyle(color: t.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
