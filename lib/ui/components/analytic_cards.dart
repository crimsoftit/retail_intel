import 'package:retail_intel/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class AnalyticCards extends StatefulWidget {
  const AnalyticCards({super.key});

  @override
  State<AnalyticCards> createState() => _AnalyticCardsState();
}

class _AnalyticCardsState extends State<AnalyticCards> {
  int totalInvValue = 0;

  // all inventory items in the database
  List<Map<String, dynamic>> _inventoryList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("initState Called");

    print("......");
    print(totalInvValue);
    print("......");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text(
                'Inventory Value',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.brown,
                ),
              ),
              subtitle: Text(
                totalInvValue.toString(),
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
