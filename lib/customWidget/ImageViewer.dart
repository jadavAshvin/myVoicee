import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final imagePath;
  FmFit fit;

  PhotoViewer(this.imagePath, this.fit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlack,
        bottomOpacity: 0.0,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: imagePath.toString().contains('https://')
              ? NetworkImage(imagePath)
              : AssetImage(imagePath),
          minScale: PhotoViewComputedScale.contained * (fit.t(0.8)),
          maxScale: fit.scale == 1 ? 4.0 : 3.0,
        ),
      ),
    );
  }
}
