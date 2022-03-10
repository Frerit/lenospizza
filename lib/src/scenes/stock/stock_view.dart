import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lenospizza/src/common/navigation.dart';
import 'package:lenospizza/src/controller/stock_controller.dart';
import 'package:lenospizza/src/models/stock_model.dart';

class StockView extends StatelessWidget {
  StockView({Key? key}) : super(key: key);

  StockController controller = Get.put(StockController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          child: Stack(
            children: [
              const Positioned(
                  bottom: 10,
                  right: 100,
                  child: Text("Inventario",
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 40))),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                      opacity: 0.1,
                      child: Image.asset("assets/images/logo_app.png"))),

              // Modal
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: MaterialButton(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        color: Colors.amber,
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Agregar Inventario",
                              content: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: controller.tecStockName,
                                        decoration: const InputDecoration(
                                            hintText: "Nombre"),
                                      ),
                                      TextFormField(
                                        controller: controller.tecStockPrice,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: "Precio"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 35,
                                            height: 35,
                                            child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                color: Colors.amber,
                                                onPressed: () {
                                                  controller
                                                      .newstockcount.value--;
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 17,
                                                )),
                                          ),
                                          Obx(
                                            () => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  "${controller.newstockcount.value}",
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 35,
                                            height: 35,
                                            child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                color: Colors.amber,
                                                onPressed: () {
                                                  controller
                                                      .newstockcount.value++;
                                                },
                                                child: const Icon(Icons.add,
                                                    size: 17)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            color: Colors.amber,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              controller.addNewStock();
                                            },
                                            child: const Text("Agregar")),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
                        child: const Icon(Icons.add, size: 17)),
                  )),
              Positioned(
                  child: SizedBox(
                      width: Get.width,
                      height: Get.height * 0.90,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 75, left: 10, right: 10),
                        child: Obx(
                          () => GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing:
                                          5.0, // Establece el espacio entre la parte superior e inferior (Axis.horizontal establece el espacio entre la izquierda y la derecha)
                                      crossAxisSpacing: 5.0, //
                                      childAspectRatio: 8),
                              itemCount: controller.list.length,
                              itemBuilder: (BuildContext context, int index) {
                                final StockModel item = controller.list[index];
                                TextEditingController ctrText =
                                    new TextEditingController();
                                return Card(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                          flex: 4,
                                          child: Text(item.name ?? '')),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              bottom: 5,
                                              top: 5),
                                          child: TextFormField(
                                            controller: ctrText,
                                            onChanged: (value) {
                                              controller.changePrice(
                                                  index, value);
                                            },
                                            decoration: InputDecoration(
                                                helperText:
                                                    "${(item.price ?? 0) * (item.quantity ?? 0)}",
                                                helperMaxLines: 1,
                                                hintText: "${item.price ?? 0}",
                                                helperStyle: const TextStyle(
                                                    fontSize: 10),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 5),
                                                enabledBorder: InputBorder.none,
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.amber))),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 35,
                                            height: 35,
                                            child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                color: Colors.amber,
                                                onPressed: () {
                                                  controller.reduceQuantity(
                                                      index, item);
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 17,
                                                )),
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "${item.quantity}",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                          SizedBox(
                                            width: 35,
                                            height: 35,
                                            child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                color: Colors.amber,
                                                onPressed: () {
                                                  controller.addQuantity(index,
                                                      item, ctrText.text);
                                                },
                                                child: const Icon(Icons.add,
                                                    size: 17)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ))),
              // Navigation
              const NavigationApp(),
            ],
          ),
        ),
      ),
    );
  }
}
