import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_pegawai_controller.dart';

class AddPegawaiPage extends StatelessWidget {
  const AddPegawaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddPegawaiController controller = Get.put(AddPegawaiController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF667eea),
                          const Color(0xFF764ba2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, -2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tambah Pegawai',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tambahkan data pegawai baru ke sistem',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: -2,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Section
                        Form(
                          key: controller.pegawaiFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Field
                              Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.nameController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan nama lengkap',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: const Color(0xFF667eea),
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF667eea),
                                      width: 2.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // NRP Field
                              Text(
                                'NRP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.nrpController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan NRP',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(
                                    Icons.badge_outlined,
                                    color: const Color(0xFF667eea),
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF667eea),
                                      width: 2.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'NRP tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Jabatan Field
                              Text(
                                'Jabatan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller.selectedJabatan.value,
                                  decoration: InputDecoration(
                                    hintText: 'Pilih jabatan',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    prefixIcon: Icon(
                                      Icons.work_outline_rounded,
                                      color: const Color(0xFF667eea),
                                      size: 22,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF667eea),
                                        width: 2.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  items: controller.jabatanList.map((jabatan) {
                                    return DropdownMenuItem<String>(
                                      value: jabatan['nama'],
                                      child: Text(jabatan['nama']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    controller.selectedJabatan.value = newValue;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Jabatan harus dipilih';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Status Field
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller.selectedStatus.value,
                                  decoration: InputDecoration(
                                    hintText: 'Pilih status',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    prefixIcon: Icon(
                                      Icons.check_circle_outline,
                                      color: const Color(0xFF667eea),
                                      size: 22,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF667eea),
                                        width: 2.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  items: controller.statusOptions.map((
                                    String status,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    controller.selectedStatus.value = newValue;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Status harus dipilih';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Group Field
                              Text(
                                'Group',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => controller.isLoadingGroup.value
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.group_outlined,
                                              color: const Color(0xFF667eea),
                                              size: 22,
                                            ),
                                            const SizedBox(width: 12),
                                            const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF667eea),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Memuat data group...',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : DropdownButtonFormField<String>(
                                        value: controller.selectedGroup.value,
                                        decoration: InputDecoration(
                                          hintText: 'Pilih group',
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 16,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                          prefixIcon: Icon(
                                            Icons.group_outlined,
                                            color: const Color(0xFF667eea),
                                            size: 22,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF667eea),
                                              width: 2.5,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 18,
                                              ),
                                        ),
                                        items: controller.groupList.map((
                                          group,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: group['nama'],
                                            child: Text(group['nama']),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          controller.selectedGroup.value =
                                              newValue;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Group harus dipilih';
                                          }
                                          return null;
                                        },
                                      ),
                              ),

                              const SizedBox(height: 20),

                              // Status Group Field
                              Text(
                                'Status Group',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller.selectedStatusGroup.value,
                                  decoration: InputDecoration(
                                    hintText: 'Pilih status group',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    prefixIcon: Icon(
                                      Icons.admin_panel_settings_outlined,
                                      color: const Color(0xFF667eea),
                                      size: 22,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF667eea),
                                        width: 2.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  items: controller.statusGroupOptions.map((
                                    String statusGroup,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: statusGroup,
                                      child: Text(statusGroup),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    controller.selectedStatusGroup.value =
                                        newValue;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Status group harus dipilih';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Password Field
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => TextFormField(
                                  controller: controller.passwordController,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: const Color(0xFF667eea),
                                      size: 22,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        color: Colors.grey.shade600,
                                        size: 22,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF667eea),
                                        width: 2.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password tidak boleh kosong';
                                    }
                                    if (value.length < 6) {
                                      return 'Password minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Submit Button
                              Obx(
                                () => Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: controller.isLoading.value
                                        ? LinearGradient(
                                            colors: [
                                              Colors.grey.shade400,
                                              Colors.grey.shade500,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: controller.isLoading.value
                                        ? [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF667eea,
                                              ).withOpacity(0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 2,
                                              offset: const Offset(0, -2),
                                            ),
                                          ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.submitPegawaiForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: controller.isLoading.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(
                                                        theme
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.color
                                                                ?.withOpacity(
                                                                  0.7,
                                                                ) ??
                                                            Colors.grey,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'Menyimpan...',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: theme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.color
                                                      ?.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person_add_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                'TAMBAH PEGAWAI',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  letterSpacing: 1.2,
                                                  shadows: [
                                                    Shadow(
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                      blurRadius: 2,
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                    ),
                                                  ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
