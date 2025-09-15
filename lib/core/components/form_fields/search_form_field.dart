import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/decorations/box_decoration.dart';
import '../../constants/utils/decorations/input_decoratoin.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/notifier/theme_notifier.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: PaddingConst.top4,
      width: double.infinity,
      height: SizeConst.searchFormFieldHeight,
      decoration: BoxDecorationConst.instance.searchField(theme, context),
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        style: TextStyle(
          color:
              Provider.of<ThemeNotifier>(
                context,
              ).getCustomTheme.beigeToLightBlue,
        ),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecorationConst.search(context),
      ),
    );
  }
}
