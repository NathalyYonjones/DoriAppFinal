import 'package:doriapp/constants/texts.dart';
import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/pages/main_page.dart';
import 'package:doriapp/services/profile_repository.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  final Profile user;

  const ViewProfilePage({super.key, required this.user});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  late String profile, age, institution;
  int image = 0;
  final formKey = GlobalKey<FormState>();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    profile = widget.user.name!;
    age = widget.user.age!;
    institution = widget.user.institution!;
    image = widget.user.image!;
    dbRef = FirebaseDatabase.instance.ref().child("users");
  }

  bool registering = false;

  Widget buildName() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: profile,
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
      initialValue: age,
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
      initialValue: (institution == "No especificado") ? "" : institution,
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

  Future<void> editProfile(String uuidUser, String uuidProfile) async {
    final snapshot =
        await dbRef.child(uuidUser).child("profile").child(uuidProfile).get();

    if (snapshot.exists) {
      await dbRef.child(uuidUser).child("profile").child(uuidProfile).update({
        "name": profile,
        "age": age,
        "institution": institution,
        "image": image,
      });
    }
  }

  Future<void> deleteProfile(String uuidUser, String uuidProfile) async {
    final snapshot =
        await dbRef.child(uuidUser).child("profile").child(uuidProfile).get();

    if (snapshot.exists) {
      await dbRef.child(uuidUser).child("profile").child(uuidProfile).remove();
    }
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
                            text: "EDITAR PERFIL",
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                User? user = FirebaseAuth.instance.currentUser;
                                await editProfile(user!.uid, widget.user.id!);
                                AppUser appUser = await ProfileRepository().getUserData();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage(user: appUser)),
                                      (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Perfil editado."),
                                    ),
                                  );
                                }
                              }
                            })),
                    const SizedBox(height: 20.0),
                    Align(
                        alignment: Alignment.center,
                        child: RoundButton(
                            text: "BORRAR PERFIL",
                            isDelete: true,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                User? user = FirebaseAuth.instance.currentUser;
                                await deleteProfile(user!.uid, widget.user.id!);
                                AppUser appUser = await ProfileRepository().getUserData();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage(user: appUser)),
                                      (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Perfil eliminado."),
                                    ),
                                  );
                                }
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
