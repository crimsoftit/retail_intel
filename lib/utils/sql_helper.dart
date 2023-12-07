// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static const _databaseName = "duara.db";
  static const _databaseVersion = 1;

  static const salesTable = 'sales';
  static const columnSalesId = 'id';
  static const columnSalesName = 'name';
  static const columnSalesUnitSp = 'unitSellingPrice';

  static const inventoryTable = 'inventory';
  static const columnInvId = 'id';
  static const columnInvCode = 'productCode';
  static const columnInvName = 'name';
  static const columnInvQty = 'quantity';
  static const columnInvBp = 'buyingPrice';
  static const columnInvUnitSp = 'unitSellingPrice';
  static const columnCreatedAt = 'createdAt';

  // SQL code to create the database tables
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
        CREATE TABLE $inventoryTable (
          $columnInvId INT IDENTITY(1, 1),
          $columnInvCode CHAR(30) NOT NULL PRIMARY KEY,
          $columnInvName TEXT,
          $columnInvQty INTEGER,
          $columnInvBp INTEGER,
          $columnInvUnitSp INTEGER,
          $columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      ''');
    testInsert();
  }

  static Future testInsert() async {
    final db = await SQLHelper.db();
    await db.execute(
        'INSERT INTO $inventoryTable VALUES(0, "12", "fruit", 2, 200, 10, "02-02-2021")');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      '$_databaseName',
      version: _databaseVersion,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // create new item (inventory)
  static Future<int> addInventoryItem(String productCode, String name, int qty,
      int buyingPrice, int unitSp) async {
    final db = await SQLHelper.db();

    final inventoryData = {
      'productCode': productCode,
      'name': name,
      'quantity': qty,
      'buyingPrice': buyingPrice,
      'unitSellingPrice': unitSp,
    };

    final id = await db.insert(
      '$inventoryTable',
      inventoryData,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  // update an inventory item by id
  static Future<int> updateInventoryItem(
      String pCode, String name, int qty, int buyingPrice, int unitSp) async {
    final db = await SQLHelper.db();

    final inventoryData = {
      'productCode': pCode,
      'name': name,
      'quantity': qty,
      'buyingPrice': buyingPrice,
      'unitSellingPrice': unitSp,
    };

    final id = await db.update(
      '$inventoryTable',
      inventoryData,
      where: 'productCode = ?',
      whereArgs: [pCode],
    );
    return id;
  }

  // read all items (inventory list)
  static Future<List<Map<String, dynamic>>> fetchInventoryItems() async {
    final db = await SQLHelper.db();
    return db.query('$inventoryTable', orderBy: '$columnCreatedAt');
  }

  // delete inventory item from the database
  static Future<int> deleteInventoryItem(String pCode) async {
    final db = await SQLHelper.db();
    int result = await db.delete(
      '$inventoryTable',
      where: 'productCode = ?',
      whereArgs: [pCode],
    );
    return result;
  }

  // fetch all inventory data from the database
  static Future<List> fetchAllInventory() async {
    var db = await SQLHelper.db();
    var result = await db.rawQuery("SELECT * from inventory");
    return result.toList();
  }
}
