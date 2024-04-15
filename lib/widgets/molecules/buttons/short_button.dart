import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';


class ShortButton extends StatelessWidget {
  final String buttonText;
  final bool activated;
  final Icon? icon;
  final VoidCallback onPressed;
  final bool small;
  const ShortButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.activated,
    this.small = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(

      onPressed: activated ? onPressed : null,
      style: FilledButton.styleFrom(
        padding: small ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12) : const EdgeInsets.all(12),

        backgroundColor: activated ? ProjectPalette.primary1 : ProjectPalette.neutral4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 8),
          Text(
            buttonText,
            style: ProjectFonts.button.copyWith(
              color: activated ? ProjectPalette.neutral3 : ProjectPalette.neutral5,
            ),
          ),
        ],
      ),
    );
  }
}
