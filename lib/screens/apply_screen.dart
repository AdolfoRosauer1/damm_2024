import 'package:damm_2024/models/volunteer_details.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/services/volunteer_details_service.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/volunteering_card.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:damm_2024/widgets/tokens/shadows.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//TODO ver pq no se está aplicando bien la sombras en las cards
class ApplyScreen extends StatelessWidget{
  static const route = "/apply";
  late VolunteerDetailsService _volunteerDetailsService;

  ApplyScreen({super.key}){
    _volunteerDetailsService = VolunteerDetailsService();
  }

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
              child: FutureBuilder<List<VolunteerDetails>>(
                future: _volunteerDetailsService.getVolunteers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Errorr: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<VolunteerDetails> volunteerDetails = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemCount: volunteerDetails.length,
                      itemBuilder: (context, index) {
                        return VolunteeringCard(
                          onPressed: () => {
                            context.go(VolunteerDetailsScreen.routeFromId(volunteerDetails[index].id))
                          },
                          type: volunteerDetails[index].type,
                          title: volunteerDetails[index].title,
                          vacancies: volunteerDetails[index].vacancies,
                          imageUrl: volunteerDetails[index].imageUrl,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Sin datos disponibles'));
                  }
                },
              ),
            ),
            const SizedBox(height: 11),
        
        

          ],
        ),
      ),
    );
  }
}