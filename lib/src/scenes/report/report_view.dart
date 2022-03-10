import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:lenospizza/src/common/chart_sem.dart';
import 'package:lenospizza/src/common/navigation.dart';
import 'package:lenospizza/src/common/progres_sales.dart';
import 'package:lenospizza/src/controller/report_controller.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final controller = Get.put(ReportController());

  final dateFormat = DateFormat.LLLL("es_CO");
  final currencyFor = NumberFormat("#,##0", "es_CO");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.getSalesFronDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            // Title
            Positioned(
                top: 50,
                left: 30,
                child: Row(
                  children: [
                    const Text("Reportes  ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const Text("de",
                        style: TextStyle(color: Colors.black38, fontSize: 20)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        toBeginningOfSentenceCase(
                                dateFormat.format(controller.today.value)) ??
                            "",
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 22),
                      ),
                    ),
                  ],
                )),

            // Toggle
            Positioned(
                top: 90,
                left: 20,
                child: SizedBox(
                  width: Get.width * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => ToggleButtons(
                          color: Colors.black.withOpacity(0.60),
                          selectedColor: Colors.amber,
                          selectedBorderColor: Colors.amber,
                          fillColor: Colors.white.withOpacity(0.08),
                          splashColor: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                          constraints: const BoxConstraints(
                              maxHeight: 40,
                              maxWidth: 40,
                              minHeight: 35,
                              minWidth: 36),
                          isSelected: controller.isSelected,
                          onPressed: (int newValue) {
                            setState(() {
                              controller.groupId.value = 0;
                              controller.chageNewValue(newValue);
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 14,
                              ),
                            ),
                            Text("HOY"),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),

            //  Grafica
            Positioned(
              top: 130,
              left: 20,
              child: SizedBox(
                  width: Get.width / 2,
                  height: Get.height * 0.5,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Colors.grey.shade100,
                    child: Obx(
                      () => controller.reporteMes.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 20, bottom: 10, left: 10),
                              child: ChartSemana(
                                controller.reporteMes,
                                animate: true,
                                onTap: (p0) {
                                  if (controller.grupos.isNotEmpty) {
                                    controller.groupId.value = p0;
                                    controller.grupos.reactive;
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                    ),
                  )),
            ),

            // Lista
            Positioned(
                right: 20,
                bottom: 70,
                child: SizedBox(
                    width: Get.width * 0.439,
                    height: Get.height * 0.4,
                    child: Obx(() => controller.grupos.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller
                                .grupos[controller.groupId.value].ventas.length,
                            itemBuilder: (context, index) {
                              final venta = controller
                                  .grupos[controller.groupId.value]
                                  .ventas[index];
                              return Card(
                                child: ListTile(
                                  title: Text("#${venta.id}  ${venta.name}"),
                                  trailing: Text(
                                      "Cant: ${venta.quantity}  \$${venta.total}"),
                                ),
                              );
                            },
                          )
                        : const SizedBox()))),

            // Populares
            Positioned(
                right: 240,
                top: 90,
                child: SizedBox(
                  width: Get.width * 0.22,
                  height: Get.height * 0.3,
                  child: Card(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.populary.length,
                        itemBuilder: (context, index) {
                          final item = controller.populary[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                item.name.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item.name),
                                          Text("${item.quantity}")
                                        ],
                                      )
                                    : SizedBox(),
                                const SizedBox(height: 5),
                                item.name.isNotEmpty
                                    ? LinearProgressIndicator(
                                        value: ((item.quantity * 100) /
                                                controller.major) /
                                            100,
                                        backgroundColor: Colors.white,
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )),

            // Torta
            Positioned(
                right: 20,
                top: 90,
                child: SizedBox(
                  width: Get.width * 0.2,
                  height: Get.height * 0.3,
                  child: Card(
                    color: Colors.amber,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: Get.width * 0.2,
                          height: Get.height * 0.22,
                          child: Obx(
                            () => ProgressCircleSales(
                              dataList: [
                                ChartSampleData(
                                    x: toBeginningOfSentenceCase(dateFormat
                                        .format(controller.today.value)),
                                    y: controller.porcenTageMount.value)
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            "\$ ${currencyFor.format(controller.majorMonth.value)}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            // NAvegacion
            const NavigationApp(),
          ],
        ),
      ),
    );
  }
}
