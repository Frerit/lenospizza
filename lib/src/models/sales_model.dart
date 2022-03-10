import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  SalesModel(
      {required this.id,
      required this.name,
      required this.created,
      required this.completed,
      required this.timestamp,
      required this.year,
      required this.month,
      required this.day,
      required this.total,
      required this.quantity});

  int? id;
  String? name;
  DateTime? created;
  DateTime? completed;
  Timestamp? timestamp;
  int? year;
  int? month;
  int? day;
  int? total;
  int? quantity;

  SalesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    created = DateTime.parse(json['created']);
    timestamp = json['timestamp'];
    completed = DateTime.parse(json['completed']);
    year = json['year'];
    month = json['month'];
    day = json['day'];
    total = json['total'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['created'] = created?.toIso8601String();
    data['completed'] = completed?.toIso8601String();
    data['timestamp'] = timestamp;
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['total'] = total;
    data['quantity'] = quantity;
    return data;
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;
  final int groupid;
  TimeSeriesSales(this.time, this.groupid, this.sales);
}

class GroupsSales {
  final int positions;
  final List<SalesModel> ventas;
  GroupsSales(this.positions, this.ventas);
}

class PopularitySales {
  final String name;
  final double quantity;

  PopularitySales(this.name, this.quantity);
}
