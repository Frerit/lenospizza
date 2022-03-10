import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lenospizza/src/models/borde_model.dart';
import 'package:lenospizza/src/models/pizza_model.dart';
import 'package:lenospizza/src/models/process_model.dart';
import 'package:lenospizza/src/models/sales_model.dart';

class HomeController extends GetxController {
  var box = GetStorage();
  var process = 0.obs;
  RxList<String> processings = RxList<String>();
  RxBool isCombined = false.obs;
  RxList<ProcessModel> listprocess = RxList<ProcessModel>();

  final dbRef = FirebaseFirestore.instance
      .collection('ventas')
      .withConverter<SalesModel>(
        fromFirestore: (snapshots, _) => SalesModel.fromJson(snapshots.data()!),
        toFirestore: (sales, _) => sales.toJson(),
      );

  void procesarPizza(
      PizzaModel pizza, int size, int border, int quantity) async {
    var id = box.read("id") ?? 0;
    id++;
    var pizzatoProcess = ProcessModel(
        id: id,
        image: pizza.image,
        name: pizza.name,
        description: pizza.description,
        created: DateTime.now(),
        price: pizza.prices[size].borders[border],
        quantity: quantity);
    await box.write("$id", pizzatoProcess.toJson());
    await box.write("id", id);
    isCombined.value = false;
    processings.add("$id");
    refresh();
  }

  void procesarPizzaCombinada(PizzaModel pizza, PizzaModel combinacion,
      int price, int size, int border, int quantity) async {
    var id = box.read("id") ?? 0;
    id++;
    var pizzatoProcess = ProcessModel(
        id: id,
        image: pizza.image,
        name: "${pizza.name} + ${combinacion.name}",
        description: "${pizza.description} + ${combinacion.description}",
        created: DateTime.now(),
        price: price,
        quantity: quantity);
    await box.write("$id", pizzatoProcess.toJson());
    await box.write("id", id);
    isCombined.value = false;
    processings.add("$id");
    refresh();
  }

  void getProcessPizzas() async {
    listprocess.clear();
    for (var id in processings) {
      var item = await box.read(id);
      if (item != null) {
        listprocess.add(ProcessModel.fromJson(item));
      }
    }
  }

  String daysBetween(DateTime from, DateTime to) {
    var hour = to.difference(from).inHours;
    String hourStr = hour.toString();
    if (hour < 12) hourStr = "0$hour";

    var minutes = to.difference(from).inMinutes;
    String minutesStr = hour.toString();
    if (minutes < 12) minutesStr = "0$minutes";

    return "$hourStr : $minutesStr";
  }

  void completarPedido(ProcessModel item, int index) async {
    final today = DateTime.now();
    final salestosave = SalesModel(
        id: item.id,
        name: item.name,
        created: item.created,
        completed: today,
        timestamp: Timestamp.now(),
        year: today.year,
        month: today.month,
        day: today.day,
        total: (item.price ?? 0) * (item.quantity ?? 1),
        quantity: item.quantity);

    dbRef.add(salestosave).catchError((error) {
      printError(info: error);
    });
    listprocess.removeAt(index);
    processings.removeAt(index);
    await box.remove(item.id.toString());
    refresh();
  }
}
