import 'package:flutter/material.dart';

import 'locale.dart';

class LanguageWrapper extends StatelessWidget {
  final Widget initialScreen;
  final Function(Locale) onLocaleChange;

  const LanguageWrapper({
    Key? key,
    required this.initialScreen,
    required this.onLocaleChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.isDirectionRTL(context)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Builder(
        builder: (context) {
          return initialScreen;
        },
      ),
    );
  }
}
