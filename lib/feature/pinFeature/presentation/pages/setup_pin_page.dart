import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../bloc/pin_bloc.dart';
import '../widgets/pin_code_input.dart';

/// شاشة إنشاء PIN لأول مرة.
/// [onCreated] يُستدعى بعد نجاح الإنشاء (عادة للانتقال إلى الصفحة الرئيسية).
class SetupPinPage extends StatelessWidget {
  final VoidCallback? onCreated;

  const SetupPinPage({super.key, this.onCreated});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PinBloc>(),
      child: _SetupPinView(onCreated: onCreated),
    );
  }
}

class _SetupPinView extends StatefulWidget {
  final VoidCallback? onCreated;

  const _SetupPinView({this.onCreated});

  @override
  State<_SetupPinView> createState() => _SetupPinViewState();
}

class _SetupPinViewState extends State<_SetupPinView> {
  static const _brandColor = Color(0xff082922);

  final _pinInputKey = GlobalKey<PinCodeInputState>();
  final _confirmPinInputKey = GlobalKey<PinCodeInputState>();

  String _pin = '';
  String _confirmPin = '';

  void _submit() {
    if (_pin.length != 6 || _confirmPin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رمز مكوّن من 6 أرقام في الحقلين')),
      );
      return;
    }
    if (_pin != _confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز PIN وتأكيده غير متطابقين')),
      );
      return;
    }
    context.read<PinBloc>().add(
          SetupPinRequested(pin: _pin, confirmPin: _confirmPin),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _brandColor,
        title: const Text('إنشاء رمز PIN', style: TextStyle(color: Colors.white)),
      ),
      body: BlocConsumer<PinBloc, PinState>(
        listener: (context, state) {
          if (state is PinSetupSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            widget.onCreated?.call();
          } else if (state is PinSetupFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is PinSetupLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const Icon(Icons.lock_outline, size: 64, color: _brandColor),
                const SizedBox(height: 16),
                const Text(
                  'يُستخدم رمز الـ PIN كقفل للتطبيق، اختر رمزاً مكوناً من 6 أرقام',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('أدخل رمز PIN'),
                ),
                const SizedBox(height: 8),
                PinCodeInput(
                  key: _pinInputKey,
                  onCompleted: (v) => setState(() => _pin = v),
                  onChanged: (v) => _pin = v,
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('تأكيد رمز PIN'),
                ),
                const SizedBox(height: 8),
                PinCodeInput(
                  key: _confirmPinInputKey,
                  onCompleted: (v) => setState(() => _confirmPin = v),
                  onChanged: (v) => _confirmPin = v,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'إنشاء رمز PIN',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
