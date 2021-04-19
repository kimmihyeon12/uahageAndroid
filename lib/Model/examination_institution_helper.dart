class examinationinstitution {
  examinationinstitution({
    this.name,
    this.address,
    this.phone,
    this.examination,
  });

  String name;
  String address;
  String phone;
  String examination;


  factory examinationinstitution.fromJson(Map<String, dynamic> json) =>
      examinationinstitution(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        examination: json["examination"],
      );
}
