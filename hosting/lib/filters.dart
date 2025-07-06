import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  final Set<String> selectedPlantTypes;
  final Set<String> selectedLightRequirements;
  final Set<String> selectedWaterRequirements;
  final Set<String> selectedSoilType;

  final Function(String, bool) onPlantTypeChanged;
  final Function(String, bool) onLightRequirementsChanged;
  final Function(String, bool) onWaterRequirementsChanged;
  final Function(String, bool) onSoilTypeChanged;

  final List<Map<String, dynamic>> availablePlantTypes;
  final List<Map<String, dynamic>> availableLightRequirements;
  final List<Map<String, dynamic>> availableWaterRequirements;
  final List<Map<String, dynamic>> availableSoilTypes;

  const FilterPanel({
    Key? key,
    required this.selectedPlantTypes,
    required this.selectedLightRequirements,
    required this.selectedWaterRequirements,
    required this.selectedSoilType,
    required this.onPlantTypeChanged,
    required this.onLightRequirementsChanged,
    required this.onWaterRequirementsChanged,
    required this.onSoilTypeChanged,
    required this.availablePlantTypes,
    required this.availableLightRequirements,
    required this.availableWaterRequirements,
    required this.availableSoilTypes,
  }) : super(key: key);

  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  // State to track expanded/collapsed status for each filter type
  final Map<String, bool> _isExpanded = {
    'Plant Type': false,
    'Light Requirements': false,
    'Watering Requirements': false,
    'Soil Type': false,
  };

  // Helper method to build collapsible filter sections
  Widget _buildCollapsibleFilter({
    required String title,
    required List<Map<String, dynamic>> options,
    required Set<String> selectedValues,
    required Function(String, bool) onChanged,
  }) {
    final selectedCount = selectedValues.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded[title] = !_isExpanded[title]!;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title ${selectedCount > 0 ? '($selectedCount)' : ""}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _isExpanded[title]! ? Icons.expand_less : Icons.expand_more,
              ),
            ],
          ),
        ),
        if (_isExpanded[title]!)
          Column(
            children: options.map((option) {
              return CheckboxListTile(
                title: Text(option['name'] as String),
                value: selectedValues.contains(option['name'] as String),
                onChanged: (bool? value) {
                  onChanged(option['name'] as String, value ?? false);
                },
                dense: true,
              );
            }).toList(),
          ),
        const Divider(height: 16, thickness: 1), // Divider for aesthetics
      ],
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
            offset: const Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
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

            // Collapsible Filter: Plant Type
            _buildCollapsibleFilter(
              title: 'Plant Type',
              options: widget.availablePlantTypes,
              selectedValues: widget.selectedPlantTypes,
              onChanged: widget.onPlantTypeChanged,
            ),

            // Collapsible Filter: Light Requirements
            _buildCollapsibleFilter(
              title: 'Light Requirements',
              options: widget.availableLightRequirements,
              selectedValues: widget.selectedLightRequirements,
              onChanged: widget.onLightRequirementsChanged,
            ),

            // Collapsible Filter: Watering Requirements
            _buildCollapsibleFilter(
              title: 'Watering Requirements',
              options: widget.availableWaterRequirements,
              selectedValues: widget.selectedWaterRequirements,
              onChanged: widget.onWaterRequirementsChanged,
            ),

            // Collapsible Filter: Soil Type
            _buildCollapsibleFilter(
              title: 'Soil Type',
              options: widget.availableSoilTypes,
              selectedValues: widget.selectedSoilType,
              onChanged: widget.onSoilTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
