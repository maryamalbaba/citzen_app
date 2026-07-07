import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// حقل إدخال رمز PIN مكوّن من 6 خانات، بدون أي مكتبة خارجية،
/// متناسق مع هوية التطبيق (اللون 0xff082922).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// حقل إدخال رمز PIN مكوّن من [length] خانات، متجاوب تماماً:
/// يحسب حجم كل خانة بناءً على العرض المتاح فعلياً (LayoutBuilder)
/// بدل استخدام أحجام ثابتة، فلا يحدث RenderFlex overflow على أي شاشة.
class PinCodeInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscure;
  final bool autoFocus;
  final double spacing;
 

 const PinCodeInput({
  super.key,
  this.length = 6,
  required this.onCompleted,
  this.onChanged,
  this.obscure = true,
  this.autoFocus = false,
  this.spacing = 8,
});

  @override
  State<PinCodeInput> createState() => PinCodeInputState();
}

class PinCodeInputState extends State<PinCodeInput> {
  static const _brandColor = Color(0xff082922);

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    if (_focusNodes.isNotEmpty) _focusNodes.first.requestFocus();
    setState(() {});
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.split('').take(widget.length).toList();
      for (var i = 0; i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final lastIndex = digits.length.clamp(0, widget.length) - 1;
      if (lastIndex >= 0) _focusNodes[lastIndex].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    widget.onChanged?.call(_value);
    if (_value.length == widget.length) {
      widget.onCompleted(_value);
    }
    setState(() {});
  }


 @override
Widget build(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max, // 🔑 ياخذ العرض المتاح بالكامل، لا أكثر ولا أقل
    children: List.generate(widget.length * 2 - 1, (i) {
      // نبني خانة إدخال في الفهارس الزوجية، ومسافة فاصلة في الفهارس الفردية
      if (i.isOdd) {
        return SizedBox(width: widget.spacing);
      }

      final index = i ~/ 2;
      return Expanded( // 🔑 هذا هو الإصلاح: يضمن ألا يتجاوز المجموع العرض المتاح أبداً
        child: AspectRatio(
          aspectRatio: 0.78, // تحكم بنسبة العرض للارتفاع بدل رقم ثابت
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: widget.autoFocus && index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            obscureText: widget.obscure,
            obscuringCharacter: '●',
            maxLength: 1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _brandColor,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.grey.shade100,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _brandColor, width: 2),
              ),
            ),
            onChanged: (v) => _onDigitChanged(index, v),
          ),
        ),
      );
    }),
  );
}
}