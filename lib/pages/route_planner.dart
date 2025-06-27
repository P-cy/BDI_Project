import 'package:flutter/material.dart';

class RoutePlanner extends StatefulWidget {
  const RoutePlanner({super.key});

  @override
  State<RoutePlanner> createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {
  // Controllers to manage the text in the input fields
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  // A flag to control the visibility of the results section
  bool _showResults = false;

  // A list to hold the steps of the calculated route.
  // In a real app, this would be populated by an API call.
  final List<Map<String, dynamic>> _routeSteps = [
    {
      'icon': Icons.directions_walk,
      'title': 'เดินไปยัง ถ.ห้วยแก้ว',
      'subtitle': 'ระยะทางประมาณ 300 เมตร',
      'color': Colors.green,
    },
    {
      'icon': Icons.directions_bus,
      'title': 'ขึ้นรถแดง (สองแถว)',
      'subtitle': 'แจ้งคนขับว่าไป "ประตูช้างเผือก"',
      'color': Colors.red,
    },
    {
      'icon': Icons.pin_drop,
      'title': 'ลงรถบริเวณประตูช้างเผือก',
      'subtitle': 'สังเกตประตูเมืองทางด้านขวา',
      'color': Colors.orange,
    },
     {
      'icon': Icons.directions_walk,
      'title': 'เดินต่อไปยังประตูท่าแพ',
      'subtitle': 'ระยะทางประมาณ 500 เมตร',
      'color': Colors.green,
    },
    {
      'icon': Icons.flag,
      'title': 'ถึงที่หมาย: ประตูท่าแพ',
      'subtitle': 'คุณได้เดินทางถึงจุดหมายแล้ว',
      'color': Colors.blue,
    }
  ];
  
  // Clean up the controllers when the widget is disposed
  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  // --- Methods to handle button presses ---

  void _useCurrentLocation() {
    // In a real app, you would use a package like 'location' or 'geolocator'
    // to get the user's current GPS coordinates and then reverse-geocode them.
    setState(() {
      _originController.text = 'ตำแหน่งปัจจุบัน (ย่านนิมมานเหมินท์)';
      _showResults = false; // Hide results when inputs change
    });
  }

  void _findRoute() {
    // Basic validation to ensure fields are not empty
    if (_originController.text.isNotEmpty && _destinationController.text.isNotEmpty) {
      // Set the flag to true to show the results section
      setState(() {
        _showResults = true;
      });
      // In a real app, this is where you would make an API call
      // to a route planning service (like Google Maps API)
      // with the origin and destination, and then parse the results.
    } else {
        // Show a snackbar if fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('กรุณาระบุทั้งต้นทางและปลายทาง'),
                backgroundColor: Colors.redAccent,
            ),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วางแผนการเดินทาง', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to prevent overflow on smaller screens
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Input Section ---
              _buildInputCard(),
              
              const SizedBox(height: 20),

              // --- Results Section (conditionally shown) ---
              if (_showResults) _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building the input card
  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Origin TextField
            TextField(
              controller: _originController,
              decoration: InputDecoration(
                labelText: 'ต้นทาง',
                hintText: 'ใส่ตำแหน่งเริ่มต้น',
                prefixIcon: Icon(Icons.trip_origin, color: Colors.blue.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Destination TextField
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'ปลายทาง',
                hintText: 'ใส่จุดหมายของคุณ',
                prefixIcon: Icon(Icons.location_on, color: Colors.red.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // "Use Current Location" Button
            TextButton.icon(
              onPressed: _useCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('ใช้ตำแหน่งปัจจุบัน'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 8),
            
            // "Find Route" Button
            ElevatedButton.icon(
              onPressed: _findRoute,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'ค้นหาเส้นทาง', 
                style: TextStyle(color: Colors.white, fontSize: 16)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building the results section
  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เส้นทางที่ดีที่สุด:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Placeholder for the map view
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            'https://placehold.co/600x250/e8e8e8/a8a8a8?text=แผนที่เส้นทาง\n(Map View Placeholder)',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Text('ไม่สามารถโหลดแผนที่ได้')),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // List of route steps
        ListView.builder(
          shrinkWrap: true, // Important to use inside a Column
          physics: const NeverScrollableScrollPhysics(), // The parent is already scrollable
          itemCount: _routeSteps.length,
          itemBuilder: (context, index) {
            final step = _routeSteps[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: step['color'].withOpacity(0.15),
                  child: Icon(step['icon'], color: step['color']),
                ),
                title: Text(step['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(step['subtitle']),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
