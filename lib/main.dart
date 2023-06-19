import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(DriverHiringApp());
}

class DriverHiringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Hiring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DriverSearchPage(),
    );
  }
}

class Driver {
  final String name;
  final String location;
  final int salary;
  final int experience;
  final String mobileNumber;
  final String drivingLicense;
  final String aadharNumber;

  Driver({
    required this.name,
    required this.location,
    required this.salary,
    required this.experience,
    required this.mobileNumber,
    required this.drivingLicense,
    required this.aadharNumber,
  });
}


class DriverSearchPage extends StatefulWidget {
  @override
  _DriverSearchPageState createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  List<Driver> drivers = [
    Driver(
      name: 'John',
      location: 'City A',
      salary: 2000,
      experience: 3,
      mobileNumber: '1234567890',
      drivingLicense: 'DL1234',
      aadharNumber: '9876543210',
    ),
    Driver(
      name: 'Mike',
      location: 'City B',
      salary: 1800,
      experience: 5,
      mobileNumber: '0987654321',
      drivingLicense: 'DL5678',
      aadharNumber: '1234509876',
    ),
    Driver(
      name: 'Sarah',
      location: 'City A',
      salary: 2500,
      experience: 4,
      mobileNumber: '1112223333',
      drivingLicense: 'DL9012',
      aadharNumber: '5432109876',
    ),
  ];

  List<Driver> filteredDrivers = [];

  void _filterDrivers() {
    final String location = _locationController.text;
    final int salary = int.tryParse(_salaryController.text) ?? 0;
    final int experience = int.tryParse(_experienceController.text) ?? 0;

    filteredDrivers = drivers
        .where((driver) =>
            driver.location.toLowerCase() == location.toLowerCase() &&
            driver.salary >= salary &&
            driver.experience >= experience)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Drivers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            TextField(
              controller: _salaryController,
              decoration: InputDecoration(
                labelText: 'Minimum Salary',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _experienceController,
              decoration: InputDecoration(
                labelText: 'Minimum Experience',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            RaisedButton(
              onPressed: _filterDrivers,
              child: Text('Search Drivers'),
            ),
            SizedBox(height: 16),
            Text(
              'Filtered Drivers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (filteredDrivers.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = filteredDrivers[index];

                    return ListTile(
                      title: Text(driver.name),
                      subtitle: Text(driver.location),
                      trailing: Text('Salary: ${driver.salary}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverDetailPage(driver: driver),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            else
              Text('No drivers found.'),
          ],
        ),
      ),
    );
  }
}

class DriverDetailPage extends StatelessWidget {
  final Driver driver;

  DriverDetailPage({required this.driver});

  void _makePhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Name: ${driver.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Location: ${driver.location}'),
            SizedBox(height: 8),
            Text('Salary: ${driver.salary}'),
            SizedBox(height: 8),
            Text('Experience: ${driver.experience} years'),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Mobile Number: ${driver.mobileNumber}'),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _makePhoneCall(driver.mobileNumber),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Driving License: ${driver.drivingLicense}'),
            SizedBox(height: 8),
            Text('Aadhar Number: ${driver.aadharNumber}'),
          ],
        ),
      ),
    );
  }

}
