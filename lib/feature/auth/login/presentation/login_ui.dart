// login_page.dart
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_bloc.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_event.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart'; // استدعاء الـ sl

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      // نقوم بحقن الـ Bloc هنا باستخدام GetIt (sl)
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              // إظهار رسالة خطأ في حال الفشل
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red),
              );
            }
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.responseModel.message),
                    backgroundColor: Colors.green),
              );

              //  نرسل البيانات على شكل Map يحتوي على المعطيات المطلوبة
              Navigator.pushReplacementNamed(
                context,
                '/otp',
                arguments: {
                  'sessionId': state.responseModel.sessionId,
                  'phone_num': _userController.text
                      .trim(), // نأخذ الرقم الذي كتبه المستخدم عند تسجيل الدخول
                },
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _userController,
                      decoration:
                          const InputDecoration(labelText: 'اسم المستخدم'),
                      validator: (v) =>
                          v!.isEmpty ? 'الرجاء إدخال اسم المستخدم' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'كلمة المرور'),
                      validator: (v) =>
                          v!.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                    ),
                    const SizedBox(height: 32),
                    state is LoginLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // إرسال حدث تسجيل الدخول للـ Bloc
                                BlocProvider.of<LoginBloc>(context).add(
                                  SubmitLoginEvent(
                                    userName: _userController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            child: const Text('دخول'),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
