// ignore_for_file: use_build_context_synchronously

import 'package:retail_intel/ui/responsive/mobile_scaffold.dart';
import 'package:retail_intel/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // all inventory items in the database
  List<Map<String, dynamic>> _inventoryList = [];

  bool _isLoading = true;

  // function to fetch all inventory data from the database
  void refreshInventoryList() async {
    final inventoryData = await SQLHelper.fetchInventoryItems();
    setState(() {
      _inventoryList = inventoryData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshInventoryList(); // loads the inventory items list when the app starts
  }

  final TextEditingController _txtCode = TextEditingController();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtBP = TextEditingController();
  final TextEditingController _txtQty = TextEditingController();
  final TextEditingController _txtUnitSP = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingInventoryData =
          _inventoryList.firstWhere((element) => element['id'] == id);
      _txtCode.text = existingInventoryData['productCode'];
      _txtName.text = existingInventoryData['name'];
      _txtBP.text = existingInventoryData['buyingPrice'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,

          // this will prevent the soft keyboard from covering the textfields
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _txtCode,
              decoration: const InputDecoration(hintText: 'product barcode'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtName,
              decoration: const InputDecoration(hintText: 'product name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtQty,
              decoration: const InputDecoration(hintText: 'quantity available'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtBP,
              decoration: const InputDecoration(hintText: 'buying price'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _txtUnitSP,
              decoration: const InputDecoration(hintText: 'unit selling price'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addInventoryItem();
                }

                if (id != null) {
                  await _updateInventoryItem(id);
                }

                // Clear the text fields
                _txtCode.text = '';
                _txtName.text = '';
                _txtBP.text = '';

                // close the bottom sheet
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'add new entry..' : 'update entry...'),
            ),
          ],
        ),
      ),
    );
  }

  // add an item to inventory table in the database
  Future<void> _addInventoryItem() async {
    await SQLHelper.addInventoryItem(
        _txtCode.text,
        _txtName.text,
        int.parse(_txtQty.text),
        int.parse(_txtBP.text),
        int.parse(_txtUnitSP.text));
    refreshInventoryList();
  }

  // update an existing inventory item
  Future<void> _updateInventoryItem(int id) async {
    await SQLHelper.updateInventoryItem(
        id,
        _txtCode.text,
        _txtName.text,
        int.parse(_txtBP.text),
        int.parse(_txtQty.text),
        int.parse(_txtUnitSP.text));
    refreshInventoryList();
  }

  //delete an item
  void _deleteInventoryItem(String pCode) async {
    await SQLHelper.deleteInventoryItem(pCode);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('item successfully deleted...'),
      ),
    );
    refreshInventoryList();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          debugPrint('back button pressed');
          const MobileScaffold();

          return true;
        },
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            refreshInventoryList();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Inventory List'),
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : ListView.builder(
                    // ignore: unnecessary_null_comparison
                    itemCount:
                        // ignore: unnecessary_null_comparison
                        (_inventoryList != null) ? _inventoryList.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          //print(_inventoryList);
                          //SQLHelper.deleteInventoryItem(inventoryList[index]['productCode']);

                          _deleteInventoryItem(
                              _inventoryList[index]['productCode']);
                          // setState(() {
                          //   Map<String, dynamic> invMap = Map<String, dynamic>.from(
                          //       _inventoryList[index]['productCode']);

                          // });
                          //_inventoryList.removeAt(index);
                          refreshInventoryList();
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 1.0,
                          child: ListTile(
                            title: Text((_inventoryList[index]['productCode'])),
                            subtitle: Text(
                                "qty:${_inventoryList[index]['quantity'].toString()} BP:${_inventoryList[index]['buyingPrice'].toString()} SP: ${_inventoryList[index]['unitSellingPrice'].toString()}"),
                            trailing: GestureDetector(
                              child: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                _deleteInventoryItem(
                                    _inventoryList[index]['id']);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showForm(null);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
}
