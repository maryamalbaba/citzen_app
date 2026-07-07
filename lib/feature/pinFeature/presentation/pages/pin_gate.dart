import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pin_bloc.dart';
import 'verify_pin_page.dart';

/// نقطة الدمج الرئيسية لميزة الـ PIN مع باقي التطبيق.
///
/// الاستخدام (مثال داخل AppRoutes.home بدلاً من MainNavWrapper مباشرة):
/// ```dart
/// home: (context) => const PinGate(child: MainNavWrapper()),
/// ```
///
/// المنطق:
/// - إن لم يُنشئ المستخدم PIN بعد -> يُعرض [child] مباشرة دون أي اعتراض.
/// - إن كان قد أنشأ PIN مسبقاً -> تُعرض [VerifyPinPage] أولاً (شاشة قفل لا يمكن
///   تجاوزها بالرجوع)، وبعد نجاح التحقق فقط يظهر [child].
class PinGate extends StatelessWidget {
  final Widget child;

  const PinGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PinBloc>()..add(const CheckPinStatusRequested()),
      child: _PinGateView(child: child),
    );
  }
}

class _PinGateView extends StatefulWidget {
  final Widget child;

  const _PinGateView({required this.child});

  @override
  State<_PinGateView> createState() => _PinGateViewState();
}

class _PinGateViewState extends State<_PinGateView> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) {
        if (state is PinStatusChecking || state is PinInitial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff082922)),
            ),
          );
        }

        if (state is PinStatusChecked) {
          // لا يوجد PIN منشأ بعد -> ادخل مباشرة، لا داعي لأي اعتراض.
          if (!state.hasPinCreated) {
            return widget.child;
          }
          // يوجد PIN وتم فتحه مسبقاً ضمن هذه الجلسة -> اعرض المحتوى مباشرة.
          if (_unlocked) {
            return widget.child;
          }
          // يوجد PIN ولم يُفتح بعد ضمن هذه الجلسة -> اعرض شاشة التحقق (لا رجوع منها).
          return VerifyPinPage(
            onUnlocked: () => setState(() => _unlocked = true),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
