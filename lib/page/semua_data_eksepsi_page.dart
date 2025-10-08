import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/semua_data_eksepsi_controller.dart';

class SemuaDataEksepsiPage extends StatelessWidget {
  const SemuaDataEksepsiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SemuaDataEksepsiController());

    const primaryGradient = [Color(0xFF667eea), Color(0xFF764ba2)];

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
              // Header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x26667eea),
                      blurRadius: 10,
                      offset: Offset(0, 4),
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
                              'SEMUA DATA EKSEPSI',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Daftar seluruh pengajuan eksepsi',
                              style: TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: controller.refreshData,
                          icon: const Icon(Icons.refresh, color: Colors.white),
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

                    if (controller.eksepsiList.isEmpty) {
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
                              Icon(Icons.schedule, color: Color(0xFF667eea), size: 48),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada data eksepsi',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 6),
                              Text('Data eksepsi akan tampil di sini'),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: ListView.builder(
                        itemCount: controller.eksepsiList.length,
                        itemBuilder: (context, index) {
                          final item = controller.eksepsiList[index];
                          final userName = (item['user_name'] ?? '') as String;
                          final userNrp = (item['user_nrp'] ?? '') as String;
                          final userId = (item['user_id'] ?? '') as String;
                          final jenis = (item['jenis_eksepsi'] ?? '-') as String;
                          final tanggalPengajuan = (item['tanggal_pengajuan'] ?? '') as String;
                          final tanggalList = (item['list_tanggal_eksepsi'] ?? '') as String;
                          final jumlahHari = item['jumlah_hari']?.toString() ?? '-';
                          final alasan = (item['alasan_eksepsi'] ?? '-') as String;

                          final titleText = userName.isNotEmpty
                              ? userName
                              : (userNrp.isNotEmpty ? userNrp : (userId.isNotEmpty ? userId : '-'));

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
                                child: const Icon(Icons.schedule, color: Colors.white, size: 20),
                              ),
                              title: Text(
                                titleText,
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
                                      const Icon(Icons.badge, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          jenis,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_outlined, size: 14, color: Color(0xFF718096)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          tanggalPengajuan.toString(),
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '$jumlahHari hari',
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
                                          alasan.isEmpty ? '-' : alasan,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
                                        ),
                                      ),
                                    ],
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
