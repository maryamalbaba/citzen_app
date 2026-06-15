// login_page.dart
import 'package:citzenapp/core/resource/color_manager.dart';
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
// المتغير المسؤول عن حالة إخفاء أو إظهار كلمة المرور
  bool _isObscured = true;
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "تسجيل الدخول",
                      style: TextStyle(color: ColorManager.darkGreen, fontSize: 20),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      style: TextStyle(
                          color: ColorManager.lightBrown, fontSize: 15),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _userController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                                Icons.person_outline,
                                color: ColorManager.lightBrown.withOpacity(0.7),
                                size: 22,
                              ),
                        labelText: 'اسم المستخدم',
                        labelStyle: TextStyle(
                            color: ColorManager.brown.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown, width: 1.8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown.withOpacity(0.6),
                              width: 1.2),
                        ),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'الرجاء إدخال اسم المستخدم' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                     obscureText: _isObscured, // ربط الحقل بالمتغير لتغيير الحالة ديناميكياً
                      style: TextStyle(
                          color: ColorManager.lightBrown, fontSize: 15),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                                Icons.lock,
                                color: ColorManager.lightBrown.withOpacity(0.7),
                                size: 22,
                              ),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: ColorManager.lightBrown.withOpacity(0.7),
                                  size: 22,
                                ),
                                onPressed: () {
                                  // عكس قيمة المتغير لتحديث الحقل بين الإخفاء والإظهار
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                              
                        labelText: 'كلمة المرور',
                        labelStyle: TextStyle(
                            color: ColorManager.brown.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown, width: 1.8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: ColorManager.lightBrown.withOpacity(0.6),
                              width: 1.2),
                        ),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: state is LoginLoading
                          ? const CircularProgressIndicator()
                          : Center(
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
                                child: const Text(
                                  'دخول',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ),
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
