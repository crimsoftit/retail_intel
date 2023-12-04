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
  void _refreshInventoryList() async {
    final inventoryData = await SQLHelper.fetchInventoryItems();
    setState(() {
      _inventoryList = inventoryData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshInventoryList(); // loads the inventory items list when the app starts
  }

  final TextEditingController _txtCode = TextEditingController();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtBP = TextEditingController();

  final TextEditingController txtQty = TextEditingController();
  final TextEditingController txtUnitSP = TextEditingController();

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
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,

          // this will prevent the soft keyboard from covering the textfields
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
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
              controller: _txtBP,
              decoration: const InputDecoration(hintText: 'buying price'),
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
      int.parse(_txtBP.text),
    );
    _refreshInventoryList();
  }

  // update an existing inventory item
  Future<void> _updateInventoryItem(int id) async {
    await SQLHelper.updateInventoryItem(
      id,
      _txtCode.text,
      _txtName.text,
      int.parse(_txtBP.text),
    );
    _refreshInventoryList();
  }

  // delete an item
  void _deleteInventoryItem(int id) async {
    await SQLHelper.deleteInventoryItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('item successfully deleted...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory List'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: _inventoryList.length,
              itemBuilder: (context, index) => Card(
                color: Colors.brown[300],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_inventoryList[index]['name']),
                  subtitle: Text(_inventoryList[index]['createdAt']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteInventoryItem(_inventoryList[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
