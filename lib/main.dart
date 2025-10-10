import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Services
import 'services/supabase_service.dart';

// Controllers
import 'controller/login_controller.dart';
import 'controller/home_controller.dart';

// Pages
import 'page/login_page.dart';
import 'page/home_page.dart';
import 'page/data_management_page.dart';
import 'page/add_pegawai_page.dart';
import 'page/add_jabatan_page.dart';
import 'page/edit_data_page.dart';
import 'page/cuti_page.dart';
import 'page/eksepsi_page.dart';
import 'page/calendar_cuti_page.dart';
import 'page/insentif_page.dart';
import 'page/semua_insentif_page.dart';
import 'page/surat_keluar_page.dart';
import 'page/edit_jabatan_page.dart';
import 'page/group_management_page.dart';
import 'page/supervisor_management_page.dart';
import 'page/semua_data_cuti_page.dart';
import 'page/semua_data_eksepsi_page.dart';
import 'page/update_checker_page.dart';
import 'page/settings_page.dart';
import 'page/slot_demo_page.dart';
import 'controller/theme_controller.dart';
import 'theme/app_tokens.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale for Intl (Android/Web)
  await initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';

  // Initialize Supabase
  await SupabaseService.initialize();

  // Test Supabase connection
  await SupabaseService.instance.testConnection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeControllers();

    return GetMaterialApp(
      title: 'MTI Pontianak',
      theme: _buildAppTheme(),
      darkTheme: _buildDarkAppTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      getPages: _buildRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Initialize all required controllers
  void _initializeControllers() {
    Get.put(LoginController());
    // Ensure HomeController is available for HomePage
    Get.put(HomeController());
    Get.put(ThemeController(), permanent: true);
  }

  /// Build application theme
  ThemeData _buildAppTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF2563EB),
      colorScheme: _buildColorScheme(),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: _buildAppBarTheme(),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      filledButtonTheme: _buildFilledButtonTheme(),
      iconTheme: const IconThemeData(color: Color(0xFF64748B)),
      hintColor: const Color(0xFF6B7280),
      extensions: const <ThemeExtension<dynamic>>[
        AppTokens.light,
      ],
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFF1F2937)),
        displayMedium: TextStyle(color: Color(0xFF1F2937)),
        displaySmall: TextStyle(color: Color(0xFF1F2937)),
        headlineLarge: TextStyle(color: Color(0xFF1F2937)),
        headlineMedium: TextStyle(color: Color(0xFF1F2937)),
        headlineSmall: TextStyle(color: Color(0xFF1F2937)),
        titleLarge: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFF1F2937)),
        bodyMedium: TextStyle(color: Color(0xFF1F2937)),
        bodySmall: TextStyle(color: Color(0xFF374151)),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Color(0xFF1F2937)),
        labelSmall: TextStyle(color: Color(0xFF1F2937)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        labelStyle: const TextStyle(color: Color(0xFF374151)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: const Color(0xFF64748B),
        suffixIconColor: const Color(0xFF64748B),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFF64748B),
        textColor: Color(0xFF2D3748),
        subtitleTextStyle: TextStyle(color: Color(0xFF718096), fontSize: 12),
      ),
    );
  }

  /// Build dark theme
  ThemeData _buildDarkAppTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF93C5FD),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA),
        secondary: Color(0xFF34D399),
        surface: Color(0xFF0F172A),
        error: Color(0xFFF87171),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFE5E7EB),
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF111827),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF60A5FA),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF60A5FA),
          side: const BorderSide(color: Color(0xFF60A5FA), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF60A5FA),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFCBD5E1)),
      hintColor: const Color(0xFF94A3B8),
      extensions: const <ThemeExtension<dynamic>>[
        AppTokens.dark,
      ],
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFE5E7EB)),
        displayMedium: TextStyle(color: Color(0xFFE5E7EB)),
        displaySmall: TextStyle(color: Color(0xFFE5E7EB)),
        headlineLarge: TextStyle(color: Color(0xFFE5E7EB)),
        headlineMedium: TextStyle(color: Color(0xFFE5E7EB)),
        headlineSmall: TextStyle(color: Color(0xFFE5E7EB)),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFFE5E7EB)),
        bodyMedium: TextStyle(color: Color(0xFFE5E7EB)),
        bodySmall: TextStyle(color: Color(0xFFCBD5E1)),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Color(0xFFE5E7EB)),
        labelSmall: TextStyle(color: Color(0xFFE5E7EB)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        labelStyle: const TextStyle(color: Color(0xFFE5E7EB)),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIconColor: const Color(0xFF94A3B8),
        suffixIconColor: const Color(0xFF94A3B8),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFFCBD5E1),
        textColor: Color(0xFFE5E7EB),
        subtitleTextStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
      ),
    );
  }

  /// Build color scheme
  ColorScheme _buildColorScheme() {
    return const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF10B981),
      surface: Color(0xFFF8FAFC),
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1F2937),
      onError: Colors.white,
    );
  }

  /// Build AppBar theme
  AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: Color(0xFF2563EB),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  /// Build Card theme
  CardThemeData _buildCardTheme() {
    return const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  /// Build ElevatedButton theme
  ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: const Color(0x1A000000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Build TextButton theme
  TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF2563EB),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Build OutlinedButton theme
  OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2563EB),
        side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Build FilledButton theme (Material 3)
  FilledButtonThemeData _buildFilledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Build application routes
  List<GetPage> _buildRoutes() {
    return [
      // Authentication
      GetPage(name: '/login', page: () => const LoginPage()),

      // Main Pages
      GetPage(name: '/home', page: () => const HomePage()),

      // Data Management
      GetPage(name: '/data-management', page: () => const DataManagementPage()),
      GetPage(
        name: '/data-management/add-pegawai',
        page: () => const AddPegawaiPage(),
      ),
      GetPage(
        name: '/data-management/add-jabatan',
        page: () => const AddJabatanPage(),
      ),
      GetPage(name: '/data-management/edit', page: () => const EditDataPage()),
      GetPage(
        name: '/data-management/edit-jabatan',
        page: () => const EditJabatanPage(),
      ),

      // Leave Management
      GetPage(name: '/cuti', page: () => const CutiPage()),
      GetPage(name: '/calendar-cuti', page: () => const CalendarCutiPage()),
      GetPage(name: '/all-cuti', page: () => const SemuaDataCutiPage()),
      GetPage(name: '/all-eksepsi', page: () => const SemuaDataEksepsiPage()),

      // Exception Management
      GetPage(name: '/eksepsi', page: () => const EksepsiPage()),

      // Insentif Management
      GetPage(name: '/insentif', page: () => const InsentifPage()),
      GetPage(name: '/all-insentif', page: () => const SemuaInsentifPage()),

      // Surat Keluar Management
      GetPage(name: '/surat-keluar', page: () => const SuratKeluarPage()),

      // Group Management
      GetPage(
        name: '/group-management',
        page: () => const GroupManagementPage(),
      ),

      // Supervisor Management
      GetPage(
        name: '/supervisor-management',
        page: () => const SupervisorManagementPage(),
      ),

      // Update Checker
      GetPage(name: '/update-checker', page: () => const UpdateCheckerPage()),

      // Settings
      GetPage(name: '/settings', page: () => const SettingsPage()),

      // Fun Demo
      GetPage(name: '/slot-demo', page: () => const SlotDemoPage()),
    ];
  }
}
