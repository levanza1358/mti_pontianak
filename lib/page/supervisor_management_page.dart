import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/supervisor_management_controller.dart';

class SupervisorManagementPage extends StatelessWidget {
  const SupervisorManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupervisorManagementController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Supervisor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.selectedTab.value = 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: controller.selectedTab.value == 0 
                            ? Colors.blue 
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 0 
                                ? Colors.blue 
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Tambah Supervisor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: controller.selectedTab.value == 0 
                              ? Colors.white 
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ),
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.selectedTab.value = 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: controller.selectedTab.value == 1 
                            ? Colors.blue 
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 1 
                                ? Colors.blue 
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Edit Supervisor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: controller.selectedTab.value == 1 
                              ? Colors.white 
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _buildAddSupervisorTab(controller);
              } else {
                return _buildEditSupervisorTab(controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSupervisorTab(SupervisorManagementController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Supervisor Baru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Nama Supervisor
          _buildFormField(
            label: 'Nama Supervisor',
            controller: controller.namaSupervisorController,
            hint: 'Masukkan nama supervisor',
          ),
          const SizedBox(height: 16),
          
          // Jabatan Supervisor
          _buildFormField(
            label: 'Jabatan Supervisor',
            controller: controller.jabatanSupervisorController,
            hint: 'Masukkan jabatan supervisor',
          ),
          const SizedBox(height: 16),
          
          // Jenis Supervisor
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Supervisor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedJenisSupervisor.value.isEmpty 
                    ? null 
                    : controller.selectedJenisSupervisor.value,
                decoration: InputDecoration(
                  hintText: 'Pilih jenis supervisor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: controller.jenisSupervisorList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedJenisSupervisor.value = newValue;
                  }
                },
              )),
            ],
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value 
                  ? null 
                  : controller.addSupervisor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Tambah Supervisor',
                      style: TextStyle(fontSize: 16),
                    ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSupervisorTab(SupervisorManagementController controller) {
    return Obx(() {
      print('=== Edit Tab Rendering ===');
      print('showEditForm: ${controller.showEditForm.value}');
      print('isLoadingList: ${controller.isLoadingList.value}');
      print('supervisorList length: ${controller.supervisorList.length}');
      
      if (controller.showEditForm.value) {
        print('Rendering edit form');
        return _buildEditForm(controller);
      } else {
        print('Rendering supervisor list');
        return _buildSupervisorList(controller);
      }
    });
  }

  Widget _buildEditForm(SupervisorManagementController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.showEditForm.value = false;
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Obx(() => Text(
                  'Edit Supervisor: ${controller.currentSupervisorName.value}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Nama Supervisor
          _buildFormField(
            label: 'Nama Supervisor',
            controller: controller.editNamaSupervisorController,
            hint: 'Masukkan nama supervisor',
          ),
          const SizedBox(height: 16),
          
          // Jabatan Supervisor
          _buildFormField(
            label: 'Jabatan Supervisor',
            controller: controller.editJabatanSupervisorController,
            hint: 'Masukkan jabatan supervisor',
          ),
          const SizedBox(height: 16),
          
          // Jenis Supervisor
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Supervisor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedEditJenisSupervisor.value.isEmpty 
                    ? null 
                    : controller.selectedEditJenisSupervisor.value,
                decoration: InputDecoration(
                  hintText: 'Pilih jenis supervisor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: controller.jenisSupervisorList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedEditJenisSupervisor.value = newValue;
                  }
                },
              )),
            ],
          ),
          const SizedBox(height: 24),
          
          // Update Button
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoadingEdit.value 
                  ? null 
                  : controller.updateSupervisor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoadingEdit.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Update Supervisor',
                      style: TextStyle(fontSize: 16),
                    ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorList(SupervisorManagementController controller) {
    return Column(
      children: [
        // Header with refresh button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Supervisor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        
        // List content
        Expanded(
          child: Obx(() {
            print('Building supervisor list - isLoadingList: ${controller.isLoadingList.value}');
            
            if (controller.isLoadingList.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (controller.supervisorList.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada data supervisor',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            
            print('Displaying ${controller.supervisorList.length} supervisors');
            
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.supervisorList.length,
              itemBuilder: (context, index) {
                final supervisor = controller.supervisorList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      supervisor['nama'] ?? 'Nama tidak tersedia',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jabatan: ${supervisor['jabatan'] ?? 'Tidak tersedia'}'),
                        Text('Jenis: ${supervisor['jenis'] ?? 'Tidak tersedia'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('Edit button pressed for supervisor: $supervisor');
                            controller.selectSupervisor(supervisor);
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            final id = supervisor['id'];
                            if (id != null) {
                              controller.deleteSupervisor(id);
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}