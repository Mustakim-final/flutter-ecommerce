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
    final data = <String, dynamic>{};
    data['pro_price'] = proPrice;
    data['pro_image'] = proImage;
    data['pro_description'] = proDescription;
    data['pro_name'] = proName;
    return data;
  }
}