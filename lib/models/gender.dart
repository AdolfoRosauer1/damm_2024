import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Gender { man, woman, nonBinary }

extension GenderExtension on Gender {
  String localizedValue(BuildContext context) {
    switch (this) {
      case Gender.man:
        return AppLocalizations.of(context)!.male;
      case Gender.woman:
        return AppLocalizations.of(context)!.female;
      case Gender.nonBinary:
        return AppLocalizations.of(context)!.nonBinary;
      default:
        return '';
    }
  }
}

Gender? genderFromString(String genderStr, BuildContext context) {
  if (genderStr == AppLocalizations.of(context)!.male) {
    return Gender.man;
  } else if (genderStr == AppLocalizations.of(context)!.female) {
    return Gender.woman;
  } else if (genderStr == AppLocalizations.of(context)!.nonBinary) {
    return Gender.nonBinary;
  } else {
    return null;
  }
}

