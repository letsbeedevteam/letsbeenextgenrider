class MotorcycleDetails {
  MotorcycleDetails({
    this.brand,
    this.model,
    this.plateNumber,
    this.color,
  });

  String brand;
  String model;
  String plateNumber;
  String color;
  MotorcycleDetails motorcycleDetails;

  factory MotorcycleDetails.fromJson(Map<String, dynamic> json) =>
      MotorcycleDetails(
        brand: json["brand"],
        model: json["model"],
        plateNumber: json["plate_number"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "model": model,
        "plate_number": plateNumber,
        "color": color,
      };
}
