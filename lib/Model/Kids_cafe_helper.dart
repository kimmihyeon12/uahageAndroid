class KidsCafe {
  KidsCafe({
    this.name,
    this.address,
    this.phone,
    this.fare,

  });

  String name;
  String address;
  String phone;
  String fare;


  factory KidsCafe.fromJson(Map<String, dynamic> json) => KidsCafe(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        fare: json["fare"],

      );
}
