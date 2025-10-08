import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/semua_data_cuti_controller.dart';
import '../theme/app_palette.dart';

class SemuaDataCutiPage extends StatelessWidget {
  const SemuaDataCutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SemuaDataCutiController());

    const primaryGradient = AppPalette.cutiAllGradient;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: primaryGradient.map((c) => c.withOpacity(0.08)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header as gradient card (like Home)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40667eea),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SEMUA DATA CUTI',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Daftar pengajuan cuti seluruh karyawan',
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white54,
                        radius: 18,
                        child: IconButton(
                          onPressed: controller.refreshData,
                          icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    if (controller.isLoadingList.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF667eea)),
                      );
                    }

                    if (controller.cutiList.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.event_busy, color: Color(0xFF667eea), size: 48),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada data cuti',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 6),
                              Text('Data cuti akan tampil di sini'),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: ListView.builder(
                        itemCount: controller.cutiList.length,
                        itemBuilder: (context, index) {
                          final item = controller.cutiList[index];
                          final nama = (item['nama'] ?? '') as String;
                          final alasan = (item['alasan_cuti'] ?? '-') as String;
                          final lama = item['lama_cuti']?.toString() ?? '-';
                          final tanggalPengajuan = (item['tanggal_pengajuan'] ?? '') as String;
                          final tanggalList = (item['list_tanggal_cuti'] ?? '') as String;
                          final locked = (item['kunci_cuti'] ?? false) as bool;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () => controller.showDetail(item),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.event_note, color: Colors.white, size: 20),
                              ),
                              title: Text(
                                nama.isEmpty ? '-' : nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          tanggalPengajuan.isEmpty
                                              ? '-'
                                              : tanggalPengajuan,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          tanggalList.isEmpty ? '-' : tanggalList.replaceAll(',', ', '),
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.timelapse, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$lama hari',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.notes, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          alasan,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    locked ? Icons.lock : Icons.lock_open,
                                    color: controller.getLockColor(locked),
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    locked ? 'Terkunci' : 'Terbuka',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: controller.getLockColor(locked),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
