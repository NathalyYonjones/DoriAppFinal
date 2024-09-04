import 'dart:async';

import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/services/profile_repository.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({
    super.key,
  });

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
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

  Future<void> addProfile(String id) async {
    final snapshot = dbRef.child(id).child("profile");

    final json = {
      "name": profile,
      "age": age,
      "institution": institution,
      "image": image
    };

    snapshot.push().set(json);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackBar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
                            text: "AGREGAR PERFIL",
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                User? user = FirebaseAuth.instance.currentUser;
                                await addProfile(user!.uid);
                                Timer(const Duration(milliseconds: 200), () async {
                                  AppUser appUser =
                                      await ProfileRepository().getUserData();
                                  if (context.mounted) {
                                    Navigator.pop(context, appUser);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Perfil agregado."),
                                      ),
                                    );
                                  }
                                });
                              }
                            })),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
