import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/main.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/pages/view_profile.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileConfig extends StatelessWidget {
  final Profile user;
  final AppUser appUser;

  const ProfileConfig({super.key, required this.user, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets().buildProfileAppBar(
        user.name!,
        context,
        isMainPage: true,
        isConfigPage: true,
        image: user.image!,
        title: 'Cuenta',
      ),
      backgroundColor: CustomColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person, color: Colors.white, // User profile image
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appUser.name!, // User name
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appUser.email!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // // Account Settings Button
            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   decoration: BoxDecoration(
            //     color: CustomColors.secondaryColor,
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   child: const Row(
            //     children: [
            //       Icon(Icons.settings, color: Colors.white),
            //       SizedBox(width: 16),
            //       Text(
            //         'Configurar cuenta',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //         ),
            //       ),
            //       Spacer(),
            //       Icon(Icons.edit, color: Colors.white),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),

            // Other Options
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.white),
                    title: const Text(
                      'Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      // Navigate to feedback page
                    },
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: const Text(
                      'Ver Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfilePage(
                            user: user,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.white),
                    title: const Text(
                      'Reestablecer información de seguimiento',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      // Reset tracking information
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
