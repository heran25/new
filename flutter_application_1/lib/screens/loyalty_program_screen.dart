import 'package:flutter/material.dart';

class LoyaltyProgramScreen extends StatefulWidget {
  @override
  _LoyaltyProgramScreenState createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen> {
  final List<Map<String, dynamic>> guests = [
    {
      'name': 'John Doe',
      'points': 1200,
      'stays': 5,
      'totalSpent': 300.0,
      'history': [
        {'date': DateTime.now().subtract(Duration(days: 10)), 'spending': 100.0},
        {'date': DateTime.now().subtract(Duration(days: 5)), 'spending': 200.0},
      ],
    },
    {
      'name': 'Jane Smith',
      'points': 800,
      'stays': 3,
      'totalSpent': 150.0,
      'history': [
        {'date': DateTime.now().subtract(Duration(days: 20)), 'spending': 150.0},
      ],
    },
    {
      'name': 'Alice Brown',
      'points': 2000,
      'stays': 10,
      'totalSpent': 500.0,
      'history': [
        {'date': DateTime.now().subtract(Duration(days: 15)), 'spending': 300.0},
        {'date': DateTime.now().subtract(Duration(days: 7)), 'spending': 200.0},
      ],
    },
  ];

  int calculatePoints(int stays, double totalSpent) {
    return (stays * 100) + (totalSpent * 10).toInt();
  }

  String getLoyaltyLevel(int points) {
    if (points >= 2000) {
      return 'Platinum';
    } else if (points >= 1000) {
      return 'Gold';
    } else {
      return 'Silver';
    }
  }

  void _redeemPoints(int index) {
    setState(() {
      final discount = guests[index]['points'] / 10;
      guests[index]['totalSpent'] -= discount;
      guests[index]['points'] = 0;
      guests[index]['history'].add({
        'date': DateTime.now(),
        'spending': -discount,
      });
    });
  }

  void _addPoints(String name, double totalSpent) {
    setState(() {
      final guestIndex = guests.indexWhere((guest) => guest['name'] == name);
      if (guestIndex != -1) {
        guests[guestIndex]['stays'] += 1;
        guests[guestIndex]['totalSpent'] += totalSpent;
        guests[guestIndex]['points'] = calculatePoints(
          guests[guestIndex]['stays'],
          guests[guestIndex]['totalSpent'],
        );
        guests[guestIndex]['history'].add({
          'date': DateTime.now(),
          'spending': totalSpent,
        });
      } else {
        guests.add({
          'name': name,
          'points': calculatePoints(1, totalSpent),
          'stays': 1,
          'totalSpent': totalSpent,
          'history': [
            {'date': DateTime.now(), 'spending': totalSpent},
          ],
        });
      }
    });
  }

  void _showAddPointsDialog() {
    String name = '';
    String spending = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Loyalty Points'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Guest Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Total Spending (\$)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => spending = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && spending.isNotEmpty) {
                  _addPoints(name, double.parse(spending));
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showGuestProfile(int index) {
    final guest = guests[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuestProfileScreen(
          guest: guest,
          redeemPoints: () => _redeemPoints(index),
        ),
      ),
    ).then((_) {
      setState(() {}); // Refresh the list after returning from the profile screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loyalty Program'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddPointsDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: guests.length,
        itemBuilder: (context, index) {
          final guest = guests[index];
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                guest['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Points: ${guest['points']}'),
                  Text('Loyalty Level: ${getLoyaltyLevel(guest['points'])}'),
                  Text('Stays: ${guest['stays']}'),
                  Text('Total Spent: \$${guest['totalSpent'].toStringAsFixed(2)}'),
                ],
              ),
              onTap: () => _showGuestProfile(index),
            ),
          );
        },
      ),
    );
  }
}

class GuestProfileScreen extends StatelessWidget {
  final Map<String, dynamic> guest;
  final VoidCallback redeemPoints;

  GuestProfileScreen({required this.guest, required this.redeemPoints});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${guest['name']} Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Points: ${guest['points']}', style: TextStyle(fontSize: 18)),
            Text('Loyalty Level: ${guest['points']}', style: TextStyle(fontSize: 18)),
            Text('Stays: ${guest['stays']}', style: TextStyle(fontSize: 18)),
            Text('Total Spent: \$${guest['totalSpent'].toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Transaction History:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: guest['history'].length,
                itemBuilder: (context, index) {
                  final history = guest['history'][index];
                  return ListTile(
                    title: Text(
                      '\$${history['spending'].toStringAsFixed(2)}',
                    ),
                    subtitle: Text('${history['date']}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: guest['points'] > 0 ? redeemPoints : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: guest['points'] > 0 ? Colors.teal : Colors.grey,
              ),
              child: Text('Redeem Points'),
            ),
          ],
        ),
      ),
    );
  }
}
