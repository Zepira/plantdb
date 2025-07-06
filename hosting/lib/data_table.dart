import 'package:flutter/material.dart';
import 'package:plant_db/plant_details.dart';
import 'package:plant_db/types/plant.dart';

class PlantDataTableSource extends DataTableSource {
  final List<Plant> plants;
  final BuildContext context;

  PlantDataTableSource(this.plants, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= plants.length) return const DataRow(cells: []);

    final plant = plants[index];
    return DataRow(
      cells: [
        // Image Column
        DataCell(
          SizedBox(
            height: 50, // Reduced image size
            width: 50,
            child: plant.imageUrl != null
                ? Image.network(
                    plant.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  )
                : const Icon(Icons.image_not_supported),
          ),
        ),
        // Common Name Column
        DataCell(Text(
          plant.commonName ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Botanical Name Column
        DataCell(Text(
          plant.botanicalName ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Plant Type Column
        DataCell(Text(
          plant.plantType ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Light Requirements Column
        DataCell(Text(
          plant.lightRequirements?.join(', ') ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Soil Type Column
        DataCell(Text(
          plant.soilType?.join(', ') ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Water Requirements Column
        DataCell(Text(
          plant.waterRequirements?.toString() ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Climate Zones Column
        DataCell(Text(
          plant.climateZones?.join(', ') ?? 'Unknown',
          overflow: TextOverflow.ellipsis,
        )),
        // Action Column (Navigate to Details)
        DataCell(
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantDetailsPage(plant: plant),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => plants.length;

  @override
  int get selectedRowCount => 0;
}

class PlantTable extends StatelessWidget {
  final List<Plant> plants;
  final bool isFilterPanelOpen; // Pass whether the filter panel is open

  const PlantTable({
    Key? key,
    required this.plants,
    required this.isFilterPanelOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlantDataTableSource dataSource =
        PlantDataTableSource(plants, context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = isFilterPanelOpen
            ? constraints.maxWidth
            : constraints
                .maxWidth; // Use full width when filter panel is closed

        return SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // Allow horizontal scrolling if needed
          child: SizedBox(
            width: availableWidth, // Set the table width dynamically
            child: PaginatedDataTable(
              columns: const [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Common Name')),
                DataColumn(label: Text('Botanical Name')),
                DataColumn(label: Text('Plant Type')),
                DataColumn(label: Text('Light Requirements')),
                DataColumn(label: Text('Soil Type')),
                DataColumn(label: Text('Water Requirements')),
                DataColumn(label: Text('Climate Zones')),
                DataColumn(label: Text('Actions')),
              ],
              source: dataSource,
              showEmptyRows: false,
              //rowsPerPage: 5, // Number of rows per page
              showCheckboxColumn: false, // Disable row selection checkboxes
            ),
          ),
        );
      },
    );
  }
}
