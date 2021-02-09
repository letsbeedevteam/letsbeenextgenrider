class Fee {
  Fee({
    this.subTotal,
    this.delivery,
    this.discountCode,
    this.discountPrice,
    this.total,
  });

  dynamic subTotal;
  dynamic delivery;
  dynamic discountCode;
  dynamic discountPrice;
  dynamic total;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"] == null ? null : json["sub_total"],
        delivery: json["delivery"],
        discountCode: json["discount_code"],
        discountPrice: json["discount_price"],
        total: json["total_price"] == null ? null : json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "delivery": delivery,
        "discount_code": discountCode,
        "discount_price": discountPrice,
        "total_price": total,
      };
}
