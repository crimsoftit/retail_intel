// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:retail_intel/constants/constants.dart';
import 'package:retail_intel/models/analytic_info_model.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({super.key, required this.model});

  final AnalyticModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: appPadding,
        vertical: appPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${model.tValue}',
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(appPadding / 2),
                height: 40,
                width: 40,
                color: primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
