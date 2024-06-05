import 'dart:io';

import 'package:flutter/material.dart';

enum ProfilePictureSize { small, large }

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final ProfilePictureSize size;

  const ProfilePicture({super.key, required this.imageUrl,required this.size});

  double _getSize() {
    switch (size) {
      case ProfilePictureSize.small:
        return 84;
      case ProfilePictureSize.large:
        return 110;
    }
  }
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      imageProvider = FileImage(File(imageUrl));
    }

    return Container(
      width: _getSize(),
      height: _getSize(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageProvider,
        ),
      ),
    );
  }
}