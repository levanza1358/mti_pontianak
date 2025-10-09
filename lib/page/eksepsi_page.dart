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
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildHeaderCard(
                      theme: theme,
                      tokens: tokens,
                      accentGradient: accentGradient,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTabSelector(
                      controller: controller,
                      theme: theme,
                      tokens: tokens,
                      accent: accent,
                      accentAlt: accentAlt,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      _buildEksepsiForm(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard({
    required ThemeData theme,
    required AppTokens tokens,
    required List<Color> accentGradient,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: accentGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tokens.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withAlpha(
                (0.18 * 255).round(),
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withAlpha(
                  (0.28 * 255).round(),
                ),
              ),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengajuan Eksepsi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Ajukan eksepsi jam kerja dan pantau statusnya.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onPrimary.withAlpha(
                      (0.88 * 255).round(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withAlpha(
                (0.18 * 255).round(),
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withAlpha(
                  (0.28 * 255).round(),
                ),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(
              Icons.schedule_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector({
    required EksepsiController controller,
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tokens.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: tokens.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: controller.tabController,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: tokens.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, accentAlt],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            icon: Icon(Icons.add_circle_outline_rounded),
            text: 'Ajukan Eksepsi',
          ),
          Tab(icon: Icon(Icons.history_rounded), text: 'Riwayat Saya'),
        ],
      ),
    );
  }

  Widget _buildEksepsiForm(
    EksepsiController controller,
    ThemeData theme,
    AppTokens tokens,
    Color accent,
    Color accentAlt,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      child: Form(
        key: controller.eksepsiFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              theme: theme,
              tokens: tokens,
              accent: accent,
              accentAlt: accentAlt,
              subtitle: controller.jenisEksepsi,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Container(
                decoration: _cardDecoration(tokens),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: accent),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Tanggal Eksepsi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: tokens.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: controller.addEksepsiEntry,
                          style: TextButton.styleFrom(
                            foregroundColor: accent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Tambah'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
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
                                padding: EdgeInsets.zero,
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
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
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
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required AppTokens tokens,
    required Color accent,
    required Color accentAlt,
    required String subtitle,
  }) {
    return Container(
      decoration: _cardDecoration(tokens),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accentAlt],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Eksepsi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: tokens.textSecondary),
                ),
              ],
            ),
          ),
        ],
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
      decoration: _cardDecoration(tokens),
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
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
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
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: _cardDecoration(tokens),
            child: Row(
              children: [
                _buildHistoryIcon(accent, accentAlt, theme),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Riwayat Eksepsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Pantau status pengajuan eksepsi Anda.',
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.refreshData,
                  icon: Icon(Icons.refresh_rounded, color: accent),
                  tooltip: 'Muat ulang data',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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
                padding: EdgeInsets.zero,
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

  Widget _buildHistoryIcon(Color accent, Color accentAlt, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accentAlt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.history_rounded, color: theme.colorScheme.onPrimary),
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
      decoration: _cardDecoration(tokens),
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
        borderSide: BorderSide(color: tokens.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: tokens.borderSubtle),
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

  BoxDecoration _cardDecoration(AppTokens tokens) {
    return BoxDecoration(
      color: tokens.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tokens.borderSubtle),
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
    final List<String> tanggalArray = tanggalList.isEmpty
        ? []
        : tanggalList.split(', ');

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
