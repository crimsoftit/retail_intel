import 'package:retail_intel/controllers/controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_intel/ui/responsive/desktop_scaffold.dart';
import 'package:retail_intel/ui/responsive/mobile_scaffold.dart';
import 'package:retail_intel/ui/responsive/responsive_layout.dart';
import 'package:retail_intel/ui/responsive/tablet_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Duara: Retail Intelligence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Controller(),
          ),
        ],
        child: const ResponsiveLayout(
          mobileScaffold: MobileScaffold(),
          tabletScaffold: TabletScaffold(),
          desktopScaffold: DesktopScaffold(),
        ),
      ),
    );
  }
}
