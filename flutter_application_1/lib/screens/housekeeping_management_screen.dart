import 'package:flutter/material.dart';

class HousekeepingManagementScreen extends StatefulWidget {
  @override
  _HousekeepingManagementScreenState createState() =>
      _HousekeepingManagementScreenState();
}

class _HousekeepingManagementScreenState
    extends State<HousekeepingManagementScreen> {
  List<Map<String, dynamic>> housekeepingTasks = [
    {
      'room': 'Room 101',
      'task': 'Clean and restock toiletries',
      'status': 'Pending',
      'assignedTo': 'Alice',
    },
    {
      'room': 'Room 202',
      'task': 'Fix broken lamp',
      'status': 'In Progress',
      'assignedTo': 'Bob',
    },
    {
      'room': 'Room 303',
      'task': 'Deep cleaning required',
      'status': 'Completed',
      'assignedTo': 'Charlie',
    },
  ];

  String filterStatus = 'All';

  void _addTask(String room, String task, String status, String assignedTo) {
    setState(() {
      housekeepingTasks.add({
        'room': room,
        'task': task,
        'status': status,
        'assignedTo': assignedTo,
      });
    });
  }

  void _editTask(int index, String room, String task, String status,
      String assignedTo) {
    setState(() {
      housekeepingTasks[index] = {
        'room': room,
        'task': task,
        'status': status,
        'assignedTo': assignedTo,
      };
    });
  }

  void _markAsCompleted(int index) {
    setState(() {
      housekeepingTasks[index]['status'] = 'Completed';
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = filterStatus == 'All'
        ? housekeepingTasks
        : housekeepingTasks
            .where((task) => task['status'] == filterStatus)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Housekeeping Management'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Housekeeping Tasks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: filterStatus,
                  items: ['All', 'Pending', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      filterStatus = value!;
                    });
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddTaskDialog();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        '${task['room']} - ${task['task']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assigned to: ${task['assignedTo']}'),
                          Text('Status: ${task['status']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: task['status'] == 'Completed'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: task['status'] == 'Completed'
                                ? null
                                : () => _markAsCompleted(index),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              _showEditTaskDialog(index, task);
                            },
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
    );
  }

  void _showAddTaskDialog() {
    String room = '';
    String task = '';
    String status = 'Pending';
    String assignedTo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Room'),
                  onChanged: (value) => room = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Task'),
                  onChanged: (value) => task = value,
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: ['Pending', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) => status = value!,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Assigned To'),
                  onChanged: (value) => assignedTo = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTask(room, task, status, assignedTo);
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

  void _showEditTaskDialog(int index, Map<String, dynamic> task) {
    String room = task['room'];
    String taskName = task['task'];
    String status = task['status'];
    String assignedTo = task['assignedTo'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Room'),
                  controller: TextEditingController(text: room),
                  onChanged: (value) => room = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Task'),
                  controller: TextEditingController(text: taskName),
                  onChanged: (value) => taskName = value,
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: ['Pending', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) => status = value!,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Assigned To'),
                  controller: TextEditingController(text: assignedTo),
                  onChanged: (value) => assignedTo = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editTask(index, room, taskName, status, assignedTo);
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
  }
}
