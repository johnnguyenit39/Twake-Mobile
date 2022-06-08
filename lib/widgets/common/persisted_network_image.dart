import 'package:flutter/material.dart';

class PersistedNetworkImage extends StatefulWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final String thumbUrl;
  final Widget progressIndicator;

  const PersistedNetworkImage(
      {Key? key,
      required this.width,
      required this.height,
      required this.fit,
      required this.thumbUrl,
      required this.progressIndicator})
      : super(key: key);

  @override
  _PersistedNetworkImageState createState() => _PersistedNetworkImageState();
}

class _PersistedNetworkImageState extends State<PersistedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
