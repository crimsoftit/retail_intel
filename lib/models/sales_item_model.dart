// ignore_for_file: unnecessary_getters_setters

class SalesItemModel {
  int? _id;
  String _productCode = "";
  String _name = "";
  int _quantity = 0;
  int _price = 0;
  String _date = "";

  SalesItemModel(
    this._productCode,
    this._name,
    this._quantity,
    this._price,
    this._date,
  );

  SalesItemModel.withId(
    this._id,
    this._productCode,
    this._name,
    this._quantity,
    this._price,
    this._date,
  );

  int? get id => _id;

  String get productCode => _productCode;
  String get name => _name;
  int get quantity => _quantity;
  int get price => _price;
  String get date => _date;

  set productCode(String newPcode) {
    if (newPcode.length <= 255 || newPcode.length >= 2) {
      _productCode = newPcode;
    }
  }

  set name(String newName) {
    if (newName.length <= 255 || newName.length >= 3) {
      _name = newName;
    }
  }

  set quantity(int newQty) {
    if (newQty >= 1) {
      _quantity = newQty;
    }
  }

  set price(int newPrice) {
    if (newPrice >= 1) {
      _price = newPrice;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert a SalesItemModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = _id;
    }
    map['productCode'] = _productCode;
    map['name'] = _name;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['date'] = _date;

    return map;
  }

  // extract a SalesItemModel object from a Map object
  SalesItemModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _productCode = map['productCode'];
    _name = map['name'];
    _quantity = map['quantity'];
    _price = map['price'];
    _date = map['date'];
  }
}
