import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final String title;
  final List<String> labels;
  final FormFieldState state;

  const InputCard({super.key, required this.title, required this.labels, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ProjectPalette.neutral3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: ProjectPalette.secondary2,
            ),
            child: Text(
              title,
              style: ProjectFonts.subtitle1,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: labels.map((label) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    radioTheme:Theme.of(context).radioTheme.copyWith(
                      fillColor: MaterialStateProperty.all(ProjectPalette.primary1)
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        visualDensity: VisualDensity.comfortable,
                        value: label,
                        groupValue: state.value,
                        onChanged: (String? value) {
                          state.didChange(value);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        label,
                        style: ProjectFonts.body1.copyWith(
                          color: ProjectPalette.black,
                      ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
