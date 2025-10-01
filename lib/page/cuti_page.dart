import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/cuti_controller.dart';

class CutiPage extends StatelessWidget {
  const CutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CutiController controller = Get.put(CutiController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 214, 214),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4facfe).withOpacity(0.3),
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
                            const SizedBox(height: 4),
                            Text(
                              'Kelola pengajuan dan riwayat cuti',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
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
                      labelColor: const Color(0xFF4facfe),
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
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
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
                    child: CircularProgressIndicator(color: Color(0xFF4facfe)),
                  );
                }

                return TabBarView(
                  controller: controller.tabController,
                  children: [
                    _buildPengajuanTab(controller, colorScheme),
                    _buildHistoryTab(controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: Pengajuan Cuti
  Widget _buildPengajuanTab(
    CutiController controller,
    ColorScheme colorScheme,
  ) {
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                      color: const Color(0xFF4facfe).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF4facfe),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pilih tanggal cuti yang diinginkan dengan teliti',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            // User Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                'NRP: ${controller.currentUser.value?['nrp'] ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4facfe).withOpacity(0.1),
                          const Color(0xFF4facfe).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sisa Cuti:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4facfe),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
                      const Expanded(
                        child: Text(
                          'Pilih Tanggal Cuti',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.calendarFormat.value ==
                                  CalendarFormat.month
                              ? Icons.calendar_view_week
                              : Icons.calendar_view_month,
                          color: const Color(0xFF4facfe),
                        ),
                        onPressed: controller.changeCalendarFormat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                        selectedDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF4facfe).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: const BoxDecoration(
                          color: Color(0xFF4facfe),
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Header style
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Color(0xFF4facfe),
                          size: 28,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Color(0xFF4facfe),
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

                  const SizedBox(height: 16),

                  // Selected dates info
                  Obx(() {
                    if (controller.selectedDates.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Belum ada tanggal yang dipilih',
                              style: TextStyle(color: Colors.grey),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4facfe),
                                ),
                              ),
                              TextButton(
                                onPressed: controller.clearSelectedDates,
                                child: const Text('Hapus Semua'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                                  color: const Color(0xFF4facfe),
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
            const SizedBox(height: 16),

            // Reason Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
                          Icons.description_outlined,
                          color: Color(0xFF4facfe),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Alasan Cuti',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.alasanController,
                    validator: controller.validateAlasan,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Masukkan alasan pengajuan cuti...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(
                          Icons.description_outlined,
                          color: Color(0xFF4facfe),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4facfe),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            Obx(
              () => Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4facfe).withOpacity(0.3),
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
  Widget _buildHistoryTab(CutiController controller) {
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4facfe)),
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
                  color: const Color(0xFF4facfe).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history,
                  size: 48,
                  color: Color(0xFF4facfe),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Belum ada riwayat cuti',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pengajuan cuti Anda akan muncul di sini',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Lock status indicator only
                            if (item['kunci_cuti'] ?? false)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 12,
                                      color: Colors.orange.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Terkunci',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade700,
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
                          // Lock/Unlock button
                          InkWell(
                            onTap: () {
                              controller.showLockConfirmation(item);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (item['kunci_cuti'] ?? false)
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                (item['kunci_cuti'] ?? false)
                                    ? Icons.lock
                                    : Icons.lock_open,
                                size: 20,
                                color: (item['kunci_cuti'] ?? false)
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Duration info
                  if (dates.isNotEmpty && dates.length > 1)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4facfe).withOpacity(0.1),
                            const Color(0xFF4facfe).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4facfe).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.date_range,
                              color: Color(0xFF4facfe),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Periode Cuti:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dates.first} - ${dates.last}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Info rows
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
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
                                color: const Color(0xFF4facfe).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.schedule,
                                color: Color(0xFF4facfe),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Tanggal Pengajuan:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
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
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                            const SizedBox(width: 8),
                            const Text(
                              'Alasan:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['alasan_cuti'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
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
                    const SizedBox(height: 12),
                    const Text(
                      'Detail Tanggal:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                            color: const Color(0xFF4facfe).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4facfe),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Remaining leave days after this application
                  if (item['remaining_days'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4facfe).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Color(0xFF4facfe),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sisa cuti setelah pengajuan: ${item['remaining_days']} hari',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4facfe),
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
