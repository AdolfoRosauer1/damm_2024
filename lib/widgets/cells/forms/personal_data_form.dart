import 'package:damm_2024/config/router.dart';
import 'package:damm_2024/providers/volunteer_provider.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/widgets/atoms/icons.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ProjectPalette.secondary2,
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16,8,0,8),
                          child: Text(
                            'Información de perfil',
                            style: ProjectFonts.subtitle1,
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          radioTheme: Theme.of(context).radioTheme.copyWith(
                            fillColor: MaterialStateProperty.all(ProjectPalette.primary1),
                          ),                  
                        ),
                        child: FormBuilderRadioGroup(
                          initialValue: volunteer.gender,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 8)
                            
                          ),
                          name: 'gender',
                          orientation: OptionsOrientation.vertical,
                          wrapRunSpacing: 0,
                          
                          //TODO fix el espacio entre las opciones
                          options: [
                            FormBuilderFieldOption(value: 'male', child: Text('Hombre',style: ProjectFonts.body1.copyWith(color: Color(0xFF000000)))),
                            FormBuilderFieldOption(value: 'female', child: Text('Mujer',style: ProjectFonts.body1.copyWith(color: Color(0xFF000000)))),
                            FormBuilderFieldOption(value: 'nonBinary', child: Text('No binario',style: ProjectFonts.body1.copyWith(color: Color(0xFF000000)))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24,),
                FormBuilderField(
                  name: 'profilePicture',
                  builder: (FormFieldState<dynamic> field){
                    return ProfilePictureCard(imageUrl: volunteer.profileImageURL,);
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
                  onPressed: ()=>{},
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
