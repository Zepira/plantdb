import 'package:flutter/material.dart';

import 'types/plant.dart';

/// Flutter code sample for [Table].

class PlantingChartComponent extends StatelessWidget {
  final dynamic plantData;
  const PlantingChartComponent({super.key, required this.plantData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Table Sample')),
          body: PlantingChart(
            plantData: plantData,
          )),
    );
  }
}

class PlantingChart extends StatelessWidget {
  final dynamic plantData; // Accept both List<Plant> and List<SeasonalTimeline>

  PlantingChart({super.key, required this.plantData});

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    final double columnWidth = 200.0;

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(150), // First column width
        1: FixedColumnWidth(100), // Fixed width for all other columns
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Build the header row
        _buildHeaderRow(),
        // Build all other rows
        ..._buildDataRows(plantData),
      ],
    );
  }

  // Method to build the header row
  TableRow _buildHeaderRow() {
    return TableRow(children: [
      Container(
        height: 32.0,
        color: Colors.green,
        child: const Center(
          child: Text(
            'Plant Name',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      ...months.map((month) {
        return Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(
              month,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    ]);
  }

  // Method to build all other rows
  List<TableRow> _buildDataRows(dynamic data) {
    if (data is List<Plant>) {
      return data.map((plant) {
        return TableRow(
          children: [
            // First column: Plant name
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                plant.commonName ?? 'Unknown Plant',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Remaining columns: Example data for months
            ...months.map((month) {
              final isActive =
                  plant.seasonalTimelineByZone?['3']?.sow.contains(month) ??
                      false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        );
      }).toList();
    } else if (data is Plant) {
      final timeline = data.seasonalTimelineByZone?['3'];

      var rows = <TableRow>[];

      debugPrint('Data is a list of SeasonalTimeline: ${timeline}');
      rows.add(
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Sow',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((month) {
              final isActive = timeline?.sow.contains(month) ?? false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        ),
      );

      rows.add(
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Transplant',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((month) {
              final isActive = timeline?.transplant.contains(month) ?? false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        ),
      );

      rows.add(
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Take Cuttings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((month) {
              final isActive = timeline?.takeCuttings.contains(month) ?? false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        ),
      );

      rows.add(
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Flower',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((month) {
              final isActive = timeline?.flower.contains(month) ?? false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        ),
      );

      rows.add(
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Harvest',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((month) {
              final isActive = timeline?.harvest.contains(month) ?? false;
              return Container(
                height: 32,
                color: isActive ? Colors.green : Colors.transparent,
              );
            }).toList(),
          ],
        ),
      );

      return rows;
    } else {
      return [
        TableRow(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'No data available',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...months.map((_) {
              return Container(
                height: 32,
                color: Colors.transparent,
              );
            }).toList(),
          ],
        ),
      ];
    }
  }
}
