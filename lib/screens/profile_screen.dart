//TODO conectar con riverpod y statemanagement
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/information_card.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/molecules/buttons/short_button.dart';
import 'package:damm_2024/widgets/molecules/components/profile_picture.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final Volunteer volunteer;

  const ProfileScreen({super.key, required this.volunteer});
  
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }

}

class _ProfileScreenState extends State<ProfileScreen> {
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    if (!widget.volunteer.hasCompletedProfile()){
      return Column(
        children: [
          const SizedBox(height: 147.5,),
          ProjectIcons.profilePicture,
          const SizedBox(height: 16,),
          Text(
            'VOLUNTARIO',
            style: ProjectFonts.overline.copyWith(color: ProjectPalette.neutral6)
          ),
          const SizedBox(height: 8,),
          Text(
            '${widget.volunteer.firstName} ${widget.volunteer.lastName}',
            style: ProjectFonts.subtitle1
          ),
          const SizedBox(height: 8,),
          Text(
            '¡Completá tu perfil para tener\n acceso a mejores oportunidades!',
            style: ProjectFonts.body1.copyWith(color: ProjectPalette.neutral6),
            textAlign: TextAlign.center,       
          ),
          //TODO CONSULTAR POR ESTAS ALTURAS
          SizedBox(height: 92,),
          ShortButton(onPressed: () => {}, buttonText:  'Completar', activated: true,icon:
            Icon(ProjectIcons.addFilledEnabled.icon, color: ProjectPalette.neutral1),)
        ],
      );
    }else{
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ProfilePicture(
                imageUrl: widget.volunteer.profileImageURL,
                size: ProfilePictureSize.large,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'VOLUNTARIO',
              style: ProjectFonts.overline.copyWith(color: ProjectPalette.neutral6)
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.volunteer.firstName} ${widget.volunteer.lastName}',
              style: ProjectFonts.subtitle1
            ), 
            const SizedBox(height: 2),
            Text(
              widget.volunteer.email,
              style: ProjectFonts.body1
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: InformationCard(
                title: 'Información Personal',
                label1: 'FECHA DE NACIMIENTO',
                content1: dateFormat.format(widget.volunteer.dateOfBirth!),
                label2: 'GÉNERO',
                content2: widget.volunteer.gender),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
              child: InformationCard(
                title: 'Datos de contacto',
                label1: 'TELÉFONO',
                content1: widget.volunteer.phoneNumber,
                label2: 'E-MAIL',
                content2: widget.volunteer.email),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(26,0,26,46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CtaButton(enabled: true, onPressed: () => {}, filled: true, actionStr: 'Editar perfil'),
                  const SizedBox(height: 8,),
                  CtaButton(enabled: true, onPressed: () => {}, filled: false, actionStr: 'Cerrar sesión', textColor: ProjectPalette.error),
                ],
              ),
            )
          ],
        )
      
      );
    }

  }
}