import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import '../widgets/grid_menu_item.dart';

const Map<String, Color> categoryColors = {
  'Food': Color(0xFFFFA726),
  'Travel': Color(0xFF42A5F5),
  'Health': Color(0xFFEF5350),
  'Event': Color(0xFFAB47BC),
  'Invest': Color(0xFF66BB6A),
  'Budget': Color(0xFF78909C),
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Format angka ke Rupiah dengan titik ribuan
  String _formatRupiah(double number) {
    final format = NumberFormat.decimalPattern('id');
    return 'Rp${format.format(number)}';
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0047AB),
            Color(0xFF3498DB),
            Color(0xFF00FFFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Finance Mate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF0047AB),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // --- 4 Kartu Bank
    final List<Map<String, dynamic>> bankCards = [
      {'bank': 'Bank BCA', 'number': '**** 2345', 'balance': 170500000.0, 'color1': const Color(0xFF0047AB), 'color2': const Color(0xFF00B4D8)},
      {'bank': 'Bank BRI', 'number': '**** 8765', 'balance': 155350000.0, 'color1': const Color(0xFF00B4D8), 'color2': const Color(0xFF0047AB)},
      {'bank': 'Bank Mandiri', 'number': '**** 4321', 'balance': 15350000.0, 'color1': const Color(0xFF0047AB), 'color2': const Color(0xFF00B4D8)},
      {'bank': 'Bank BJB', 'number': '**** 7890', 'balance': 75350000.0, 'color1': const Color(0xFF00B4D8), 'color2': const Color(0xFF0047AB)},
    ];

    // Hitung total balance otomatis
    double totalBalance = 0;
    for (var card in bankCards) {
      totalBalance += card['balance'] as double;
    }

    // --- Dummy Data Transaksi
    final transactions = [
      TransactionModel('Investasi', '+Rp10.000.000', 'Invest'),
      TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
      TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
      TransactionModel('Gym Membership', '-Rp150.000', 'Health'),
      TransactionModel('Movie Ticket', '-Rp60.000', 'Event'),
      TransactionModel('Salary', '+Rp5.000.000', 'Income'),
    ];

    // Hitung pengeluaran tiap kategori
    final Map<String, double> categoryExpenses = {};
    double totalExpense = 0;
    for (var transaction in transactions) {
      if (transaction.amount.startsWith('-')) {
        final cleaned = transaction.amount.replaceAll('-Rp', '').replaceAll('.', '');
        final amount = double.tryParse(cleaned) ?? 0;
        totalExpense += amount;
        categoryExpenses.update(transaction.category, (v) => v + amount, ifAbsent: () => amount);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomHeader(context),
              const SizedBox(height: 16),

              // --- Total Balance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0047AB), Color(0xFF00B4D8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRupiah(totalBalance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- My Cards
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'My Cards',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bankCards.length,
                  itemBuilder: (context, index) {
                    final card = bankCards[index];
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
                      child: AtmCard(
                        bankName: card['bank'],
                        cardNumber: card['number'],
                        balance: _formatRupiah(card['balance']),
                        color1: card['color1'],
                        color2: card['color2'],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // --- Grid Menu (kategorinya dibuat lebih kecil)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: width < 400 ? 3 : 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                  children: const [
                    GridMenuItem(icon: Icons.health_and_safety, label: 'Health', onTap: null),
                    GridMenuItem(icon: Icons.travel_explore, label: 'Travel', onTap: null),
                    GridMenuItem(icon: Icons.fastfood, label: 'Food', onTap: null),
                    GridMenuItem(icon: Icons.event, label: 'Event', onTap: null),
                    GridMenuItem(icon: Icons.trending_up, label: 'Invest', onTap: null),
                    GridMenuItem(icon: Icons.pie_chart, label: 'Budget', onTap: null),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Expense Summary
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Expense Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 40,
                            startDegreeOffset: -90,
                            sections: categoryExpenses.entries.map((entry) {
                              final percent = (entry.value / totalExpense) * 100;
                              return PieChartSectionData(
                                color: categoryColors[entry.key] ?? Colors.grey.shade400,
                                value: entry.value,
                                title: '${percent.toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Expense: ${_formatRupiah(totalExpense)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: categoryExpenses.entries.map((entry) {
                          final percent = (entry.value / totalExpense) * 100;
                          return Chip(
                            label: Text(
                              '${entry.key} ${percent.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor:
                                (categoryColors[entry.key] ?? Colors.grey.shade400)
                                    .withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Last Transactions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Last Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}