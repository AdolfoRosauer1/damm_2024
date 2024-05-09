import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';

//TODO ver pq no se está aplicando bien la sombras en las cards
class ApplyScreen extends StatelessWidget{
  static const route = "/apply";

  const ApplyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const  BoxDecoration(
        color: ProjectPalette.secondary1,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,24,16,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ProjectPalette.neutral1,
                borderRadius: BorderRadius.circular(2),
                boxShadow: ProjectShadows.shadow1
              ),
              child: TextField(
                decoration: InputDecoration(
                  
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Buscar',
                  hintStyle: ProjectFonts.subtitle1.copyWith(color: ProjectPalette.neutral6),
                  prefixIcon: ProjectIcons.searchFilledEnabled,
                  suffixIcon: ProjectIcons.mapFilledActivated,

                ),
              ),
            ),
            const SizedBox(height: 32,),
            Text('Voluntariados', style: ProjectFonts.headline1),
            const SizedBox(height: 24,),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                separatorBuilder: (_,__) => const SizedBox(height: 24,),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const VolunteeringCard();
                },
              ), 
         
            ),
            const SizedBox(height: 11,)
        
        

          ],
        ),
      ),
    );
  }
}