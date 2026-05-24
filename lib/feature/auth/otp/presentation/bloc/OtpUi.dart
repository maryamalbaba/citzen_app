import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/Token/secureTokenstorage.dart';
import 'package:citzenapp/core/service/dioClient.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/data/repo/repoImp.dart';
import 'package:citzenapp/feature/auth/otp/data/source/remotedata.dart';
import 'package:citzenapp/feature/auth/otp/domain/usecase/otpUsecase.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_event.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_state.dart';
import 'package:citzenapp/feature/process/presentation/type_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  @override
  void dispose() {
    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpBloc(
        OTpUseCase(
          OtpStepRepositoryImpl(
            remotOtpImpl(
              api: DioConsumer(
                DioClient(
                  SecureTokenStorage(
                    const FlutterSecureStorage(),
                  ),
                ),
              ),
            ),
            SecureTokenStorage(
              const FlutterSecureStorage(),
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is OtpSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم التحقق بنجاح',
                      ),
                      
                    ),
                  );
 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>TransactionTypesPage()
                      ),
                    );
                  /// navigate home
                }

                if (state is OtpError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'أدخل كود التحقق',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Pinput(
                      controller: otpController,
                      length: 6,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: 'لقد أرسلنا كود تحقق على الرقم ',
                            ),
                            TextSpan(
                              text: widget.phone_num,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 30,
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
                          context.read<OtpBloc>().add(
                                VerifyOtpEvent(
                                  otp: OtpModel(
                                    session_id: widget.sessionId,
                                    otp: otpController.text,
                                  ),
                                ),
                              );
                        },
                        child: state is OtpLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'إرسال',
                              ),
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
    );
  }
}
