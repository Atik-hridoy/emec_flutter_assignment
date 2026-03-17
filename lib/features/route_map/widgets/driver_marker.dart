import 'package:flutter/material.dart';

class DriverMarker extends StatelessWidget {
  const DriverMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.directions_bike,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
