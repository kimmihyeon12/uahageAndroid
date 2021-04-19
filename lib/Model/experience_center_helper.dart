class Experiencecenter {
  Experiencecenter({
    this.name,
    this.address,
    this.phone,
    this.fare,
  });

  String name;
  String address;
  String phone;
  String fare;


  factory Experiencecenter.fromJson(Map<String, dynamic> json) =>
      Experiencecenter(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        fare: json["fare"],
      );
}
