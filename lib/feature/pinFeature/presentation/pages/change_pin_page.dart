import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../bloc/pin_bloc.dart';
import '../widgets/pin_code_input.dart';

class ChangePinPage extends StatelessWidget {
  const ChangePinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PinBloc>(),
      child: const _ChangePinView(),
    );
  }
}

class _ChangePinView extends StatefulWidget {
  const _ChangePinView();

  @override
  State<_ChangePinView> createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<_ChangePinView> {
  static const _brandColor = Color(0xff082922);

  final _oldPinKey = GlobalKey<PinCodeInputState>();
  final _newPinKey = GlobalKey<PinCodeInputState>();
  final _confirmPinKey = GlobalKey<PinCodeInputState>();

  String _oldPin = '';
  String _newPin = '';
  String _confirmNewPin = '';

  void _submit() {
    if (_oldPin.length != 6 || _newPin.length != 6 || _confirmNewPin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول (6 أرقام لكل حقل)')),
      );
      return;
    }
    if (_newPin != _confirmNewPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز PIN الجديد وتأكيده غير متطابقين')),
      );
      return;
    }
    context.read<PinBloc>().add(
          ChangePinRequested(
            oldPin: _oldPin,
            newPin: _newPin,
            confirmNewPin: _confirmNewPin,
          ),
        );
  }

  Widget _labeledPinField({
    required String label,
    required GlobalKey<PinCodeInputState> key,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label),
        const SizedBox(height: 8),
        PinCodeInput(key: key, onCompleted: onChanged, onChanged: onChanged),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _brandColor,
        title: const Text('تغيير رمز PIN', style: TextStyle(color: Colors.white)),
      ),
      body: BlocConsumer<PinBloc, PinState>(
        listener: (context, state) {
          if (state is PinChangeSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.of(context).pop();
          } else if (state is PinChangeFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is PinChangeLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                _labeledPinField(
                  label: 'رمز PIN الحالي',
                  key: _oldPinKey,
                  onChanged: (v) => _oldPin = v,
                ),
                _labeledPinField(
                  label: 'رمز PIN الجديد',
                  key: _newPinKey,
                  onChanged: (v) => _newPin = v,
                ),
                _labeledPinField(
                  label: 'تأكيد رمز PIN الجديد',
                  key: _confirmPinKey,
                  onChanged: (v) => _confirmNewPin = v,
                ),
                const SizedBox(height: 16),
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
                            'حفظ التغييرات',
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
