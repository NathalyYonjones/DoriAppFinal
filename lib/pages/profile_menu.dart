import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/pages/change_music.dart';
import 'package:doriapp/pages/games.dart';
import 'package:doriapp/pages/info.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatefulWidget {
  final Profile user;
  final AppUser appUser;
  final String ip;
  const ProfileMenu(
      {super.key, required this.user, required this.appUser, required this.ip});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets().buildProfileAppBar(
          widget.user.name!,
          context,
          isMainPage: true,
          image: widget.user.image!,
          user: widget.user,
          appUser: widget.appUser,
        ),
        backgroundColor: CustomColors.primaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/miditoys.png'),
                    width: 135,
                    height: 100,
                    fit: BoxFit.cover),
                const Image(
                    image: AssetImage('assets/dori.png'),
                    width: 350,
                    height: 150,
                    fit: BoxFit.cover),
                const SizedBox(height: 75.0),
                RoundButton(
                  text: "CAMBIAR MÚSICA",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeMusicPage(
                                user: widget.user,
                                appUser: widget.appUser,
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                RoundButton(
                  text: "SEGUIMIENTO",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamesPage(
                                user: widget.user,
                                appUser: widget.appUser,
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                RoundButton(
                  text: "INFORMACIÓN",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPage(
                                user: widget.user,
                                appUser: widget.appUser,
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
