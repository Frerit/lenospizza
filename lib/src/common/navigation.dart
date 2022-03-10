import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:lenospizza/src/scenes/home/home_page_view.dart';
import 'package:lenospizza/src/scenes/report/report_view.dart';
import 'package:lenospizza/src/scenes/stock/stock_view.dart';

class NavigationApp extends StatelessWidget {
  const NavigationApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 50,
      child: Container(
        width: 400,
        height: 45,
        color: Colors.transparent,
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemNavigations(
                  icon: 'assets/images/005-cocina.png',
                  view: const HomePageView()),
              ItemNavigations(
                  icon: 'assets/images/004-menu.png', view: StockView()),
              ItemNavigations(
                  icon: 'assets/images/002-crecimiento.png',
                  view: ReportView()),
              ItemNavigations(
                  icon: 'assets/images/003-cerveza.png', view: StockView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget ItemNavigations({required String icon, required Widget view}) {
    return InkWell(
      onTap: () {
        Get.to(view);
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          icon,
          width: 40,
          height: 30,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class SizzePizzaWidget extends StatelessWidget {
  const SizzePizzaWidget({
    Key? key,
    required this.paddings,
    required this.backgroundColor,
  }) : super(key: key);

  final double paddings;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      padding: EdgeInsets.all(paddings),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Image.asset(
        "assets/images/pizzasize.png",
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
