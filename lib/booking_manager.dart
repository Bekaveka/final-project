import 'package:flutter/foundation.dart';

class Booking {
  final String hotelName;
  final String location;
  final String imagePath;
  final String checkIn;
  final String checkOut;
  final int guests;
  final int rooms;
  final double total;
  final DateTime createdAt;

  const Booking({
    required this.hotelName,
    required this.location,
    required this.imagePath,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.total,
    required this.createdAt,
  });
}

class BookingManager {
  BookingManager._();

  static final ValueNotifier<List<Booking>> bookingsNotifier =
      ValueNotifier<List<Booking>>([]);

  static void addBooking(Booking booking) {
    final current = List<Booking>.from(bookingsNotifier.value);
    current.insert(0, booking);
    bookingsNotifier.value = current;
  }
}


