import 'package:cloud_firestore/cloud_firestore.dart';

class ProcessModel {
  ProcessModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.description,
      required this.created,
      required this.price,
      required this.quantity});

  int? id;
  String? image;
  String? name;
  String? description;
  DateTime? created;
  int? price;
  int? quantity;

  ProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    created = DateTime.parse(json['created']);
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    data['created'] = created?.toIso8601String();
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
}
