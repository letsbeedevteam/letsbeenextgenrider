import 'package:letsbeenextgenrider/data/models/pick.dart';

class Additional {
  Additional({
    this.name,
    this.picks,
  });

  String name;
  List<Pick> picks;

  factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        name: json["name"],
        picks: List<Pick>.from(json["picks"].map((x) => Pick.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "picks": List<dynamic>.from(picks.map((x) => x.toJson())),
      };
}
