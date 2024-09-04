import 'package:doriapp/model/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  Future<AppUser> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child("users/${user!.uid}").get();

    if (snapshot.exists) {
      List<Profile> profiles = [];

      final data = snapshot.value as Map<dynamic, dynamic>;

      if (data['profile'] != null) {
        final profileData = data['profile'] as Map<dynamic, dynamic>;

        profileData.forEach((key, value) {
          final info = value as Map<dynamic, dynamic>;
          Profile newProfile = Profile(
              name: info['name'],
              age: info['age'],
              institution: info['institution'],
              image: info['image']);
          newProfile.setId(key);

          if (info['gamesB'] != null) {
            List<GameB> newGamesB = [];

            final gamesB = info['gamesB'] as Map<dynamic, dynamic>;
            gamesB.forEach((key, value) {
              final game = value as Map<dynamic, dynamic>;
              GameB newGame = GameB(time: game['time'] ~/ 1000, errors: game['errors']);
              newGamesB.add(newGame);
            });

            newProfile.setGamesB(newGamesB);
          }

          if (info['gamesC'] != null) {
            List<GameC> newGamesC = [];

            final gamesC = info['gamesC'] as Map<dynamic, dynamic>;
            gamesC.forEach((key, value) {
              final game = value as Map<dynamic, dynamic>;

              final blue = game['blue'] as Map<dynamic, dynamic>;
              final red = game['red'] as Map<dynamic, dynamic>;
              final yellow = game['yellow'] as Map<dynamic, dynamic>;

              GameResult blueResult = GameResult(
                errors: blue['errors'],
                corrects: blue['corrects'],
              );

              GameResult redResult = GameResult(
                errors: red['errors'],
                corrects: red['corrects'],
              );

              GameResult yellowResult = GameResult(
                errors: yellow['errors'],
                corrects: yellow['corrects'],
              );

              GameColor blueColor = GameColor(
                colorName: 'blue',
                result: blueResult,
              );

              GameColor redColor = GameColor(
                colorName: 'red',
                result: redResult,
              );

              GameColor yellowColor = GameColor(
                colorName: 'yellow',
                result: yellowResult,
              );

              GameC newGame = GameC(colors: [blueColor, redColor, yellowColor]);
              newGamesC.add(newGame);
            });

            newProfile.setGamesC(newGamesC);
          }
          profiles.add(newProfile);
        });
      }

      AppUser newUser = AppUser(
          name: data['name'],
          email: data['email'],
          date: data['date'],
          isAdmin: (data['isAdmin'] == 1) ? true : false,
          profiles: profiles);

      newUser.setId(user.uid);

      return newUser;
    }

    throw Exception();
  }

  Future<void> sendData(String uuid, String id, String ip) async {
    final url = Uri.parse('http://$ip/update');

    final response = await http.post(
      url,
      body: {
        "uuid": uuid,
        "id": id,
      },
    );

    if (response.statusCode == 200) {
      print('Datos enviados correctamente: ${response.body}');
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }
}
