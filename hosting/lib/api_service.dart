import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import './types/plant.dart'; // Adjust path if necessary

class ApiService {
  // IMPORTANT: Replace with your actual deployed Cloud Function URL
  static const String _apiBaseUrl = 'https://api-bzyhmja4mq-uc.a.run.app';

  // Generic method to fetch reference data
  Future<List<Map<String, dynamic>>> fetchReferenceData(String endpoint) async {
    final uri = Uri.parse('$_apiBaseUrl/$endpoint');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception(
          'Failed to load $endpoint: ${response.statusCode} ${response.body}');
    }
  }

  // Fetch all available plant types
  Future<List<Map<String, dynamic>>> fetchPlantTypes() {
    return fetchReferenceData('plant-types');
  }

  // Fetch all available light needs
  Future<List<Map<String, dynamic>>> fetchLightRequirements() {
    return fetchReferenceData('light-requirements');
  }

  // Fetch all available watering needs
  Future<List<Map<String, dynamic>>> fetchWaterRequirements() {
    return fetchReferenceData('water-requirements');
  }

  // Fetch all available growth habits
  Future<List<Map<String, dynamic>>> fetchGrowthHabits() {
    return fetchReferenceData('growth-habits');
  }

  // Fetch all available climate zones
  Future<List<Map<String, dynamic>>> fetchClimateZones() {
    return fetchReferenceData('climate-zones');
  }

  // Fetch all available soil types
  Future<List<Map<String, dynamic>>> fetchSoilTypes() {
    return fetchReferenceData('soil-types');
  }

  // Fetch all available mature sizes
  Future<List<Map<String, dynamic>>> fetchMatureSizes() {
    return fetchReferenceData('mature-sizes');
  }

  // Fetch all available bloom colors
  Future<List<Map<String, dynamic>>> fetchBloomColors() {
    return fetchReferenceData('bloom-colors');
  }

  // Fetch plants with optional filters
  Future<List<Plant>> fetchPlants({
    String? searchQuery,
    Set<String>? plantTypes,
    Set<String>? lightRequirements,
    Set<String>? waterRequirements,
    Set<String>? growthHabits,
    String? climateZone,
    Set<String>? soilType,
    String? matureSize,
    Set<String>? bloomColors,
  }) async {
    final Map<String, String> queryParams = {};

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // If server-side search is implemented, uncomment this
      // queryParams['search_query'] = searchQuery;
    }
    if (plantTypes != null && plantTypes.isNotEmpty) {
      queryParams['plant_type'] = plantTypes.join(',');
    }
    if (lightRequirements != null) {
      queryParams['light_requirements'] = lightRequirements.join(',');
    }
    if (waterRequirements != null) {
      queryParams['water_requirements'] = waterRequirements.join(',');
    }
    if (growthHabits != null && growthHabits.isNotEmpty) {
      queryParams['growth_habits'] = growthHabits.join(',');
    }
    if (climateZone != null) {
      queryParams['climate_zones'] = climateZone;
    }
    if (soilType != null) {
      queryParams['soil_type'] = soilType.join(',');
    }
    if (matureSize != null) {
      queryParams['mature_size'] = matureSize;
    }
    if (bloomColors != null && bloomColors.isNotEmpty) {
      queryParams['bloom_colors'] = bloomColors.join(',');
    }

    final uri =
        Uri.parse('$_apiBaseUrl/plants').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonPlants = json.decode(response.body);
      return jsonPlants
          .map((data) => Plant.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Failed to load plants: ${response.statusCode} ${response.body}');
    }
  }
}
