import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/controller/insentif_controller.dart';
import 'package:intl/intl.dart';

class InsentifPage extends GetView<InsentifController> {
  const InsentifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InsentifController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Insentif'),
        actions: [
          Obx(() {
            final years = controller.availableYears.toList()
              ..sort((a, b) => b.compareTo(a));
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: controller.selectedYear.value,
                  dropdownColor: theme.primaryColor,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  items: years.map((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      controller.changeYear(newValue);
                    }
                  },
                ),
              ),
            );
          }),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'Insentif Premi'),
            Tab(text: 'Insentif Lembur'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [_buildPremiTab(theme), _buildLemburTab(theme)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new insentif
          Get.snackbar(
            'Info',
            'Fitur tambah insentif akan segera hadir!',
            backgroundColor: theme.primaryColor,
            colorText: Colors.white,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPremiTab(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistics
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A73E8), // Google Blue
                    const Color(0xFF1557B0), // Darker shade of Google Blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A73E8).withOpacity(0.3),
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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
            const SizedBox(height: 20),

            // List Insentif
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredPremiList.length,
              itemBuilder: (context, index) {
                final insentif = controller.filteredPremiList[index];
                return Card(
                  elevation: 2,
                  shadowColor: theme.shadowColor.withOpacity(0.1),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1A73E8).withOpacity(0.1),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          color: Color(0xFF1A73E8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insentif['nama'] ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'NRP: ${insentif['nrp'] ?? '-'}',
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.formatCurrency(insentif['nominal']),
                            style: const TextStyle(
                              color: Color(0xFF1A73E8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  insentif['bulan'] != null
                                      ? DateFormat('MMMM yyyy').format(
                                          DateTime.parse(insentif['bulan']),
                                        )
                                      : '-',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLemburTab(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistics
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF34A853), // Google Green
                    Color(0xFF28864F), // Darker shade of Google Green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34A853).withOpacity(0.3),
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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
            const SizedBox(height: 20),

            // List Insentif
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredLemburList.length,
              itemBuilder: (context, index) {
                final insentif = controller.filteredLemburList[index];
                return Card(
                  elevation: 2,
                  shadowColor: theme.shadowColor.withOpacity(0.1),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF34A853).withOpacity(0.1),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          color: Color(0xFF34A853),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insentif['nama'] ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'NRP: ${insentif['nrp'] ?? '-'}',
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF34A853).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.formatCurrency(insentif['nominal']),
                            style: const TextStyle(
                              color: Color(0xFF34A853),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  insentif['bulan'] != null
                                      ? DateFormat('MMMM yyyy').format(
                                          DateTime.parse(insentif['bulan']),
                                        )
                                      : '-',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
