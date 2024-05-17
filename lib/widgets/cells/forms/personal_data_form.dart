import 'package:damm_2024/config/router.dart';
import 'package:damm_2024/models/gender.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
import 'package:damm_2024/widgets/cells/cards/input_card.dart';
import 'package:damm_2024/widgets/cells/cards/profile_picture_card.dart';
import 'package:damm_2024/widgets/molecules/buttons/cta_button.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:damm_2024/widgets/tokens/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalDataForm extends ConsumerWidget {
  const PersonalDataForm({super.key});
  
  static const route = "editProfile";
  static const completeRoute = "${ProfileScreen.route}/$route";


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteer = ref.watch(volunteerProvider);
    final formKey = GlobalKey<FormBuilderState>();

    
    return Theme(
      data: ThemeData(
        appBarTheme: const AppBarTheme(
          color: ProjectPalette.neutral1
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: ProjectPalette.neutral6),
          leading:IconButton(
            onPressed: () => {
              CustomNavigationHelper.parentNavigatorKey.currentState!.pop()
              
            }, 
            icon: ProjectIcons.closeFilledEnabled),
        ),
        body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: formKey,
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Datos de perfil',
                    style: ProjectFonts.headline1,
                  ),
                ),
                const SizedBox(height: 24,),
                FormBuilderDateTimePicker(
                  name: 'dateOfBirth',
                  initialValue: volunteer.dateOfBirth,
                  decoration: InputDecoration(
                    suffixIcon: ProjectIcons.calendarFilledActivated,
                    
                    labelStyle: ProjectFonts.caption.copyWith(color: ProjectPalette.neutral6, backgroundColor: ProjectPalette.neutral3 ),
                    hintText: "DD/MM/YY",
                    hintStyle: ProjectFonts.subtitle1.copyWith(color: ProjectPalette.neutral5 ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Fecha de nacimiento',
                    
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ProjectPalette.neutral6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  inputType: InputType.date,
                  format: DateFormat('dd/MM/yyyy'),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: const BoxDecoration(
                    color: ProjectPalette.neutral3
                  ),
                  child: FormBuilderField(
                    name: 'gender',
                    initialValue: volunteer.gender?.value,
                    builder: (FormFieldState<dynamic> field){
                      return InputCard(title: 'Información de perfil',
                        labels: Gender.values.map((e) => e.value).toList(),
                        state: field

                      );
                    }
                  )
                  //  ],
               //   ),
                ),
                const SizedBox(height: 24,),
                FormBuilderField(
                  name: 'profilePicture',
                  builder: (FormFieldState<dynamic> field){
                    return ProfilePictureCard(imageUrl: volunteer.profileImageURL,field: field,);
                  }
                ),
                const SizedBox(height: 32,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Datos de contacto',
                    style: ProjectFonts.headline1,
                  ),
                ),
                const SizedBox(height: 24,),
                Text(
                  'Estos datos serán compartidos con la organización para ponerse en contacto contigo',
                  style: ProjectFonts.subtitle1,
                ),
                const SizedBox(height: 24,),
                FormBuilderTextField(
                  initialValue: volunteer.phoneNumber,
                  name: 'phoneNumber',
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ProjectPalette.neutral6),                    
                      borderRadius: BorderRadius.circular(4)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: const Text('Teléfono'),
                    labelStyle: ProjectFonts.caption.copyWith(color: ProjectPalette.neutral6, backgroundColor: ProjectPalette.neutral3 ),
                    hintText: 'Ej: +541178445459',
                    hintStyle: ProjectFonts.subtitle1.copyWith(color: ProjectPalette.neutral5 ),
          
                  ),
                ),
                const SizedBox(height: 24,),
                FormBuilderTextField(
                  initialValue: volunteer.email,
                  name: 'email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ProjectPalette.neutral6),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: const Text('Mail'),
                    labelStyle: ProjectFonts.caption.copyWith(color: ProjectPalette.neutral6, backgroundColor: ProjectPalette.neutral3 ),
                    hintText: 'Ej: mimail@mail.com',
                    hintStyle: ProjectFonts.subtitle1.copyWith(color: ProjectPalette.neutral5 ),
          
                  ),
                ),
                const SizedBox(height: 32,),
                CtaButton(
                  enabled: true,
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      // Formulario validado y guardado
                      final formData = formKey.currentState?.value;
                      print('Form Data: $formData');
                    } else {
                      // Manejar errores de validación
                      print('Validation failed');
                    }
                  },                 
                  filled: true,
                  actionStr: 'Guardar datos'
                ),
                const SizedBox(height: 32,)
              
                
              ],
            ),
          ),
                ),
        ),
      ),
    );
  }
}



Widget _buildRadioOption(FormFieldState<dynamic> field, String value, String label) {
  return Theme(
    data: Theme.of(field.context).copyWith(
      radioTheme: Theme.of(field.context).radioTheme.copyWith(
        fillColor: MaterialStateProperty.all(ProjectPalette.primary1),
      ),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Radio<String>(
            value: value,
            groupValue: field.value,
            onChanged: (val) {
              field.didChange(val);
            },
          ),
        ),
        Text(label,style: ProjectFonts.body1.copyWith(
          color: ProjectPalette.black
          ),
        ),
      ],
    ),
  );
}
