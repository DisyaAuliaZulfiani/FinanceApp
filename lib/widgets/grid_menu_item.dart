import 'package:flutter/material.dart';

class GridMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; 

  const GridMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: const Color(0xFFF1F0F7), 
            child: InkWell(
              onTap: onTap,
              splashColor: const Color(0xFF3498DB).withOpacity(0.3),
              highlightColor: const Color(0xFF3498DB).withOpacity(0.1),
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                // PERBAIKAN: Hapus 'const' dan gunakan variabel 'icon' yang benar
                child: Icon( 
                  icon, // <-- VARIABEL 'icon' HARUS DIGUNAKAN DI SINI
                  color: const Color(0xFF3B5998), 
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}