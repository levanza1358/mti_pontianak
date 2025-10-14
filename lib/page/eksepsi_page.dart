import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/eksepsi_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';
import 'pdf_eksepsi_page.dart';

class EksepsiPage extends StatelessWidget {
  const EksepsiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EksepsiController());
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;
    final accentGradient = tokens.eksepsiGradient;
    final accent = accentGradient.first;
    final accentAlt = accentGradient.last;
    final overlayFactor = isDark ? 0.08 : 0.14;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        foregroundColor: theme.colorScheme.onPrimary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: accentGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          tooltip: 'Kembali',
        ),
        titleSpacing: 0,
        title: Text(
          'Pengajuan Eksepsi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          // Pindahkan tombol Tambah Tanggal ke AppBar; tampil hanya di tab Pengajuan
          AnimatedBuilder(
            animation: controller.tabController,
            builder: (context, _) {
              final isPengajuan = controller.tabController.index == 0;
              if (!isPengajuan) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Obx(() {
                  final disabled = controller.eksepsiEntries.length >= 10;
                  return TextButton.icon(
                    onPressed: disabled ? null : controller.addEksepsiEntry,
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text(
                      'Tambah tanggal',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
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
                labelColor: accent,
                unselectedLabelColor: Colors.white.withOpacity(0.85),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: 'Pengajuan'),
                  Tab(text: 'Riwayat'),
                ],
              ),
            ),
          ),
        ),
      ),
      // Tombol tambah tanggal dipindah ke AppBar; hilangkan FAB
      // Tombol submit sticky untuk mode portrait agar selalu terlihat di Android
      bottomNavigationBar: AnimatedBuilder(
        animation: controller.tabController,
        builder: (context, _) {
          final isPengajuan = controller.tabController.index == 0;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          if (!isPengajuan || !isPortrait) return const SizedBox.shrink();
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(isDark ? 0.6 : 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : controller.submitEksepsiApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Text(
                            'Kirim Pengajuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              }),
            ),
          );
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: accentGradient
                .map((color) => color.withAlpha((overlayFactor * 255).round()))
                .toList(),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  // Gunakan padding 20px di atas, kiri, kanan
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    interactive: true,
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        _buildEksepsiForm(
                          context,
                          controller,
                          theme,
                          tokens,
                          accent,
                          accentAlt,
                        ),
                        _buildHistoryTab(
                          controller,
                          theme,
                          tokens,
                          accent,
                          accentAlt,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEksepsiForm(
    BuildContext context,
    EksepsiController controller,
    ThemeData theme,
    AppTokens tokens,
    Color accent,
    Color accentAlt,
  ) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Tata letak adaptif: mode landscape dua kolom agar scroll lebih nyaman
    return Padding(
      // Hilangkan padding bawah agar tidak ada ruang kosong ekstra
      padding: EdgeInsets.zero,
      child: Form(
        key: controller.eksepsiFormKey,
        child: isLandscape
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom kiri: daftar entri eksepsi dengan scrollbar
                  Expanded(
                    child: Container(
                      // Hilangkan padding container agar konten menyentuh tepi
                      padding: EdgeInsets.zero,
                      child: Obx(
                        () => controller.eksepsiEntries.isEmpty
                            ? _buildEmptyState(
                                tokens: tokens,
                                message:
                                    'Belum ada tanggal eksepsi yang ditambahkan.',
                                description:
                                    'Tekan tombol "Tambah" untuk menambahkan entri eksepsi.',
                              )
                            : ListView.separated(
                                primary: true,
                                padding: EdgeInsets.zero,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: controller.eksepsiEntries.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  return _buildEksepsiEntry(
                                    controller,
                                    index,
                                    theme,
                                    tokens,
                                    accent,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  // Kurangi jarak antar kolom agar lebih rapat
                  const SizedBox(width: AppSpacing.sm),
                  // Kolom kanan: informasi dan CTA selalu terlihat
                  SizedBox(
                    width: 360,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Signature Section (landscape sidebar)
                          _buildSignatureSection(controller, theme, tokens),
                          const SizedBox(height: AppSpacing.md),
                          Obx(() {
                            final isLoading = controller.isLoading.value;
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : controller.submitEksepsiApplication,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Kirim Pengajuan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      // Hilangkan padding container agar konten menyentuh tepi
                      padding: EdgeInsets.zero,
                      child: Obx(
                        () => controller.eksepsiEntries.isEmpty
                            ? _buildEmptyState(
                                tokens: tokens,
                                message:
                                    'Belum ada tanggal eksepsi yang ditambahkan.',
                                description:
                                    'Tekan tombol "Tambah" untuk menambahkan entri eksepsi.',
                              )
                            : ListView.separated(
                                primary: true,
                                padding: EdgeInsets.zero,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: controller.eksepsiEntries.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  return _buildEksepsiEntry(
                                    controller,
                                    index,
                                    theme,
                                    tokens,
                                    accent,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  // Signature Section (portrait below list)
                  _buildSignatureSection(controller, theme, tokens),
                ],
              ),
      ),
    );
  }

  Widget _buildEksepsiEntry(
    EksepsiController controller,
    int index,
    ThemeData theme,
    AppTokens tokens,
    Color accent,
  ) {
    final entry = controller.eksepsiEntries[index];
    final alasanController = entry['alasan']!;
    final tanggalController = entry['tanggal']!;

    return Container(
      decoration: _cardDecoration(tokens, theme),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eksepsi ${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              if (controller.eksepsiEntries.length > 1)
                IconButton(
                  onPressed: () => controller.removeEksepsiEntry(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: 'Hapus entri',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: tanggalController,
            decoration: _inputDecoration(
              tokens: tokens,
              theme: theme,
              accent: accent,
              label: 'Tanggal Eksepsi',
              hint: 'Pilih tanggal eksepsi',
              suffix: const Icon(Icons.calendar_today_rounded),
            ),
            readOnly: true,
            validator: controller.validateTanggalEksepsi,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime(DateTime.now().year + 10, 12, 31),
              );
              if (picked != null) {
                controller.setSelectedDate(picked, index);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: alasanController,
            maxLines: 3,
            decoration: _inputDecoration(
              tokens: tokens,
              theme: theme,
              accent: accent,
              label: 'Alasan Eksepsi',
              hint: 'Masukkan alasan eksepsi',
              alignLabelWithHint: true,
            ),
            validator: controller.validateAlasan,
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(
    EksepsiController controller,
    ThemeData theme,
    AppTokens tokens,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    return Container
    (
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tokens.borderSubtle,
          width: isDark ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: tokens.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf093fb).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.gesture,
                      color: Color(0xFFf093fb),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Tanda Tangan Digital',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tokens.textPrimary,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: (controller.hasSignature.value
                            ? Colors.green
                            : Colors.amber)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    border: Border.all(
                      color: controller.hasSignature.value
                          ? Colors.green
                          : Colors.amber,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.hasSignature.value
                            ? Icons.check_circle
                            : Icons.pending,
                        color: controller.hasSignature.value
                            ? Colors.green
                            : Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        controller.hasSignature.value
                            ? 'Tersedia'
                            : 'Belum ada',
                        style: TextStyle(
                          color: controller.hasSignature.value
                              ? Colors.green
                              : Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(() {
            final data = controller.signatureData.value;
            if (data != null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: tokens.card,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(color: tokens.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.memory(
                      data,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Preview tanda tangan',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: tokens.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.border_color,
                    color: tokens.textSecondary,
                    size: 28,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Belum ada tanda tangan',
                    style: TextStyle(
                      color: tokens.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.clearSignature,
                  icon: const Icon(Icons.clear),
                  label: const Text('Hapus'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.showSignatureDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text('Buat TTD'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    EksepsiController controller,
    ThemeData theme,
    AppTokens tokens,
    Color accent,
    Color accentAlt,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHistory.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                );
              }

              if (controller.eksepsiHistory.isEmpty) {
                return _buildEmptyState(
                  tokens: tokens,
                  message: 'Belum ada riwayat eksepsi',
                  description:
                      'Pengajuan yang sudah dibuat akan muncul di sini.',
                );
              }

              return ListView.separated(
                primary: true,
                padding: EdgeInsets.zero,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.eksepsiHistory.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = controller.eksepsiHistory[index];
                  return _buildHistoryCard(
                    controller,
                    item,
                    theme,
                    tokens,
                    accent,
                  );
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
    ThemeData theme,
    AppTokens tokens,
    Color accent,
  ) {
    final status = item['status_persetujuan'] ?? 'Menunggu';
    final statusColor = controller.getStatusColor(status);
    final statusIcon = controller.getStatusIcon(status);

    return Container(
      decoration: _cardDecoration(tokens, theme),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: InkWell(
        onTap: () => _showDetailDialog(item, theme, tokens, accent),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['jenis_eksepsi'] ?? 'Jam Masuk & Jam Pulang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Jumlah Hari: ${item['jumlah_hari'] ?? 1}',
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _navigateToPdfPreview(item),
                      icon: Icon(
                        Icons.picture_as_pdf_rounded,
                        color: theme.colorScheme.error,
                      ),
                      tooltip: 'Generate PDF',
                    ),
                    if (status.toLowerCase() == 'menunggu')
                      IconButton(
                        onPressed: () =>
                            controller.showDeleteConfirmation(item),
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        tooltip: 'Batalkan pengajuan',
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha((0.16 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 16, color: statusColor),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              'Tanggal',
              item['list_tanggal_eksepsi'] ?? '-',
              tokens,
            ),
            _buildDetailRow('Alasan', item['alasan_eksepsi'] ?? '-', tokens),
            _buildDetailRow(
              'Tanggal Pengajuan',
              item['tanggal_pengajuan'] != null
                  ? _formatDateDisplay(item['tanggal_pengajuan'])
                  : '-',
              tokens,
            ),
            if (item['catatan_persetujuan'] != null &&
                item['catatan_persetujuan'].toString().isNotEmpty)
              _buildDetailRow('Catatan', item['catatan_persetujuan'], tokens),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, AppTokens tokens) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: tokens.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required AppTokens tokens,
    required String message,
    required String description,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: tokens.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: tokens.textSecondary),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required AppTokens tokens,
    required ThemeData theme,
    required Color accent,
    required String hint,
    String? label,
    Widget? suffix,
    bool alignLabelWithHint = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final baseOutlineColor =
        isDark ? tokens.borderSubtle.withOpacity(0.9) : tokens.borderSubtle;
    final outlineWidth = isDark ? 1.4 : 1.0;

    return InputDecoration(
      hintText: hint,
      labelText: label,
      alignLabelWithHint: alignLabelWithHint,
      hintStyle: TextStyle(color: tokens.textSecondary),
      filled: true,
      fillColor: theme.inputDecorationTheme.fillColor ?? tokens.surface,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: baseOutlineColor, width: outlineWidth),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: baseOutlineColor, width: outlineWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
    );
  }

  BoxDecoration _cardDecoration(AppTokens tokens, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final borderWidth = isDark ? 1.4 : 1.0;
    return BoxDecoration(
      color: tokens.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tokens.borderSubtle, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: tokens.shadowColor,
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  void _navigateToPdfPreview(Map<String, dynamic> item) {
    Get.to(() => PdfEksepsiPage(eksepsiData: item));
  }

  void _showDetailDialog(
    Map<String, dynamic> item,
    ThemeData theme,
    AppTokens tokens,
    Color accent,
  ) {
    final tanggalList = item['list_tanggal_eksepsi'] ?? '';
    final List<String> tanggalArray =
        tanggalList.isEmpty ? [] : tanggalList.split(', ');

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail Tanggal Eksepsi'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis: ${item['jenis_eksepsi'] ?? 'Jam Masuk & Jam Pulang'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Alasan: ${item['alasan_eksepsi'] ?? '-'}',
                  style: TextStyle(color: tokens.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tanggal yang diajukan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tanggalArray.length,
                    itemBuilder: (context, index) {
                      final tanggal = tanggalArray[index].trim();
                      if (tanggal.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      DateTime? date;
                      try {
                        date = DateTime.parse(tanggal);
                      } catch (_) {}

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: accent.withAlpha((0.12 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accent.withAlpha((0.28 * 255).round()),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: accent,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                date != null
                                    ? '${_getDayName(date)}, ${DateFormat('dd MMMM yyyy').format(date)}'
                                    : tanggal,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: tokens.textPrimary,
                                ),
                              ),
                            ),
                            if (date != null && _isWeekend(date))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withAlpha(40),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Weekend',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (item['tanggal_pengajuan'] != null)
                  Text(
                    'Diajukan pada: ${_formatDateDisplay(item['tanggal_pengajuan'])}',
                    style: TextStyle(fontSize: 12, color: tokens.textSecondary),
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
    } catch (_) {
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
