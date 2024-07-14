import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final String title;
  final List<String> labels;
  final FormFieldState state;

  const InputCard({super.key, required this.title, required this.state, required this.labels});

  @override
  Widget build(BuildContext context) {
    final errorStyle = Theme.of(context).inputDecorationTheme.errorStyle ??
        const TextStyle(color: ProjectPalette.error, fontSize: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        Container(
          decoration:  BoxDecoration(
            color: ProjectPalette.neutral3,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: state.hasError ? ProjectPalette.error : Colors.transparent,
              width: 1.0
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: ProjectPalette.secondary2,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(4))
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
                  children: 
                    labels.map((label) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          radioTheme: Theme.of(context).radioTheme.copyWith(
                            fillColor: WidgetStateProperty.all(ProjectPalette.primary1),
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
            ]
          ),
        ),
        if (state.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0),
            child: Text(
              state.errorText!,
              style: errorStyle,
            ),
          ),
          
      ],
    );
  }
}
