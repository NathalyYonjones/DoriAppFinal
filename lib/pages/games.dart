import 'package:doriapp/constants/widgets.dart';
import 'package:doriapp/model/models.dart';
import 'package:doriapp/services/profile_repository.dart';
import 'package:doriapp/utils/colors.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  final Profile user;
  final AppUser appUser;
  const GamesPage({super.key, required this.user, required this.appUser});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  bool isArmadoCorrecto = true;
  late List<GameB> gamesB;
  late List<GameC> gamesC;

  @override
  void initState() {
    super.initState();
    if (widget.user.gamesB != null) {
      gamesB = widget.user.gamesB!;
    } else {
      gamesB = [];
    }
    if (widget.user.gamesC != null) {
      gamesC = widget.user.gamesC!;
    } else {
      gamesC = [];
    }
  }

  Color getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'yellow':
        return Colors.yellow;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey; // Color por defecto si el color no coincide
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        AppUser newUser = await ProfileRepository().getUserData();

        for (var profile in newUser.profiles!) {
          if (profile.id == widget.user.id) {
            widget.user.gamesB = profile.gamesB;
            widget.user.gamesC = profile.gamesC;
          }
        }

        setState(() {
          if (widget.user.gamesB != null) {
            gamesB = widget.user.gamesB!;
          } else {
            gamesB = [];
          }

          if (widget.user.gamesC != null) {
            gamesC = widget.user.gamesC!;
          } else {
            gamesC = [];
          }
        });

        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: Scaffold(
          appBar: CustomWidgets().buildProfileAppBar(
            widget.user.name!,
            context,
            isMainPage: true,
            title: 'Seguimiento',
            appUser: widget.appUser,
            user: widget.user,
            image: widget.user.image!,
          ),
          backgroundColor: CustomColors.primaryColor,
          body: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Buscar',
              //       prefixIcon: Icon(Icons.search),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: DropdownButtonFormField<int>(
                  value: 0,
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Armado correcto'),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Identificación de color'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isArmadoCorrecto = value == 0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Categoría de juego:',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              (isArmadoCorrecto)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: gamesB.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset(
                                'assets/rompe.png'), // Reemplaza con el icono real
                            title: Text('Juego Armado Correcto ${index + 1}'),
                            subtitle: const Text('Ver más información'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Text('Informe de Juego',
                                        textAlign: TextAlign.center),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Alinea el texto a la izquierda
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/rompe.png',
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text(
                                              'Errores: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Pone "Errores" en bold
                                            ),
                                            Text('${gamesB[index].errors}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text(
                                              'Tiempo: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold), // Pone "Tiempo" en bold
                                            ),
                                            Text('${formatDuration(gamesB[index].time)}'),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: gamesC.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset(
                                'assets/rompe.png'), // Reemplaza con el icono real
                            title: Text('Juego Identificar Color ${index + 1}'),
                            subtitle: const Text('Ver más información'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Colors.cyan[50], // Color de fondo del dialog
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Center(
                                      child: Text('Informe de Juego'),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/rompe.png', // Asegúrate de tener esta imagen en tu proyecto
                                          width: 100,
                                          height: 100,
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        // Recorrido de cada color en gamesC
                                        for (var color in gamesC[index].colors!)
                                          Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                color: getColor(color.colorName!),
                                                padding: const EdgeInsets.all(8),
                                                child: Center(
                                                  child: Text(
                                                    getSpanishColor(color.colorName!),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                color: getColor(color.colorName!)
                                                    .withOpacity(0.6),
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Aciertos'),
                                                        Text('${color.result!.corrects}'),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Errores'),
                                                        Text('${color.result!.errors}'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          )),
    );
  }
}

String getSpanishColor(String s) {
  switch (s.toLowerCase()) {
    case 'yellow':
      return 'Amarillo';
    case 'red':
      return 'Rojo';
    case 'blue':
      return 'Azul';
    default:
      return 'Color desconocido';
  }
}

formatDuration(int? time) {
  if (time == null) {
    return 'N/A';
  }
  final minutes = time ~/ 60;
  final seconds = time % 60;
  return '$minutes minutos $seconds segundos';
}
