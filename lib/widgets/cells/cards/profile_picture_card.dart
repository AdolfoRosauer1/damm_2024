import 'package:damm_2024/widgets/molecules/buttons/short_button.dart';
import 'package:damm_2024/widgets/molecules/components/profile_picture.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePictureCard extends StatefulWidget{
  final String? imageUrl;
  final FormFieldState field;
  const ProfilePictureCard({super.key, required this.imageUrl, required this.field});

  @override
  _ProfilePictureCardState createState() => _ProfilePictureCardState();
}

class _ProfilePictureCardState extends State<ProfilePictureCard> {
  bool _isLoading = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  _getButtonText(){
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty){
      return 'Subir foto';
    }
      return 'Cambiar foto'; //return AppLocalizations.of(context)!.changePhoto; //TEXTO A CAMBIAR
  }
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    print("SELECCION IMAGEN");
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageUrl = pickedImage.path;
        widget.field.didChange(_imageUrl);
        widget.field.save(); 

      });
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    if (_imageUrl == null || _imageUrl!.isEmpty){
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
                  AppLocalizations.of(context)!.profilePhoto, //TEXTO A CAMBIAR
                  style: ProjectFonts.subtitle1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,16,8),
              child: ShortButton(
                onPressed: ()=>_pickImage(),
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
                    AppLocalizations.of(context)!.profilePhoto, //TEXTO A CAMBIAR
                    style: ProjectFonts.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  ShortButton(
                    onPressed: () => _pickImage(),
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
              imageUrl: _imageUrl!,
              size: ProfilePictureSize.small,
            ),
            )

        ],
      ),
    );
    }
  }
}