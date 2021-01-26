class Pick {
    Pick({
        this.id,
        this.name,
        this.price,
    });

    int id;
    String name;
    dynamic price;

    factory Pick.fromJson(Map<String, dynamic> json) => Pick(
        id: json["id"],
        name: json["name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
    };
}