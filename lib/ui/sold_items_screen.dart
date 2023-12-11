// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:retail_intel/constants/constants.dart';
import 'package:retail_intel/ui/responsive/mobile_scaffold.dart';
import 'package:retail_intel/utils/sql_helper.dart';

class SoldItemsScreen extends StatefulWidget {
  const SoldItemsScreen({super.key});

  @override
  State<SoldItemsScreen> createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends State<SoldItemsScreen> {
  // all inventory items in the database
  List<Map<String, dynamic>> _inventoryList = [];

  // all sold items in the database
  List<Map<String, dynamic>> _soldItemsList = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _txtCode = TextEditingController();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtQty = TextEditingController();
  final TextEditingController _txtPrice = TextEditingController();
  final TextEditingController _txtInvQty = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int availableStockQty = 0;

  @override
  void initState() {
    super.initState();

    // loads the sold items list when the app starts
    refreshSoldItemsList();

    print(_inventoryList);
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(String? productCode) async {
    if (productCode != null) {
      // pCode == null -> create new item
      // pCode != null -> update an existing item
      final existingEntry = _soldItemsList
          .firstWhere((element) => element['productCode'] == productCode);
      _txtCode.text = existingEntry['productCode'];
      _txtName.text = existingEntry['name'];
      _txtQty.text = (existingEntry['quantity']).toString();
      _txtPrice.text = (existingEntry['price']).toString();
    } else {
      _txtCode.text = '';
      _txtName.text = '';
      _txtQty.text = '';
      _txtPrice.text = '';

      scanBarcode();
    }
    var textStyle = Theme.of(context).textTheme.bodyMedium;

    showModalBottomSheet(
      context: context,
      elevation: 5.0,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,

          // this will prevent the soft keyboard from covering the fields
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
                      labelText:
                          'qty/no. of units(${_txtInvQty.text} available)',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field qty is required!';
                        // ignore: unrelated_type_equality_checks
                      } else if (value == 0) {
                        return 'invalid value for qty!';
                      } else if (int.parse(value) > availableStockQty) {
                        return 'qty exceeds available stock!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _txtPrice,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field product price is required!';
                        // ignore: unrelated_type_equality_checks
                      } else if (value == 0) {
                        return 'invalid value for product price!';
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: true,
                    child: TextField(
                      controller: _txtInvQty,
                      readOnly: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // validator returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
                        if (productCode == null) {
                          await _addItemToSales();
                        }

                        if (productCode != null) {
                          await _updateSoldItem(productCode);
                        }

                        // Clear the text fields
                        _txtCode.text = '';
                        _txtName.text = '';
                        _txtQty.text = '';
                        _txtPrice.text = '';

                        // close the bottom sheet
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(productCode == null
                        ? 'add new entry..'
                        : 'update entry...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                            onTap: () {
                              _showForm(_soldItemsList[index]['productCode']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showForm(null);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

  // function to fetch/load all soldItems data from the database
  void refreshSoldItemsList() async {
    final soldItems = await SQLHelper.fetchSoldItems();
    setState(() {
      _soldItemsList = soldItems;
      _isLoading = false;
    });
  }

  // function to fetch/load scanned inventory item from the database
  Future scannedInventoryItem(String pCode) async {
    final inventoryData = await SQLHelper.fetchInventoryItems();

    final scannedItem =
        inventoryData.firstWhere((element) => element['productCode'] == pCode);

    setState(() {
      _inventoryList = inventoryData;
      availableStockQty = scannedItem['quantity'];
    });
    _txtInvQty.text = scannedItem['quantity'].toString();
    _txtCode.text = scannedItem['productCode'];
    _txtName.text = scannedItem['name'];
    _txtPrice.text = (scannedItem['unitSellingPrice']).toString();
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

  // function to scan product barcode
  Future scanBarcode() async {
    String scanResults;

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);

      scannedInventoryItem(scanResults);
    } on PlatformException {
      scanResults = "failed to get platform version ..";
    }
  }

  // add sold item to sales table in the database
  Future<void> _addItemToSales() async {
    await SQLHelper.db();
    await SQLHelper.addSoldItem(
      _txtCode.text,
      _txtName.text,
      int.parse(_txtPrice.text),
      int.parse(_txtQty.text),
      date,
    );
    refreshSoldItemsList();
  }

  // update sold item
  Future<void> _updateSoldItem(String pCode) async {
    await SQLHelper.updateSoldItem(
      _txtCode.text,
      _txtName.text,
      int.parse(_txtPrice.text),
      int.parse(_txtQty.text),
      date,
    );
    refreshSoldItemsList();
  }
}