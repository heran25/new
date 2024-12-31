import 'package:flutter/material.dart';

class GuestProfileScreen extends StatefulWidget {
  @override
  _GuestProfileScreenState createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  final List<Map<String, String>> _guestProfiles = [
    {'name': 'Abebe Tessema', 'email': 'abebetessema@example.com', 'phone': '0911353264'},
    {'name': 'Desalegn Kebede', 'email': 'desalegnkebede@example.com', 'phone': '0989013989'},
    {'name': 'Tsehay Bekele', 'email': 'tsehaybekele@example.com', 'phone': '555-555-5555'},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredGuests = _guestProfiles
        .where((guest) => guest['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Profiles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Guests',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredGuests.isEmpty
                  ? Center(
                      child: Text(
                        'No guests found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredGuests.length,
                      itemBuilder: (context, index) {
                        final guest = filteredGuests[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(guest['name']![0].toUpperCase()),
                            ),
                            title: Text(guest['name']!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${guest['email']}'),
                                Text('Phone: ${guest['phone']}'),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editGuestProfile(context, guest);
                                } else if (value == 'delete') {
                                  _deleteGuestProfile(guest);
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
        onPressed: () {
          _addGuestProfile(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Guest',
      ),
    );
  }

  void _addGuestProfile(BuildContext context) {
    _showGuestProfileDialog(
      context,
      title: 'Add New Guest',
      onSave: (name, email, phone) {
        setState(() {
          _guestProfiles.add({'name': name, 'email': email, 'phone': phone});
        });
      },
    );
  }

  void _editGuestProfile(BuildContext context, Map<String, String> guest) {
    _showGuestProfileDialog(
      context,
      title: 'Edit Guest Profile',
      initialName: guest['name'],
      initialEmail: guest['email'],
      initialPhone: guest['phone'],
      onSave: (name, email, phone) {
        setState(() {
          guest['name'] = name;
          guest['email'] = email;
          guest['phone'] = phone;
        });
      },
    );
  }

  void _deleteGuestProfile(Map<String, String> guest) {
    setState(() {
      _guestProfiles.remove(guest);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${guest['name']} has been deleted.')),
    );
  }

  void _showGuestProfileDialog(
    BuildContext context, {
    required String title,
    String? initialName,
    String? initialEmail,
    String? initialPhone,
    required Function(String, String, String) onSave,
  }) {
    final _nameController = TextEditingController(text: initialName);
    final _emailController = TextEditingController(text: initialEmail);
    final _phoneController = TextEditingController(text: initialPhone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = _nameController.text;
                final email = _emailController.text;
                final phone = _phoneController.text;
                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
                  onSave(name, email, phone);
                  Navigator.of(context).pop();
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
