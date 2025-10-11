// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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
                            onPressed: () => controller.refreshAllData(),
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        // Remaining leave display
                        Obx(() {
                          final user = controller.currentUser.value;
                          if (user != null && user['sisa_cuti'] != null) {
                            return Container(
                              margin: const EdgeInsets.only(left: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Sisa Cuti: ${user['sisa_cuti']} hari',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar (conditional visibility)
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox.shrink();
                }

                // Show tabs only for Atasan
                if (controller.isAtasan) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    child: TabBar(
                      controller: controller.tabController,
                      labelColor: accent,
                      unselectedLabelColor: t.textSecondary,
                      indicatorColor: accent,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.calendar_month),
                          text: 'Kalender',
                        ),
                        Tab(
                          icon: Icon(Icons.list_alt),
                          text: 'Data Cuti',
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Show TabBarView for Atasan, single view for Bawahan
                  if (controller.isAtasan) {
                    return TabBarView(
                      controller: controller.tabController,
                      children: [
                        _buildCalendarView(controller, t, accent),
                        _buildDataListView(controller, t, accent),
                      ],
                    );
                  } else {
                    // For Bawahan, show only calendar view
                    return _buildCalendarView(controller, t, accent);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
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
  }

  Widget _buildDataListView(
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info tip for data list
          Container(
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
                    'Daftar semua pengajuan cuti dari pegawai dalam group yang sama.',
                    style: TextStyle(fontSize: 14, color: t.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Data list card
          _buildDataListCard(controller, t, accent),
        ],
      ),
    );
  }

  Widget _buildDataListCard(
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
              Icon(Icons.list_alt, color: accent, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Data Cuti Tim',
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
            if (controller.isLoadingEmployeeList.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: accent),
                ),
              );
            }

            final employeeList = controller.employeeList;

            if (employeeList.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 48, color: t.textSecondary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Belum ada data pegawai',
                      style: TextStyle(fontSize: 16, color: t.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employeeList.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final employee = employeeList[index];
                return _buildEmployeeCard(employee, controller, t, accent);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(
    Map<String, dynamic> employee,
    CalendarCutiController controller,
    AppTokens t,
    Color accent,
  ) {
    final isCurrentUser = employee['id'] == controller.currentUser.value?['id'];
    final statusGroup = employee['status_group'] ?? 'Staff';
    final sisaCuti = employee['sisa_cuti'] ?? 0;

    return Card(
      elevation: 0,
      color: isCurrentUser ? accent.withOpacity(0.05) : t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isCurrentUser ? accent.withOpacity(0.2) : t.borderSubtle,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          print('🔥 DEBUG: Employee card tapped!');
          print('🔥 DEBUG: Employee data: ${employee.toString()}');
          print('🔥 DEBUG: Employee ID: ${employee['id']}');
          print('🔥 DEBUG: Employee Name: ${employee['name']}');
          _showEmployeeCutiDialog(employee, controller);
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                employee['name'] ?? 'Unknown',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCurrentUser ? accent : t.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusGroup == 'Atasan' 
                    ? Colors.blue.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusGroup,
                style: TextStyle(
                  fontSize: 11,
                  color: statusGroup == 'Atasan' ? Colors.blue : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.group, size: 14, color: t.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Group: ${employee['group'] ?? 'Tidak ada group'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: t.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.account_balance_wallet, size: 14, color: accent),
                const SizedBox(width: 4),
                Text(
                  'Sisa cuti: $sisaCuti hari',
                  style: TextStyle(
                    fontSize: 12,
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
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
            _buildInfoRow('Sisa Cuti', '${user['sisa_cuti'] ?? 0} hari', t, isHighlight: true, accent: accent),
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

  Widget _buildInfoRow(String label, String value, AppTokens t, {bool isHighlight = false, Color? accent}) {
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
            child: isHighlight && accent != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: accent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  )
                : Text(
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

  // Show employee's leave data in a dialog
  void _showEmployeeCutiDialog(
    Map<String, dynamic> employee,
    CalendarCutiController controller,
  ) async {
    final employeeId = employee['id'];
    final employeeName = employee['name'] ?? 'Unknown';

    print('🔥 DEBUG: _showEmployeeCutiDialog called');
    print('🔥 DEBUG: Employee ID: $employeeId');
    print('🔥 DEBUG: Employee Name: $employeeName');

    // Use a single dialog with loading state management
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: controller.loadEmployeeCutiData(employeeId),
            builder: (context, snapshot) {
              final theme = Theme.of(context);
              final isDark = theme.brightness == Brightness.dark;
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading state
                return Container(
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                // Show error state
                return Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat data cuti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              final cutiData = snapshot.data ?? [];
              print('🔥 DEBUG: Received cutiData: ${cutiData.toString()}');
              print('🔥 DEBUG: cutiData length: ${cutiData.length}');
              
              // Show dialog content with data
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modern gradient header with theme-aware colors
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark 
                          ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                          : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? const Color(0xFF1E293B).withOpacity(0.3)
                            : const Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data Cuti',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                employeeName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content area
                  Expanded(
                    child: cutiData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada data cuti',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pegawai ini belum pernah mengajukan cuti',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: cutiData.length,
                            itemBuilder: (context, index) {
                              final cuti = cutiData[index];
                              return _buildCutiCard(cuti, index + 1, theme, isDark);
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Build individual leave card for dialog with theme-aware colors
  Widget _buildCutiCard(Map<String, dynamic> cuti, int number, ThemeData theme, bool isDark) {
    
    final alasan = cuti['alasan_cuti'] ?? 'Tidak ada keterangan';
    final lamaCuti = cuti['lama_cuti'] ?? 0;
    final listTanggalCuti = cuti['list_tanggal_cuti'] ?? '';
    final tanggalPengajuan = cuti['tanggal_pengajuan'];

    // Parse tanggal pengajuan
    DateTime? pengajuanDate;
    if (tanggalPengajuan != null) {
      pengajuanDate = DateTime.tryParse(tanggalPengajuan.toString());
    }

    // Simplify date display - convert comma-separated dates to range format
    String simplifiedDates = _simplifyDateRange(listTanggalCuti);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Numbered circle with theme-aware gradient
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                    ? [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]
                    : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                      ? const Color(0xFF3B82F6).withOpacity(0.3)
                      : const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration and submission date in a row
                  Row(
                    children: [
                      // Duration badge with theme-aware colors
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark 
                            ? const Color(0xFF059669).withOpacity(0.2)
                            : const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark 
                              ? const Color(0xFF059669).withOpacity(0.4)
                              : const Color(0xFF10B981).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: isDark 
                                ? const Color(0xFF10B981)
                                : const Color(0xFF059669),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$lamaCuti hari',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDark 
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Submission date next to duration
                      if (pengajuanDate != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark 
                              ? const Color(0xFFD97706).withOpacity(0.2)
                              : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark 
                                ? const Color(0xFFD97706).withOpacity(0.4)
                                : const Color(0xFFFF9800).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: isDark 
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFFFF9800),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Diajukan: ${DateFormat('dd MMM yyyy').format(pengajuanDate)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark 
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Reason and dates in a row (two columns)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column: Reason
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark 
                              ? theme.colorScheme.surface.withOpacity(0.5)
                              : const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alasan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      alasan,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Right column: Leave dates
                      if (simplifiedDates.isNotEmpty)
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark 
                                ? const Color(0xFF1E40AF).withOpacity(0.1)
                                : const Color(0xFF2196F3).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark 
                                  ? const Color(0xFF3B82F6).withOpacity(0.3)
                                  : const Color(0xFF2196F3).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 16,
                                  color: isDark 
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF2196F3),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tanggal Cuti',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        simplifiedDates,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to simplify date range display
  String _simplifyDateRange(String dateList) {
    if (dateList.isEmpty) return '';
    
    try {
      // Split the comma-separated dates
      List<String> dates = dateList.split(',').map((e) => e.trim()).toList();
      
      if (dates.isEmpty) return '';
      if (dates.length == 1) {
        // Single date
        DateTime date = DateTime.parse(dates[0]);
        return DateFormat('dd MMM yyyy').format(date);
      }
      
      // Multiple dates - show as range
      dates.sort(); // Sort dates
      DateTime firstDate = DateTime.parse(dates.first);
      DateTime lastDate = DateTime.parse(dates.last);
      
      if (dates.length == 2) {
        // Two dates
        return '${DateFormat('dd MMM').format(firstDate)} - ${DateFormat('dd MMM yyyy').format(lastDate)}';
      } else {
        // Multiple dates - show range with count
        return '${DateFormat('dd MMM').format(firstDate)} - ${DateFormat('dd MMM yyyy').format(lastDate)} (${dates.length} hari)';
      }
    } catch (e) {
      // If parsing fails, return original string truncated
      return dateList.length > 50 ? '${dateList.substring(0, 50)}...' : dateList;
    }
  }
}
