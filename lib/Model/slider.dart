class Cursol_Slider {
  Cursol_Slider({
    required this.photo,
  });
  late final String photo;

  Cursol_Slider.fromJson(Map<String, dynamic> json){
    photo = json['photo'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['photo'] = photo;
    return data;
  }
}