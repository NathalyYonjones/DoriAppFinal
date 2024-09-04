import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/pages/login_page.dart';
import 'package:doriapp/pages/profile_register.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/utils/functions.dart';
import 'package:doriapp/utils/text_styles.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime? pickedDate;

  TextEditingController dateController = TextEditingController();

  late String email, password, name;
  final formKey = GlobalKey<FormState>();

  bool showPassword = false;

  Widget buildEmail() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        email = value!;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Correo electrónico",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, ingrese su correo electrónico";
        } else if (!value.contains("@")) {
          return "Por favor, ingrese un correo electrónico válido";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        password = value!;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Contraseña",
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ),
      obscureText: !showPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, ingrese su contraseña";
        } else if (value.length < 6) {
          return "La contraseña debe tener al menos 6 caracteres";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildName() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        name = value!;
      },
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        labelText: "Nombre",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, ingrese su nombre";
        } else {
          return null;
        }
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    pickedDate = (await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      locale: const Locale('es', ''),
      confirmText: 'Aceptar',
    ))!;

    if (pickedDate != null) {
      setState(() {
        dateController.text = _formatDate(pickedDate!);
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString();
    final String month = CustomFunctions.getMonthName(date.month);
    final String year = date.year.toString();
    return '$day de $month del $year';
  }

  Widget buildDate() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      controller: dateController,
      onTap: () => _selectDate(context),
      decoration: const InputDecoration(
        labelText: "Fecha de nacimiento",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, seleccione una fecha";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildForm() {
    return Expanded(
        flex: 3,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Spacer(flex: 1),
              buildName(),
              const SizedBox(height: 10.0),
              buildEmail(),
              const SizedBox(height: 10.0),
              buildPassword(),
              const SizedBox(height: 10.0),
              buildDate(),
              const Spacer(flex: 2),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.appBar,
        backgroundColor: CustomColors.primaryColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: TitleWidget(text: CustomTexts.registro)),
                buildForm(),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: RoundButton(
                          text: "SIGUIENTE",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileRegisterPage(
                                          email: email,
                                          password: password,
                                          name: name,
                                          date: pickedDate!.microsecondsSinceEpoch,
                                        )),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "¿Ya tienes una cuenta? Iniciar Sesión",
                            style: CustomTextStyles.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))));
  }
}
