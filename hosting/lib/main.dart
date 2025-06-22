import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase Firestore dependency
import 'custom_scaffold.dart';
import 'firebase_options.dart';
import 'plantdetails.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Database',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 7, 68, 41),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Plant Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _plants = [];

  @override
  void initState() {
    super.initState();
    _fetchPlants(); // Fetch plants from Firebase on initialization
  }

  Future<void> _fetchPlants() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('plants').get();
      setState(() {
        _plants = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching plants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlants = _plants
        .where((plant) => plant['commonName']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    return CustomScaffold(
      breadcrumbs: [
        {'label': 'Home', 'route': '/'},
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            // Set max width
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return Container(
                      //height: 200, // Set the height of each row to 200px
                      padding: const EdgeInsets.all(8.0), // Optional padding
                      child: ListTile(
                        leading: SizedBox(
                          height: 200.0,
                          width: 200.0,
                          child: plant['imageUrl'] != null
                              ? Image.network(
                                  plant[
                                      'imageUrl'], // Display image from Firebase Storage
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit
                                      .contain, // Adjust fit to prevent cropping
                                )
                              : const Icon(
                                  Icons.image_not_supported, // Fallback icon
                                  size:
                                      200, // Ensure fallback icon matches the image size
                                ),
                        ),
                        title: Text(
                          plant['commonName'] ?? 'Unknown',
                          style: const TextStyle(
                              fontSize: 18), // Optional text styling
                        ),
                        subtitle: Text(
                          plant['botanicalName'] ?? 'No description',
                          style: const TextStyle(
                              fontSize: 14), // Optional text styling
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlantDetailsPage(plant: plant),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
