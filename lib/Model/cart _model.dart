class Cart_model {
  Cart_model({
    required this.price,
    required this.image,
    required this.name,
  });
  late final String price;
  late final String image;
  late final String name;

  Cart_model.fromJson(Map<String, dynamic> json){
    price = json['price'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['price'] = price;
    _data['image'] = image;
    _data['name'] = name;
    return _data;
  }
}