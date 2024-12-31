import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'manager_dashboard.dart';
import 'guest_profile_screen.dart' as guestProfileScreen; // Alias the first import
import 'billing_screen.dart';
import 'room_management_screen.dart';
import 'reports_screen.dart';
import 'authentication_screen.dart';
import 'notifications_screen.dart';
import 'housekeeping_management_screen.dart';
import 'loyalty_program_screen.dart'; // Import the second without alias

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Management App'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => AuthenticationScreen()));
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust the grid layout dynamically based on screen width
          int crossAxisCount = constraints.maxWidth > 1200
              ? 4 // 4 columns for very large screens
              : constraints.maxWidth > 800
                  ? 3 // 3 columns for medium screens
                  : 2; // Default to 2 columns for smaller screens
          double childAspectRatio = constraints.maxWidth > 1200
              ? 1.3 // Slightly larger cards for very large screens
              : 1.1; // Standard card size for medium/small screens

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: childAspectRatio,
              children: [
                _buildFeatureButton(
                  context,
                  title: 'Booking Management',
                  icon: Icons.book_online,
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => BookingScreen()));
                  },
                  color1: Colors.teal.shade400,
                  color2: Colors.blue.shade400,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Manager Dashboard',
                  icon: Icons.dashboard,
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => ManagerDashboard()));
                  },
                  color1: Colors.orange.shade400,
                  color2: Colors.deepOrange.shade300,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Guest Profiles',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                guestProfileScreen.GuestProfileScreen())); // Use alias here
                  },
                  color1: Colors.purple.shade400,
                  color2: Colors.purple.shade200,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Billing System',
                  icon: Icons.receipt,
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => BillingScreen()));
                  },
                  color1: Colors.green.shade400,
                  color2: Colors.green.shade200,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Room Management',
                  icon: Icons.hotel,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RoomManagementScreen()));
                  },
                  color1: Colors.indigo.shade400,
                  color2: Colors.indigo.shade200,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Reports',
                  icon: Icons.bar_chart,
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => ReportsScreen()));
                  },
                  color1: Colors.red.shade400,
                  color2: Colors.red.shade200,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Housekeeping Management',
                  icon: Icons.cleaning_services,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                HousekeepingManagementScreen()));
                  },
                  color1: Colors.blueGrey.shade400,
                  color2: Colors.blueGrey.shade200,
                ),
                _buildFeatureButton(
                  context,
                  title: 'Loyalty Program',
                  icon: Icons.loyalty,
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => LoyaltyProgramScreen()));
                  },
                  color1: Colors.pink.shade400,
                  color2: Colors.pink.shade200,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onPressed,
      required Color color1,
      required Color color2}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2], // Dynamic gradient color for each card
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white), // Adjusted icon size
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14, // Slightly smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
