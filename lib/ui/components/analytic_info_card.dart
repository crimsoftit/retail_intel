// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:retail_intel/constants/constants.dart';
import 'package:retail_intel/models/analytic_info_model.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({super.key, required this.model});

  final AnalyticModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                '${currencyFormat.format(int.parse(model.tValue))}',
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(appPadding / 2),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: model.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  model.svgSrc,
                  color: model.color,
                ),
              ),
            ],
          ),
          Text(model.title),
        ],
      ),
    );
  }
}
