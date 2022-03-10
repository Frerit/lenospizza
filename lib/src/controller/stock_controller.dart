import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lenospizza/src/models/stock_model.dart';

class StockController extends GetxController {
  final GetStorage box = GetStorage('Stock');
  var stockcount = 0.obs;
  var newstockcount = 0.obs;
  RxList<StockModel> list = RxList<StockModel>();

  TextEditingController tecStockName = TextEditingController();
  TextEditingController tecStockPrice = TextEditingController();

  @override
  void onReady() {
    getStock();
    super.onReady();
  }

  void getStock() async {
    stockcount.value = await box.read("count");
    print("stockcount: ${stockcount.value}");
    list.clear();
    for (var i = 0; i < stockcount.value; i++) {
      getDataStorege(i);
    }
  }

  void getDataStorege(int i) async {
    var json = await box.read("stock-$i");
    StockModel item = StockModel.fromJson(json);
    list.add(item);
  }

  void changePrice(int index, String value) {
    print("Change" ": $index - " + value);
  }

  void reduceQuantity(int index, StockModel item) {
    if (item.quantity! > 0) {
      item.quantity = (item.quantity ?? 0) - 1;
      box.write("stock-$index", item.toJson());
      getStock();
    }
  }

  void addQuantity(int index, StockModel item, String value) {
    if (value != "") {
      item.price = int.parse(value);
    }
    item.quantity = (item.quantity ?? 0) + 1;
    box.write("stock-$index", item.toJson());
    getStock();
  }

  void addNewStock() {
    var item = StockModel(
        name: tecStockName.text,
        description: "",
        price: int.parse(tecStockPrice.text),
        quantity: newstockcount.value);
    box.write("stock-${stockcount.value}", item.toJson());
    stockcount.value++;
    box.write("count", stockcount.value);
    tecStockName.clear();
    tecStockPrice.clear();
    newstockcount.value = 0;
    getStock();
  }
}
