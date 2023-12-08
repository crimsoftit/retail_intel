import 'package:retail_intel/constants/constants.dart';
import 'package:retail_intel/ui/components/analytic_cards.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    _stateUpdate();
  }

  void _stateUpdate() {
    setState() {}

    print("refresh done");
  }

  // List<Analytics> aData = [
  //   Analytics(title: 'T. Inventory', invData: '3000'),
  // ];

  // Widget analyticsTemplate(data) {
  //   return Card()
  // }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            AnalyticCards(),
          ],
        ),
      ),
    );
  }
}
