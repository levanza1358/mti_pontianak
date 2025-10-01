import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_data_controller.dart';

class EditDataPage extends StatelessWidget {
  const EditDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditDataController controller = Get.put(EditDataController());

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
          child: Column(
            children: [
              // Header Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
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
                            'Edit Data Pegawai',
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
                            'Ubah dan kelola data pegawai',
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
                        onPressed: () => Get.offAllNamed('/home'),
                        icon: const Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan nama atau NRP...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: const Color(0xFF667eea),
                      size: 22,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      onPressed: controller.clearSearch,
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Content Area
              Expanded(
                child: Obx(() {
                  // Show edit form if pegawai selected
                  if (controller.isDataFound.value) {
                    return _buildEditForm(controller);
                  }

                  // Show loading
                  if (controller.isLoadingList.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  // Show empty state
                  if (controller.pegawaiList.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada data pegawai',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show filtered list
                  final listToShow = controller.filteredPegawaiList;

                  if (listToShow.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ditemukan hasil pencarian',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: listToShow.length,
                    itemBuilder: (context, index) {
                      final pegawai = listToShow[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                              spreadRadius: -2,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.08),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => controller.selectPegawai(pegawai),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(
                                            0xFF667eea,
                                          ).withOpacity(0.8),
                                          const Color(
                                            0xFF667eea,
                                          ).withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF667eea,
                                          ).withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pegawai['name'] ??
                                              'Nama tidak tersedia',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF2D3748),
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                offset: const Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'NRP: ${pegawai['nrp'] ?? 'Tidak tersedia'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color(0xFF718096),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Jabatan: ${pegawai['jabatan'] ?? 'Tidak tersedia'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color(0xFF718096),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (pegawai['status'] != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Status: ${pegawai['status']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xFF718096),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                        if (pegawai['group_'] != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Group: ${pegawai['group_']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xFF718096),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF667eea,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      color: Color(0xFF667eea),
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(EditDataController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: controller.editDataFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header dengan tombol kembali
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.orange),
                      onPressed: controller.resetToList,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Data Pegawai',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Obx(
                            () => Text(
                              'Mengedit: ${controller.currentUserName.value}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form fields
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama field
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.nameController,
                      validator: controller.validateName,
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
                    ),
                    const SizedBox(height: 16),

                    // NRP field (read-only)
                    const Text(
                      'NRP (Tidak dapat diubah)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.nrpController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'NRP pegawai',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF64748B),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Jabatan Dropdown
                    const Text(
                      'Jabatan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedJabatan.value,
                        validator: controller.validateJabatan,
                        decoration: InputDecoration(
                          hintText: 'Pilih jabatan',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.work_outline,
                            color: Color(0xFF64748B),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        items: controller.isLoadingJabatan.value
                            ? []
                            : controller.jabatanList.map((jabatan) {
                                return DropdownMenuItem<String>(
                                  value: jabatan['nama'],
                                  child: Text(jabatan['nama']),
                                );
                              }).toList(),
                        onChanged: (value) {
                          controller.selectedJabatan.value = value;
                        },
                        hint: controller.isLoadingJabatan.value
                            ? const Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Loading jabatan...'),
                                ],
                              )
                            : const Text('Pilih jabatan'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value,
                        validator: controller.validateStatus,
                        decoration: InputDecoration(
                          hintText: 'Pilih status',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.assignment_ind_outlined,
                            color: Color(0xFF64748B),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        items: controller.statusOptions.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedStatus.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Group Dropdown
                    const Text(
                      'Group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedGroup.value,
                        validator: controller.validateGroup,
                        decoration: InputDecoration(
                          hintText: 'Pilih group',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.group_outlined,
                            color: Color(0xFF64748B),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        items: controller.groupOptions.map((group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedGroup.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Group Dropdown
                    const Text(
                      'Status Group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedStatusGroup.value,
                        validator: controller.validateStatusGroup,
                        decoration: InputDecoration(
                          hintText: 'Pilih status group',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.account_tree_outlined,
                            color: Color(0xFF64748B),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        items: controller.statusGroupOptions.map((statusGroup) {
                          return DropdownMenuItem<String>(
                            value: statusGroup,
                            child: Text(statusGroup),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedStatusGroup.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field (optional)
                    const Text(
                      'Password Baru (Opsional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kosongkan jika tidak ingin mengubah password',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Masukkan password baru',
                          hintStyle: const TextStyle(color: Color(0xFF64748B)),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF64748B),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF667eea),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: controller.resetToList,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color(0xFF667eea),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => Container(
                      height: 50,
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
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: controller.isLoading.value
                            ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
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
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.updatePegawai,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Menyimpan...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.save_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
