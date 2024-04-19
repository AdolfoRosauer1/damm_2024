import 'package:damm_2024/widgets/molecules/buttons/short_button.dart';
import 'package:damm_2024/widgets/molecules/components/profile_picture.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';

class ProfilePictureCard extends StatelessWidget{
  final String? imageUrl;
  
  const ProfilePictureCard({super.key, this.imageUrl});

  _getButtonText(){
    if (imageUrl == null){
      return 'Subir foto';
    }
    return 'Cambiar foto';
  }
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null){
      return Container(
        decoration: BoxDecoration(
          color: ProjectPalette.secondary2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,14,0,14),
                child: Text(
                  'Foto de perfil',
                  style: ProjectFonts.subtitle1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,16,8),
              child: ShortButton(onPressed: ()=>{},
              small: true,
               buttonText: _getButtonText(),
                activated: true),
            )
          ],
        ),
      );
    }else{
      return Container(
      decoration: BoxDecoration(
        color: ProjectPalette.secondary2,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foto de perfil',
                    style: ProjectFonts.subtitle1,
                  ),
                  SizedBox(height: 8),
                  ShortButton(
                    onPressed: () => {},
                    small: true,
                    buttonText: _getButtonText(),
                    activated: true,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,19,8),
            child: ProfilePicture(
              imageUrl: imageUrl!,
              size: ProfilePictureSize.small,
            ),
            )

        ],
      ),
    );
    }
  }
}