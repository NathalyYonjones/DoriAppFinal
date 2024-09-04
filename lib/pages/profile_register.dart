import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/main.dart';
import 'package:doriapp/pages/login_page.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/utils/text_styles.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileRegisterPage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final int date;
  const ProfileRegisterPage(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.date});

  @override
  State<ProfileRegisterPage> createState() => _ProfileRegisterPageState();
}

class _ProfileRegisterPageState extends State<ProfileRegisterPage> {
  late String profile, age, institution;
  int image = 0;
  final formKey = GlobalKey<FormState>();

  late DatabaseReference dbRef;

  bool registering = false;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("users");
  }

  Widget buildName() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        profile = value!;
      },
      keyboardType: TextInputType.text,
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

  Widget buildAge() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        age = value!;
      },
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: "Edad",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, ingrese su edad";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildInstitution() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (String? value) {
        institution = value!;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: "Institución*",
      ),
    );
  }

  Widget buildImage() {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                image = (image - 1) % 8;
              });
            },
          ),
          Expanded(
            child: Image.asset(
              'assets/avatars/image_$image.png',
              width: 100,
              height: 100,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                image = (image + 1) % 8;
              });
            },
          ),
        ],
      ),
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
            buildAge(),
            const SizedBox(height: 10.0),
            buildInstitution(),
            const SizedBox(height: 30.0),
            buildImage(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Future<void> createUser(String uuid, String name, String email, int date) async {
    Map<String, dynamic> user = {
      "name": name,
      "email": email,
      "date": date,
      "isAdmin": 0,
    };

    await dbRef.child(uuid).set(user);
  }

  Future<void> setProfile(
      String uuid, String name, String age, String institution, int image) async {
    Map<String, dynamic> profile = {
      "name": name,
      "age": age,
      "institution": institution,
      "image": image,
    };

    await dbRef.child(uuid).child("profile").push().set(profile);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<UserCredential?> registerUser() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: widget.email, password: widget.password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        buildSnackBar("Contraseña débil. Por favor, ingrese una contraseña más segura.");
      } else if (e.code == 'email-already-in-use') {
        buildSnackBar("Correo ya registrado. Por favor, ingrese otro correo.");
      } else {
        buildSnackBar("Error al registrar. Por favor, intente nuevamente.");
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Expanded(flex: 1, child: TitleWidget(text: CustomTexts.registroSub)),
              buildForm(),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: RoundButton(
                            text: "REGISTRARSE",
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                UserCredential? userCredential = await registerUser();
                                if (userCredential != null) {
                                  userCredential.user!.sendEmailVerification();
                                  await createUser(userCredential.user!.uid, widget.name,
                                      widget.email, widget.date);
                                  await setProfile(userCredential.user!.uid, profile, age,
                                      institution, image);
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage()),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Registro realizado. Correo de verificación enviado."),
                                      ),
                                    );
                                  }
                                }
                              }
                            })),
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
            ]),
          ),
        ));
  }
}
