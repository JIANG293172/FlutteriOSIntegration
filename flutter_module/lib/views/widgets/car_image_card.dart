import 'package:flutter/material.dart';

/// 车辆图片卡片Widget
class CarImageCard extends StatelessWidget {
  const CarImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Icon(Icons.directions_car_filled, size: 72, color: Colors.black54),
      ),
    );
  }
}
