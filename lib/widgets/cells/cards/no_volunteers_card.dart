import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';
enum NoVolunteersCardSize {
  small, 
  medium
}
class NoVolunteersCard extends StatelessWidget {
  const NoVolunteersCard({super.key, required this.message, required this.size});
  final String message;
  final NoVolunteersCardSize size;

  _getPadding(){
    switch(size){
      case NoVolunteersCardSize.small:
        return const EdgeInsets.symmetric(vertical: 18,horizontal: 24);
      case NoVolunteersCardSize.medium:
        return const EdgeInsets.symmetric(vertical: 30,horizontal: 24);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: _getPadding(),

      decoration: BoxDecoration(
        color: ProjectPalette.neutral1,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: ProjectFonts.subtitle1.copyWith(
              color: ProjectPalette.black
            ),
          ),
        ],
      ),

    );
  }
}