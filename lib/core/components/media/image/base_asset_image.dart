import 'package:flutter/material.dart';

class BaseAssetImage extends StatelessWidget {
  const BaseAssetImage(this.assetPath, {super.key, required this.fit});
  final String assetPath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetPath, fit: fit);
  }
}
