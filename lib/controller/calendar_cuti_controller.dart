import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/supabase_service.dart';
import 'login_controller.dart';

class CalendarCutiController extends GetxController with GetSingleTickerProviderStateMixin {
  // Observable state variables
  final isLoading = false.obs;
  final isLoadingCalendar = false.obs;
  final isLoadingDataList = false.obs;
  final currentUser = Rxn<Map<String, dynamic>>();

  // Calendar data
  final calendarEvents = <DateTime, List<Map<String, dynamic>>>{}.obs;
  final selectedDay = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.month.obs;

  // Data list for leave records
  // Observable list for employee data (instead of leave data)
  final employeeList = <Map<String, dynamic>>[].obs;
  final isLoadingEmployeeList = false.obs;

  // Tab controller
  late TabController tabController;

  // Login controller reference
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    // Initialize tab controller with 2 tabs
    tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    await loadCurrentUser();
    await loadCalendarData();
    await loadEmployeeList();
  }

  // Load current user data
  Future<void> loadCurrentUser() async {
    isLoading.value = true;
    try {
      final user = loginController.currentUser.value;
      if (user != null) {
        // Get fresh user data with group, status_group, and sisa_cuti
        final result = await SupabaseService.instance.client
            .from('users')
            .select('*, group, status_group, sisa_cuti')
            .eq('id', user['id'])
            .single();

        currentUser.value = result;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load calendar data with hierarchical permissions
  Future<void> loadCalendarData() async {
    isLoadingCalendar.value = true;

    try {
      if (currentUser.value == null) {
        calendarEvents.clear();
        return;
      }

      final user = currentUser.value!;
      final userId = user['id'];
      final userGroup = user['group'];
      final statusGroup = user['status_group'];

      List<Map<String, dynamic>> cutiData = [];

      if (statusGroup == 'Atasan') {
        // Atasan can see their own leave + Bawahan's leave in same group

        // First get own leave data
        final ownLeaveResult = await SupabaseService.instance.client
            .from('cuti')
            .select('''
              *,
              users!inner(id, name, group, status_group)
            ''')
            .eq('users_id', userId);

        // Then get Bawahan's leave data in same group
        final bawahanLeaveResult = await SupabaseService.instance.client
            .from('cuti')
            .select('''
              *,
              users!inner(id, name, group, status_group)
            ''')
            .eq('users.status_group', 'Bawahan')
            .eq('users.group', userGroup);

        // Combine both results
        cutiData = [
          ...List<Map<String, dynamic>>.from(ownLeaveResult),
          ...List<Map<String, dynamic>>.from(bawahanLeaveResult),
        ];
      } else {
        // Bawahan can only see their own leave

        final result = await SupabaseService.instance.client
            .from('cuti')
            .select('''
              *,
              users!inner(id, name, group, status_group)
            ''')
            .eq('users_id', userId);

        cutiData = List<Map<String, dynamic>>.from(result);
      }

      // Process data into calendar events
      final Map<DateTime, List<Map<String, dynamic>>> events = {};

      for (var cuti in cutiData) {
        try {
          // Parse list_tanggal_cuti (varchar) - format bisa "2024-01-15,2024-01-16,2024-01-17"
          final listTanggalCuti = cuti['list_tanggal_cuti'] as String?;

          if (listTanggalCuti != null && listTanggalCuti.isNotEmpty) {
            // Split tanggal berdasarkan koma dan parse setiap tanggal
            final tanggalList = listTanggalCuti.split(',');

            for (String tanggalStr in tanggalList) {
              try {
                final tanggal = DateTime.parse(tanggalStr.trim());
                final normalizedDate = DateTime(
                  tanggal.year,
                  tanggal.month,
                  tanggal.day,
                );

                if (events[normalizedDate] == null) {
                  events[normalizedDate] = [];
                }

                events[normalizedDate]!.add({
                  'id': cuti['id'],
                  'user_name': cuti['users']['name'],
                  'alasan': cuti['alasan_cuti'] ?? 'Tidak ada keterangan',
                  'status': cuti['status'] ?? 'pending',
                  'lama_cuti': cuti['lama_cuti'],
                  'users_id': cuti['users_id'],
                  'is_own': cuti['users_id'] == userId,
                  'tanggal': tanggalStr.trim(),
                });
              } catch (dateError) {
                // Ignore invalid date format and continue with next date
                debugPrint('Invalid date format: $dateError');
              }
            }
          }
        } catch (e) {
          // Ignore individual cuti processing errors to allow other entries to process
          debugPrint('Error processing cuti entry: $e');
        }
      }

      calendarEvents.value = events;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data kalender cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingCalendar.value = false;
    }
  }

  // Get events for a specific day
  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return calendarEvents[normalizedDay] ?? [];
  }

  // Load employee's leave data by employee ID
  Future<List<Map<String, dynamic>>> loadEmployeeCutiData(String employeeId) async {
    try {
      print('🔥 DEBUG: Starting loadEmployeeCutiData for employee ID: $employeeId');
      
      final result = await SupabaseService.instance.client
          .from('cuti')
          .select('''
            *,
            users!inner(id, name, group, status_group)
          ''')
          .eq('users_id', employeeId)
          .order('tanggal_pengajuan', ascending: false);

      print('🔥 DEBUG: Query result: ${result.toString()}');
      print('🔥 DEBUG: Result length: ${result.length}');
      
      final cutiData = List<Map<String, dynamic>>.from(result);
      print('🔥 DEBUG: Processed cuti data: ${cutiData.toString()}');
      
      return cutiData;
    } catch (e) {
      print('🔥 DEBUG: Error in loadEmployeeCutiData: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data cuti pegawai: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return [];
    }
  }

  // Check if a day has events
  bool hasEventsOnDay(DateTime day) {
    return getEventsForDay(day).isNotEmpty;
  }

  // Refresh calendar data
  Future<void> refreshCalendarData() async {
    await loadCalendarData();
  }

  // Calendar event handlers
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
  }

  // Check if user is Atasan (to show/hide tabs)
  bool get isAtasan => currentUser.value?['status_group'] == 'Atasan';

  // Refresh all data
  Future<void> refreshAllData() async {
    await loadCalendarData();
    await loadEmployeeList();
  }

  // Load employee list for Atasan to see all employees in same group
  Future<void> loadEmployeeList() async {
    isLoadingEmployeeList.value = true;

    try {
      if (currentUser.value == null) {
        employeeList.clear();
        return;
      }

      final user = currentUser.value!;
      final userGroup = user['group'];
      final statusGroup = user['status_group'];

      // Only load employee list for Atasan
      if (statusGroup != 'Atasan') {
        employeeList.clear();
        return;
      }

      // Get all employees from same group
      final result = await SupabaseService.instance.client
          .from('users')
          .select('id, name, group, status_group, sisa_cuti')
          .eq('group', userGroup)
          .order('name', ascending: true);

      employeeList.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pegawai: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingEmployeeList.value = false;
    }
  }
}
