import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lenospizza/src/common/animate.dart';
import 'package:lenospizza/src/common/custom_clip.dart';
import 'package:lenospizza/src/common/data.dart';
import 'package:lenospizza/src/common/navigation.dart';
import 'package:lenospizza/src/controller/home_controller.dart';
import 'package:lenospizza/src/models/pizza_model.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _controller = CarouselController();
  final HomeController controller = Get.put(HomeController());
  AnimationController? descAnimateCTL;
  AnimationController? combiAnimateCTL;
  AnimationController? btnAnimateCTL;
  final currencyFor = NumberFormat("#,##0", "es_CO");
  int _current = 2;
  int _border = 0;
  int _size = 0;
  int count = 1;

  PizzaModel combination =
      PizzaModel(image: "", name: "", description: "", prices: []);

  late BuildContext dialogContext; // <<----

  void resetIndex(int index) {
    setState(() {
      _current = index;
      _border = 0;
      _size = 0;
      count = 1;
    });
  }

  void descAnimeteElement() async {
    await descAnimateCTL?.reverse();
    await descAnimateCTL?.forward();
  }

  void combiAnimeteElement() async {
    if (controller.isCombined.value) {
      await combiAnimateCTL?.reverse();
      await combiAnimateCTL?.forward();
    }
  }

  void btnAnimeteElement() async {
    await btnAnimateCTL?.reverse();
    await btnAnimateCTL?.forward();
  }

  void animateElements() {
    descAnimeteElement();
    combiAnimeteElement();
    btnAnimeteElement();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = pizzaList[_current].prices[_size].borders[_border];
    var combinate = subtotal;
    if (controller.isCombined.value) {
      combinate = subtotal < combination.prices[_size].borders[_border]
          ? combination.prices[_size].borders[_border]
          : subtotal;
    }
    final _total = combinate * count;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              // Image Pizza
              Positioned(
                left: -65,
                top: -50,
                child: ClipRRect(
                  child: Align(
                    alignment: const Alignment(10.0, -1.5),
                    child: Image.asset(pizzaList[_current].image,
                        fit: BoxFit.cover, width: 330, height: 360),
                  ),
                ),
              ),

              Obx(
                () => controller.isCombined.value
                    ? Positioned(
                        left: -65,
                        top: -50,
                        child: ClipPath(
                          clipper: CustomClipPath(),
                          child: Align(
                            alignment: const Alignment(10.0, -1.5),
                            child: Image.asset(combination.image,
                                fit: BoxFit.cover, width: 330, height: 360),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),

              // Description
              Positioned(
                  top: 30,
                  left: 300,
                  child: FadeInLeft(
                    controller: (p0) {
                      descAnimateCTL = p0;
                    },
                    duration: const Duration(milliseconds: 1000),
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          Text(
                            pizzaList[_current].name,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pizzaList[_current].description,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                          Image.asset(
                            "assets/images/separatosline.png",
                            height: 45,
                          ),
                        ],
                      ),
                    ),
                  )),
              // Description 1
              Obx(() => controller.isCombined.value
                  ? Positioned(
                      top: 170,
                      left: 300,
                      child: FadeInLeft(
                        duration: const Duration(milliseconds: 500),
                        controller: (p1) {
                          combiAnimateCTL = p1;
                        },
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Text(
                                combination.name,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                combination.description,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      ))
                  : const SizedBox()),

              // Hold
              Positioned(
                  top: 10,
                  right: 30,
                  child: InkWell(
                    onTap: () {
                      controller.getProcessPizzas();
                      showDialog(
                          context: context,
                          builder: (contextClose) {
                            return Dialog(
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: -10,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          animateElements();
                                          Navigator.pop(contextClose);
                                        },
                                        child: const Icon(Icons.close)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 40, horizontal: 10),
                                    height: 300,
                                    child: Obx(
                                      () => controller.listprocess.isNotEmpty
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  controller.listprocess.length,
                                              itemBuilder: (context, index) {
                                                final pizzaItem = controller
                                                    .listprocess[index];
                                                return SizedBox(
                                                  height: 200,
                                                  width: 300,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            pizzaItem.image ??
                                                                "assets/images/pizza1.png",
                                                            width: 150,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                  controller.daysBetween(
                                                                      pizzaItem
                                                                              .created ??
                                                                          DateTime
                                                                              .now(),
                                                                      DateTime
                                                                          .now()),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          24)),
                                                              const SizedBox(
                                                                  height: 10),
                                                              SizedBox(
                                                                  width: 150,
                                                                  child: Text(
                                                                      pizzaItem
                                                                              .name ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20))),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      SizedBox(
                                                        width: 300,
                                                        child: Text(
                                                            pizzaItem
                                                                    .description ??
                                                                "",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Divider(),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                              "CANTIDAD: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17)),
                                                          Text(
                                                              pizzaItem.quantity
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          22)),
                                                          const SizedBox(
                                                              width: 10),
                                                          const Text("PRECIO: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17)),
                                                          Text(
                                                              "\$${currencyFor.format((pizzaItem.price ?? 0) * (pizzaItem.quantity ?? 1))}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      22)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              "ID: ${pizzaItem.id}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          const SizedBox(
                                                              width: 20),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: FadeInLeft(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              child:
                                                                  MaterialButton(
                                                                height: 45,
                                                                minWidth: 150,
                                                                onPressed: () {
                                                                  controller
                                                                      .completarPedido(
                                                                          pizzaItem,
                                                                          index);
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0)),
                                                                color: Colors
                                                                    .amber,
                                                                child:
                                                                    const Text(
                                                                  "Completar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Center(
                                              child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/horno.png",
                                                  width: 100,
                                                ),
                                                const SizedBox(height: 13),
                                                const Text(
                                                  "No hay pedidos \nen proceso",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 24),
                                                ),
                                              ],
                                            )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0),
                              child: Obx(
                                () => Text("${controller.processings.length}",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            Container(
                              width: 50,
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                "assets/images/pizza-box.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ],
                        )),
                  )),

              // Sizes
              Positioned(
                  right: 20,
                  top: 100,
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        const Text(
                          "Tamaño",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Image.asset(
                          "assets/images/separatosline.png",
                          height: 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _size = 0;
                                });
                              },
                              child: SizzePizzaWidget(
                                  paddings: 20,
                                  backgroundColor: _size == 0
                                      ? Colors.black12
                                      : Colors.transparent),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _size = 1;
                                });
                              },
                              child: SizzePizzaWidget(
                                  paddings: 15,
                                  backgroundColor: _size == 1
                                      ? Colors.black12
                                      : Colors.transparent),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _size = 2;
                                });
                              },
                              child: SizzePizzaWidget(
                                  paddings: 10,
                                  backgroundColor: _size == 2
                                      ? Colors.black12
                                      : Colors.transparent),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _border = 0;
                                });
                              },
                              child: Container(
                                width: 50,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: _border == 0
                                      ? Colors.grey[200]
                                      : Colors.grey[10],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                ),
                                child: Image.asset(
                                  "assets/images/pizzanoborde.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _border = 1;
                                });
                              },
                              child: Container(
                                width: 50,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: _border == 1
                                      ? Colors.grey[200]
                                      : Colors.grey[10],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                ),
                                child: Image.asset(
                                  "assets/images/pizzaborder.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),

              // Carrousel
              Positioned(
                bottom: 100,
                left: 20,
                child: Row(
                  children: [
                    SizedBox(
                        width: 40,
                        child: InkWell(
                            onTap: () =>
                                _controller.animateToPage(_current - 1),
                            child:
                                Image.asset('assets/images/left-arrow.png'))),
                    SizedBox(
                      height: 160,
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: CarouselSlider.builder(
                        itemCount: pizzaList.length,
                        itemBuilder: (context, index, realIndex) {
                          final item = pizzaList[index];
                          return InkWell(
                            onTap: () => _controller.animateToPage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _current == index
                                    ? Colors.black12
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                              ),
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.only(top: 13),
                              child: Stack(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Image.asset(item.image,
                                      fit: BoxFit.cover, width: 300.0),
                                  Positioned(
                                    bottom: 3.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        pizzaList[index].name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 2,
                            enableInfiniteScroll: true,
                            viewportFraction: 0.2,
                            initialPage: 2,
                            onPageChanged: (index, reason) {
                              resetIndex(index);
                            }),
                      ),
                    ),
                    SizedBox(
                        width: 40,
                        child: InkWell(
                            onTap: () =>
                                _controller.animateToPage(_current + 1),
                            child:
                                Image.asset("assets/images/right-arrow.png"))),
                  ],
                ),
              ),

              // Selector
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.6),
                                    blurRadius: 8,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  color: Colors.amber,
                                  onPressed: () {
                                    if (count > 1) {
                                      setState(() {
                                        count--;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.remove)),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "$count",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                )),
                            Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.6),
                                    blurRadius: 8,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  color: Colors.amber,
                                  onPressed: () {
                                    setState(() {
                                      count++;
                                    });
                                  },
                                  child: const Icon(Icons.add)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text("\$ ${currencyFor.format(_total)}",
                              style: const TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.bold)),
                        ),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 300),
                          controller: (b0) {
                            btnAnimateCTL = b0;
                          },
                          child: MaterialButton(
                            height: 45,
                            minWidth: 150,
                            onPressed: () {
                              if (controller.isCombined.value) {
                                controller.procesarPizzaCombinada(
                                    pizzaList[_current],
                                    combination,
                                    combinate,
                                    _size,
                                    _border,
                                    count);
                                animateElements();
                              } else {
                                openModalCombination(context);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.amber,
                            child: const Text(
                              "Procesar",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),

              // Navigation
              const NavigationApp(),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> openModalCombination(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text("Es Combinada",
                    style: TextStyle(
                        fontSize: 34,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          setState(() {
                            combination = pizzaList[_current];
                            controller.isCombined.value = true;
                          });
                          animateElements();
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 2.0, color: Colors.grey.shade100),
                              right: BorderSide(
                                  width: 2.0, color: Colors.grey.shade200),
                            ),
                            color: Colors.white,
                          ),
                          child: const Center(
                              child: Text("SI",
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber))),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.procesarPizza(
                              pizzaList[_current], _size, _border, count);
                          Navigator.pop(dialogContext);
                          animateElements();
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 2.0, color: Colors.grey.shade100),
                            ),
                            color: Colors.white,
                          ),
                          child: const Center(
                              child: Text("NO",
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
