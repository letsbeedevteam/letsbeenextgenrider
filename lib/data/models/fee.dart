class Fee {
    Fee({
        this.subTotal,
        this.delivery,
        this.discountCode,
        this.discountPrice,
        this.total,
    });

    double subTotal;
    int delivery;
    dynamic discountCode;
    int discountPrice;
    double total;

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"] == null ? null : json["sub_total"].toDouble(),
        delivery: json["delivery"],
        discountCode: json["discount_code"],
        discountPrice: json["discount_price"],
        total: json["total"] == null ? null : json["total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "delivery": delivery,
        "discount_code": discountCode,
        "discount_price": discountPrice,
        "total": total,
    };
}