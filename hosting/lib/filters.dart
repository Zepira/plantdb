import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final Set<String> selectedPlantTypes;
  final Set<String> selectedLightRequirements;
  final Set<String> selectedWaterRequirements;
  // final Set<String> selectedGrowthHabits;
  // final String? selectedClimateZone;
  final Set<String> selectedSoilType;
  // final String? selectedMatureSize;
  // final Set<String> selectedBloomColors;

  final Function(String, bool) onPlantTypeChanged;
  final Function(String, bool) onLightRequirementsChanged;
  final Function(String, bool) onWaterRequirementsChanged;
  // final Function(String, bool) onGrowthHabitChanged;
  // final Function(String?) onClimateZoneChanged;
  final Function(String, bool) onSoilTypeChanged;
  // final Function(String?) onMatureSizeChanged;
  // final Function(String, bool) onBloomColorChanged;

  // New: Parameters to receive the available reference data lists
  final List<Map<String, dynamic>> availablePlantTypes;
  final List<Map<String, dynamic>> availableLightRequirements;
  final List<Map<String, dynamic>> availableWaterRequirements;
  final List<Map<String, dynamic>> availableGrowthHabits;
  final List<Map<String, dynamic>> availableClimateZones;
  final List<Map<String, dynamic>> availableSoilTypes;
  final List<Map<String, dynamic>> availableMatureSizes;
  final List<Map<String, dynamic>> availableBloomColors;

  const FilterPanel({
    Key? key,
    required this.selectedPlantTypes,
    required this.selectedLightRequirements,
    required this.selectedWaterRequirements,
    // required this.selectedGrowthHabits,
    // required this.selectedClimateZone,
    required this.selectedSoilType,
    // required this.selectedMatureSize,
    // required this.selectedBloomColors,
    required this.onPlantTypeChanged,
    required this.onLightRequirementsChanged,
    required this.onWaterRequirementsChanged,
    // required this.onGrowthHabitChanged,
    // required this.onClimateZoneChanged,
    required this.onSoilTypeChanged,
    // required this.onMatureSizeChanged,
    // required this.onBloomColorChanged,
    // Initialize new parameters
    required this.availablePlantTypes,
    required this.availableLightRequirements,
    required this.availableWaterRequirements,
    required this.availableGrowthHabits,
    required this.availableClimateZones,
    required this.availableSoilTypes,
    required this.availableMatureSizes,
    required this.availableBloomColors,
  }) : super(key: key);

  // Helper method to create filter section headers
  Widget _buildFilterHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width for the side panel
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color for the side panel
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        // Makes the panel scrollable if content overflows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(
                height: 24, thickness: 1), // A separator for aesthetics

            // Filter: Plant Type
            _buildFilterHeader('Plant Type'),
            // Use availablePlantTypes to dynamically generate checkboxes
            ...availablePlantTypes.map((type) {
              return CheckboxListTile(
                title: Text(type['name'] as String), // Display 'name'
                value: selectedPlantTypes
                    .contains(type['name'] as String), // Check against 'id'
                onChanged: (bool? value) => onPlantTypeChanged(
                    type['name'] as String, value ?? false), // Pass 'id' back
                dense: true,
              );
            }).toList(),

            // Filter: Light Needs
            _buildFilterHeader('Light Requirements'),
            ...availableLightRequirements.map((type) {
              return CheckboxListTile(
                title: Text(type['name'] as String), // Display 'name'
                value: selectedLightRequirements
                    .contains(type['name'] as String), // Check against 'id'
                onChanged: (bool? value) => onLightRequirementsChanged(
                    type['name'] as String, value ?? false), // Pass 'id' back
                dense: true,
              );
            }).toList(),

            // Filter: Watering Needs
            _buildFilterHeader('Watering Requirements'),
            ...availableWaterRequirements.map((type) {
              return CheckboxListTile(
                title: Text(type['name'] as String), // Display 'name'
                value: selectedWaterRequirements
                    .contains(type['name'] as String), // Check against 'id'
                onChanged: (bool? value) => onWaterRequirementsChanged(
                    type['name'] as String, value ?? false), // Pass 'id' back
                dense: true,
              );
            }).toList(),

            // // Filter: Growth Habit
            // _buildFilterHeader('Growth Habit'),
            // // Use availableGrowthHabits to dynamically generate checkboxes
            // ...availableGrowthHabits.map((habit) {
            //   return CheckboxListTile(
            //     title: Text(habit['name'] as String),
            //     value: selectedGrowthHabits.contains(habit['id'] as String),
            //     onChanged: (bool? value) =>
            //         onGrowthHabitChanged(habit['id'] as String, value ?? false),
            //     dense: true,
            //   );
            // }).toList(),

            // // Filter: Climate Zone (USDA Hardiness Zones)
            // _buildFilterHeader('Climate Zone'),
            // DropdownButtonFormField<String>(
            //   value: selectedClimateZone,
            //   hint: const Text('Select Climate Zone'),
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //   ),
            //   // Use availableClimateZones to dynamically generate dropdown items
            //   items: availableClimateZones.map((zone) {
            //     return DropdownMenuItem<String>(
            //       value: zone['id'] as String,
            //       child: Text(zone['name'] as String),
            //     );
            //   }).toList(),
            //   onChanged: onClimateZoneChanged,
            // ),

            // Filter: Soil Type
            _buildFilterHeader('Soil Type'),
            ...availableSoilTypes.map((type) {
              return CheckboxListTile(
                title: Text(type['name'] as String), // Display 'name'
                value: selectedSoilType
                    .contains(type['name'] as String), // Check against 'id'
                onChanged: (bool? value) => onSoilTypeChanged(
                    type['name'] as String, value ?? false), // Pass 'id' back
                dense: true,
              );
            }).toList(),

            // // Filter: Mature Size
            // _buildFilterHeader('Mature Size'),
            // DropdownButtonFormField<String>(
            //   value: selectedMatureSize,
            //   hint: const Text('Select Mature Size'),
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //   ),
            //   // Use availableMatureSizes to dynamically generate dropdown items
            //   items: availableMatureSizes.map((size) {
            //     return DropdownMenuItem<String>(
            //       value: size['id'] as String,
            //       child: Text(size['name'] as String),
            //     );
            //   }).toList(),
            //   onChanged: onMatureSizeChanged,
            // ),

            // // Filter: Bloom Color
            // _buildFilterHeader('Bloom Color'),
            // // Use availableBloomColors to dynamically generate checkboxes
            // ...availableBloomColors.map((color) {
            //   return CheckboxListTile(
            //     title: Text(color['name'] as String),
            //     value: selectedBloomColors.contains(color['id'] as String),
            //     onChanged: (bool? value) =>
            //         onBloomColorChanged(color['id'] as String, value ?? false),
            //     dense: true,
            //   );
            // }).toList(),
          ],
        ),
      ),
    );
  }
}
