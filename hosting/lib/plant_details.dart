import 'package:flutter/material.dart';
import 'package:plant_db/planting_chart.dart';

import 'custom_scaffold.dart';
import 'types/plant.dart';

class PlantDetailsPage extends StatelessWidget {
  final Plant plant;

  const PlantDetailsPage({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plantDetails = plant.toMap();

    return CustomScaffold(
        breadcrumbs: [
          {'label': 'Home', 'route': '/'},
          {'label': 'Plant Details', 'route': '/plantdetails'},
        ],
        body: //Padding(
            // padding: const EdgeInsets.all(16.0),
            //child:
            SingleChildScrollView(
                child: Center(
                    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            plant.imageUrl != null
                ? Image.network(
                    plant.imageUrl ?? '',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.scaleDown,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    size: 100,
                  ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant.botanicalName ?? 'No botanical name available',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(children: [PlantingChart(plantData: plant)])
                ],
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const SizedBox(height: 16),
            //         RichText(
            //           text: TextSpan(
            //             children: [
            //               const TextSpan(
            //                 text: 'Common Name: ',
            //                 style: TextStyle(
            //                     fontSize: 20,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.black),
            //               ),
            //               TextSpan(
            //                 text: plant.commonName ?? 'Unknown',
            //                 style: const TextStyle(
            //                     fontSize: 20, color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ),
            //         const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Botanical Name: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text: plant.botanicalName ?? 'No description',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Plant Type: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text: plant.plantType ?? 'No plant type available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Light Needs: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text:
            //         //             plant.lightNeeds ?? 'No light needs available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Soil Type: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text:
            //         //             plant.soilType != null && plant.soilType is List
            //         //                 ? (plant.soilType as List).join(', ')
            //         //                 : 'No soil type available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Water Requirements: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text: plant.waterRequirements ??
            //         //             'No water requirements available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Height: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text: '${plant.growth.heightCm}cm' ??
            //         //             'No height available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: TextSpan(
            //         //     children: [
            //         //       const TextSpan(
            //         //         text: 'Spread: ',
            //         //         style: TextStyle(
            //         //             fontSize: 16,
            //         //             fontWeight: FontWeight.bold,
            //         //             color: Colors.black),
            //         //       ),
            //         //       TextSpan(
            //         //         text: '${plant.growth.spreadCm}cm' ??
            //         //             'No spread available',
            //         //         style: const TextStyle(
            //         //             fontSize: 16, color: Colors.black),
            //         //       ),
            //         //     ],
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // RichText(
            //         //   text: const TextSpan(
            //         //     text: 'Propagation:',
            //         //     style: TextStyle(
            //         //         fontSize: 16,
            //         //         fontWeight: FontWeight.bold,
            //         //         color: Colors.black),
            //         //   ),
            //         // ),
            //         // const SizedBox(height: 8),
            //         // if (plant.propagation != null && plant.propagation is List)
            //         //   ...plant.propagation.map<Widget>((method) {
            //         //     return Padding(
            //         //       padding:
            //         //           const EdgeInsets.only(left: 16.0, bottom: 8.0),
            //         //       child: Column(
            //         //         crossAxisAlignment: CrossAxisAlignment.start,
            //         //         children: [
            //         //           RichText(
            //         //             text: TextSpan(
            //         //               children: [
            //         //                 TextSpan(
            //         //                   text: '- ${method.method ?? 'Unknown'}:',
            //         //                   style: const TextStyle(
            //         //                       fontSize: 14,
            //         //                       fontWeight: FontWeight.bold,
            //         //                       color: Colors.black),
            //         //                 ),
            //         //               ],
            //         //             ),
            //         //           ),
            //         //           RichText(
            //         //             text: TextSpan(
            //         //               children: [
            //         //                 TextSpan(
            //         //                   text:
            //         //                       '  ${method.description ?? 'No description available'}',
            //         //                   style: const TextStyle(
            //         //                       fontSize: 14, color: Colors.black),
            //         //                 ),
            //         //               ],
            //         //             ),
            //         //           ),
            //         //         ],
            //         //       ),
            //         //     );
            //         //   }).toList()
            //         // else
            //         //   const Text(
            //         //     'No propagation methods available.',
            //         //     style: TextStyle(fontSize: 14),
            //         //   ),
            //       ],
            //     ),
            //   ),

            //   // ),
            // )
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...plantDetails.entries.map((entry) {
                    if (entry.value is List<Propagation>) {
                      // Handle List<Propagation> directly
                      final propagationList = entry.value as List<Propagation>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: propagationList.map((propagationItem) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${propagationItem.method}: ',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: propagationItem.description ??
                                        'No description available',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      // Handle other types of data
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }
                  }).toList(),
                ],
              ),
            ),
          ],
        ))));
  }
}
