// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:retail_intel/constants/constants.dart';
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

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _txtCode = TextEditingController();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtBP = TextEditingController();
  final TextEditingController _txtQty = TextEditingController();
  final TextEditingController _txtUnitSP = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(String? pCode) async {
    if (pCode != null) {
      // pCode == null -> create new item
      // pCode != null -> update an existing item
      final existingInventoryData = _inventoryList
          .firstWhere((element) => element['productCode'] == pCode);
      _txtCode.text = existingInventoryData['productCode'];
      _txtName.text = existingInventoryData['name'];
      _txtQty.text = (existingInventoryData['quantity']).toString();
      _txtBP.text = (existingInventoryData['buyingPrice']).toString();
      _txtUnitSP.text = (existingInventoryData['unitSellingPrice']).toString();
    } else {
      _txtCode.text = '';
      _txtName.text = '';
      _txtQty.text = '';
      _txtBP.text = '';
      _txtUnitSP.text = '';
      scanBarCodeNormal();
    }

    final formKey = GlobalKey<FormState>();

    var textStyle = Theme.of(context).textTheme.bodyMedium;

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
          children: <Widget>[
            // form to handle input data
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _txtCode,
                    decoration: InputDecoration(
                      labelText: 'product barcode',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'product barcode is required!';
                      } else if (value.length <= 2) {
                        return 'product barcode should be more than 2 characters!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _txtName,
                    decoration: InputDecoration(
                      labelText: 'product name',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'product name is required!';
                      } else if (value.length < 2) {
                        return 'product name should be more than 2 characters!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _txtQty,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'qty/no. of units',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field qty is required!';
                        // ignore: unrelated_type_equality_checks
                      } else if (value == 0) {
                        return 'invalid value for qty!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _txtBP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'buying price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field buying price is required!';
                        // ignore: unrelated_type_equality_checks
                      } else if (value == 0) {
                        return 'invalid value for buying price!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _txtUnitSP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'unit selling price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field unit selling is required!';
                        // ignore: unrelated_type_equality_checks
                      } else if (value == 0) {
                        return 'invalid value for unit selling!';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // validator returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
                        if (pCode == null) {
                          await _addInventoryItem();
                        }

                        if (pCode != null) {
                          await _updateInventoryItem(pCode);
                        }

                        // Clear the text fields
                        _txtCode.text = '';
                        _txtName.text = '';
                        _txtQty.text = '';
                        _txtBP.text = '';
                        _txtUnitSP.text = '';

                        // close the bottom sheet
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                        pCode == null ? 'add new entry..' : 'update entry...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // add an item to inventory table in the database
  Future<void> _addInventoryItem() async {
    await SQLHelper.db();
    await SQLHelper.addInventoryItem(
        _txtCode.text,
        _txtName.text,
        int.parse(_txtQty.text),
        int.parse(_txtBP.text),
        int.parse(_txtUnitSP.text),
        date);
    refreshInventoryList();
  }

  // update an existing inventory item
  Future<void> _updateInventoryItem(String pCode) async {
    await SQLHelper.updateInventoryItem(
        _txtCode.text,
        _txtName.text,
        int.parse(_txtQty.text),
        int.parse(_txtBP.text),
        int.parse(_txtUnitSP.text),
        date);
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

  // scan product barcode
  void scanBarCodeNormal() async {
    String scanResults;

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
      _txtCode.text = scanResults;
    } on PlatformException {
      scanResults = "ERROR!! failed to get platform version";
    }
    _txtCode.text = scanResults;
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
                  hintText: 'Search inventory...',
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
                    // ignore: unnecessary_null_comparison
                    itemCount:
                        // ignore: unnecessary_null_comparison
                        (_inventoryList != null) ? _inventoryList.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(_inventoryList[index]['name']),
                        onDismissed: (direction) {
                          _deleteInventoryItem(
                              _inventoryList[index]['productCode']);

                          refreshInventoryList();
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 1.0,
                          child: ListTile(
                            title: Text((_inventoryList[index]['name'])),
                            subtitle: Text(
                                "qty:${_inventoryList[index]['quantity'].toString()} BP:${_inventoryList[index]['buyingPrice'].toString()} SP: ${_inventoryList[index]['unitSellingPrice'].toString()} Modified: ${_inventoryList[index]['createdAt']}"),
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown[300],
                              foregroundColor: Colors.white,
                              child: Text(_inventoryList[index]['name'][0]
                                  .toUpperCase()),
                            ),
                            trailing: GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ),
                              onTap: () {
                                _deleteInventoryItem(
                                    _inventoryList[index]['productCode']);
                              },
                            ),
                            onTap: () {
                              _showForm(_inventoryList[index]['productCode']);
                            },
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
