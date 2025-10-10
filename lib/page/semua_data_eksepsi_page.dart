// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/semua_data_eksepsi_controller.dart';
import '../theme/app_tokens.dart';

class SemuaDataEksepsiPage extends StatelessWidget {
  const SemuaDataEksepsiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SemuaDataEksepsiController());
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = t.eksepsiGradient;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: accentGradient
                .map((c) => c.withOpacity(isDark ? 0.08 : 0.14))
                .toList(),
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: accentGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: t.shadowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
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
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white54,
                        radius: 18,
                        child: IconButton(
                          onPressed: controller.refreshData,
                          icon: const Icon(Icons.refresh,
                              color: Colors.white, size: 18),
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
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              accentGradient.first),
                        ),
                      );
                    }

                    if (controller.eksepsiList.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: t.card,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: t.shadowColor,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule,
                                  color: accentGradient.first, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada data eksepsi',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: t.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text('Data eksepsi akan tampil di sini',
                                  style: TextStyle(color: t.textSecondary)),
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
                          final jenis =
                              (item['jenis_eksepsi'] ?? '-') as String;
                          final tanggalPengajuan =
                              (item['tanggal_pengajuan'] ?? '') as String;
                          final tanggalList =
                              (item['list_tanggal_eksepsi'] ?? '') as String;
                          final jumlahHari =
                              item['jumlah_hari']?.toString() ?? '-';
                          final alasan =
                              (item['alasan_eksepsi'] ?? '-') as String;

                          final titleText = userName.isNotEmpty
                              ? userName
                              : (userNrp.isNotEmpty
                                  ? userNrp
                                  : (userId.isNotEmpty ? userId : '-'));

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: t.card,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: t.shadowColor,
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
                                  gradient: LinearGradient(
                                    colors: accentGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.schedule,
                                    color: Colors.white, size: 20),
                              ),
                              title: Text(
                                titleText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: t.textPrimary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.badge,
                                          size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          jenis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: t.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.schedule_outlined,
                                          size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          tanggalPengajuan.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: t.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          tanggalList.isEmpty
                                              ? '-'
                                              : tanggalList.replaceAll(
                                                  ',', ', '),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: t.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.timelapse,
                                          size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$jumlahHari hari',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: t.textSecondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.notes,
                                          size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          alasan.isEmpty ? '-' : alasan,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: t.textSecondary),
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
