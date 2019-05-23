//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class UdhariClass {
  int _amount;
  String _context, _name, _date;
  var myDatabase = Firestore.instance;

  Future<bool> connected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else
      return false;
  }

  void getData(
      int _getAmount, String _getName, String _getContext, String _getDate) {
    _amount = _getAmount;
    _name = _getName;
    _context = _getContext;
    _date = _getDate;
  }

  get name => _name;
  get amount => _amount;

  set amount(String newAmount) {
    this._amount = ((int.parse(newAmount)) ?? 0);
  }

  set context(String newContext) {
    this._context = newContext ?? "No Context!";
  }

  set name(String newName) {
    this._name = newName ?? "An Alien";
  }

  set date(String newDate) {
    this._date = newDate;
  }

  void pushToFirebase(int _radioButtonVal, String _deviceID) {
    var docContext;
    if (_radioButtonVal == 1) {
      docContext = "borrow";
    } else if (_radioButtonVal == 2) {
      docContext = "lend";
    } else {
      docContext = "Erraneous radioButtonVal";
      print("Erraneous radioButtonVal!\n Val : $_radioButtonVal");
    }
    myDatabase
        .collection('Users')
        .document(_deviceID)
        .collection(docContext)
        .document('${this._name}')
        .setData({
      'Name': this._name,
      'Amount': this._amount,
      'Context': this._context,
      'Date': this._date,
    }).then((_) {
      print("Data for ${this._name} Added Successfully");
    }).catchError((_) {
      print("Errro occured!!");
    });
  }
}
