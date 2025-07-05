import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // No longer directly querying plants from Firestore
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // For JSON encoding/decoding

import 'package:plant_db/filters.dart'; // Your updated FilterPanel
import 'custom_scaffold.dart';
import 'firebase_options.dart';
import 'plant_details.dart';
import 'planting_chart.dart';
import './types/plant.dart'; // Adjust the path to where your Plant class is defined

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
  List<Plant> _plants = [];

  // Filter states - align with FilterPanel and API query parameters
  final Set<String> _selectedPlantTypes = {};
  final Set<String> _selectedLightRequirements = {};
  final Set<String> _selectedWaterRequirements = {};
  final Set<String> _selectedGrowthHabits = {};
  String? _selectedClimateZone;
  final Set<String> _selectedSoilType = {};
  String? _selectedMatureSize;
  final Set<String> _selectedBloomColors = {};

  // Reference data lists (fetched from API to populate filters dynamically)
  // Changed to List<Map<String, dynamic>> to hold both 'id' and 'name'
  List<Map<String, dynamic>> _availablePlantTypes = [];
  List<Map<String, dynamic>> _availableLightRequirements = [];
  List<Map<String, dynamic>> _availableWaterRequirements = [];
  List<Map<String, dynamic>> _availableGrowthHabits = [];
  List<Map<String, dynamic>> _availableClimateZones = [];
  List<Map<String, dynamic>> _availableSoilTypes = [];
  List<Map<String, dynamic>> _availableMatureSizes = [];
  List<Map<String, dynamic>> _availableBloomColors = [];

  // Base URL for your Cloud Functions API
  // IMPORTANT: Replace with your actual deployed Cloud Function URL
  static const String _apiBaseUrl = 'https://api-bzyhmja4mq-uc.a.run.app';

  @override
  void initState() {
    super.initState();
    _fetchReferenceData(); // Fetch reference data first to populate filters
    _fetchPlants(); // Then fetch initial plants
  }

  // Fetches dynamic filter options from the API
  Future<void> _fetchReferenceData() async {
    try {
      final responsePlantTypes =
          await http.get(Uri.parse('$_apiBaseUrl/plant-types'));
      final responseLightRequirements =
          await http.get(Uri.parse('$_apiBaseUrl/light-requirements'));
      final responseWaterRequirements =
          await http.get(Uri.parse('$_apiBaseUrl/water-requirements'));
      // final responseGrowthHabits = await http.get(Uri.parse('$_apiBaseUrl/growth-habits'));
      // final responseClimateZones = await http.get(Uri.parse('$_apiBaseUrl/climate-zones'));
      final responseSoilTypes =
          await http.get(Uri.parse('$_apiBaseUrl/soil-types'));
      // final responseMatureSizes = await http.get(Uri.parse('$_apiBaseUrl/mature-sizes'));
      // final responseBloomColors = await http.get(Uri.parse('$_apiBaseUrl/bloom-colors'));

      if (responsePlantTypes.statusCode == 200 &&
              responseLightRequirements.statusCode == 200 &&
              responseWaterRequirements.statusCode == 200 &&
              // responseGrowthHabits.statusCode == 200 &&
              // responseClimateZones.statusCode == 200 &&
              responseSoilTypes.statusCode == 200 //&&
          // responseMatureSizes.statusCode == 200 &&
          // responseBloomColors.statusCode == 200
          ) {
        setState(() {
          // Map to List<Map<String, dynamic>> to retain both 'id' and 'name'
          _availablePlantTypes = (json.decode(responsePlantTypes.body) as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          _availableLightRequirements =
              (json.decode(responseLightRequirements.body) as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          _availableWaterRequirements =
              (json.decode(responseWaterRequirements.body) as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          // _availableGrowthHabits = (json.decode(responseGrowthHabits.body) as List)
          //     .map((item) => item as Map<String, dynamic>)
          //     .toList();
          // _availableClimateZones = (json.decode(responseClimateZones.body) as List)
          //     .map((item) => item as Map<String, dynamic>)
          //     .toList();
          _availableSoilTypes = (json.decode(responseSoilTypes.body) as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
          // _availableMatureSizes = (json.decode(responseMatureSizes.body) as List)
          //     .map((item) => item as Map<String, dynamic>)
          //     .toList();
          // _availableBloomColors = (json.decode(responseBloomColors.body) as List)
          //     .map((item) => item as Map<String, dynamic>)
          //     .toList();
        });
      } else {
        print('Failed to load reference data. Status codes: '
            'Plant Types: ${responsePlantTypes.statusCode}, '
            'Light Needs: ${responseLightRequirements.statusCode}, '
            // 'Watering Needs: ${responseWaterRequirements.statusCode}, '
            // 'Growth Habits: ${responseGrowthHabits.statusCode}, '
            // 'Climate Zones: ${responseClimateZones.statusCode}, '
            'Soil Types: ${responseSoilTypes.statusCode}, '
            // 'Mature Sizes: ${responseMatureSizes.statusCode}, '
            // 'Bloom Colors: ${responseBloomColors.statusCode}'
            );
      }
    } catch (e) {
      print('Error fetching reference data: $e');
    }
  }

  // Fetches plants from the API with current filters
  Future<void> _fetchPlants() async {
    try {
      // Construct query parameters
      final Map<String, String> queryParams = {};
      if (_searchQuery.isNotEmpty) {
        // Note: Server-side search logic would be needed for efficient text search
        // This client-side search query is commented out as it is inefficient for large datasets
        // queryParams['search_query'] = _searchQuery;
      }
      if (_selectedPlantTypes.isNotEmpty) {
        queryParams['plant_type'] = _selectedPlantTypes.join(',');
      }
      if (_selectedLightRequirements != null) {
        queryParams['light_requirements'] =
            _selectedLightRequirements.join(',');
      }
      if (_selectedWaterRequirements != null) {
        queryParams['water_requirements'] =
            _selectedWaterRequirements.join(',');
      }
      if (_selectedGrowthHabits.isNotEmpty) {
        queryParams['growth_habits'] = _selectedGrowthHabits.join(',');
      }
      if (_selectedClimateZone != null) {
        queryParams['climate_zones'] = _selectedClimateZone!;
      }
      if (_selectedSoilType != null) {
        queryParams['soil_type'] = _selectedSoilType.join(',');
      }
      if (_selectedMatureSize != null) {
        queryParams['mature_size'] = _selectedMatureSize!;
      }
      if (_selectedBloomColors.isNotEmpty) {
        queryParams['bloom_colors'] = _selectedBloomColors.join(',');
      }

      final uri = Uri.parse('$_apiBaseUrl/plants')
          .replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonPlants = json.decode(response.body);

        setState(() {
          _plants = jsonPlants
              .map((data) => Plant.fromJson(data as Map<String, dynamic>))
              .toList();
        });
      } else {
        print('Failed to load plants: ${response.statusCode} ${response.body}');
        setState(() {
          _plants = []; // Clear plants on error
        });
      }
    } catch (e) {
      print('Error fetching plants: $e');
      setState(() {
        _plants = []; // Clear plants on error
      });
    }
  }

  // Callback functions for FilterPanel
  void _onPlantTypeChanged(String plantType, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedPlantTypes.add(plantType);
      } else {
        _selectedPlantTypes.remove(plantType);
      }
    });
    _fetchPlants(); // Re-fetch plants with new filter
  }

  void _onLightRequirementsChanged(String lightNeed, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedLightRequirements.add(lightNeed);
      } else {
        _selectedLightRequirements.remove(lightNeed);
      }
    });
    _fetchPlants();
  }

  void _onWaterRequirementsChanged(String wateringNeed, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedWaterRequirements.add(wateringNeed);
      } else {
        _selectedWaterRequirements.remove(wateringNeed);
      }
    });
    _fetchPlants();
  }

  void _onGrowthHabitChanged(String growthHabit, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedGrowthHabits.add(growthHabit);
      } else {
        _selectedGrowthHabits.remove(growthHabit);
      }
    });
    _fetchPlants();
  }

  void _onClimateZoneChanged(String? climateZone) {
    setState(() {
      _selectedClimateZone = climateZone;
    });
    _fetchPlants();
  }

  void _onSoilTypeChanged(String soilType, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedSoilType.add(soilType);
      } else {
        _selectedSoilType.remove(soilType);
      }
    });
    _fetchPlants();
  }

  void _onMatureSizeChanged(String? matureSize) {
    setState(() {
      _selectedMatureSize = matureSize;
    });
    _fetchPlants();
  }

  void _onBloomColorChanged(String bloomColor, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedBloomColors.add(bloomColor);
      } else {
        _selectedBloomColors.remove(bloomColor);
      }
    });
    _fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    // The client-side filtering based on _searchQuery is still here,
    // but the main filtering logic for plant attributes is now server-side.
    // If you want text search to also be server-side, you'll need to implement
    // that in your Cloud Function and pass `_searchQuery` to the API.
    final filteredPlantsBySearch = _searchQuery == ''
        ? _plants
        : _plants
            .where((plant) => plant.commonName
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return CustomScaffold(
      breadcrumbs: const [
        {'label': 'Home', 'route': '/'},
      ],
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Panel
            FilterPanel(
              selectedPlantTypes: _selectedPlantTypes,
              selectedLightRequirements: _selectedLightRequirements,
              selectedWaterRequirements: _selectedWaterRequirements,
              // selectedGrowthHabits: _selectedGrowthHabits,
              // selectedClimateZone: _selectedClimateZone,
              selectedSoilType: _selectedSoilType,
              // selectedMatureSize: _selectedMatureSize,
              // selectedBloomColors: _selectedBloomColors,
              onPlantTypeChanged: _onPlantTypeChanged,
              onLightRequirementsChanged: _onLightRequirementsChanged,
              onWaterRequirementsChanged: _onWaterRequirementsChanged,
              // onGrowthHabitChanged: _onGrowthHabitChanged,
              // onClimateZoneChanged: _onClimateZoneChanged,
              onSoilTypeChanged: _onSoilTypeChanged,
              // onMatureSizeChanged: _onMatureSizeChanged,
              // onBloomColorChanged: _onBloomColorChanged,

              // Pass the fetched reference data to populate the filters
              // Ensure these are passed as `List<String>` or `List<dynamic>` depending on your FilterPanel implementation
              availablePlantTypes: _availablePlantTypes,
              availableLightRequirements: _availableLightRequirements,
              availableWaterRequirements: _availableWaterRequirements,
              availableGrowthHabits: _availableGrowthHabits,
              availableClimateZones: _availableClimateZones,
              availableSoilTypes: _availableSoilTypes,
              availableMatureSizes: _availableMatureSizes,
              availableBloomColors: _availableBloomColors,
            ),
            const SizedBox(width: 16), // Spacing between side panel and content
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    // Scrollable Plant List
                    ListView.builder(
                      shrinkWrap:
                          true, // Ensures the ListView takes only the necessary space
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                      itemCount: filteredPlantsBySearch.length,
                      itemBuilder: (context, index) {
                        final plant = filteredPlantsBySearch[index];
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Enlarged Image (4x bigger)
                              SizedBox(
                                height:
                                    400.0, // 4x the original height (200 * 4)
                                width: 400.0, // 4x the original width (200 * 4)
                                child: plant.imageUrl != null
                                    ? Image.network(
                                        plant.imageUrl!,
                                        width: 400,
                                        height: 400,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            size: 400,
                                          );
                                        },
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 400,
                                      ),
                              ),
                              const SizedBox(
                                  width: 16), // Spacing between image and text
                              // Plant Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      plant.commonName ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize:
                                            24, // Larger font size for the title
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Spacing between title and subtitle
                                    Text(
                                      plant.botanicalName ?? 'No description',
                                      style: const TextStyle(
                                        fontSize:
                                            18, // Larger font size for the subtitle
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16), // Optional spacing
                    // Planting Calendar
                    PlantingChart(
                      plantData: filteredPlantsBySearch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
