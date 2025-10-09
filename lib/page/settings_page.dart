import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version.isEmpty ? '' : info.version;
      });
    } catch (_) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGradient = AppPalette.homeGradient;
    final themeC = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header gradient card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengaturan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Tema & Pembaruan Aplikasi',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white54,
                      radius: 18,
                      child: const Icon(Icons.settings, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Theme section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Obx(() {
                          final selected = themeC.mode.value;
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.brightness_6_rounded),
                                title: const Text('Tema'),
                                subtitle: Text(
                                  _labelForMode(selected),
                                  style: Theme.of(
                                    context,
                                  ).listTileTheme.subtitleTextStyle,
                                ),
                              ),
                              const Divider(height: 1),
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.system,
                                groupValue: selected,
                                onChanged: (v) =>
                                    themeC.setMode(v ?? ThemeMode.system),
                                title: const Text('Ikuti Sistem'),
                              ),
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.light,
                                groupValue: selected,
                                onChanged: (v) =>
                                    themeC.setMode(v ?? ThemeMode.light),
                                title: const Text('Terang'),
                              ),
                              RadioListTile<ThemeMode>(
                                value: ThemeMode.dark,
                                groupValue: selected,
                                onChanged: (v) =>
                                    themeC.setMode(v ?? ThemeMode.dark),
                                title: const Text('Gelap'),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // App section
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.system_update_rounded),
                            title: const Text('Update Aplikasi'),
                            subtitle: const Text(
                              'Cek versi terbaru dan pasang pembaruan',
                            ),
                            trailing: _version.isEmpty
                                ? null
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'v$_version',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                            onTap: () => Get.toNamed('/update-checker'),
                          ),
                        ],
                      ),
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

  String _labelForMode(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Ikuti Sistem';
    }
  }
}
