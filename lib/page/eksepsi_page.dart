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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Pengajuan & Riwayat Eksepsi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: const Color(0xFF16213E),
            child: TabBar(
              controller: controller.tabController,
              indicatorColor: const Color(0xFF0F3460),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              tabs: const [
                Tab(
                  icon: Icon(Icons.edit_calendar),
                  text: 'Ajukan Eksepsi',
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: 'Riwayat Saya',
                ),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildFormTab(controller, context),
                _buildHistoryTab(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEksepsiEntry(EksepsiController controller, BuildContext context, int index, Map<String, TextEditingController> controllers) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0F3460)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with entry number and remove button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eksepsi ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.eksepsiEntries.length > 1)
                IconButton(
                  onPressed: () => controller.removeEksepsiEntry(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Hapus eksepsi ini',
                ),
            ],
          ),
          
          const SizedBox(height: 16),

          // Jenis Eksepsi (Fixed Display)
          const Text(
            'Jenis Eksepsi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0F3460)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Jam Masuk & Jam Pulang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tanggal Eksepsi
          const Text(
            'Tanggal Eksepsi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controllers['tanggal'],
            style: const TextStyle(color: Colors.white),
            readOnly: true,
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF0F3460),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                controller.setSelectedDate(pickedDate, index);
              }
            },
            decoration: InputDecoration(
              hintText: 'Pilih tanggal eksepsi',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: Colors.grey[400],
              ),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[400],
              ),
              filled: true,
              fillColor: const Color(0xFF1A1A2E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460), width: 2),
              ),
            ),
            validator: controller.validateTanggalEksepsi,
          ),

          const SizedBox(height: 16),

          // Alasan Eksepsi untuk tanggal ini
          const Text(
            'Alasan Eksepsi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controllers['alasan'],
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Jelaskan alasan eksepsi untuk tanggal ini...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFF1A1A2E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F3460), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Alasan eksepsi harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormTab(EksepsiController controller, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.eksepsiFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Obx(() {
              final user = controller.currentUser.value;
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F3460)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Pemohon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Nama', user['name'] ?? '-'),
                    _buildInfoRow('NRP', user['nrp'] ?? '-'),
                    _buildInfoRow('Nomor HP/WA', user['phone'] ?? '-'),
                    _buildInfoRow('Jabatan', user['jabatan'] ?? '-'),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Dynamic Eksepsi Entries
            Obx(() => Column(
              children: [
                ...controller.eksepsiEntries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controllers = entry.value;
                  return _buildEksepsiEntry(controller, context, index, controllers);
                }).toList(),
                
                // Add More Button
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: controller.addEksepsiEntry,
                  icon: const Icon(Icons.add, color: Color(0xFF0F3460)),
                  label: const Text(
                    'Tambah Eksepsi Lain',
                    style: TextStyle(color: Color(0xFF0F3460)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0F3460)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ],
            )),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.clearForm,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Bersihkan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitEksepsiApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3460),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Ajukan Eksepsi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(EksepsiController controller) {
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F3460)),
          ),
        );
      }

      if (controller.eksepsiHistory.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Belum ada riwayat eksepsi',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.eksepsiHistory.length,
          itemBuilder: (context, index) {
            final item = controller.eksepsiHistory[index];
            return _buildHistoryCard(context, controller, item);
          },
        ),
      );
    });
  }

  Widget _buildHistoryCard(BuildContext context, EksepsiController controller, Map<String, dynamic> item) {
    final dateString = item['list_tanggal_eksepsi'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList().cast<String>()
        : <String>[];
    
    final status = item['status_persetujuan'] ?? 'Menunggu';
    final statusColor = controller.getStatusColor(status);
    final statusIcon = controller.getStatusIcon(status);

    return GestureDetector(
      onTap: () => _showEksepsiDetail(context, item, dates),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0F3460)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Eksepsi #${item['id']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Details
            if (item['jam_masuk'] != null)
              _buildDetailRow('Jam Masuk', item['jam_masuk']),
            if (item['jam_pulang'] != null)
              _buildDetailRow('Jam Pulang', item['jam_pulang']),
            if (item['keterangan'] != null && item['keterangan'].toString().isNotEmpty)
              _buildDetailRow('Keterangan', item['keterangan']),
            _buildDetailRow(
              'Tanggal',
              dates.isNotEmpty ? '${dates.first} - ${dates.last}' : '-',
            ),
            _buildDetailRow('Jumlah Hari', '${item['jumlah_hari'] ?? 0} hari'),
            _buildDetailRow(
              'Tanggal Pengajuan',
              item['tanggal_pengajuan'] != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(
                      DateTime.parse(item['tanggal_pengajuan']),
                    )
                  : '-',
            ),

            const SizedBox(height: 8),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status.toLowerCase() == 'menunggu')
                  TextButton.icon(
                    onPressed: () => controller.showDeleteConfirmation(item),
                    icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                    label: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEksepsiDetail(BuildContext context, Map<String, dynamic> item, List<String> dates) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue[300],
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Detail Tanggal Eksepsi #${item['id']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info eksepsi
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis: ${item['jenis_eksepsi'] ?? '-'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Alasan: ${item['alasan_eksepsi'] ?? '-'}',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 13,
                        ),
                      ),
                      if (item['jam_masuk'] != null || item['jam_pulang'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Jam: ${item['jam_masuk'] ?? '-'} - ${item['jam_pulang'] ?? '-'}',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Header daftar tanggal
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.blue[300],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daftar Tanggal Eksepsi (${dates.length} hari)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Daftar tanggal
                Flexible(
                  child: dates.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F3460),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange[300],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tidak ada tanggal eksepsi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
                            final date = dates[index];
                            final isWeekend = _isWeekend(date);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isWeekend 
                                    ? const Color(0xFF4A1A1A) 
                                    : const Color(0xFF0F3460),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isWeekend 
                                      ? Colors.red.withOpacity(0.3)
                                      : Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isWeekend 
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: isWeekend ? Colors.red[300] : Colors.blue[300],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDateDisplay(date),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          _getDayName(date),
                                          style: TextStyle(
                                            color: isWeekend ? Colors.red[300] : Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isWeekend)
                                    Icon(
                                      Icons.weekend,
                                      color: Colors.red[300],
                                      size: 16,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isWeekend(String dateString) {
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dateString);
      return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    } catch (e) {
      return false;
    }
  }

  String _formatDateDisplay(String dateString) {
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getDayName(String dateString) {
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dateString);
      return DateFormat('EEEE', 'id_ID').format(date);
    } catch (e) {
      return '';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}