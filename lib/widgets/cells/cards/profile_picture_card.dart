import 'package:damm_2024/widgets/molecules/buttons/short_button.dart';
import 'package:damm_2024/widgets/molecules/components/profile_picture.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePictureCard extends StatefulWidget{
  final String? imageUrl;
  final FormFieldState field;

  const ProfilePictureCard({super.key, required this.imageUrl, required this.field});

  @override
  ProfilePictureCardState createState() => ProfilePictureCardState();
}

class ProfilePictureCardState extends State<ProfilePictureCard> {
  bool _isLoading = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  _getButtonText() {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return AppLocalizations.of(context)!.uploadPhoto;
    }
    return AppLocalizations.of(context)!.changePhoto;
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source); //ImageSource.camera
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

  Future<void> _selectImageSource() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(AppLocalizations.of(context)!.gallery),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: Text(AppLocalizations.of(context)!.camera),
            onTap: () async {
              Navigator.of(context).pop();
              var cameraStatus = await Permission.camera.status;
              if (!cameraStatus.isGranted) {
                await Permission.camera.request();
              }
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorStyle = Theme.of(context).inputDecorationTheme.errorStyle ??
    const TextStyle(color: ProjectPalette.error, fontSize: 12);

    if (_isLoading) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ProjectPalette.secondary2,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: widget.field.hasError ? ProjectPalette.error : Colors.transparent,
                width: 1.0
              )        
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
                    child: Text(
                      AppLocalizations.of(context)!.profilePhoto,
                      style: ProjectFonts.subtitle1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: ShortButton(
                    onPressed: () => _selectImageSource(),
                    small: true,
                    buttonText: _getButtonText(),
                    activated: true,
                  ),
                ),
              ],
            ),
          ),
          if (widget.field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                widget.field.errorText!,
                style: errorStyle,
              ),
            ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.field.hasError ? ProjectPalette.error : Colors.transparent,
                width: 1.0
              ),
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
                          AppLocalizations.of(context)!.profilePhoto,
                          style: ProjectFonts.subtitle1,
                        ),
                        const SizedBox(height: 8),
                        ShortButton(
                          onPressed: () => _selectImageSource(),
                          small: true,
                          buttonText: _getButtonText(),
                          activated: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 19, 8),
                  child: ProfilePicture(
                    imageUrl: _imageUrl!,
                    size: ProfilePictureSize.small,
                  ),
                ),
              ],
            ),
          ),
          if (widget.field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                widget.field.errorText!,
                style: errorStyle,
              ),
            ),
        ],
      );
    }
  }
}
