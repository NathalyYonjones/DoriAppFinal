import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/pages/registration_page.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/utils/text_styles.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/text_field.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoverPage extends StatelessWidget {
  const RecoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

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
              const Expanded(flex: 1, child: TitleWidget(text: CustomTexts.recuperar)),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    CustomTextField(
                      hintText: "Correo electrónico",
                      isPassword: false,
                      controller: emailController,
                      validate: false,
                      errorText: CustomTexts.invalidEmail,
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: RoundButton(
                          text: "ENVIAR",
                          onPressed: () {
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(
                              email: emailController.text,
                            )
                                .then((value) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Correo enviado."),
                                  ),
                                );
                              }
                            }).onError((error, stackTrace) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Error al enviar correo. Correo no registrado."),
                                  ),
                                );
                              }
                            });
                          },
                        )),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationPage()),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
