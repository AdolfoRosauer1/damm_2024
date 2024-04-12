import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String actionStr;
  final bool enabled;
  final bool filled;
  final Color? textColor;
  const CtaButton({super.key,required this.enabled, required this.onPressed,required this.filled,required this.actionStr, this.textColor, });

  _getButtonBackgroundColor(){
    if (filled){
      return enabled ? ProjectPalette.primary1 : ProjectPalette.neutral4;
    }
    return Colors.transparent;
  }
  _getTextColor(){
    if (enabled){
      return filled ? ProjectPalette.neutral3 : ProjectPalette.primary1;

    }
    return ProjectPalette.neutral5;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          
          backgroundColor: _getButtonBackgroundColor(),
          shape: RoundedRectangleBorder(
    
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          actionStr,
          style: ProjectFonts.button.copyWith(
            color: textColor ?? _getTextColor()
          ), 
        ),
      ),
    );
  }
}
