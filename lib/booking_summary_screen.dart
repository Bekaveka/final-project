import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'booking_manager.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String hotelName;
  final String location;
  final String price;
  final String imagePath;

  const BookingSummaryScreen({
    super.key,
    required this.hotelName,
    required this.location,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final priceValue = int.parse(price.split(' ')[0].replaceAll('\$', ''));
    final nights = 2;
    final amount = priceValue * nights;
    final tax = 30;
    final total = amount + tax;

    const checkIn = '24-Oct-2023';
    const checkOut = '26-Oct-2023';
    const guests = 3;
    const rooms = 1;

    final booking = Booking(
      hotelName: hotelName,
      location: location,
      imagePath: imagePath,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      rooms: rooms,
      total: total.toDouble(),
      createdAt: DateTime.now(),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFF1A75FF),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            color: Color(0xFF1A75FF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHotelCard(),
            const SizedBox(height: 24),
            _buildBookingDetails(
              checkIn: checkIn,
              checkOut: checkOut,
              guests: guests,
              rooms: rooms,
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 24),
            _buildPriceBreakdown(amount, tax, total),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A75FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentScreen(booking: booking),
                ),
              );
            },
            child: const Text(
              'CONTINUE TO PAYMENT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFC107), width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price.split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A75FF),
                        ),
                      ),
                      TextSpan(
                        text: ' ${price.split(' ')[1]}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails({
    required String checkIn,
    required String checkOut,
    required int guests,
    required int rooms,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDetailRow('Booking Date', '1-Oct-2023'),
          const SizedBox(height: 16),
          _buildDetailRow('Check-in', checkIn),
          const SizedBox(height: 16),
          _buildDetailRow('Check-out', checkOut),
          const SizedBox(height: 16),
          _buildDetailRow('Guests', '$guests'),
          const SizedBox(height: 16),
          _buildDetailRow('Room(s)', '$rooms'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown(int amount, int tax, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPriceRow('Amount', '\$$amount x 2'),
          const SizedBox(height: 12),
          _buildPriceRow('Tax', '\$$tax'),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '\$$total',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A75FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


