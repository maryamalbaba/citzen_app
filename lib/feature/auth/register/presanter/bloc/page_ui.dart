// ignore_for_file: public_member_api_docs, sort_constructors_first

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم التسجيل بنجاح'),
                  ),
                );

                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                      Navigator.pushReplacementNamed(
                      context,
                      '/otp',
                      arguments: {
                        'sessionId': state.user
                            .sessionId, 
                        
                        'phone_num': phoneController
                            .text, 
                       
                      },
                    );
                  },
                );
              }

              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Field(
                      controller: userNameController,
                      hint: 'Username',
                      icon: Icons.person,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Field(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Field(
                      controller: phoneController,
                      hint: 'Phone Number',
                      icon: Icons.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Field(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          final request = RegisterRequestModel(
                            userName: userNameController.text,
                            email: emailController.text,
                            phone_number: phoneController.text,
                            password: passwordController.text,
                          );

                          context.read<AuthBloc>().add(
                                RegisterCitizenEvent(
                                  user: request,
                                ),
                              );
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Register',
                              ),
                      ),
                    ),
                  ],
                ),
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
  });

  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
