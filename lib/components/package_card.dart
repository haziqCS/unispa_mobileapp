import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class PackageCard extends StatelessWidget {
  final String name;
  final String desc;
  final String price;
  final String duration;
  final VoidCallback? onTap;

  const PackageCard({
    super.key,
    required this.name,
    required this.desc,
    required this.price,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Config.spaceSmall,
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Config.spaceSmall,
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text(duration),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16),
                const SizedBox(width: 4),
                Text(price),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
