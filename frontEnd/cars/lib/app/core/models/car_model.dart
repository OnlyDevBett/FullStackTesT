class CarModel {
  int? id;
  int? userId;
  String? name;
  String? model;
  double? price;
  bool? availabilityStatus;
  String? createdAt;
  String? updatedAt;

  CarModel(
      {
        this.id,
         this.userId,
         this.name,
         this.model,
         this.price,
         this.availabilityStatus,
        this.createdAt,
        this.updatedAt});

  CarModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    userId = int.parse(json['user_id'].toString());
    name = json['name'];
    model = json['model'];
    price = json['price'];
    availabilityStatus = json['availability_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['model'] = model;
    data['price'] = price;
    data['availability_status'] = availabilityStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
