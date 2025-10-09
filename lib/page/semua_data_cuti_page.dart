import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/semua_data_cuti_controller.dart';
import '../theme/app_tokens.dart';
import '../theme/app_spacing.dart';

class SemuaDataCutiPage extends StatelessWidget {
  const SemuaDataCutiPage({super.key});

  // Helpers untuk pemformatan agar penulisan rapi
  String _monthName(int m) {
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return bulan[(m - 1).clamp(0, 11)];
  }

  String _formatDateIso(String iso, {bool includeTime = true}) {
    if (iso.isEmpty) return '-';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final dd = d.day.toString().padLeft(2, '0');
    final mm = _monthName(d.month);
    final yy = d.year;
    if (!includeTime) return '$dd $mm $yy';
    final hh = d.hour.toString().padLeft(2, '0');
    final nn = d.minute.toString().padLeft(2, '0');
    return '$dd $mm $yy, $hh:$nn';
  }

  String _formatTanggalList(String csv) {
    if (csv.isEmpty) return '-';
    final parts = csv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '-';
    final formatted = parts.map((p) {
      final d = DateTime.tryParse(p);
      if (d == null) return p;
      final dd = d.day.toString().padLeft(2, '0');
      final mm = _monthName(d.month);
      final yy = d.year;
      return '$dd $mm $yy';
    }).toList();
    return formatted.join(', ');
  }

  // Bangun tampilan chip untuk daftar tanggal cuti agar lebih menarik
  Widget _buildTanggalChips(String csv, AppTokens t) {
    final parts = csv
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return Text('-', style: TextStyle(fontSize: 12, color: t.textSecondary));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: parts.map((p) {
        final d = DateTime.tryParse(p);
        final dd = d?.day.toString().padLeft(2, '0');
        final mm = d != null ? _monthName(d.month) : null;
        final yy = d?.year;
        final label = (dd != null && mm != null && yy != null) ? '$dd $mm $yy' : p;

        return Chip(
          label: Text(label),
          backgroundColor: t.cutiAllGradient.first.withOpacity(0.12),
          labelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: t.cutiAllGradient.first,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: t.cutiAllGradient.first.withOpacity(0.30),
              width: 0.8,
            ),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SemuaDataCutiController());
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: t.cutiAllGradient
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
                    colors: t.cutiAllGradient,
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
                    // Data terfilter per-bulan
                    final currentList = controller.cutiForSelectedMonth;

                    Widget content;
                    if (controller.isLoadingList.value) {
                      content = Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            t.cutiAllGradient.first,
                          ),
                        ),
                      );
                    } else if (currentList.isEmpty) {
                      content = Container(
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
                              Icon(Icons.event_busy, color: t.cutiAllGradient.first, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada data cuti untuk ${controller.monthLabel()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: t.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ubah bulan dengan tombol navigasi di atas',
                                style: TextStyle(color: t.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      content = RefreshIndicator(
                        onRefresh: controller.refreshData,
                        child: ListView.builder(
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final item = currentList[index];
                          final nama = (item['nama'] ?? '') as String;
                          final alasan = (item['alasan_cuti'] ?? '-') as String;
                          final lama = item['lama_cuti']?.toString() ?? '-';
                          final tanggalPengajuan = (item['tanggal_pengajuan'] ?? '') as String;
                          final tanggalList = (item['list_tanggal_cuti'] ?? '') as String;
                          final locked = (item['kunci_cuti'] ?? false) as bool;

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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: t.cutiAllGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: t.shadowColor,
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    (lama.isEmpty || lama == '-') ? '-' : lama,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                nama.isEmpty ? '-' : nama,
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
                                      Icon(Icons.schedule, size: 14, color: t.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _formatDateIso(tanggalPengajuan, includeTime: true),
                                          style: TextStyle(fontSize: 12, color: t.textSecondary),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 14, color: t.textSecondary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: _buildTanggalChips(tanggalList, t),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.timelapse, size: 14, color: t.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$lama hari',
                                      style: TextStyle(fontSize: 12, color: t.textSecondary),
                                    ),
                                  ],
                                ),
                                // Baris alasan dihapus sesuai permintaan
                              ],
                            ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        locked ? Icons.lock : Icons.lock_open,
                                        color: controller.getLockColor(locked),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        locked ? 'Terkunci' : 'Terbuka',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: controller.getLockColor(locked),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () => controller.showForceDeleteConfirmation(item),
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: t.dangerFg,
                                    ),
                                    tooltip: 'Hapus paksa',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      );
                    }

                    // Navigasi bulan (mundur/maju)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: t.card,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: t.shadowColor,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: controller.prevMonth,
                                icon: const Icon(Icons.chevron_left),
                                color: t.textPrimary,
                                tooltip: 'Bulan sebelumnya',
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    controller.monthLabel(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: t.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: controller.nextMonth,
                                icon: const Icon(Icons.chevron_right),
                                color: t.textPrimary,
                                tooltip: 'Bulan berikutnya',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(child: content),
                      ],
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
