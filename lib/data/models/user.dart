class User {
  User({
    this.name,
    this.cellphoneNumber
  });

  String name;
  String cellphoneNumber;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        cellphoneNumber: json["cellphone_number"]
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cellphone_number": cellphoneNumber,
      };
}
