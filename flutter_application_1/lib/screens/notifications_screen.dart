import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Booking Assigned',
      'message': 'A new booking has been assigned to Room 101. Please prepare the room.',
      'icon': Icons.check_circle,
      'time': '2h ago',
      'color': Colors.green,
    },
    {
      'title': 'Payment Received',
      'message': 'A payment of \$350 has been received for Room 202.',
      'icon': Icons.payment,
      'time': '4h ago',
      'color': Colors.blue,
    },
    {
      'title': 'Room Service Request',
      'message': 'There is a request for extra towels in Room 103.',
      'icon': Icons.room_service,
      'time': '1d ago',
      'color': Colors.orange,
    },
    {
      'title': 'Maintenance Required',
      'message': 'The air conditioning in Room 305 is not working properly. Maintenance is required.',
      'icon': Icons.build,
      'time': '3d ago',
      'color': Colors.red,
    },
  ];

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(
              child: _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Notifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: _clearAllNotifications,
          icon: Icon(Icons.clear_all),
          label: Text('Clear All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, index);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification['color'].withOpacity(0.2),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 28,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message']),
            SizedBox(height: 4),
            Text(
              notification['time'],
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteNotification(index);
          },
        ),
      ),
    );
  }
}
