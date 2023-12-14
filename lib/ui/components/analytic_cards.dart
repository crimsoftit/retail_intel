import 'package:retail_intel/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class AnalyticCards extends StatefulWidget {
  const AnalyticCards({super.key});

  @override
  State<AnalyticCards> createState() => _AnalyticCardsState();
}

class _AnalyticCardsState extends State<AnalyticCards> {
  num totalInvValue = 0;

  // all inventory items in the database
  List inventoryList = [];

  // get total inventory value from the database
  void calculateInventoryValue() async {
    inventoryList = await SQLHelper.fetchAllInventory();
    for (var element in inventoryList) {
      totalInvValue = (totalInvValue) + element['buyingPrice'];
    }
    //print(totalInvValue);
    setState(() {
      totalInvValue = totalInvValue;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateInventoryValue();
    // print("initState Called");
    //print(totalInvValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.brown,
                ),
              ),
              subtitle: Text(
                '$totalInvValue',
                style: TextStyle(
                  color: Colors.brown[300],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: const Text('buy tickets'),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('buy tickets'),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
