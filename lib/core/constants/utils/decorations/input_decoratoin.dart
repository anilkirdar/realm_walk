import 'package:flutter/material.dart';

import '../../../extensions/context_extension.dart';

class InputDecorationConst {
  static InputDecoration search(BuildContext context) => InputDecoration(
    prefixIcon: Icon(Icons.search, color: context.theme.iconTheme.color),
    alignLabelWithHint: true,
    floatingLabelAlignment: FloatingLabelAlignment.center,
    // labelStyle: TextStyleConst.searchLabel(theme),
    border: InputBorder.none,
    hintText: 'Search',
  );
}
