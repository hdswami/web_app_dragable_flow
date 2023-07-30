import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_user_profile_app/utils/seats_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setValue(bool value) async {
    await _preferences?.setBool("Theme", value);
  }

  static bool? getValue() {
    return _preferences?.getBool("Theme");
  }

  static void saveSeatState(List<Seat> selectedSeat) async {
    var saveObject = jsonEncode(selectedSeat);
    await _preferences?.setString("seats", saveObject);
    debugPrint(saveObject);
  }

  static Future<List<Seat>> getSavedSeatState() async {
    List<Seat> selectedSeat = [];
    var savedObject = _preferences?.getString("seats") ?? '{}';
   List saveObject = jsonDecode(savedObject);
    for (var item in saveObject) {
      selectedSeat.add(Seat.fromJson(item));
    }
    return selectedSeat;
  }
}
