import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Gender { man, woman, nonBinary }

extension GenderExtension on Gender {

  String get value {
    switch (this) {
      case  Gender.man:
        return "Hombre";
      case Gender.woman:
        return "Mujer";
      case Gender.nonBinary:
        return "No Binario";
      default:
        return "";
    }
  }
      


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



Gender? genderFromString(String genderStr) {
  if (genderStr == Gender.man.value) {
    return Gender.man;
  } else if (genderStr == Gender.woman.value) {
    return Gender.woman;
  } else if (genderStr == Gender.nonBinary.value) {
    return Gender.nonBinary;
  } else {
    return null;
  }
}

