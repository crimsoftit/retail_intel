import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var myDefaultBackground = Colors.orange[100];

// current date
var date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

final currencyFormat = NumberFormat.currency(
    locale: Platform.localeName,
    customPattern: '#,### \u00a4',
    symbol: 'Ksh',
    decimalDigits: 2);

// Default App Padding
const appPadding = 10.0;

// Colors used in this app
var primaryColor = Colors.brown[300];
var secondaryColor = Colors.white;
const bgColor = Color.fromRGBO(247, 251, 254, 1);
const textColor = Colors.blueGrey;
const lightTextColor = Colors.black26;
const transparent = Colors.transparent;

const grey = Color.fromRGBO(148, 170, 220, 1);
const purple = Color.fromRGBO(165, 80, 179, 1);
const orange = Color.fromRGBO(251, 137, 13, 1);
const green = Color.fromRGBO(51, 173, 127, 1);
const red = Colors.red;

var myAppBar = AppBar(
  backgroundColor: myDefaultBackground,
);
