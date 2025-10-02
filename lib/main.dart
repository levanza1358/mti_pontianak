import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Services
import 'services/supabase_service.dart';

// Controllers
import 'controller/login_controller.dart';

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
import 'page/surat_keluar_page.dart';
import 'page/edit_jabatan_page.dart';
import 'page/group_management_page.dart';
import 'page/supervisor_management_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      getPages: _buildRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Initialize all required controllers
  void _initializeControllers() {
    Get.put(LoginController());
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
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

      // Exception Management
      GetPage(name: '/eksepsi', page: () => const EksepsiPage()),

      // Insentif Management
      GetPage(name: '/insentif', page: () => const InsentifPage()),

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
    ];
  }
}
