class RegexMessageParser {
  RegexMessageParser._();

  static String parse(String regex, String label) {
    final parts = <String>[];

    // 1. استخراج البداية المطلوبة ^09 أو ^05 أو ^+966 إلخ
    final startMatch = RegExp(r'^\^(\+?[\w\u0600-\u06FF\[\]|]+?)(?=\\d|\\w|\[|\{|$)').firstMatch(regex);
    if (startMatch != null) {
      final start = startMatch.group(1)!
          .replaceAll(r'\+', '+')
          .replaceAll('[', '')
          .replaceAll(']', '');
      if (start.isNotEmpty && start != '^') {
        parts.add('يجب أن يبدأ بـ "$start"');
      }
    }

    // 2. استخراج الطول المطلوب
    // حالة {n} — طول محدد بالضبط
    final exactMatch = RegExp(r'\\d\{(\d+)\}|\[0-9\]\{(\d+)\}').allMatches(regex);
    int totalDigits = 0;
    for (final m in exactMatch) {
      totalDigits += int.parse(m.group(1) ?? m.group(2) ?? '0');
    }

    // نضيف البادئة لحساب الطول الكلي
    final prefixLength = startMatch?.group(1)!
        .replaceAll(r'\+', '+')
        .replaceAll(RegExp(r'[^0-9a-zA-Z+]'), '')
        .length ?? 0;

    final totalLength = prefixLength + totalDigits;

    if (totalDigits > 0) {
      if (totalLength > totalDigits) {
        parts.add('ويتكون من $totalLength خانة إجمالاً');
      } else {
        parts.add('ويتكون من $totalDigits خانة');
      }
    }

    // حالة {n,m} — طول بين حدين
    final rangeMatch = RegExp(r'\{(\d+),(\d+)\}').firstMatch(regex);
    if (rangeMatch != null && totalDigits == 0) {
      parts.add('ويتكون من ${rangeMatch.group(1)} إلى ${rangeMatch.group(2)} خانة');
    }

    // 3. تحديد نوع المحتوى المطلوب
    final isDigitsOnly = regex.contains(r'\d') || regex.contains('[0-9]');
    final isAlphaOnly = regex.contains('[a-zA-Z]') && !isDigitsOnly;
    final isAlphaNumeric = regex.contains('[a-zA-Z]') && isDigitsOnly;
    final isArabic = regex.contains(r'\u0600') || regex.contains('0600-06FF');
    final hasPlus = regex.contains(r'\+') || regex.startsWith(r'^\+');

    if (hasPlus) {
      parts.add('ويبدأ برمز + متبوعاً برمز الدولة');
    } else if (isArabic) {
      parts.add('ويحتوي على أحرف عربية فقط');
    } else if (isAlphaNumeric) {
      parts.add('ويحتوي على أحرف وأرقام');
    } else if (isAlphaOnly) {
      parts.add('ويحتوي على أحرف فقط');
    } else if (isDigitsOnly) {
      parts.add('ويحتوي على أرقام فقط');
    }

    // 4. بناء مثال من الـ regex
    final example = _buildExample(regex);

    // 5. تجميع الرسالة
    if (parts.isEmpty) {
      return 'صيغة $label غير صحيحة';
    }

    final description = parts.join(' ');
    final message = '$label يجب أن $description';

    return example != null ? '$message\nمثال: $example' : message;
  }

  // بناء مثال تلقائي من الـ regex
  static String? _buildExample(String regex) {
    try {
      String example = '';

      // استخرج البادئة
      final prefixMatch = RegExp(
        r'^\^(\+?[0-9]+)',
      ).firstMatch(regex);
      if (prefixMatch != null) {
        example += prefixMatch.group(1)!;
      }

      // استخرج عدد الأرقام المطلوبة بعد البادئة
      final digitMatches = RegExp(r'\\d\{(\d+)\}|\[0-9\]\{(\d+)\}')
          .allMatches(regex);

      for (final m in digitMatches) {
        final count = int.parse(m.group(1) ?? m.group(2) ?? '0');
        // نولّد أرقام تصاعدية للمثال
        for (int i = 0; i < count; i++) {
          example += ((i % 9) + 1).toString();
        }
      }

      // إذا ما في أرقام محددة بـ {n} جرب \d+ أو [0-9]+
      if (digitMatches.isEmpty && (regex.contains(r'\d+') || regex.contains('[0-9]+'))) {
        example += '12345';
      }

      return example.isNotEmpty ? example : null;
    } catch (_) {
      return null;
    }
  }
}