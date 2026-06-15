// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/Token/secureTokenStorage.dart';
import 'package:citzenapp/core/service/dioClient.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/OtpUi.dart';

import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';

import 'package:citzenapp/feature/auth/register/data/repo/authrepoImpl.dart';
import 'package:citzenapp/feature/auth/register/data/source/remote_data_source_impl.dart';
import 'package:citzenapp/feature/auth/register/domain/usecase/register_citizen_usecase.dart';

import 'package:citzenapp/feature/auth/register/presanter/bloc/register_bloc.dart';

import 'package:citzenapp/feature/auth/register/presanter/bloc/register_state.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        RegisterCitizenUseCase(
          AuthRepositoryImpl(
            remote: AuthRemoteDataSourceImpl(
              DioConsumer(
                DioClient(
                  SecureTokenStorage(
                    const FlutterSecureStorage(),
                  ),
                ),
              ),
            ),
            tokenStorage: SecureTokenStorage(
              const FlutterSecureStorage(),
            ),
          ),
        ),
      ),
      child: Directionality(
        textDirection:
            TextDirection.rtl, // لضمان التوافق التام مع اللغة العربية
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم التسجيل بنجاح')),
                );

                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/otp',
                      arguments: {
                        'sessionId': state.user.sessionId,
                        'phone_num': phoneController.text,
                      },
                    );
                  },
                );
              }

              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              // نتحقق هنا إذا كانت الحالة الحالية هي حالة التحميل
              final isLoading = state is AuthLoading;

              return Stack(
                children: [
                  // الطبقة الأساسية للواجهة
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 60.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Image.asset(
                              'assets/images/logo.png',
                              height: 120,
                            ),
                            const SizedBox(height: 50),
                            Field(
                              controller: userNameController,
                              hint: 'اسم المستخدم',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                            Field(
                              controller: emailController,
                              hint: 'ايميل',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            Field(
                              controller: phoneController,
                              hint: 'رقم الموبايل',
                              icon: Icons.phone_android_outlined,
                            ),
                            const SizedBox(height: 20),
                            Field(
                              controller: passwordController,
                              hint: 'كلمة السر',
                              icon: Icons.lock_open_outlined,

                              obscureText:
                                  _isObscured, // استخدم المتغير الذي قمت بتعريفه في الأعلى
                              suffixIcon: IconButton(
                                // إضافة زر العين
                                icon: Icon(
                                  // تغيير شكل الأيقونة بناءً على حالة الإخفاء
                                  _isObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color:
                                      ColorManager.lightBrown.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  // تغيير الحالة عند الضغط لإظهار/إخفاء النص
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 30),

                            // زر الإرسال ثابت ولا يتغير شكله الداخلي عند التحميل
                            SizedBox(
                              width: 160,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.darkGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shadowColor: Colors.black.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null // تعطيل الزر أثناء التحميل لمنع التكرار
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          final request = RegisterRequestModel(
                                            userName: userNameController.text,
                                            email: emailController.text,
                                            phone_number: phoneController.text,
                                            password: passwordController.text,
                                          );

                                          context.read<AuthBloc>().add(
                                                RegisterCitizenEvent(
                                                    user: request),
                                              );
                                        }
                                      },
                                child: const Text(
                                  'ارسال',
                                  style: TextStyle(
                                    fontSize: 18,
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

                  // طبقة حركة التحميل الجميلة (تظهر فقط عندما يكون isLoading = true)
                  if (isLoading)
                    Container(
                      color: Colors.black
                          .withOpacity(0.25), // تعتيم خفيف وناعم للخلفية
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorManager.darkGreen),
                              strokeWidth: 3.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon, // 1. أضف هذا السطر
  });

  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final bool obscureText;
  final Widget? suffixIcon; // 2. أضف هذا السطر

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,

        hintText: hint,

        hintStyle: TextStyle(
            color: ColorManager.lightBrown.withOpacity(0.6), fontSize: 15),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        prefixIcon: Icon(icon,
            color: ColorManager.lightBrown.withOpacity(0.7), size: 22),
        // 1. الحدود الافتراضية
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorManager.lightBrown, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: ColorManager.lightBrown, width: 1.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: ColorManager.lightBrown.withOpacity(0.6), width: 1.2),
        ),
      ),
    );
  }
}
