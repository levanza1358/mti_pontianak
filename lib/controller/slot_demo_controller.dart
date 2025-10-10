import 'dart:math';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../controller/login_controller.dart';
import 'package:flutter/material.dart'; // Untuk Snackbar Colors

class SlotDemoController extends GetxController {
  // Dependencies
  final LoginController _loginController = Get.find<LoginController>();
  final Random _rand = Random();

  // Grid constants
  static const int cols = 6;
  static const int rows = 5;

  // 10 simbol (7 simbol + 3 angka agar lebih sulit)
  final List<String> symbols = [
    '🍒', '🍋', '🍇', '🔔', '⭐', '💎', '7️⃣',
    '1', '5', '8',
  ];

  // Bobot & nilai simbol (base)
  // Angka ditambahkan dengan bobot relatif tinggi namun nilai rendah
  // untuk menambah variasi dan menurunkan peluang kombinasi bernilai tinggi.
  final Map<String, int> symbolWeight = {
    '🍒': 24,
    '🍋': 22,
    '🍇': 20,
    '🔔': 11,
    '⭐': 5,
    '💎': 5,
    '7️⃣': 1, // sedikit lebih jarang untuk meningkatkan kesulitan
    '1': 26,
    '5': 18,
    '8': 15,
  };

  final Map<String, int> symbolValue = {
    '🍒': 1,
    '🍋': 1,
    '🍇': 2,
    '🔔': 3,
    '⭐': 4,
    '💎': 6,
    '7️⃣': 8,
    '1': 1,
    '5': 2,
    '8': 3,
  };

  // Kesulitan permanen 10 (Maksimal Sulit)
  final int difficulty = 10;
  Map<String, int> _effectiveWeight = {};
  double _multiplierScale = 1.0;
  int _payoutCap = 40;

  // State observables
  final coins = 0.obs; // dari kolom credit_slot
  final isSpinning = false.obs;
  // Grid harus diinisialisasi sebelum digunakan di UI
  final grid = <List<String>>[].obs;
  final matched = <List<bool>>[].obs;
  final isLoadingLeaderboard = false.obs;
  final leaderboard = <Map<String, dynamic>>[].obs;
  // Hasil terakhir (untuk label Menang/Kalah di UI)
  final lastOutcomeLabel = ''.obs; // contoh: "Menang +3" atau "Kalah" atau "Koin habis"
  final lastOutcomeIsWin = false.obs;

  @override
  void onInit() {
    super.onInit();
    _recomputeGameParams();
    // Inisialisasi grid dan matched dengan data awal
    grid.value =
        List.generate(rows, (_) => List.generate(cols, (_) => _pickSymbol()));
    matched.value =
        List.generate(rows, (_) => List.generate(cols, (_) => false));
    loadCredit();
    // Leaderboard akan di-refresh ketika tab-nya diakses
  }

  /// Menghitung ulang bobot simbol dan skala hadiah berdasarkan difficulty.
  void _recomputeGameParams() {
    _effectiveWeight = Map<String, int>.from(symbolWeight);
    final h = (difficulty.clamp(1, 10)) / 10.0; // 1.0 untuk sulit maksimal

    // Kurangi peluang simbol bernilai tinggi
    for (final s in ['⭐', '💎', '7️⃣']) {
      final w = _effectiveWeight[s] ?? 0;
      final reduced = (w * (1 - 0.5 * h)).round();
      _effectiveWeight[s] = max(1, reduced);
    }
    // Naikkan peluang simbol bernilai rendah
    for (final s in ['🍒', '🍋', '🍇', '1', '5', '8']) {
      final w = _effectiveWeight[s] ?? 0;
      final increased = (w * (1 + 0.12 * h)).round();
      _effectiveWeight[s] = max(1, increased);
    }

    // Skala multiplier hadiah (turun karena kesulitan tinggi)
    _multiplierScale = (1.0 - 0.05 * (difficulty - 5)).clamp(0.6, 1.25);
    // Batasi payout per putaran
    _payoutCap = (40 - (10 * h)).round();
  }

  /// Memilih simbol berdasarkan bobot efektif yang sudah disesuaikan.
  String _pickSymbol() {
    if (_effectiveWeight.isEmpty) _recomputeGameParams();
    final total = _effectiveWeight.values.fold<int>(0, (a, b) => a + b);
    int r = _rand.nextInt(total);
    for (final e in _effectiveWeight.entries) {
      r -= e.value;
      if (r < 0) return e.key;
    }
    return symbols.first;
  }

  /// Memuat saldo koin dari Supabase.
  Future<void> loadCredit() async {
    try {
      final user = _loginController.currentUser.value;
      if (user == null) return;
      final result = await SupabaseService.instance.client
          .from('users')
          .select('credit_slot')
          .eq('id', user['id'])
          .single();
      coins.value = (result['credit_slot'] ?? 0) as int;
    } catch (e) {
      // Jika gagal memuat dari DB, gunakan fallback 50 jika koin saat ini 0
      if (coins.value == 0) coins.value = 50;
    }
  }

  /// Menyimpan saldo koin ke Supabase.
  Future<void> _persistCredit(int newCredit) async {
    try {
      final user = _loginController.currentUser.value;
      if (user == null) return;
      await SupabaseService.instance.client
          .from('users')
          .update({'credit_slot': newCredit}).eq('id', user['id']);
    } catch (_) {/* Abaikan error penyimpanan kecil */}
  }

  /// Mengevaluasi grid hasil putaran dan menghitung kemenangan.
  int _evaluateGrid(List<List<String>> g) {
    // Reset matched state
    matched.value =
        List.generate(rows, (_) => List.generate(cols, (_) => false));
    int total = 0;
    int runs = 0;

    int rewardForRun(String symbol, int len) {
      final base = symbolValue[symbol] ?? 0;
      int mult;
      if (len >= 5) {
        mult = 6;
      } else if (len == 4) {
        mult = 4;
      } else if (len == 3) {
        mult = 2;
      } else {
        mult = 0;
      }
      return base * mult;
    }

    void awardRun(String symbol, int len) {
      final r = (rewardForRun(symbol, len) * _multiplierScale).round();
      if (r <= 0) return;
      runs++;
      // Kemenangan berikutnya mendapat 70% dari nilai penuh
      final adjusted = runs == 1 ? r : (r * 0.7).round();
      total += adjusted;
    }

    // List sementara untuk menampung posisi yang match (untuk update matched.value)
    final tempMatched =
        List.generate(rows, (_) => List.generate(cols, (_) => false));

    // Horizontal check
    for (int r = 0; r < rows; r++) {
      int run = 1;
      int start = 0;
      for (int c = 1; c < cols; c++) {
        if (g[r][c] == g[r][c - 1]) {
          run++;
        } else {
          if (run >= 3) {
            for (int x = start; x <= c - 1; x++) {
              tempMatched[r][x] = true;
            }
            awardRun(g[r][start], run);
          }
          run = 1;
          start = c;
        }
      }
      if (run >= 3) {
        for (int x = start; x <= cols - 1; x++) {
          tempMatched[r][x] = true;
        }
        awardRun(g[r][start], run);
      }
    }

    // Vertical check
    for (int c = 0; c < cols; c++) {
      int run = 1;
      int start = 0;
      for (int r = 1; r < rows; r++) {
        if (g[r][c] == g[r - 1][c]) {
          run++;
        } else {
          if (run >= 3) {
            for (int y = start; y <= r - 1; y++) {
              tempMatched[y][c] = true;
            }
            awardRun(g[start][c], run);
          }
          run = 1;
          start = r;
        }
      }
      if (run >= 3) {
        for (int y = start; y <= rows - 1; y++) {
          tempMatched[y][c] = true;
        }
        awardRun(g[start][c], run);
      }
    }

    // Update matched state (memastikan update UI terjadi)
    matched.value = tempMatched;

    // Batasi payout per putaran
    total = min(total, _payoutCap);
    return total;
  }

  /// Memulai proses putaran (spin) slot.
  Future<void> spin() async {
    if (isSpinning.value) return;
    // Biaya per putaran: 3 koin
    const int costPerSpin = 3;
    if (coins.value < costPerSpin) {
      // Tampilkan label di UI saat koin tidak cukup
      lastOutcomeLabel.value = 'Koin tidak cukup';
      lastOutcomeIsWin.value = false;
      return;
    }

    // 1. Persiapan Spin
    isSpinning.value = true;
    coins.value -= costPerSpin; // Biaya putar 3 koin
    matched.value = List.generate(
        rows, (_) => List.generate(cols, (_) => false)); // Reset highlight
    await _persistCredit(coins.value);

    // 2. Animasi putaran
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      // Update grid.value secara langsung untuk memicu UI update
      grid.value =
          List.generate(rows, (_) => List.generate(cols, (_) => _pickSymbol()));
    }

    // 3. Hasil akhir
    final end =
        List.generate(rows, (_) => List.generate(cols, (_) => _pickSymbol()));
    final win = _evaluateGrid(end);

    grid.value = end; // Tampilkan hasil akhir
    isSpinning.value = false;

    // 4. Proses kemenangan
    if (win > 0) {
      coins.value += win;
      await _persistCredit(coins.value);
      // Update label hasil menang
      lastOutcomeLabel.value = 'Menang +$win';
      lastOutcomeIsWin.value = true;
      refreshLeaderboard(); // Segera refresh leaderboard
    } else {
      // Update label hasil kalah
      lastOutcomeLabel.value = 'Kalah';
      lastOutcomeIsWin.value = false;
    }
  }

  /// Memuat data leaderboard dari Supabase.
  Future<void> refreshLeaderboard() async {
    try {
      isLoadingLeaderboard.value = true;
      final result = await SupabaseService.instance.client
          .from('users')
          .select('name, nrp, credit_slot')
          .order('credit_slot', ascending: false)
          .limit(50);
      leaderboard.value = List<Map<String, dynamic>>.from(result);
    } catch (_) {
      leaderboard.clear();
      // Tampilkan error jika diperlukan, tapi untuk leaderboard cukup clear data
    } finally {
      isLoadingLeaderboard.value = false;
    }
  }
}
