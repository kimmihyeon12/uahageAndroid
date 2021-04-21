class KidsCafe {
  KidsCafe(
      {this.id, this.name, this.address, this.phone, this.fare, this.bookmark});
  int id;
  String name;
  String address;
  String phone;
  String fare;
  int bookmark;

  factory KidsCafe.fromJson(Map<String, dynamic> json) => KidsCafe(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      fare: json["fare"],
      bookmark: json["bookmark"]);
}
