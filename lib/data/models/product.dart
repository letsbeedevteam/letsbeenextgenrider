import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';

class Product {
  Product({
    this.menuId,
    this.name,
    this.price,
    this.customerPrice,
    this.sellerPrice,
    this.quantity,
    this.choices,
    this.additionals,
    this.note,
  });

  int menuId;
  String name;
  dynamic price; // needs to be changed to double
  dynamic customerPrice; // needs to be changed to double
  dynamic sellerPrice; // needs to be changed to double
  int quantity;
  List<Choice> choices;
  List<Additional> additionals;
  dynamic note;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        menuId: json["product_id"],
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        quantity: json["quantity"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(
            json["additionals"].map((x) => Additional.fromJson(x))),
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
