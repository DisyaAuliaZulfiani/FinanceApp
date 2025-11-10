import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import '../widgets/grid_menu_item.dart';

// Definisi warna yang konsisten untuk Donut Chart
const Map<String, Color> categoryColors = {
  'Food': Color(0xFFFFA726), // Orange
  'Travel': Color(0xFF42A5F5), // Blue
  'Health': Color(0xFFEF5350), // Red
  'Event': Color(0xFFAB47BC), // Purple
  'Invest': Color(0xFF66BB6A), // Green
  'Budget': Color(0xFF78909C), // Grey (Jika ada)
};


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi untuk memformat angka menjadi format Rupiah sederhana
  String _formatRupiah(double number) {
    return 'Rp${number.toStringAsFixed(0)}'; 
  }

  // Widget kustom untuk Header minimalis
  Widget _buildCustomHeader(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 0, 71, 171), 
          Color(0xFF3498DB),              
          Color.fromARGB(255, 0, 255, 255), 
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only( // Sudut tumpul
        bottomLeft: Radius.circular(25), 
        bottomRight: Radius.circular(25),
      ),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: 12.0, 
      horizontal: 16.0,
    ),
    // Row utama menampung semua elemen
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // ===== 1. ELEMEN KIRI (Spacer kosong, lebarnya sama dengan elemen kanan) =====
        // Menggunakan SizedBox yang lebarnya setara dengan Row ikon di kanan
        const SizedBox(width: 70), // Perkirakan lebar yang dibutuhkan oleh ikon kanan (32+16+28+16)
        
        // ===== 2. ELEMEN TENGAH (Finance Mate) =====
        const Text(
          'Finance Mate',
          textAlign: TextAlign.center, // Tambahkan ini untuk jaga-jaga
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white, 
          ),
        ),
        
        // ===== 3. ELEMEN KANAN (Ikon) =====
        // Ikon Aksi Cepat Kanan (Notifikasi & Profil)
        Row(
          // Gunakan ukuran tetap, dan atur mainAxisAlignment di Row ini jika perlu
          children: const [
            Icon(
              Icons.notifications_none_rounded,
              color: Colors.white, 
              size: 28,
            ),
            SizedBox(width: 16),
            CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF0047AB), 
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final transactions = [
      TransactionModel('Investasi', '+Rp10.000.000', 'Invest'),
      TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
      TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
      TransactionModel('Gym Membership', '-Rp150.000', 'Health'),
      TransactionModel('Movie Ticket', '-Rp60.000', 'Event'),
      TransactionModel('Salary', '+Rp5.000.000', 'Income'),
    ];

    // ===== LOGIKA PEMROSESAN DATA UNTUK CHART =====
    final Map<String, double> categoryExpenses = {};
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.amount.startsWith('-')) {
        final cleanedAmount = transaction.amount
            .replaceAll('-Rp', '')
            .replaceAll('.', '')
            .replaceAll(',', '');
        
        final amount = double.tryParse(cleanedAmount) ?? 0.0;
        totalExpense += amount;
        
        categoryExpenses.update(
          transaction.category,
          (existingValue) => existingValue + amount,
          ifAbsent: () => amount,
        );
      }
    }
    // ===============================================

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu terang
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panggil Header Kustom
              _buildCustomHeader(context), 

              // ===== Title My Cards =====
              const Text(
                'My Cards',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ===== Banner Cards (Tidak diubah) =====
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AtmCard(
                      bankName: 'Bank BCA',
                      cardNumber: '**** 2345',
                      balance: 'Rp1.650.500.000',
                      color1: Color.fromARGB(255, 0, 71, 171),
                      color2: Color.fromARGB(255, 0, 255, 255),
                    ),
                    SizedBox(width: 16),
                    AtmCard(
                      bankName: 'Bank BRI',
                      cardNumber: '**** 8765',
                      balance: 'Rp155.350.000',
                      color1: Color.fromARGB(255, 0, 255, 255),
                      color2: Color.fromARGB(255, 0, 71, 171),
                    ),
                    SizedBox(width: 16),
                    AtmCard(
                      bankName: 'Bank Mandiri',
                      cardNumber: '**** 7654',
                      balance: 'Rp277.350.000',
                      color1: Color.fromARGB(255, 0, 71, 171),
                      color2: Color.fromARGB(255, 0, 255, 255),
                    ),
                    SizedBox(width: 16),
                    AtmCard(
                      bankName: 'BANK BJB',
                      cardNumber: '**** 5821',
                      balance: 'Rp105.350.000',
                      color1: Color.fromARGB(255, 0, 255, 255),
                      color2: Color.fromARGB(255, 0, 71, 171),
                    ),
                  ],
                ),
              ),

              // UBAH: Jarak vertikal diperbesar dari 24 menjadi 40
              const SizedBox(height: 40),

              // ===== Grid Menu (Ditambahkan onTap) =====
              GridView.count(
                // Catatan: Jumlah crossAxisCount 8 terlalu banyak untuk layout standar, 
                // saya rekomendasikan 4 atau 5. Jika Anda tetap menggunakan 8, pastikan 
                // GridMenuItem Anda cukup kecil. Saya asumsikan Anda ingin layout 7 kolom.
                crossAxisCount: 7, // Diubah menjadi 7 agar rapi
                shrinkWrap: true,
                crossAxisSpacing: 18, // Diubah dari 20 ke 18 untuk menyesuaikan 7 kolom
                mainAxisSpacing: 18,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  // Menambahkan onTap: null untuk mengaktifkan efek visual InkWell
                  GridMenuItem(icon: Icons.health_and_safety, label: 'Health', onTap: null),
                  GridMenuItem(icon: Icons.travel_explore, label: 'Travel', onTap: null),
                  GridMenuItem(icon: Icons.fastfood, label: 'Food', onTap: null),
                  GridMenuItem(icon: Icons.event, label: 'Event', onTap: null),
                  GridMenuItem(icon: Icons.trending_up, label: 'Invest', onTap: null),
                  GridMenuItem(icon: Icons.pie_chart, label: 'Budget', onTap: null),
                  GridMenuItem(icon: Icons.money_off, label: 'Bills', onTap: null), 
                ],
              ),

              // UBAH: Jarak vertikal diperbesar dari 24 menjadi 40
              const SizedBox(height: 8),

              // ===== EXPENSE SUMMARY =====
              const Text(
                'Expense Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. DONUT CHART (DIBUNGKUS STACK)
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack( // Gunakan Stack untuk menempatkan teks di tengah
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 50, // Lubang Donut
                            startDegreeOffset: -90,
                            sections: categoryExpenses.entries.map((entry) {
                              final categoryName = entry.key;
                              final categoryTotal = entry.value;

                              final percentage = (categoryTotal / totalExpense) * 100;

                              return PieChartSectionData(
                                color: categoryColors[categoryName] ?? Colors.grey.shade400,
                                value: categoryTotal,
                                title: percentage.toStringAsFixed(0) + '%', 
                                radius: 35,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // 2. TAMBAH: Teks Total Pengeluaran di tengah Stack
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total Expense',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _formatRupiah(totalExpense),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF34495E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 20),

                  // 3. LEGEND (Keterangan)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categoryExpenses.entries.map((entry) {
                        final categoryName = entry.key;
                        final categoryTotal = entry.value;
                        final color = categoryColors[categoryName] ?? Colors.grey.shade400;
                        final percentage = (categoryTotal / totalExpense) * 100;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                percentage.toStringAsFixed(1) + '%',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              // ===== LIST TRANSAKSI =====
              const Text(
                'Last Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: transactions[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}