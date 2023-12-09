// ignore_for_file: unnecessary_null_comparison

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retail_intel/ui/responsive/mobile_scaffold.dart';
import 'package:retail_intel/utils/sql_helper.dart';

class SoldItemsScreen extends StatefulWidget {
  const SoldItemsScreen({super.key});

  @override
  State<SoldItemsScreen> createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends State<SoldItemsScreen> {
  // all inventory items in the database
  List<Map<String, dynamic>> _soldItemsList = [];

  bool _isLoading = true;

  var date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

  @override
  void initState() {
    super.initState();
    refreshSoldItemsList(); // loads the inventory items list when the app starts
  }

  // function to show input form

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          debugPrint('back button pressed');
          const MobileScaffold();

          return true;
        },
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            refreshSoldItemsList();
          },
          child: Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.brown[300],
              // search field
              title: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search sold items...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  // Perform search functionality here
                },
              ),
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : ListView.builder(
                    itemCount:
                        (_soldItemsList != null) ? _soldItemsList.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(_soldItemsList[index]['name']),
                        onDismissed: (direction) {
                          _deleteSoldItem(_soldItemsList[index]['productCode']);
                          refreshSoldItemsList();
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 1.0,
                          child: ListTile(
                            title: Text((_soldItemsList[index]['name'])),
                            subtitle: Text(
                                "qty:${_soldItemsList[index]['quantity'].toString()} code: ${_soldItemsList[index]['productCode']} price: ${_soldItemsList[index]['price'].toString()} Modified: ${_soldItemsList[index]['date']}"),
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown[300],
                              foregroundColor: Colors.white,
                              child: Text(_soldItemsList[index]['name'][0]
                                  .toUpperCase()),
                            ),
                            trailing: GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ),
                              onTap: () {
                                _deleteSoldItem(
                                    _soldItemsList[index]['productCode']);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

  // function to fetch all inventory data from the database
  void refreshSoldItemsList() async {
    final soldItems = await SQLHelper.fetchSoldItems();
    setState(() {
      _soldItemsList = soldItems;
      _isLoading = false;
    });
  }

  // function to delete an item from the sales table in the database
  void _deleteSoldItem(String pCode) async {
    await SQLHelper.deleteSoldItem(pCode);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('item deleted successfully...'),
    ));
    refreshSoldItemsList();
  }
}
