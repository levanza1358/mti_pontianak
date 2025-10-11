// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/cuti_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';
import 'pdf_cuti_page.dart';

class CutiPage extends StatelessWidget {
  const CutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CutiController controller = Get.put(CutiController());
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: t.cutiAllGradient
                  .map((c) => c.withOpacity(isDark ? 0.08 : 0.14))
                  .toList(),
            ),
          ),
          child: Column(
            children: [
              // Modern Header Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: t.cutiAllGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                    Row(
                      children: [
                        // Back Button
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        // Title Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pengajuan Cuti',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Kelola pengajuan dan riwayat cuti',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tab Bar
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
                        labelColor: t.cutiAllGradient.first,
                        unselectedLabelColor: Colors.white.withOpacity(0.8),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        tabs: const [
                          Tab(text: 'Pengajuan'),
                          Tab(text: 'Riwayat'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Obx(() {
                  // Show error if user data failed to load
                  if (controller.currentUser.value == null &&
                      !controller.isLoadingUser.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: AppSpacing.lg),
                          Text(
                            'Gagal memuat data pengguna',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show loading while fetching user data
                  if (controller.isLoadingUser.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4facfe),
                      ),
                    );
                  }

                  return TabBarView(
                    controller: controller.tabController,
                    children: [
                      _buildPengajuanTab(context, controller, colorScheme),
                      _buildHistoryTab(context, controller),
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

  // Tab 1: Pengajuan Cuti
  Widget _buildPengajuanTab(
    BuildContext context,
    CutiController controller,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.cutiFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: t.cutiAllGradient.first.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF4facfe),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pilih tanggal cuti yang diinginkan dengan teliti',
                      style: TextStyle(fontSize: 14, color: t.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            // User Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4facfe).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF4facfe),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.currentUser.value?['name'] ??
                                    'Loading...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: t.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Obx(
                              () => Text(
                                'NRP: ${controller.currentUser.value?['nrp'] ?? '-'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: t.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          t.cutiAllGradient.first.withOpacity(0.10),
                          t.cutiAllGradient.first.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sisa Cuti:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: t.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: t.cutiAllGradient.first,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(
                            () => Text(
                              '${controller.sisaCuti.value} hari',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
            const SizedBox(height: 20),

            // Calendar Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4facfe).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Color(0xFF4facfe),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pilih Tanggal Cuti',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: t.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.calendarFormat.value ==
                                  CalendarFormat.month
                              ? Icons.calendar_view_week
                              : Icons.calendar_view_month,
                          color: t.cutiAllGradient.first,
                        ),
                        onPressed: controller.changeCalendarFormat,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Obx(
                    () => TableCalendar<String>(
                      firstDay: DateTime(2020, 1, 1),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: controller.focusedDay.value,
                      calendarFormat: controller.calendarFormat.value,
                      startingDayOfWeek: StartingDayOfWeek.monday,

                      // Calendar style
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: const TextStyle(color: Colors.red),
                        holidayTextStyle: const TextStyle(color: Colors.red),
                        selectedDecoration: BoxDecoration(
                          gradient: LinearGradient(colors: t.cutiAllGradient),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: t.cutiAllGradient.first.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: t.cutiAllGradient.first,
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Header style
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: t.textPrimary,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: t.cutiAllGradient.first,
                          size: 28,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: t.cutiAllGradient.first,
                          size: 28,
                        ),
                      ),

                      // Selection logic
                      selectedDayPredicate: (day) {
                        return controller.isSelectedDay(day);
                      },

                      onDaySelected: controller.onDaySelected,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Selected dates info
                  Obx(() {
                    if (controller.selectedDates.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              theme.inputDecorationTheme.fillColor ?? t.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: t.textSecondary,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Belum ada tanggal yang dipilih',
                              style: TextStyle(color: t.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4facfe).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tanggal dipilih: ${controller.selectedDates.length} hari',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: t.cutiAllGradient.first,
                                ),
                              ),
                              TextButton(
                                onPressed: controller.clearSelectedDates,
                                child: const Text('Hapus Semua'),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: controller.selectedDates.map((date) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: t.cutiAllGradient.first,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${date.day}/${date.month}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Reason (single unified box)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller.alasanController,
                validator: controller.validateAlasan,
                maxLines: 5,
                style: TextStyle(color: t.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Alasan Cuti',
                  hintText: 'Masukkan alasan pengajuan cuti...',
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF4facfe),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: AppSpacing.section),

            // Signature Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: t.shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4facfe).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.gesture,
                              color: Color(0xFF4facfe),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Tanda Tangan Digital',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: t.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => controller.hasSignature.value
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: t.successBg,
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.sm),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: t.successFg,
                                      size: 16,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Tersedia',
                                      style: TextStyle(
                                        color: t.successFg,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: t.warningBg,
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.sm),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pending,
                                      color: t.warningFg,
                                      size: 16,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Belum ada',
                                      style: TextStyle(
                                        color: t.warningFg,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Obx(() {
                    final data = controller.signatureData.value;
                    if (data != null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: t.card,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                          border: Border.all(color: t.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.memory(
                              data,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Preview tanda tangan',
                              style: TextStyle(
                                fontSize: 12,
                                color: t.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: t.card,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        border: Border.all(color: t.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.border_color,
                            color: t.textSecondary,
                            size: 28,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Belum ada tanda tangan',
                            style: TextStyle(
                              color: t.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.clearSignature,
                          icon: const Icon(Icons.clear),
                          label: const Text('Hapus'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.md),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.showSignatureDialog,
                          icon: const Icon(Icons.edit),
                          label: const Text('Buat TTD'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.md),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Submit Button
            Obx(
              () => Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: t.cutiAllGradient),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: t.shadowColor,
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.submitCutiApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Mengajukan Cuti...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Ajukan Cuti',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Tab 2: History Cuti
  Widget _buildHistoryTab(BuildContext context, CutiController controller) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(t.cutiAllGradient.first),
          ),
        );
      }

      if (controller.cutiHistory.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: t.cutiAllGradient.first.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: 48,
                  color: t.cutiAllGradient.first,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Belum ada riwayat cuti',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Pengajuan cuti Anda akan muncul di sini',
                style: TextStyle(fontSize: 14, color: t.textSecondary),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.cutiHistory.length,
        itemBuilder: (context, index) {
          final item = controller.cutiHistory[index];

          // Parse dates from list_tanggal_cuti field (comma-separated string)
          final dateString = item['list_tanggal_cuti'] ?? '';
          final dates = dateString.isNotEmpty
              ? dateString.split(',').map((e) => e.trim()).toList()
              : <String>[];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: t.shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with status and action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuti ${dates.length} Hari',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: t.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Lock status indicator only
                            if (item['kunci_cuti'] ?? false)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: t.warningBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: t.warningFg.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 12,
                                      color: t.warningFg,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Terkunci',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: t.warningFg,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // PDF button
                          InkWell(
                            onTap: () async {
                              final isLocked = item['kunci_cuti'] ?? false;

                              // Jika sudah terkunci, langsung buka PDF tanpa dialog
                              if (isLocked) {
                                Get.to(() => PdfCutiPage(cutiData: item));
                                return;
                              }

                              // Jika belum terkunci, tampilkan konfirmasi
                              final confirmed = await Get.dialog<bool>(
                                    AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                        'Apakah pengajuan cuti ini sudah benar?\nSetelah dikunci, data tidak dapat dihapus.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: const Text('Ya, lanjut'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (!confirmed) return;

                              await controller.toggleKunciCuti(item);

                              Get.to(() => PdfCutiPage(cutiData: item));
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: t.chipBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.picture_as_pdf,
                                size: 20,
                                color: t.chipFg,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const SizedBox(width: AppSpacing.sm),
                          // Delete button (only show if not locked)
                          if (!(item['kunci_cuti'] ?? false))
                            InkWell(
                              onTap: () {
                                controller.showDeleteConfirmation(item);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: t.dangerBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: t.dangerFg,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Duration info
                  if (dates.isNotEmpty && dates.length > 1)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            t.cutiAllGradient.first.withOpacity(0.1),
                            t.cutiAllGradient.first.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: t.cutiAllGradient.first.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.date_range,
                              color: t.cutiAllGradient.first,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Periode Cuti:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: t.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dates.first} - ${dates.last}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: t.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),

                  // Info rows
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor ?? t.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Submission date
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: t.cutiAllGradient.first.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.schedule,
                                color: t.cutiAllGradient.first,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Tanggal Pengajuan:',
                              style: TextStyle(
                                fontSize: 12,
                                color: t.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item['tanggal_pengajuan'] != null
                                  ? DateTime.parse(
                                      item['tanggal_pengajuan'],
                                    ).toString().split(' ')[0]
                                  : '-',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: t.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Reason
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4facfe).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.description_outlined,
                                color: Color(0xFF4facfe),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Alasan:',
                              style: TextStyle(
                                fontSize: 12,
                                color: t.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item['alasan_cuti'] ?? '-',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: t.textPrimary,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Individual dates
                  if (dates.length > 1) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Detail Tanggal:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: t.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: dates.map<Widget>((date) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: t.cutiAllGradient.first.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: t.cutiAllGradient.first,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Remaining leave days after this application
                  if (item['remaining_days'] != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: t.cutiAllGradient.first.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: t.cutiAllGradient.first,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sisa cuti setelah pengajuan: ${item['remaining_days']} hari',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: t.cutiAllGradient.first,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
