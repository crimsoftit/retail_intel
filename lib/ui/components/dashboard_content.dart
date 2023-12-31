// ignore_for_file: unused_element

import 'package:retail_intel/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:retail_intel/ui/components/analytics.dart';

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

    debugPrint("refresh done");
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            SizedBox(
              height: appPadding,
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Analytics(),
                ),
              ],
            ),
            //AnalyticCards(),
          ],
        ),
      ),
    );
  }
}
