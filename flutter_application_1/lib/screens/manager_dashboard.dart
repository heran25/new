import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username == 'manager' && password == 'password123') {
                  setState(() {
                    _isLoggedIn = true;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerDashboard()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  List<Map<String, String>> rooms = []; // List to hold room data
  List<Map<String, String>> staffMembers = []; // List to hold staff data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 20),
              _buildStatisticsSection(),
              SizedBox(height: 20),
              _buildHorizontalSections(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Text(
      'Welcome, Manager',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Occupied Rooms', '25', Colors.orange),
                _buildStatCard('Available Rooms', '75', Colors.green),
                _buildStatCard('Total Revenue', '\$12,340', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildHorizontalSections(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildRoomManagementSection(context)),
        SizedBox(width: 16),
        Expanded(child: _buildStaffManagementSection(context)),
        SizedBox(width: 16),
        Expanded(child: _buildReportsSection(context)),
      ],
    );
  }

  Widget _buildRoomManagementSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildActionButton(context, 'View All Rooms', Icons.hotel, Colors.blue),
            SizedBox(height: 12),
            _buildActionButton(context, 'Add New Room', Icons.add_box, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffManagementSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staff Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildActionButton(context, 'View Staff Members', Icons.people, Colors.purple),
            SizedBox(height: 12),
            _buildActionButton(context, 'Add New Staff', Icons.person_add, Colors.green),
            SizedBox(height: 12),
            _buildActionButton(context, 'Edit Staff Details', Icons.edit, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildActionButton(context, 'Generate Financial Report', Icons.attach_money, Colors.green),
            SizedBox(height: 12),
            _buildActionButton(context, 'Generate Occupancy Report', Icons.bar_chart, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        if (title == 'View All Rooms') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRoomsScreen(rooms: rooms, onRoomUpdated: (updatedRoom, index) {
                setState(() {
                  rooms[index] = updatedRoom;
                });
              }),
            ),
          );
        } else if (title == 'Add New Room') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRoomScreen(onRoomAdded: (newRoom) {
                setState(() {
                  rooms.add(newRoom);
                });
              }),
            ),
          );
        } else if (title == 'View Staff Members') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewStaffScreen(staffMembers: staffMembers),
            ),
          );
        } else if (title == 'Add New Staff') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStaffScreen(onStaffAdded: (newStaff) {
                setState(() {
                  staffMembers.add(newStaff);
                });
              }),
            ),
          );
        } else if (title == 'Edit Staff Details') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStaffScreen(staffMembers: staffMembers),
            ),
          );
        }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class ViewRoomsScreen extends StatelessWidget {
  final List<Map<String, String>> rooms;
  final Function(Map<String, String>, int) onRoomUpdated;

  ViewRoomsScreen({required this.rooms, required this.onRoomUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Rooms'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Room ${rooms[index]["name"]}'),
              subtitle: Text('Status: ${rooms[index]["status"]}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Open edit dialog for room
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit Room'),
                        content: Column(
                          children: [
                            TextField(
                              controller: TextEditingController(text: rooms[index]["name"]),
                              decoration: InputDecoration(labelText: 'Room Name'),
                              onChanged: (value) {
                                rooms[index]["name"] = value;
                              },
                            ),
                            TextField(
                              controller: TextEditingController(text: rooms[index]["status"]),
                              decoration: InputDecoration(labelText: 'Room Status'),
                              onChanged: (value) {
                                rooms[index]["status"] = value;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              onRoomUpdated(rooms[index], index);
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddRoomScreen extends StatelessWidget {
  final Function(Map<String, String>) onRoomAdded;

  AddRoomScreen({required this.onRoomAdded});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController statusController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Room'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Room Name'),
            ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Room Status'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<String, String> newRoom = {
                  'name': nameController.text,
                  'status': statusController.text,
                };
                onRoomAdded(newRoom);
                Navigator.pop(context);
              },
              child: Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewStaffScreen extends StatelessWidget {
  final List<Map<String, String>> staffMembers;

  ViewStaffScreen({required this.staffMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Staff Members'),
      ),
      body: ListView.builder(
        itemCount: staffMembers.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(staffMembers[index]["name"]!),
              subtitle: Text('Role: ${staffMembers[index]["role"]}'),
            ),
          );
        },
      ),
    );
  }
}

class AddStaffScreen extends StatelessWidget {
  final Function(Map<String, String>) onStaffAdded;

  AddStaffScreen({required this.onStaffAdded});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Staff'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Staff Name'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map<String, String> newStaff = {
                  'name': nameController.text,
                  'role': roleController.text,
                };
                onStaffAdded(newStaff);
                Navigator.pop(context);
              },
              child: Text('Add Staff'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditStaffScreen extends StatelessWidget {
  final List<Map<String, String>> staffMembers;

  EditStaffScreen({required this.staffMembers});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Staff Details'),
      ),
      body: ListView.builder(
        itemCount: staffMembers.length,
        itemBuilder: (context, index) {
          nameController.text = staffMembers[index]["name"]!;
          roleController.text = staffMembers[index]["role"]!;
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(staffMembers[index]["name"]!),
              subtitle: Text('Role: ${staffMembers[index]["role"]}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Show dialog to edit
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit Staff'),
                        content: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(labelText: 'Staff Name'),
                            ),
                            TextField(
                              controller: roleController,
                              decoration: InputDecoration(labelText: 'Role'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              staffMembers[index]["name"] = nameController.text;
                              staffMembers[index]["role"] = roleController.text;
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
