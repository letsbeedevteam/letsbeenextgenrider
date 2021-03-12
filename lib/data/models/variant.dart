class Variant {
  Variant({
    this.type,
    this.price,
    this.customerPrice,
    this.sellerPrice,
    this.pick,
  });

  String type;
  dynamic price;
  dynamic customerPrice;
  dynamic sellerPrice;
  String pick;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        type: json["type"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        pick: json["pick"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
        "pick": pick,
      };
}
