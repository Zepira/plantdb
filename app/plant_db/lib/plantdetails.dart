import 'package:flutter/material.dart';

import 'custom_scaffold.dart';

class PlantDetailsPage extends StatelessWidget {
  final Map<String, dynamic> plant;

  const PlantDetailsPage({Key? key, required this.plant}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      breadcrumbs: [
        {'label': 'Home', 'route': '/'},
        {'label': 'Plant Details', 'route': '/plantdetails'},
      ],
      body: //Padding(
          // padding: const EdgeInsets.all(16.0),
          //child:
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            plant['imageUrl'] != null
                ? Image.network(
                    plant['imageUrl'],
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.scaleDown,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    size: 100,
                  ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Common Name: ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['commonName'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Botanical Name: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['botanicalName'] ?? 'No description',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Description: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Plant Type: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['plantType'] ?? 'No plant type available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Light Needs: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['lightNeeds'] ?? 'No light needs available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Soil Type: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['soilType'] != null && plant['soilType'] is List
                        ? (plant['soilType'] as List).join(', ')
                        : 'No soil type available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Water Requirements: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: plant['waterRequirements'] ??
                        'No water requirements available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Height: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: '${plant['growth']["heightCm"]}cm' ??
                        'No height available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Spread: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: '${plant['growth']["spreadCm"]}cm' ??
                        'No spread available',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                text: 'Propagation:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            if (plant['propagation'] != null && plant['propagation'] is List)
              ...plant['propagation'].map<Widget>((method) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '- ${method['method'] ?? 'Unknown'}:',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '  ${method['description'] ?? 'No description available'}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              const Text(
                'No propagation methods available.',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
      // ),
    );
  }
}
