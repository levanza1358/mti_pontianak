// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient untuk halaman login
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.08),
                    theme.colorScheme.secondary.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Perusahaan
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/MTI_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 32),

                    // Login Form dengan efek blur (frosted glass)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
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
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'NRP',
                                      hintText: 'Masukkan NRP Anda',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color:
                                            theme.textTheme.bodyMedium?.color,
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
                                      controller:
                                          loginController.passwordController,
                                      validator:
                                          loginController.validatePassword,
                                      obscureText: loginController
                                          .isPasswordHidden.value,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        hintText: 'Masukkan password Anda',
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            loginController
                                                    .isPasswordHidden.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: theme
                                                .textTheme.bodyMedium?.color,
                                          ),
                                          onPressed: loginController
                                              .togglePasswordVisibility,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: theme.dividerColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: theme.dividerColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: theme.primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                            theme.scaffoldBackgroundColor,
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

                                  // Remember Me (Lupa Password dihapus)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          Checkbox(
                                            value: loginController
                                                .rememberMe.value,
                                            onChanged: (_) {
                                              loginController
                                                  .toggleRememberMe();
                                            },
                                            activeColor: theme.primaryColor,
                                          ),
                                          GestureDetector(
                                            onTap: loginController
                                                .toggleRememberMe,
                                            child: Text(
                                              'Ingat Saya',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: theme.textTheme
                                                    .bodyMedium?.color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Login Button dengan warna yang lebih tegas dan state-aware
                                  Obx(
                                    () => ElevatedButton(
                                      onPressed: loginController.isLoading.value
                                          ? null
                                          : loginController.login,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return theme.colorScheme.onSurface
                                                  .withOpacity(0.12);
                                            }
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return theme.colorScheme.primary
                                                  .withOpacity(0.85);
                                            }
                                            if (states.contains(
                                                    MaterialState.hovered) ||
                                                states.contains(
                                                    MaterialState.focused)) {
                                              return theme
                                                  .colorScheme.primaryContainer;
                                            }
                                            return theme.colorScheme.primary;
                                          },
                                        ),
                                        foregroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return theme.colorScheme.onSurface
                                                  .withOpacity(0.38);
                                            }
                                            return theme.colorScheme.onPrimary;
                                          },
                                        ),
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                          theme.colorScheme.onPrimary
                                              .withOpacity(0.08),
                                        ),
                                        shadowColor:
                                            MaterialStateProperty.all<Color>(
                                          theme.colorScheme.primary
                                              .withOpacity(0.35),
                                        ),
                                        elevation: MaterialStateProperty
                                            .resolveWith<double>(
                                          (states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return 0;
                                            }
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return 6;
                                            }
                                            return 3;
                                          },
                                        ),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      child: loginController.isLoading.value
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Sedang Login...',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
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
                      ),
                    ),
                    // Version information at the bottom
                    const SizedBox(height: 32),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Versi ${snapshot.data!.version}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
