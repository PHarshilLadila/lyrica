import 'package:flutter/material.dart';

String getLocalizedTextFromAPI(
  Map<String, dynamic> data,
  BuildContext context,
  String keyPrefix,
) {
  final langCode = Localizations.localeOf(context).languageCode;
  return data['${keyPrefix}_$langCode'] ?? data['${keyPrefix}_en'] ?? '';
}

class APITranslatedText extends StatelessWidget {
  final Map<String, dynamic> data;
  final String keyPrefix;
  final TextStyle? style;

  const APITranslatedText(this.data, this.keyPrefix, {this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      getLocalizedTextFromAPI(data, context, keyPrefix),
      style: style,
    );
  }
}
