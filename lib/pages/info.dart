import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final Profile user;
  final AppUser appUser;
  const InfoPage({super.key, required this.user, required this.appUser});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets().buildProfileAppBar(
          widget.user.name!,
          context,
          isMainPage: true,
          title: 'Información',
          appUser: widget.appUser,
          user: widget.user,
          image: widget.user.image!,
        ),
        backgroundColor: CustomColors.primaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Image(
                  image: AssetImage('assets/toy.png'),
                  fit: BoxFit.cover,
                  height: 350,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo at the top
                      Image.asset(
                        'assets/dori.png', // Replace with your logo path
                        height: 60,
                      ),
                      const SizedBox(height: 20), // Spacing between logo and text
                      // Main description text
                      const Text(
                        'DORI es un rompecabezas interactivo que enseña los colores básicos, '
                        'estimulando el desarrollo cognitivo y motriz de tus hijos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20), // Spacing between text sections
                      // Monitoring description
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Con esta aplicación puedes '),
                            TextSpan(
                              text: 'monitorear',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' el uso del juguete y el progreso de tu hijo.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Spacing between text sections
                      // Music feature description
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Además, puedes colocar la '),
                            TextSpan(
                              text: 'canción favorita',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' de tu hijo para que ',
                            ),
                            TextSpan(
                              text: 'DORI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' la reproduzca.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
