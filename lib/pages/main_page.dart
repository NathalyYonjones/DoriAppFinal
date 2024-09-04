import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/pages/add_profile_page.dart';
import 'package:doriapp/pages/profile_menu.dart';
import 'package:doriapp/services/profile_repository.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:doriapp/utils/text_styles.dart';
import 'package:doriapp/widgets/round_button.dart';
import 'package:doriapp/widgets/title_widget.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final AppUser user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  String ip = "";

  Future<void> _startProvisioning() async {
    final provisioner = Provisioner.espTouch();

    provisioner.listen((response) {
      Navigator.of(context).pop(response);
    });

    provisioner.start(ProvisioningRequest.fromStrings(
      ssid: ssidController.text,
      bssid: '00:00:00:00:00:00',
      password: passwordController.text,
    ));

    ProvisioningResponse? response = await showDialog<ProvisioningResponse>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buscando'),
          content: const Text('Buscando red. Espere...'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (provisioner.running) {
      provisioner.stop();
    }

    if (response != null) {
      ip = response.ipAddressText!;
      _onDeviceProvisioned(response);
    }
  }

  _onDeviceProvisioned(ProvisioningResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dispositivo Conectado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Dispositivo conectado correctamente a la red ${ssidController.text}'),
              SizedBox.fromSize(size: const Size.fromHeight(20)),
              const Text('Dispositivo:'),
              Text('IP: ${response.ipAddressText}'),
              Text('BSSID: ${response.bssidText}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets().buildProfileAppBar(widget.user.name!, context),
        backgroundColor: CustomColors.primaryColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
          child: Center(
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image(
                        image: AssetImage('assets/dori.png'),
                        width: 138,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/miditoys.png'),
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(30)),
                RoundButton(
                    text: "CONECTAR",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Conectar a Red"),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  Icons.cell_tower_outlined,
                                  size: 80,
                                  color: CustomColors.primaryColor,
                                  shadows: [
                                    Shadow(
                                      color: CustomColors.secondaryColor,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                SizedBox.fromSize(size: const Size.fromHeight(10)),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'SSID (Nombre de Red)',
                                  ),
                                  controller: ssidController,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                  ),
                                  obscureText: true,
                                  controller: passwordController,
                                ),
                                SizedBox.fromSize(size: const Size.fromHeight(20)),
                                ElevatedButton(
                                  onPressed: _startProvisioning,
                                  child: const Text('Conectar',
                                      style: TextStyle(
                                        color: CustomColors.secondaryColor,
                                      )),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar",
                                    style: TextStyle(
                                      color: CustomColors.secondaryColor,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                SizedBox.fromSize(size: const Size.fromHeight(30)),
                const Expanded(flex: 1, child: TitleWidget(text: 'Perfiles')),
                Expanded(
                  flex: 6,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.user.profiles!.length + 1,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      if (index == widget.user.profiles!.length) {
                        return ListTile(
                          title: Text(
                            'Agregar perfil',
                            style: CustomTextStyles.medium,
                          ),
                          leading: const Icon(Icons.add,
                              color: CustomColors.secondaryColor, size: 48),
                          onTap: () async {
                            AppUser newUser = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddProfilePage()),
                            );
                            setState(() {
                              widget.user.profiles = newUser.profiles;
                            });
                          },
                        );
                      } else {
                        final profile = widget.user.profiles![index];
                        return ListTile(
                          title: Text(
                            "Perfil ${index + 1}",
                            style: CustomTextStyles.smallBold,
                          ),
                          leading: Image.asset(
                            'assets/avatars/image_${profile.image}.png',
                            width: 50,
                            height: 50,
                          ),
                          subtitle: Text("Nombre: ${profile.name}"),
                          trailing: const Icon(Icons.navigate_next_outlined),
                          onTap: () {
                            ProfileRepository()
                                .sendData(widget.user.id!, profile.id!, ip);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileMenu(
                                  ip: ip,
                                  user: profile,
                                  appUser: widget.user,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }
}
