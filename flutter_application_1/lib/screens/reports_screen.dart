import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildSummaryCards(),
              SizedBox(height: 20),
              _buildGraphSection(),
              SizedBox(height: 20),
              _buildTableSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hotel Performance Summary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.filter_alt),
          label: Text('Filter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard('Bookings', '1,245', Colors.purple),
        _buildCard('Revenue', '\$58,400', Colors.green),
        _buildCard('Cancellations', '32', Colors.red),
      ],
    );
  }

  Widget _buildCard(String title, String value, Color color) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, color: color, size: 36),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Distribution',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CustomPaint(
            painter: BarGraphPainter(),
          ),
        ),
      ],
    );
  }

  Widget _buildTableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Reports',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Bookings')),
              DataColumn(label: Text('Revenue')),
              DataColumn(label: Text('Cancellations')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('2024-01-01')),
                DataCell(Text('150')),
                DataCell(Text('\$4,200')),
                DataCell(Text('3')),
              ]),
              DataRow(cells: [
                DataCell(Text('2024-01-02')),
                DataCell(Text('180')),
                DataCell(Text('\$5,400')),
                DataCell(Text('2')),
              ]),
              DataRow(cells: [
                DataCell(Text('2024-01-03')),
                DataCell(Text('120')),
                DataCell(Text('\$3,800')),
                DataCell(Text('1')),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

class BarGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.teal;

    final barWidth = size.width / 8;
    final data = [50, 70, 100, 80, 60, 90, 110, 65]; // Example revenue distribution data points

    // Calculate max data value for scaling the graph
    final maxDataValue = data.reduce((value, element) => value > element ? value : element);

    for (int i = 0; i < data.length; i++) {
      final left = i * 1.5 * barWidth;
      final top = size.height - (data[i] / maxDataValue) * size.height; // Scale data to fit the canvas
      final right = left + barWidth;
      final bottom = size.height;

      // Draw the bar
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
