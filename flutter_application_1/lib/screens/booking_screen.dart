import 'package:flutter/material.dart';

// Room model class
class Room {
  final int roomNumber;
  final String roomType;
  final double pricePerNight;
  bool isAvailable;

  Room({
    required this.roomNumber,
    required this.roomType,
    required this.pricePerNight,
    this.isAvailable = true,
  });
}

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<Room> rooms = List.generate(
    10,
    (index) => Room(
      roomNumber: 100 + index,
      roomType: index % 2 == 0 ? 'Single' : 'Double',
      pricePerNight: 120 + (index * 10),
      isAvailable: index % 2 == 0,
    ),
  );

  void _showBookingForm(Room room) {
    showDialog(
      context: context,
      builder: (context) {
        return BookingFormDialog(
          room: room,
          onBookingSuccess: () {
            setState(() {
              room.isAvailable = false;  // Mark the room as booked (not available)
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Management'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(room.roomNumber.toString()),
              ),
              title: Text('${room.roomType} Room'),
              subtitle: Text('Price: \$${room.pricePerNight}/night'),
              trailing: ElevatedButton(
                onPressed: room.isAvailable
                    ? () => _showBookingForm(room)
                    : null,
                child: Text(room.isAvailable ? 'Book Now' : 'Occupied'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookingFormDialog extends StatelessWidget {
  final Room room;
  final VoidCallback onBookingSuccess;  // Callback for booking success

  BookingFormDialog({required this.room, required this.onBookingSuccess});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Book Room ${room.roomNumber}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final name = _nameController.text;
              final email = _emailController.text;
              final phone = _phoneController.text;

              // Simulate booking process
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Room ${room.roomNumber} booked successfully for $name!',
                  ),
                ),
              );

              // Call the booking success callback to update the room availability
              onBookingSuccess();
            }
          },
          child: Text('Book Now'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingScreen(),
  ));
}
