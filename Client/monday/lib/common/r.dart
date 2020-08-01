import 'package:monday/generated/l10n.dart';
import 'package:flutter/material.dart';

/*
Class used for fixing the issue reported at: https://github.com/flutter/flutter/issues/39593
 */

class R extends S {
  static of(BuildContext context) {
    return S.current;
  }
}