class Choice {
  Choice({
    this.name,
    this.price,
    this.customerPrice,
    this.sellerPrice,
    this.pick,
  });

  String name;
  dynamic price;
  dynamic customerPrice;
  dynamic sellerPrice;
  String pick;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        pick: json["pick"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
        "pick": pick,
      };
}
