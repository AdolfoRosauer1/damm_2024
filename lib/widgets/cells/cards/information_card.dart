import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InformationCard extends StatelessWidget{
  final String title;
  final String label1;
  final String content1;
  final String label2;
  final String content2;
  final bool hasMap;
  final LatLng? center;


  const InformationCard({super.key, required this.title, 
  required this.label1, required this.content1, required this.label2,
   required this.content2, this.hasMap=false, this.center});



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.neutral3
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            decoration: const BoxDecoration(
              color: ProjectPalette.secondary2
            ),
            child: Text(
              title,
              style: ProjectFonts.subtitle1,
            ),
          ),
          if (hasMap && center != null) ... [
            SizedBox(
              height: 155,
      
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: center!,
                    zoom: 15
                  ),
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId('Ubicación del voluntariado'),
                      position: center!
                    )
                  },
                ),
              ),
            )
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label1 ,
                  style: ProjectFonts.overline.copyWith(color: ProjectPalette.neutral6)
                ,),
                Text(
                  content1,
                  style: ProjectFonts.body1,
                ),
                const SizedBox(height: 8,),
                if (label2.isNotEmpty && content2.isNotEmpty) ... [
                  Text(
                    label2 ,
                    style: ProjectFonts.overline.copyWith(color: ProjectPalette.neutral6),
                  ),
                  Text(
                    content2,
                    style: ProjectFonts.body1,
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
}

}