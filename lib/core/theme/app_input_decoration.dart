import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:flutter/material.dart';

InputDecoration appInputDecoration({String? hint, String? label}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: const TextStyle(color: ColorManager.gray, fontSize: 13),
    filled: true,
    fillColor: ColorManager.extraLightBaieg,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColorManager.darkGreen, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColorManager.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: ColorManager.red, width: 1.5),
    ),
  );
}