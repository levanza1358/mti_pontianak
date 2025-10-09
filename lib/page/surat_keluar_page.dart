import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/surat_keluar_controller.dart';
import 'package:intl/intl.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tokens.dart';

class SuratKeluarPage extends StatelessWidget {
  const SuratKeluarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SuratKeluarController controller = Get.put(SuratKeluarController());
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;

    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                gradient: LinearGradient(
                  colors: tokens.eksepsiGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tokens.shadowColor,
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
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(AppSpacing.md),
                        ),
                      ),
                      // Title Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Surat Keluar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Kelola surat keluar perusahaan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mail Icon
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                        ),
                        child: const Icon(
                          Icons.mail_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Tab Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      indicator: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(AppSpacing.md - 2),
                      ),
                      indicatorPadding: const EdgeInsets.all(AppSpacing.xs),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      dividerColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      splashFactory: NoSplash.splashFactory,
                      tabs: const [
                        Tab(text: 'Buat Surat'),
                        Tab(text: 'History'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildFormTab(controller, theme),
                  _buildHistoryTab(controller, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTab(SuratKeluarController controller, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Info Card
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.extension<AppTokens>()!.card,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                boxShadow: [
                  BoxShadow(
                    color: theme.extension<AppTokens>()!.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.extension<AppTokens>()!.chipBg,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: theme.extension<AppTokens>()!.chipFg,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Lengkapi semua informasi surat keluar dengan benar',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.extension<AppTokens>()!.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main Form Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.extension<AppTokens>()!.card,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                boxShadow: [
                  BoxShadow(
                    color: theme.extension<AppTokens>()!.shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildModernTextField(
                    controller: controller.namaPerusahaanController,
                    label: 'Nama Perusahaan',
                    icon: Icons.business,
                    validator: (value) =>
                        controller.validateRequired(value, 'Nama Perusahaan'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildModernTextField(
                    controller: controller.judulSuratController,
                    label: 'Judul Surat',
                    icon: Icons.title,
                    validator: (value) =>
                        controller.validateRequired(value, 'Judul Surat'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildModernTextField(
                    controller: controller.deskripsiSuratController,
                    label: 'Deskripsi Surat',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) =>
                        controller.validateRequired(value, 'Deskripsi Surat'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildModernTextField(
                    controller: controller.nomorSuratController,
                    label: 'Nomor Surat (Optional)',
                    icon: Icons.numbers,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildModernTextField(
                    controller: controller.tanggalKirimController,
                    label: 'Tanggal Kirim Surat',
                    icon: Icons.calendar_month,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: Get.context!,
                        initialDate:
                            controller.selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        controller.selectedDate.value = date;
                        controller.tanggalKirimController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(date);
                      }
                    },
                    validator: (value) => controller.validateRequired(
                      value,
                      'Tanggal Kirim Surat',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  // Modern Signature Section
                  _buildSignatureSection(controller),
                  const SizedBox(height: AppSpacing.section),
                  Obx(
                    () => Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: theme.extension<AppTokens>()!.eksepsiGradient,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.md),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, color: Colors.white),
                                  SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Simpan Surat',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(SuratKeluarController controller, ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        );
      }

      if (controller.suratKeluarList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.extension<AppTokens>()!.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.mail_outline,
                  size: 64,
                  color: theme.extension<AppTokens>()!.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada data surat keluar',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.extension<AppTokens>()!.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Buat surat keluar pertama Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.extension<AppTokens>()!.textMuted,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: controller.suratKeluarList.length,
        itemBuilder: (context, index) {
          final surat = controller.suratKeluarList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.extension<AppTokens>()!.card,
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              boxShadow: [
                BoxShadow(
                  color: theme.extension<AppTokens>()!.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showDetailDialog(context, surat, theme),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.extension<AppTokens>()!.chipBg,
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                        ),
                        child: Icon(
                          Icons.business,
                          color: theme.extension<AppTokens>()!.chipFg,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surat['nama_perusahaan'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.extension<AppTokens>()!.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              surat['judul_surat'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.extension<AppTokens>()!.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.extension<AppTokens>()!.chipBg,
                                borderRadius: BorderRadius.circular(AppSpacing.sm),
                              ),
                              child: Text(
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(DateTime.parse(surat['created_at'])),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.extension<AppTokens>()!.chipFg,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _showDetailDialog(
    BuildContext context,
    Map<String, dynamic> surat,
    ThemeData theme,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.lg),
        ),
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Surat Keluar',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.extension<AppTokens>()!.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: theme.extension<AppTokens>()!.textPrimary,
                    ),
                  ),
                ],
              ),
              Divider(color: theme.extension<AppTokens>()!.borderSubtle),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Nama Perusahaan',
                        surat['nama_perusahaan'] ?? '-',
                        theme,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Judul Surat',
                        surat['judul_surat'] ?? '-',
                        theme,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Deskripsi Surat',
                        surat['deskripsi_surat'] ?? '-',
                        theme,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Nomor Surat',
                        surat['nomor_surat'] ?? 'Tidak ada',
                        theme,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Tanggal Dibuat',
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(DateTime.parse(surat['created_at'])),
                        theme,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tanda Tangan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (surat['url_ttd'] != null)
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              surat['url_ttd'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Gagal memuat tanda tangan'),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: const Center(
                            child: Text('Tidak ada tanda tangan'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.extension<AppTokens>()!.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.extension<AppTokens>()!.card,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: theme.extension<AppTokens>()!.borderSubtle),
          ),
          child: Text(value, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(Get.context!).extension<AppTokens>()!.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(Get.context!).colorScheme.primary),
            filled: true,
            fillColor: Theme.of(Get.context!).extension<AppTokens>()!.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              borderSide: BorderSide(color: Theme.of(Get.context!).extension<AppTokens>()!.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              borderSide: BorderSide(color: Theme.of(Get.context!).extension<AppTokens>()!.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              borderSide: BorderSide(color: Theme.of(Get.context!).colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(SuratKeluarController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).extension<AppTokens>()!.card,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: Theme.of(Get.context!).extension<AppTokens>()!.borderSubtle),
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
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(Get.context!).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Icon(
                      Icons.gesture,
                      color: Theme.of(Get.context!).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Tanda Tangan Digital',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(Get.context!).extension<AppTokens>()!.textPrimary,
                    ),
                  ),
                ],
              ),
              Obx(
                () => controller.hasSignature.value
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(Get.context!).extension<AppTokens>()!.successBg,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(Get.context!).extension<AppTokens>()!.successFg,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Tersedia',
                              style: TextStyle(
                                color: Theme.of(Get.context!).extension<AppTokens>()!.successFg,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(Get.context!).extension<AppTokens>()!.warningBg,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pending,
                              color: Theme.of(Get.context!).extension<AppTokens>()!.warningFg,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Belum ada',
                              style: TextStyle(
                                color: Theme.of(Get.context!).extension<AppTokens>()!.warningFg,
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
          const SizedBox(height: AppSpacing.lg),
          Obx(() {
            if (controller.signatureData.value != null) {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!).extension<AppTokens>()!.card,
                  border: Border.all(color: Theme.of(Get.context!).extension<AppTokens>()!.borderSubtle),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  child: Image.memory(
                    controller.signatureData.value!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            } else {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!).extension<AppTokens>()!.card,
                  border: Border.all(color: Theme.of(Get.context!).extension<AppTokens>()!.borderSubtle),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 48,
                        color: Theme.of(Get.context!).extension<AppTokens>()!.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Belum ada tanda tangan',
                        style: TextStyle(
                          color: Theme.of(Get.context!).extension<AppTokens>()!.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.clearSignature,
                  icon: const Icon(Icons.clear),
                  label: const Text('Hapus'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                    backgroundColor: Theme.of(Get.context!).colorScheme.primary,
                    foregroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
}
