import 'package:retail_intel/constants/constants.dart';
import 'package:retail_intel/models/analytic_info_model.dart';
import 'package:retail_intel/ui/components/analytic_info_card.dart';
import 'package:retail_intel/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  num totalInvValue = 0;
  num totalSales = 0;

  // all inventory items in the database
  List inventoryList = [];

  // all sold item entries in the database
  List soldItems = [];

  List<AnalyticModel> analyticData = [];

  // get total inventory value from the database
  void calculateInventoryValue() async {
    inventoryList = await SQLHelper.fetchAllInventory();
    for (var element in inventoryList) {
      totalInvValue = (totalInvValue) + element['buyingPrice'];
    }

    analyticData.add(
      AnalyticModel(
        svgSrc: "assets/icons/inventory.svg",
        title: "Inventory Value",
        tValue: totalInvValue.toString(),
        color: const Color.fromRGBO(17, 159, 250, 1),
      ),
    );

    var mappedData = {for (var e in analyticData) e.title: e.tValue};
    //print(totalInvValue);
    setState(() {
      totalInvValue = totalInvValue.toInt();
      mappedData = mappedData;
      analyticData = analyticData;
      inventoryList = inventoryList;
    });
    print("******");
    print(mappedData);
    print("******");
  }

  //get total sales value from the database
  void calculateTotalSales() async {
    soldItems = await SQLHelper.fetchSoldItems();
    for (var soldItem in soldItems) {
      totalSales = (totalSales) + soldItem['total_price'];
    }

    analyticData.add(
      AnalyticModel(
        svgSrc: "assets/icons/stock.svg",
        title: 'Total Sales',
        tValue: totalSales.toString(),
        color: const Color.fromRGBO(165, 80, 179, 1),
      ),
    );

    var mappedData = {for (var e in analyticData) e.title: e.tValue};

    setState(() {
      analyticData = analyticData;
      totalSales = totalSales.toInt();
      mappedData = mappedData;
      soldItems = soldItems;
    });
    print("******");
    print(mappedData);
    print("******");
  }

  @override
  void initState() {
    super.initState();
    calculateInventoryValue();
    calculateTotalSales();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: analyticData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.11,
        ),
        itemBuilder: (context, index) =>
            AnalyticInfoCard(model: analyticData[index]),
      ),
    );
  }
}
