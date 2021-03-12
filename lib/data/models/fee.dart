class Fee {
  Fee({
    this.subTotal,
    this.delivery,
    this.discountCode,
    this.discountPrice,
    this.totalPrice,
    this.customerTotalPrice,
    this.sellerTotalPrice,
  });

  dynamic subTotal;
  dynamic delivery;
  dynamic discountCode;
  dynamic discountPrice;
  dynamic totalPrice;
  dynamic customerTotalPrice;
  dynamic sellerTotalPrice;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"] == null ? null : json["sub_total"],
        delivery: json["delivery"],
        discountCode: json["discount_code"],
        discountPrice: json["discount_price"],
        totalPrice: json["total_price"] == null ? null : json["total_price"],
        customerTotalPrice: json["customer_total_price"] == null ? null : json["customer_total_price"],
        sellerTotalPrice: json["seller_total_price"] == null ? null : json["seller_total_price"],
      );

  Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "delivery": delivery,
        "discount_code": discountCode,
        "discount_price": discountPrice,
        "total_price": totalPrice,
        "customer_total_price": customerTotalPrice,
        "seller_total_price": sellerTotalPrice,
      };
}
