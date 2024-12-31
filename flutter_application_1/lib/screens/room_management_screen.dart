import 'package:flutter/material.dart';

class RoomManagementScreen extends StatefulWidget {
  @override
  _RoomManagementScreenState createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  final List<Map<String, dynamic>> _rooms = [
    {'number': 101, 'type': 'Single', 'price': 100, 'status': 'Available'},
    {'number': 102, 'type': 'Double', 'price': 150, 'status': 'Occupied'},
    {'number': 103, 'type': 'Suite', 'price': 300, 'status': 'Available'},
    {'number': 104, 'type': 'Single', 'price': 100, 'status': 'Occupied'},
  ];

  void _addRoom() {
    _showRoomFormDialog(
      context,
      title: 'Add New Room',
      onSave: (number, type, price, status) {
        setState(() {
          _rooms.add({
            'number': int.parse(number),
            'type': type,
            'price': double.parse(price),
            'status': status,
          });
        });
      },
    );
  }

  void _editRoom(Map<String, dynamic> room) {
    _showRoomFormDialog(
      context,
      title: 'Edit Room Details',
      initialNumber: room['number'].toString(),
      initialType: room['type'],
      initialPrice: room['price'].toString(),
      initialStatus: room['status'],
      onSave: (number, type, price, status) {
        setState(() {
          room['number'] = int.parse(number);
          room['type'] = type;
          room['price'] = double.parse(price);
          room['status'] = status;
        });
      },
    );
  }

  void _deleteRoom(Map<String, dynamic> room) {
    setState(() {
      _rooms.remove(room);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Room ${room['number']} has been deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Management'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Rooms',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: room['status'] == 'Available'
                            ? Colors.green
                            : Colors.red,
                        child: Text(room['number'].toString()),
                      ),
                      title: Text('${room['type']} Room'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \$${room['price']}'),
                          Text('Status: ${room['status']}'),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editRoom(room);
                          } else if (value == 'delete') {
                            _deleteRoom(room);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRoom,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Room',
      ),
    );
  }

  void _showRoomFormDialog(
    BuildContext context, {
    required String title,
    String? initialNumber,
    String? initialType,
    String? initialPrice,
    String? initialStatus,
    required void Function(
      String number,
      String type,
      String price,
      String status,
    )
        onSave,
  }) {
    final numberController = TextEditingController(text: initialNumber);
    final typeController = TextEditingController(text: initialType);
    final priceController = TextEditingController(text: initialPrice);
    final statusController = TextEditingController(text: initialStatus);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: 'Room Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price Per Night',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(
                    labelText: 'Status (Available/Occupied)',
                    border: OutlineInputBorder(),
                  ),
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
                final number = numberController.text;
                final type = typeController.text;
                final price = priceController.text;
                final status = statusController.text;

                if (number.isNotEmpty &&
                    type.isNotEmpty &&
                    price.isNotEmpty &&
                    status.isNotEmpty) {
                  onSave(number, type, price, status);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required.')),
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
