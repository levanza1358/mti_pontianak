// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/calendar_cuti_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class CalendarCutiPage extends StatelessWidget {
  const CalendarCutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarCutiController controller = Get.put(CalendarCutiController());
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accent = t.cutiAllGradient.first;

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
              // Header card (mengadopsi gaya dari Pengajuan Cuti, tanpa AppBar)
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
                        // Back Button bergaya card
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
                        // Title & subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kalender Cuti',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Lihat kalender cuti dan riwayat tim',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol refresh bergaya card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => controller.refreshCalendarData(),
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info tip (inspirasi dari halaman Cuti)
                        _buildInfoTip(t, accent),
                        const SizedBox(height: AppSpacing.md),
                        // User info card
                        _buildUserInfoCard(controller, t, accent),
                        const SizedBox(height: AppSpacing.lg),

                        // Calendar card
                      _buildCalendarCard(controller, t, accent),
                        const SizedBox(height: AppSpacing.lg),

                        // Selected day events
                        _buildSelectedDayEvents(controller, t, accent),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTip(AppTokens t, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: t.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.info_outline, color: accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Pilih tanggal cuti dengan teliti. Ketuk tanggal untuk melihat detail pengajuan Anda maupun tim.',
              style: TextStyle(fontSize: 14, color: t.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: t.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: accent, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Informasi Pengguna',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: t.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow('Nama', user['name'] ?? '-', t),
            _buildInfoRow('Group', user['group'] ?? '-', t),
            _buildInfoRow('Status', user['status_group'] ?? '-', t),
            if (user['status_group'] == 'Atasan') ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Dapat melihat cuti bawahan dalam group yang sama',
                  style: TextStyle(
                    fontSize: 12,
                    color: accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value, AppTokens t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 14, color: t.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: t.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: t.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: accent, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Kalender Cuti',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: t.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Obx(() {
            if (controller.isLoadingCalendar.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: accent),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar<Map<String, dynamic>>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.focusedDay.value,
                  calendarFormat: controller.calendarFormat.value,
                  eventLoader: controller.getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: t.textSecondary),
                    holidayTextStyle: const TextStyle(color: Color(0xFFEF4444)),
                    selectedDecoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: accent.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: accent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: accent,
                      size: 28,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: accent,
                      size: 28,
                    ),
                    headerPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: t.textPrimary,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return null;
                      final dots = events.take(3).map((e) {
                        (e['status'] ?? '').toString();
                        final isOwn = e['is_own'] == true;
                        final color = isOwn ? accent : t.textSecondary;
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dots,
                      );
                    },
                  ),
                  onDaySelected: controller.onDaySelected,
                  onFormatChanged: controller.onFormatChanged,
                  onPageChanged: controller.onPageChanged,
                  selectedDayPredicate: (day) {
                    return isSameDay(controller.selectedDay.value, day);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEvents(
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
    return Obx(() {
      final selectedEvents = controller.getEventsForDay(
        controller.selectedDay.value,
      );

      if (selectedEvents.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: t.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: t.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tidak ada cuti pada ${_formatDate(controller.selectedDay.value)}',
                style: TextStyle(fontSize: 16, color: t.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: t.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event, color: accent, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Cuti pada ${_formatDate(controller.selectedDay.value)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: t.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            ...selectedEvents.map((event) => _buildEventCard(event, t, accent)),
          ],
        ),
      );
    });
  }

  Widget _buildEventCard(
    Map<String, dynamic> event,
    AppTokens t,
    Color accent,
  ) {
    final isOwn = event['is_own'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwn ? accent.withOpacity(0.08) : t.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOwn ? accent.withOpacity(0.25) : t.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOwn ? Icons.person : Icons.group,
                size: 16,
                color: isOwn ? accent : t.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  event['user_name'] ?? event['users_id']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isOwn ? accent : t.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            event['alasan'] ?? 'Tidak ada alasan',
            style: TextStyle(fontSize: 13, color: t.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.date_range, size: 14, color: t.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatDate(DateTime.parse(event['tanggal'])),
                style: TextStyle(fontSize: 12, color: t.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.schedule, size: 14, color: t.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${event['lama_cuti'] ?? 0} hari total',
                style: TextStyle(fontSize: 12, color: t.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helpers status & legend dihapus karena tidak digunakan.

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
