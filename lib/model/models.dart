class AppUser {
  String? id;
  String? name;
  String? email;
  int? date;
  bool? isAdmin;
  List<Profile>? profiles;

  AppUser({this.name, this.email, this.date, this.isAdmin, this.profiles});

  AppUser.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    email = json['email'];
    date = json['date'];
    isAdmin = json['isAdmin'];
  }

  void setId(String id) {
    this.id = id;
  }
}

class Profile {
  String? id;
  String? name;
  String? age;
  String? institution;
  int? image;
  List<GameB>? gamesB;
  List<GameC>? gamesC;

  Profile(
      {this.id,
      this.name,
      this.age,
      this.institution,
      this.image,
      this.gamesB,
      this.gamesC});

  Profile.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    age = json['age'];
    institution = json['institution'];
    image = json['image'];
  }

  void setId(String id) {
    this.id = id;
  }

  void setGamesB(List<GameB> gamesB) {
    this.gamesB = gamesB;
  }

  void setGamesC(List<GameC> gamesC) {
    this.gamesC = gamesC;
  }
}

class GameB {
  int? errors;
  int? time;

  GameB({this.errors, this.time});

  GameB.fromJson(Map<String, dynamic> json) {
    errors = json['errors'];
    time = json['time'];
  }
}

class GameC {
  List<GameColor>? colors;

  GameC({required this.colors});

  factory GameC.fromMap(Map<String, dynamic> map) {
    List<GameColor> colorList = [];
    map.forEach((colorName, resultMap) {
      colorList.add(GameColor.fromMap(colorName, resultMap));
    });
    return GameC(colors: colorList);
  }
}

class GameResult {
  int? errors;
  int? corrects;

  GameResult({this.errors, this.corrects});

  GameResult.fromJson(Map<String, dynamic> json) {
    errors = json['errors'];
    corrects = json['corrects'];
  }
}

class GameColor {
  String? colorName;
  GameResult? result;

  GameColor({this.colorName, this.result});

  factory GameColor.fromMap(String colorName, Map<String, dynamic> map) {
    return GameColor(
      colorName: colorName,
      result: GameResult.fromJson(map),
    );
  }
}

class Audio {
  String? name;
  bool? isAccepted;

  Audio({this.name, this.isAccepted});
}
