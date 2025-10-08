import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class HomeController extends GetxController {
  final LoginController authController = Get.find<LoginController>();

  List<Widget> buildPermissionBasedMenus(
    BuildContext context,
    Function menuCardBuilder,
  ) {
    final List<Widget> menus = [];

    if (authController.hasPermissionManagementData) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Manajemen Data',
          subtitle: 'Kelola data pegawai dan sistem',
          icon: Icons.storage_rounded,
          color: const Color(0xFF667eea),
          onTap: () => Get.toNamed('/data-management'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    if (authController.hasPermissionCuti) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Pengajuan Cuti',
          subtitle: 'Ajukan dan kelola permohonan cuti',
          icon: Icons.event_available_rounded,
          color: const Color(0xFF4facfe),
          onTap: () => Get.toNamed('/cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Kalender Cuti',
          subtitle: 'Lihat jadwal cuti dalam kalender',
          icon: Icons.calendar_month_rounded,
          color: const Color(0xFF00d2ff),
          onTap: () => Get.toNamed('/calendar-cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Pengajuan Eksepsi',
          subtitle: 'Ajukan dan kelola eksepsi kehadiran',
          icon: Icons.schedule_rounded,
          color: const Color(0xFFf093fb),
          onTap: () => Get.toNamed('/eksepsi'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    if (authController.hasPermissionAllCuti) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Semua Data Cuti',
          subtitle: 'Lihat semua pengajuan cuti',
          icon: Icons.list_alt_rounded,
          color: const Color(0xFF10b981),
          onTap: () => Get.toNamed('/all-cuti'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    if (authController.hasPermissionAllEksepsi) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Semua Data Eksepsi',
          subtitle: 'Lihat semua pengajuan eksepsi',
          icon: Icons.fact_check_rounded,
          color: const Color(0xFF22c55e),
          onTap: () => Get.toNamed('/all-eksepsi'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    if (authController.hasPermissionInsentif) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Data Insentif',
          subtitle: 'Kelola insentif premi dan lembur',
          icon: Icons.attach_money_rounded,
          color: const Color(0xFF38b2ac),
          onTap: () => Get.toNamed('/insentif'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    if (authController.hasPermissionSuratKeluar) {
      menus.add(
        menuCardBuilder(
          context: context,
          title: 'Surat Keluar',
          subtitle: 'Buat dan kelola surat keluar',
          icon: Icons.mail_rounded,
          color: const Color(0xFF60a5fa),
          onTap: () => Get.toNamed('/surat-keluar'),
        ),
      );
      menus.add(const SizedBox(height: 8));
    }
    menus.add(
      menuCardBuilder(
        context: context,
        title: 'Update Aplikasi',
        subtitle: 'Cek versi terbaru dan pasang update',
        icon: Icons.system_update_rounded,
        color: const Color(0xFF8360c3),
        onTap: () => Get.toNamed('/update-checker'),
      ),
    );
    menus.add(const SizedBox(height: 8));
    return menus;
  }
}
