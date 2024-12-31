import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<Map<String, dynamic>> _bills = [
    {'name': 'John Doe', 'room': 101, 'amount': 250.0, 'date': '2023-12-21', 'isPaid': false},
    {'name': 'Jane Smith', 'room': 102, 'amount': 300.0, 'date': '2023-12-20', 'isPaid': false},
    {'name': 'Alice Johnson', 'room': 103, 'amount': 150.0, 'date': '2023-12-19', 'isPaid': true},
  ];

  String _searchQuery = '';
  String _filterDate = '';

  @override
  Widget build(BuildContext context) {
    final filteredBills = _bills
        .where((bill) =>
            bill['name'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            (_filterDate.isEmpty || bill['date'] == _filterDate))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Guest Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            SizedBox(height: 16),

            // Date Filter
            TextField(
              decoration: InputDecoration(
                labelText: 'Filter by Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onChanged: (query) {
                setState(() {
                  _filterDate = query;
                });
              },
            ),
            SizedBox(height: 20),

            // Bill List
            Expanded(
              child: filteredBills.isEmpty
                  ? Center(
                      child: Text(
                        'No bills found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBills.length,
                      itemBuilder: (context, index) {
                        final bill = filteredBills[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(bill['room'].toString()),
                            ),
                            title: Text(bill['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Room: ${bill['room']}'),
                                Text('Date: ${bill['date']}'),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${bill['amount'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: bill['isPaid'] ? Colors.green : Colors.red,
                                  ),
                                ),
                                SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      bill['isPaid'] = !bill['isPaid'];
                                    });
                                  },
                                  child: Text(
                                    bill['isPaid'] ? 'Paid' : 'Mark as Paid',
                                    style: TextStyle(
                                      color: bill['isPaid'] ? Colors.green : Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _showBillDetailsDialog(bill);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewBill(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Bill',
      ),
    );
  }

  void _addNewBill(BuildContext context) {
    _showBillDialog(
      context,
      title: 'Add New Bill',
      onSave: (name, room, amount, date) {
        setState(() {
          _bills.add({'name': name, 'room': room, 'amount': amount, 'date': date, 'isPaid': false});
        });
      },
    );
  }

  void _showBillDetailsDialog(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bill Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${bill['name']}'),
              Text('Room: ${bill['room']}'),
              Text('Amount: \$${bill['amount']}'),
              Text('Date: ${bill['date']}'),
              SizedBox(height: 10),
              Text(
                'Status: ${bill['isPaid'] ? 'Paid' : 'Unpaid'}',
                style: TextStyle(color: bill['isPaid'] ? Colors.green : Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBillDialog(
    BuildContext context, {
    required String title,
    String? initialName,
    int? initialRoom,
    double? initialAmount,
    String? initialDate,
    required void Function(String name, int room, double amount, String date) onSave,
  }) {
    final nameController = TextEditingController(text: initialName);
    final roomController = TextEditingController(text: initialRoom?.toString());
    final amountController = TextEditingController(text: initialAmount?.toString());
    final dateController = TextEditingController(text: initialDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Guest Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: roomController,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final room = int.tryParse(roomController.text) ?? 0;
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final date = dateController.text;

                if (name.isNotEmpty && room > 0 && amount > 0 && date.isNotEmpty) {
                  onSave(name, room, amount, date);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields correctly.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
