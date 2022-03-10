import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:lenospizza/src/models/sales_model.dart';

class ReportController extends GetxController {
  final dbRef = FirebaseFirestore.instance
      .collection('ventas')
      .withConverter<SalesModel>(
        fromFirestore: (snapshots, _) => SalesModel.fromJson(snapshots.data()!),
        toFirestore: (sales, _) => sales.toJson(),
      );

  var today = DateTime.now().obs;
  var groupId = 0.obs;
  RxList<TimeSeriesSales> reporteMes = RxList.empty();
  RxList<bool> isSelected = [false, true, false].obs;
  RxList<GroupsSales> grupos = RxList.empty();
  RxList<PopularitySales> populary = RxList.empty();
  var major = 0.0;
  var majorMonth = 0.0.obs;
  var porcenTageMount = 0.0.obs;
  List<double> salesMonth = List.generate(12, (indes) => 0);

  void getSalesFronDB() async {
    grupos.clear();
    populary.clear();

    var list = await dbRef
        .orderBy("created", descending: false)
        .get()
        .then((snapshot) => snapshot.docs);
    var days = list.map((e) => e.data());

    final groups = groupBy(days, (SalesModel e) {
      var time = DateTime(e.created!.year, e.created!.month, e.created!.day);
      return time;
    });

    final names = groupBy(days, (SalesModel e) {
      if (e.month == today.value.month) {
        return e.name;
      }
    });

    if (names.isNotEmpty) {
      populary.clear();
      List<PopularitySales> listoDesorder = [];
      names.forEach((key, value) {
        populary.add(PopularitySales(key ?? "", value.length.toDouble()));
      });
      populary.sort((a, b) => a.quantity.compareTo(b.quantity));

      List<PopularitySales> tempList = populary.reversed.toList();
      populary.clear();
      populary.addAll(tempList);
      final quan = populary.map((element) => element.quantity).toList();
      major = quan.reduce(max);
    } else {
      populary.clear();
    }

    if (groups.isNotEmpty) {
      reporteMes.clear();
      var id = 0;
      groups.forEach((key, value) {
        var total = 0;
        for (var item in value) {
          total += item.total ?? 0;
        }
        salesMonth[key.month - 1] = total.toDouble();
        if (key.month == today.value.month) {
          grupos.add(GroupsSales(id, value));
          reporteMes.add(TimeSeriesSales(key, id, total));
        }
        id++;
      });

      final saleM = salesMonth.reduce(max);
      majorMonth.value = salesMonth[today.value.month - 1];
      porcenTageMount.value = majorMonth * 100 / saleM;
      print(porcenTageMount);
    } else {
      reporteMes.addAll([TimeSeriesSales(today.value, 0, 0)]);
    }
  }

  void chageNewValue(int newValue) {
    for (var index = 0; index < isSelected.length; index++) {
      if (index == newValue) {
        isSelected[index] = true;
      } else {
        isSelected[index] = false;
      }
    }
    switch (newValue) {
      case 0:
        if (today.value.month > 0) {
          today.value = DateTime(
              today.value.year, today.value.month - 1, today.value.day);
        }
        break;
      case 1:
        today.value = DateTime.now();
        break;
      case 2:
        if (today.value.month <= 12) {
          today.value = DateTime(
              today.value.year, today.value.month + 1, today.value.day);
        }
        break;
      default:
    }
  }
}
