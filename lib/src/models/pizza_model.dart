import 'package:lenospizza/src/models/borde_model.dart';

class PizzaModel {
  PizzaModel(
      {required this.image,
      required this.name,
      required this.description,
      required this.prices});

  final String image;
  final String name;
  final String description;
  final List<BorderModel> prices;
}
