import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/pages/main_page.dart';
import 'package:doriapp/pages/recover_account.dart';
import 'package:doriapp/pages/registration_page.dart';
import 'package:doriapp/services/profile_repository.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/utils/text_styles.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  bool showPassword = false;
  final formKey = GlobalKey<FormState>();

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
      obscureText: !showPassword,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, ingrese su contraseña";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecoverPage()),
          );
        },
        child: Text(
          "¿Has olvidado tu contraseña?",
          style: CustomTextStyles.small,
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Spacer(flex: 1),
            buildEmail(),
            const SizedBox(height: 10.0),
            buildPassword(),
            buildForgotPasswordButton(context),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: RoundButton(
              text: "INICIAR SESIÓN",
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  UserCredential? userCredential = await login();
                  if (userCredential != null) {
                    if (userCredential.user!.emailVerified) {
                      final user = await ProfileRepository().getUserData();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage(user: user)),
                            (route) => false);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Por favor, verifica tu correo electrónico"),
                            ),
                          );
                        }
                      }
                    }
                  }
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
                  MaterialPageRoute(builder: (context) => const RegistrationPage()),
                );
              },
              child: Text(
                "¿No tienes cuenta? Regístrate",
                style: CustomTextStyles.small,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<UserCredential?> login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        buildSnackBar("Usuario no encontrado.");
      }
      if (e.code == 'wrong-password') {
        buildSnackBar("Contraseña incorrecta.");
      } else {
        buildSnackBar("Error al iniciar sesión. Por favor, intente nuevamente.");
      }
    }
    return null;
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
              const Expanded(flex: 1, child: TitleWidget(text: CustomTexts.login)),
              buildForm(context),
              buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
