import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.school,
                    size: 50,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'MTI Pontianak',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan login untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 32),

                // Login Form
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: loginController.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // NRP Field
                          TextFormField(
                            controller: loginController.nrpController,
                            validator: loginController.validateNrp,
                            decoration: InputDecoration(
                              labelText: 'NRP',
                              hintText: 'Masukkan NRP Anda',
                              prefixIcon: Icon(
                                Icons.person,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.dividerColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.dividerColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: theme.primaryColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: theme.scaffoldBackgroundColor,
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          Obx(
                            () => TextFormField(
                              controller: loginController.passwordController,
                              validator: loginController.validatePassword,
                              obscureText:
                                  loginController.isPasswordHidden.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Masukkan password Anda',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    loginController.isPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                  onPressed:
                                      loginController.togglePasswordVisibility,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.scaffoldBackgroundColor,
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!loginController.isLoading.value) {
                                  loginController.login();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Remember Me and Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Row(
                                  children: [
                                    Checkbox(
                                      value: loginController.rememberMe.value,
                                      onChanged: (_) {
                                        loginController.toggleRememberMe();
                                      },
                                      activeColor: theme.primaryColor,
                                    ),
                                    GestureDetector(
                                      onTap: loginController.toggleRememberMe,
                                      child: Text(
                                        'Ingat Saya',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle forgot password
                                },
                                child: Text(
                                  'Lupa Password?',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          Obx(
                            () => ElevatedButton(
                              onPressed: loginController.isLoading.value
                                  ? null
                                  : loginController.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: loginController.isLoading.value
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Sedang Login...',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer
                Text(
                  'Sistem Informasi Manajemen Pegawai',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
