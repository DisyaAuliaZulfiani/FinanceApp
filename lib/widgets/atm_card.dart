import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final String bankName;
  final String cardNumber;
  final String balance;
  final Color color1;
  final Color color2;

  const AtmCard({
    super.key,
    required this.bankName,
    required this.cardNumber,
    required this.balance,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan lebar maksimum yang ideal (misalnya 400 piksel)
    const double maxWidth = 320; 

    return Container(
      // MENGUBAH: Menggunakan batasan lebar maksimum
      // Kita ambil lebar 85% layar saat ini ATAU maksimum 400 piksel, mana yang lebih kecil.
      width: (MediaQuery.of(context).size.width * 0.85).clamp(280.0, maxWidth), 
      
      margin: const EdgeInsets.only(right: 16), 
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.5), 
            blurRadius: 20, 
            spreadRadius: 2,
            offset: const Offset(0, 10), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Nama Bank & Ikon Sinyal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bankName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.wifi, 
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          
          // Saldo dengan Label Jelas
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance,
                // MENGUBAH: Ukuran font disesuaikan agar tidak terlalu besar di kartu yang lebih kecil
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Nomor Kartu
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Ukuran font disesuaikan
              letterSpacing: 3, 
            ),
          ),
        ],
      ),
    );
  }
}