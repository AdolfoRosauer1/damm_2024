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
    return Container(
      width: _getSize(),
      height: _getSize(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl), // Si la imagen está en la web
          // image: AssetImage(imageUrl), // Si la imagen está en los assets
        ),
      ),
    );
  }
}
