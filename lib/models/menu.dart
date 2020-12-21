import 'package:letsbeenextgenrider/models/additional.dart';
import 'package:letsbeenextgenrider/models/choice.dart';

class Menu {
    Menu({
        this.menuId,
        this.name,
        this.price,
        this.quantity,
        this.choices,
        this.additionals,
        this.note,
    });

    int menuId;
    String name;
    double price;
    int quantity;
    List<Choice> choices;
    List<Additional> additionals;
    dynamic note;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menu_id"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "note": note,
    };
}