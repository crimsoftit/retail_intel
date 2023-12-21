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

    analyticData
        .add(AnalyticModel(title: "T.Inv", tValue: totalInvValue.toString()));

    var mappedData = {for (var e in analyticData) e.title: e.tValue};
    //print(totalInvValue);
    setState(() {
      totalInvValue = totalInvValue.toInt();
      mappedData = mappedData;
    });
    print("******");
    print(mappedData);
    print("******");
  }

  // get total sales value from the database
  void totalSales() async {
    soldItems = await SQLHelper.fetchSoldItems();
    for (var soldItem in soldItems) {}
  }

  @override
  void initState() {
    super.initState();
    calculateInventoryValue();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: analyticData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: appPadding,
          mainAxisSpacing: appPadding,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (context, index) =>
            AnalyticInfoCard(model: analyticData[index]),
      ),
    );
  }
}
