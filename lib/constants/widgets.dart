import 'package:doriapp/main.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/pages/profile_config.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static AppBar appBar = AppBar(
    backgroundColor: CustomColors.primaryColor,
    toolbarHeight: 100,
    title: const Align(
      alignment: Alignment.centerRight,
      child: Image(
        image: AssetImage('assets/dori.png'),
        width: 115,
        height: 50,
        fit: BoxFit.cover,
      ),
    ),
  );

  buildProfileAppBar(
    String name,
    BuildContext context, {
    bool isMainPage = false,
    bool isConfigPage = false,
    int image = 0,
    String title = '',
    Profile? user,
    AppUser? appUser,
  }) {
    var actionsMain = [
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.person,
            size: 28,
            color: CustomColors.secondaryColor,
          ),
          label: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: CustomColors.secondaryColor,
            ),
          ),
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          icon: const Icon(
            Icons.logout,
            size: 28,
            color: CustomColors.secondaryColor,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
    ];

    var actions = [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: TextButton.icon(
          onPressed: (!isConfigPage)
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileConfig(
                        user: user!,
                        appUser: appUser!,
                      ),
                    ),
                  );
                }
              : () {},
          icon: Image.asset(
            'assets/avatars/image_$image.png',
            width: 35,
            height: 35,
          ),
          label: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: CustomColors.secondaryColor,
            ),
          ),
        ),
      ),
    ];

    return AppBar(
      backgroundColor: CustomColors.primaryColor,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: CustomColors.secondaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      leading: (!isMainPage)
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 28,
                  color: CustomColors.secondaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      actions: !isMainPage ? actionsMain : actions,
    );
  }
}
