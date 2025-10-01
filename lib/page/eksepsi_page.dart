import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/eksepsi_controller.dart';

class EksepsiPage extends StatelessWidget {
  const EksepsiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EksepsiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksepsi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Ajukan Eksepsi'),
                Tab(text: 'Riwayat Saya'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildEksepsiForm(controller),
                _buildHistoryTab(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEksepsiForm(EksepsiController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.eksepsiFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Eksepsi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        controller.jenisEksepsi,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tanggal Eksepsi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: controller.addEksepsiEntry,
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: controller.eksepsiEntries.length,
                            itemBuilder: (context, index) {
                              return _buildEksepsiEntry(controller, index);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submitEksepsiApplication,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Kirim Pengajuan',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEksepsiEntry(EksepsiController controller, int index) {
    final entry = controller.eksepsiEntries[index];
    final alasanController = entry['alasan']!;
    final tanggalController = entry['tanggal']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eksepsi ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.eksepsiEntries.length > 1)
                  IconButton(
                    onPressed: () => controller.removeEksepsiEntry(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: tanggalController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Eksepsi',
                hintText: 'Pilih tanggal eksepsi',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              validator: controller.validateTanggalEksepsi,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  controller.setSelectedDate(picked, index);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: alasanController,
              decoration: const InputDecoration(
                labelText: 'Alasan Eksepsi',
                hintText: 'Masukkan alasan eksepsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: controller.validateAlasan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(EksepsiController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Eksepsi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.eksepsiHistory.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada riwayat eksepsi',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.eksepsiHistory.length,
                itemBuilder: (context, index) {
                  final item = controller.eksepsiHistory[index];
                  return _buildHistoryCard(controller, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    EksepsiController controller,
    Map<String, dynamic> item,
  ) {
    final status = item['status_persetujuan'] ?? 'Menunggu';
    final statusColor = controller.getStatusColor(status);
    final statusIcon = controller.getStatusIcon(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetailDialog(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['jenis_eksepsi'] ?? 'Jam Masuk & Jam Pulang',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jumlah Hari: ${item['jumlah_hari'] ?? 1}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Only show status if it's not "Menunggu"
                      if (status.toLowerCase() != 'menunggu')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 16, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (status.toLowerCase() == 'menunggu')
                        IconButton(
                          onPressed: () =>
                              controller.showDeleteConfirmation(item),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Tanggal', item['list_tanggal_eksepsi'] ?? '-'),
              _buildDetailRow('Alasan', item['alasan_eksepsi'] ?? '-'),
              _buildDetailRow(
                'Tanggal Pengajuan',
                item['tanggal_pengajuan'] != null
                    ? _formatDateDisplay(item['tanggal_pengajuan'])
                    : '-',
              ),
              if (item['catatan_persetujuan'] != null &&
                  item['catatan_persetujuan'].toString().isNotEmpty)
                _buildDetailRow('Catatan', item['catatan_persetujuan']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    final tanggalList = item['list_tanggal_eksepsi'] ?? '';
    final List<String> tanggalArray = tanggalList.split(', ');
    
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detail Tanggal Eksepsi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis: ${item['jenis_eksepsi'] ?? 'Jam Masuk & Jam Pulang'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Alasan: ${item['alasan_eksepsi'] ?? '-'}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tanggal yang Diajukan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tanggalArray.length,
                    itemBuilder: (context, index) {
                      final tanggal = tanggalArray[index].trim();
                      if (tanggal.isEmpty) return const SizedBox.shrink();
                      
                      DateTime? date;
                      try {
                        date = DateTime.parse(tanggal);
                      } catch (e) {
                        // If parsing fails, try to display the raw string
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                date != null 
                                  ? '${_getDayName(date)}, ${DateFormat('dd MMMM yyyy').format(date)}'
                                  : tanggal,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (date != null && _isWeekend(date))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Weekend',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (item['tanggal_pengajuan'] != null)
                  Text(
                    'Diajukan pada: ${_formatDateDisplay(item['tanggal_pengajuan'])}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  String _formatDateDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getDayName(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }
}
