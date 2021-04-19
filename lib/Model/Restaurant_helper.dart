class Restaurant {
  Restaurant({
    this.name,
    this.address,
    this.phone,
    this.bed,
    this.menu,
    this.chair,
    this.diapers,
    this.carriage,
    this.playroom,
    this.tableware,
    this.meetingroom,
    this.nursingroom,



  });


  String name;
  String address;
  String phone;
  String menu;
  String carriage;
  String bed;
  String tableware;
  String nursingroom;
  String meetingroom;
  String diapers;
  String playroom;
  String chair;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        menu: json["menu"],
        bed: json["bed"],
        tableware: json["tableware"],
        meetingroom: json["meetingroom"],
        diapers: json["diapers"],
        playroom: json["playroom"],
        carriage: json["carriage"],
        nursingroom: json["nursingroom"],
        chair: json["chair"]
    );
  }
}
