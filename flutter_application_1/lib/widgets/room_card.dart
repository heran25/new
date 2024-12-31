import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(room.roomNumber.toString()),
        ),
        title: Text('${room.roomType} Room'),
        subtitle: Text('Price: \$${room.pricePerNight}/night'),
        trailing: ElevatedButton(
          onPressed: room.isAvailable ? () {} : null,
          child: Text(room.isAvailable ? 'Book Now' : 'Occupied'),
        ),
      ),
    );
  }
}
