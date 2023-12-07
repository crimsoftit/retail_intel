// ignore_for_file: must_be_immutable

import 'package:retail_intel/ui/components/drawer_list_tile.dart';
import 'package:retail_intel/constants/constants.dart';

import 'package:retail_intel/ui/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:retail_intel/ui/responsive/desktop_scaffold.dart';
import 'package:retail_intel/ui/responsive/mobile_scaffold.dart';
import 'package:retail_intel/ui/responsive/responsive_layout.dart';
import 'package:retail_intel/ui/responsive/tablet_scaffold.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      //backgroundColor: myDefaultBackground,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            height: 200,
            child: Image.asset(
              'assets/images/dhc_logo.png',
              //color: Colors.transparent,
            ),
          ),
          DrawerListTile(
            title: 'D A S H B O A R D',
            svgSrc: 'assets/icons/Dashboard.svg',
            tap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ResponsiveLayout(
                      mobileScaffold: MobileScaffold(),
                      tabletScaffold: TabletScaffold(),
                      desktopScaffold: DesktopScaffold(),
                    );
                  },
                ),
              );
            },
          ),
          DrawerListTile(
            title: 'M E S S A G E S',
            svgSrc: 'assets/icons/Message.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'I N V E N T O R Y',
            svgSrc: 'assets/icons/inventory.svg',
            tap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const InventoryScreen();
              }));
            },
          ),
          DrawerListTile(
            title: 'S A L E S',
            svgSrc: 'assets/icons/stock.svg',
            tap: () async {
              // await Navigator.push(context,
              //     MaterialPageRoute(builder: (context) {
              //   return const SoldItemsScreen();
              // }));
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
            title: 'S T A T I S T I CS',
            svgSrc: 'assets/icons/Statistics.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'S E T T I N G S',
            svgSrc: 'assets/icons/Settings.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'L O G O U T',
            svgSrc: 'assets/icons/Logout.svg',
            tap: () {},
          ),
        ],
      ),
    );
  }
}
