class Product {
  Product({
    required this.proPrice,
    required this.proImage,
    required this.proDescription,
    required this.proName,
  });
  late final String proPrice;
  late final String proImage;
  late final String proDescription;
  late final String proName;

  Product.fromJson(Map<String, dynamic> json){
    proPrice = json['pro_price'];
    proImage = json['pro_image'];
    proDescription = json['pro_description'];
    proName = json['pro_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pro_price'] = proPrice;
    _data['pro_image'] = proImage;
    _data['pro_description'] = proDescription;
    _data['pro_name'] = proName;
    return _data;
  }
}