
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String localizeCurrency(double value, BuildContext context) {

    Locale myLocale = Localizations.localeOf(context);

    String formattedCurrency;
    if (myLocale.languageCode == 'es') {
      // Formato para español (España)
      formattedCurrency = NumberFormat.currency(
        locale: 'es', 
        symbol: '\$', 
        decimalDigits: 2,
      ).format(value);
     // formattedCurrency = formattedCurrency.replaceAll('.', '#').replaceAll(',', '.').replaceAll('#', ',');
    } else {
      // Formato para inglés (Estados Unidos)
      formattedCurrency = NumberFormat.currency(
        locale: 'en', 
        symbol: '\$', 
        decimalDigits: 2,
      ).format(value);
    }

    return formattedCurrency;
}

String localizeDate(DateTime date, BuildContext context) {

    Locale myLocale = Localizations.localeOf(context);

    String formattedDate;
    if (myLocale.languageCode == 'es') {
      // Formato para español (España)
      formattedDate = DateFormat('dd/MM/yyyy', 'es').format(date);
    } else {
      // Formato para inglés (Estados Unidos)
      formattedDate = DateFormat('MM/dd/yyyy', 'en').format(date);
    }
    return formattedDate;
}