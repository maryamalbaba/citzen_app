import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pin_bloc.dart';
import '../widgets/pin_code_input.dart';

/// شاشة "قفل التطبيق": تظهر عند كل فتح للتطبيق بشرط وجود PIN مُنشأ مسبقاً.
/// لا يمكن تجاوزها بزر الرجوع (PopScope canPop: false) — تماماً كما هو متوقع
/// من شاشة قفل: لا خروج منها إلا بإدخال الرمز الصحيح.
class VerifyPinPage extends StatelessWidget {
  /// يُستدعى بعد نجاح التحقق (unlocked == true) للانتقال إلى الصفحة الرئيسية.
  final VoidCallback onUnlocked;

  const VerifyPinPage({super.key, required this.onUnlocked});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PinBloc>(),
      child: _VerifyPinView(onUnlocked: onUnlocked),
    );
  }
}

class _VerifyPinView extends StatefulWidget {
  final VoidCallback onUnlocked;

  const _VerifyPinView({required this.onUnlocked});

  @override
  State<_VerifyPinView> createState() => _VerifyPinViewState();
}

class _VerifyPinViewState extends State<_VerifyPinView> {
  static const _brandColor = Color(0xff082922);

  final _pinInputKey = GlobalKey<PinCodeInputState>();
  String _pin = '';

  void _submit() {
    if (_pin.length != 6) return;
    context.read<PinBloc>().add(VerifyPinRequested(pin: _pin));
  }

  @override
  Widget build(BuildContext context) {
    // canPop: false يمنع إغلاق الشاشة أو الرجوع منها دون التحقق الناجح.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<PinBloc, PinState>(
          listener: (context, state) {
            if (state is PinVerifySuccess) {
              widget.onUnlocked();
            } else if (state is PinVerifyFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              _pinInputKey.currentState?.clear();
              setState(() => _pin = '');
            }
          },
          builder: (context, state) {
  final isLoading = state is PinVerifyLoading;
  return SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            // 🔑 يضمن أن المحتوى يتوسّط عمودياً عند توفر مساحة كافية،
            // ويتمدد بحرية (Scroll) عند ظهور الكيبورد فلا يحدث overflow.
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 64, color: _brandColor),
                  const SizedBox(height: 16),
                  const Text(
                    'أدخل رمز PIN لفتح التطبيق',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: PinCodeInput(
                      key: _pinInputKey,
                      autoFocus: true,
                      onCompleted: (v) {
                        _pin = v;
                        _submit();
                      },
                      onChanged: (v) => _pin = v,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isLoading) const CircularProgressIndicator(color: _brandColor),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
},
        ),
      ),
    );
  }
}
