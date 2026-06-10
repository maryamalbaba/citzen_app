import 'dart:async';
import 'package:citzenapp/core/bottomNav/MainNavWrapper.dart';
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_event.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_state.dart';
import 'package:citzenapp/feature/auth/resendotp/presentation/bloc/resend_otp_bloc.dart';
import 'package:citzenapp/feature/auth/resendotp/presentation/bloc/resend_otp_event.dart';
import 'package:citzenapp/feature/auth/resendotp/presentation/bloc/resend_otp_state.dart';

// استدعاء ملف الـ injection container الخاص بكِ
import 'package:citzenapp/core/service/get_it/injection_container.dart' as di;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String sessionId;
  final String phone_num;
  const OtpPage({super.key, required this.sessionId, required this.phone_num});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  late String currentSessionId;
  Timer? _timer;
  int _startSeconds = 300; // 5 دقائق = 300 ثانية
  bool _isResendButtonEnable = false;

  @override
  void initState() {
    super.initState();
    // 💥 نضمن أن المتغير المحلي يأخذ القيمة الممررة فوراً عند الإقلاع
    currentSessionId = widget.sessionId;
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _isResendButtonEnable = false;
      _startSeconds = 300;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          _isResendButtonEnable = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  الحل الاحترافي: نستخدم الـ MultiBlocProvider لجلب الـ Blocs من di.sl
    // لكي لا يتم إعادة إنشائها مع كل ثانية يتحرك فيها المؤقت
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<OtpBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<ResendOtpBloc>(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: MultiBlocListener(
              listeners: [
                // 1. مراقب التحقق العادي
                BlocListener<OtpBloc, OtpState>(
                  listener: (context, state) {
                    if (state is OtpSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم التحقق بنجاح')),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MainNavWrapper()),
                        (route) => false,
                      );
                    }
                    if (state is OtpError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                ),
                // 2. مراقب عملية إعادة الإرسال المحدثة
                BlocListener<ResendOtpBloc, ResendOtpState>(
                  listener: (context, state) {
                    if (state is ResendOtpSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إعادة إرسال رمز التحقق بنجاح'),
                          backgroundColor: Color.fromARGB(255, 31, 75, 33),
                        ),
                      );
                      setState(() {
                        // 🔥 تحديث السيسشن القديم بالسيسشن الجديد المستلم من الباكيند بأمان
                        currentSessionId = state.response.sessionId;
                      });
                      _startTimer(); // إعادة تدوير المؤقت لـ 5 دقائق جديدة
                    }
                    if (state is ResendOtpError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(state.message),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 100, 90)),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<OtpBloc, OtpState>(
                builder: (context, otpState) {
                  return Column(
                    children: [
                      const Spacer(),
                      Image.asset('assets/images/logo.png', height: 90),
                      const SizedBox(height: 30),
                      const Text('أدخل كود التحقق'),
                      const SizedBox(height: 30),
                      Pinput(
                        controller: otpController,
                        length: 6,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                          children: [
                            const TextSpan(
                                text: 'لقد أرسلنا كود تحقق على الرقم '),
                            TextSpan(
                              text: widget.phone_num,
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ⏳ عرض مؤقت الـ 5 دقائق التنازلي
                      Text(
                        _formatTimer(_startSeconds),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _startSeconds < 60
                              ? Colors.red
                              : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🔄 زر إعادة الإرسال المحمي والمستمع لحالة الـ العداد
                      BlocBuilder<ResendOtpBloc, ResendOtpState>(
                        builder: (context, resendState) {
                          if (resendState is ResendOtpSuccess) {
                            print(
                                '🔥 RESEND SUCCESS - New Session ID: ${resendState.response}');
                            print('Current before update: $currentSessionId');
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return InkWell(
                            onTap: _isResendButtonEnable
                                ? () {
                                    context.read<ResendOtpBloc>().add(
                                          TriggerResendOtpEvent(
                                              oldSessionId: currentSessionId),
                                        );
                                  }
                                : null,
                            child: Text(
                              'لم يصلني الرمز؟ إعادة إرسال OTP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _isResendButtonEnable
                                    ? ColorManager.darkGreen
                                    : Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.darkGreen,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // 1. تحديد القيمة المتوفرة بأمان (المحدثة من الـ Resend أو القادمة من الصفحة السابقة)
                            final sessionIdToSend =
                                currentSessionId.trim().isNotEmpty
                                    ? currentSessionId.trim()
                                    : widget.sessionId.trim();

                            // 2. طباعة تشخيصية في الـ Console لمعرفة القيمة قبل الإرسال مباشرة
                            print('=== DEBUG OTP SUBMIT ===');
                            print(
                                'Current Session ID State: "$currentSessionId"');
                            print('Widget Session ID: "${widget.sessionId}"');
                            print(
                                'Final Session ID to Send: "$sessionIdToSend"');
                            print('========================');

                            // 3. منع الإرسال إذا كانت القيمة لا تزال فارغة لتجنب استهلاك طلبات السيرفر
                            if (sessionIdToSend.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'خطأ: معرّف الجلسة غير موجود، يرجى إعادة المحاولة من الشاشة السابقة')),
                              );
                              return;
                            }

                            // 4. إرسال الـ Event بالبيانات السليمة
                            context.read<OtpBloc>().add(
                                  VerifyOtpEvent(
                                    otp: OtpModel(
                                      session_id: sessionIdToSend,
                                      otp: otpController.text,
                                    ),
                                  ),
                                );
                          },
                          child: otpState is OtpLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('إرسال'),
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
