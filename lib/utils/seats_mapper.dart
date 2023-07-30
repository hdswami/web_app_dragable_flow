import 'package:flutter/material.dart';
import 'package:flutter_user_profile_app/user_shared_preferences.dart';

class SeatMapper {
  static final SeatMapper singleton = SeatMapper._internal();

  static const double defaultOffsetDx = 220.00;
  static const double defaultOffsetDy = 90.40;
  static const Offset defaultOffset = Offset(
    220.00,
    90.40,
  );
  static const Offset defaultOffsetMobile = Offset(
    20.00,
    10.40,
  );
  factory SeatMapper() {
    return singleton;
  }

  SeatMapper._internal();

  List<Seat> seats = [];

  Future<void> restore() async {
    await UserSharedPreferences.getSavedSeatState().then((value) {
      seats = value;
    });
  }
}

class Seat {
  String? seatNo;
  Offset? offset;
  double? dx;
  double? dy;
  Seat(this.seatNo, this.offset, this.dx, this.dy);

  static Seat fromJson(dynamic json) {
    Seat seat = Seat(json['seatNo'] as String, null, json['dx'], json['dy']);
    seat.offset = Offset(json['dx'] ?? 0, json['dy'] ?? 0);
    return seat;
  }

  Map<String, dynamic> toJson() => {
        'seatNo': seatNo,
        'dx': offset?.dx,
        'dy': offset?.dy,
      };
}
