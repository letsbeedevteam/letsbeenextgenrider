import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';

class Product {
  Product(
      {this.productId,
      this.name,
      this.price,
      this.customerPrice,
      this.sellerPrice,
      this.quantity,
      this.variants,
      this.additionals,
      this.note,
      this.removable});

  int productId;
  String name;
  dynamic price; // needs to be changed to double
  dynamic customerPrice; // needs to be changed to double
  dynamic sellerPrice; // needs to be changed to double
  int quantity;
  List<Choice> variants;
  List<Additional> additionals;
  String note;
  bool removable;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        quantity: json["quantity"],
        variants:
            List<Choice>.from(json["variants"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(
            json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"],
        removable: json["removable"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
        "quantity": quantity,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "note": note,
        "removable": removable,
      };
}
