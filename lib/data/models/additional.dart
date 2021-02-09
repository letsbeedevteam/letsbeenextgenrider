import 'package:letsbeenextgenrider/data/models/pick.dart';

class Additional {
  Additional({
    this.id,
    this.name,
    this.price,
    this.customerPrice,
    this.sellerPrice,
  });

  int id;
  String name;
  dynamic price;
  dynamic customerPrice;
  dynamic sellerPrice;

  factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
      };
}
