import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // No longer directly querying plants from Firestore
import 'package:http/http.dart' as http; // Import http package
import 'package:plant_db/api_service.dart';
import 'package:plant_db/data_table.dart';
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
  bool _showFilters = false; // State to track filter menu visibility
  bool _isLoading = false; // State to track if plants are being fetched
  bool _isReferenceDataLoading =
      false; // State to track if reference data is being fetched
  String? _errorMessage; // State to store error messages

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
  List<Map<String, dynamic>> _availableSoilTypes = [];

  // Base URL for your Cloud Functions API
  // IMPORTANT: Replace with your actual deployed Cloud Function URL
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchReferenceData(); // Fetch reference data first to populate filters
    _fetchPlants(); // Then fetch initial plants
  }

  // Fetches dynamic filter options from the API
  Future<void> _fetchReferenceData() async {
    setState(() {
      _isReferenceDataLoading = true;
      _errorMessage = null; // Clear previous errors
    });
    try {
      final List<List<Map<String, dynamic>>> results = await Future.wait([
        _apiService.fetchPlantTypes(),
        _apiService.fetchLightRequirements(),
        _apiService.fetchWaterRequirements(),
        //_apiService.fetchGrowthHabits(),
        //_apiService.fetchClimateZones(),
        _apiService.fetchSoilTypes(),
        //_apiService.fetchMatureSizes(),
        //_apiService.fetchBloomColors(),
      ]);

      setState(() {
        _availablePlantTypes = results[0];
        _availableLightRequirements = results[1];
        _availableWaterRequirements = results[2];
        // _availableGrowthHabits = results[3];
        // _availableClimateZones = results[4];
        _availableSoilTypes = results[3];
        // _availableMatureSizes = results[6];
        // _availableBloomColors = results[7];
      });
      _fetchPlants(); // Fetch plants only after reference data is loaded
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching reference data: $e';
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isReferenceDataLoading = false;
      });
    }
  }

  // Fetches plants from the API with current filters
  Future<void> _fetchPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });
    try {
      final List<Plant> fetchedPlants = await _apiService.fetchPlants(
        searchQuery: _searchQuery,
        plantTypes: _selectedPlantTypes,
        lightRequirements: _selectedLightRequirements,
        waterRequirements: _selectedWaterRequirements,
        growthHabits: _selectedGrowthHabits,
        climateZone: _selectedClimateZone,
        soilType: _selectedSoilType,
        matureSize: _selectedMatureSize,
        bloomColors: _selectedBloomColors,
      );

      setState(() {
        _plants = fetchedPlants;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching plants: $e';
        _plants = []; // Clear plants on error
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
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
    final filteredPlantsBySearch = _searchQuery == ''
        ? _plants
        : _plants
            .where((plant) => plant.commonName
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    // Get screen width to adjust layout for mobile
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Define a breakpoint for mobile

    return CustomScaffold(
      breadcrumbs: const [
        {'label': 'Home', 'route': '/'},
      ],
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show/Hide Filters Button
            if (_showFilters)
              FilterPanel(
                selectedPlantTypes: _selectedPlantTypes,
                selectedLightRequirements: _selectedLightRequirements,
                selectedWaterRequirements: _selectedWaterRequirements,
                selectedSoilType: _selectedSoilType,
                onPlantTypeChanged: _onPlantTypeChanged,
                onLightRequirementsChanged: _onLightRequirementsChanged,
                onWaterRequirementsChanged: _onWaterRequirementsChanged,
                onSoilTypeChanged: _onSoilTypeChanged,
                availablePlantTypes: _availablePlantTypes,
                availableLightRequirements: _availableLightRequirements,
                availableWaterRequirements: _availableWaterRequirements,
                availableSoilTypes: _availableSoilTypes,
              ),
            if (_showFilters && !isMobile)
              const SizedBox(width: 16), // Spacing between filter and content
            // Main Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show/Hide Filters Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFilters =
                              !_showFilters; // Toggle filter visibility
                        });
                      },
                      child:
                          Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
                    ),
                  ),
                  // Search Bar
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
                  // Scrollable Content (Plant List + Planting Calendar)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plant List
                          PlantTable(
                            plants: filteredPlantsBySearch,
                            isFilterPanelOpen: _showFilters,
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
          ],
        ),
      ),
    );
  }
}
