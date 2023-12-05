// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';

import 'package:flutter/foundation.dart';
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
          $columnInvId INTEGER,
          $columnInvCode CHAR(30) NOT NULL PRIMARY KEY,
          $columnInvName TEXT,
          $columnInvQty INTEGER,
          $columnInvBp INTEGER,
          $columnInvUnitSp INTEGER,
          $columnCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      ''');
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
  static Future<int> updateInventoryItem(int id, String pCode, String name,
      int qty, int buyingPrice, int unitSp) async {
    final db = await SQLHelper.db();

    final inventoryData = {
      'productCode': pCode,
      'name': name,
      'quantity': qty,
      'buyingPrice': buyingPrice,
      'unitSellingPrice': unitSp,
    };

    final result = await db.update(
      '$inventoryTable',
      inventoryData,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  // read all items (inventory list)
  static Future<List<Map<String, dynamic>>> fetchInventoryItems() async {
    final db = await SQLHelper.db();
    return db.query('$inventoryTable', orderBy: '$columnCreatedAt');
  }

  // delete inventory item from the database
  static Future<void> deleteInventoryItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        '$inventoryTable',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // calculate total inventory value
  static Future calculateInventoryValue() async {
    final db = await SQLHelper.db();
    final result = await db
        .rawQuery('SELECT SUM(buyingPrice) AS TOTAL_INV FROM $inventoryTable');
    //print(result.toList());
    return result.toList();
  }

  // fetch all inventory data from the database
  static Future<List> fetchAllInventory() async {
    var db = await SQLHelper.db();
    var result = await db.rawQuery("SELECT * from inventory");
    return result.toList();
  }
}
