class Details {
  Details({
    this.refCode,
    this.paymentUrl,
    this.link,
    this.fee,
  }
  );

  String refCode;
  String paymentUrl;
  String link;
  dynamic fee;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    refCode: json['ref_code'],
    paymentUrl: json['payment_url'],
    link: json['link'],
    fee: json['fee'],

  );

  Map<String, dynamic> toJson() => {
    'ref_code': refCode,
    'payment_url': paymentUrl,
    'link': link,
    'fee': fee,
  };
}
