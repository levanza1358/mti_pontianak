// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_tokens.dart';
import '../controller/slot_demo_controller.dart';

// SlotDemoPage kini hanya bertanggung jawab untuk membangun UI.
// Semua logika state dan interaksi data ada di SlotDemoController.
class SlotDemoPage extends StatefulWidget {
  const SlotDemoPage({super.key});

  @override
  State<SlotDemoPage> createState() => _SlotDemoPageState();
}

class _SlotDemoPageState extends State<SlotDemoPage>
    with SingleTickerProviderStateMixin {
  // Controller diinisialisasi dan ditemukan di sini
  late final SlotDemoController _c;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Mengambil atau membuat instance controller.
    // Jika belum ada, Get.put() akan membuatnya (seperti di kode awal Anda).
    _c = Get.put(SlotDemoController());

    // Controller UI-specific
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPlayTab(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    // Menggunakan Obx untuk mendengarkan perubahan state dari controller
    return Obx(() {
      final isSpinning = _c.isSpinning.value;
      final coins = _c.coins.value;
      final outcomeText = _c.lastOutcomeLabel.value;
      final outcomeIsWin = _c.lastOutcomeIsWin.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Card(
          elevation: isDark ? 0 : 3,
          shadowColor: isDark ? t.shadowColor : t.shadowColor.withOpacity(0.25),
          color: t.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: t.borderSubtle),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display Credit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Credit Slot', style: theme.textTheme.titleMedium),
                        const SizedBox(width: 8),
                        // [DIUBAH] Menggunakan IconButton sederhana yang memanggil handleRefreshTap
                        IconButton(
                          tooltip:
                              'Refresh credit (tap 5x saat kredit 0 untuk reset)',
                          // Memanggil metode controller yang baru
                          onPressed: isSpinning ? null : _c.handleRefreshTap,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                        ),
                        if (outcomeText.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (outcomeIsWin ? Colors.green : Colors.red)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: outcomeIsWin ? Colors.green : Colors.red,
                              ),
                            ),
                            child: Text(
                              outcomeText,
                              style: TextStyle(
                                color: outcomeIsWin ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        coins.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Grid Slot - Dibuat tetap 6 kolom dan terpusat
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            SlotDemoController.cols, // FIX: Selalu 6 kolom
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0, // Membuat item menjadi kotak
                      ),
                      itemCount:
                          SlotDemoController.rows * SlotDemoController.cols,
                      itemBuilder: (context, index) {
                        final r = index ~/ SlotDemoController.cols;
                        final c = index % SlotDemoController.cols;

                        // Mengakses state grid dari controller
                        final sym = _c.grid.value[r][c];
                        // Mengakses state matched dari controller
                        final isMatch = !isSpinning && _c.matched.value[r][c];

                        final bgColor = isMatch
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.18)
                            : (isDark ? t.surface : t.elevatedCard);
                        final borderColor = isMatch
                            ? Theme.of(context).colorScheme.primary
                            : t.borderSubtle;

                        return AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isMatch ? 1.06 : 1.0,
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: borderColor, width: isMatch ? 2 : 1),
                              boxShadow: [
                                BoxShadow(
                                  color: t.shadowColor.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              sym,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Spin Button
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      // Memanggil metode spin dari controller (butuh minimal 2 koin)
                      onPressed: (isSpinning || coins < 2) ? null : _c.spin,
                      icon: const Icon(Icons.casino_rounded),
                      label: Text(isSpinning ? 'Memutar...' : 'Putar'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Catatan: ini hanya simulasi hiburan, tidak melibatkan uang sungguhan.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: t.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLeaderboardTab(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;

    return Card(
      elevation: 0,
      color: t.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: t.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Leaderboard', style: theme.textTheme.titleMedium),
                IconButton(
                  tooltip: 'Refresh leaderboard',
                  // Memanggil metode controller untuk refresh
                  onPressed: _c.refreshLeaderboard,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Menggunakan Obx untuk mendengarkan state leaderboard dari controller
            Expanded(
              child: Obx(() {
                if (_c.isLoadingLeaderboard.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = _c.leaderboard.value;
                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada data leaderboard',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: t.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => Divider(color: t.borderSubtle),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final name = (item['name'] ?? '').toString();
                    final nrp = (item['nrp'] ?? '').toString();
                    final credit =
                        int.tryParse('${item['credit_slot'] ?? 0}') ?? 0;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.12),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      title: Text(name.isNotEmpty ? name : '(Tanpa nama)'),
                      subtitle: nrp.isNotEmpty ? Text(nrp) : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.savings_rounded, size: 18),
                          const SizedBox(width: 6),
                          Text('$credit'),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.extension<AppTokens>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: isDark ? 0 : 4,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? t.insentifGradient : t.homeGradient,
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
        title: const Text(
          'Slot',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            // Samakan dengan Pengajuan Cuti
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (i) {
                  if (i == 1) _c.refreshLeaderboard();
                },
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: t.shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                // Samakan dengan Pengajuan Cuti: gunakan aksen pertama cuti
                labelColor: t.cutiAllGradient.first,
                unselectedLabelColor: Colors.white.withOpacity(0.85),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(text: 'Main'),
                  Tab(text: 'Leaderboard'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlayTab(context),
              _buildLeaderboardTab(context),
            ],
          ),
        ),
      ),
    );
  }
}
