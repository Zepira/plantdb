class Plant {
  final String? commonName;
  final String? imageUrl;
  final String? botanicalName;
  final String? plantType;
  final List<String>? lightRequirements;
  final List<String>? soilType;
  final List<String>? waterRequirements;
  final List<int>? climateZones;
  final Growth? growth;
  final Map<String, SeasonalTimeline>? seasonalTimelineByZone;
  final List<Propagation>? propagation;
  final YieldPerPlant? yieldPerPlant;
  final List<PurchaseLink>? purchaseLinks;
  final List<Resource>? resources;

  Plant({
    this.commonName,
    this.imageUrl,
    this.botanicalName,
    this.plantType,
    this.lightRequirements,
    this.soilType,
    this.waterRequirements,
    this.climateZones,
    this.growth,
    this.seasonalTimelineByZone,
    this.propagation,
    this.yieldPerPlant,
    this.purchaseLinks,
    this.resources,
  });

  // Factory constructor to parse JSON
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      commonName: json['commonName'],
      imageUrl: json['imageUrl'],
      botanicalName: json['botanicalName'],
      plantType: json['plantType'],
      lightRequirements: json['lightRequirements'] is String
          ? [
              json['lightRequirements'] as String
            ] // Wrap single String in a List
          : (json['lightRequirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      soilType: json['soilType'] != null
          ? (json['soilType'] is String
              ? [json['soilType'] as String] // Wrap single String in a List
              : (json['soilType'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList())
          : null, // Handle missing or null soilType
      waterRequirements: json['waterRequirements'] is String
          ? [
              json['waterRequirements'] as String
            ] // Wrap single String in a List
          : (json['waterRequirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      climateZones: json['climateZones'] != null
          ? (json['climateZones'] is int
              ? [json['climateZones'] as int] // Wrap single int in a List
              : (json['climateZones'] as List<dynamic>)
                  .map((e) => e as int)
                  .toList())
          : null, // Handle missing or null climateZones
      growth: json['growth'] != null ? Growth.fromJson(json['growth']) : null,
      seasonalTimelineByZone:
          (json['seasonalTimelineByZone'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, SeasonalTimeline.fromJson(value))),
      propagation: (json['propagation'] as List<dynamic>?)
          ?.map((item) => Propagation.fromJson(item))
          .toList(),
      yieldPerPlant: json['yieldPerPlant'] != null
          ? YieldPerPlant.fromJson(json['yieldPerPlant'])
          : null,
      purchaseLinks: (json['purchaseLinks'] as List<dynamic>?)
          ?.map((item) => PurchaseLink.fromJson(item))
          .toList(),
      resources: (json['resources'] as List<dynamic>?)
          ?.map((item) => Resource.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Growth Type': plantType,
      'Light Requirements': lightRequirements,
      'Water Requirements': waterRequirements,
      'Height': '${growth?.heightCm} cm',
      'Spread': '${growth?.spreadCm} cm',
      'Soil Type': soilType?.join(', '),
      'Propagation': propagation,
    };
  }
}

class Growth {
  final int heightCm;
  final int spreadCm;
  final bool cutAndComeAgain;
  final String harvestType;
  final SelfReproducing selfReproducing;

  Growth({
    required this.heightCm,
    required this.spreadCm,
    required this.cutAndComeAgain,
    required this.harvestType,
    required this.selfReproducing,
  });

  factory Growth.fromJson(Map<String, dynamic> json) {
    return Growth(
      heightCm: json['heightCm'],
      spreadCm: json['spreadCm'],
      cutAndComeAgain: json['cutAndComeAgain'],
      harvestType: json['harvestType'],
      selfReproducing: SelfReproducing.fromJson(json['selfReproducing']),
    );
  }
}

class SelfReproducing {
  final bool selfSeeding;
  final bool runners;
  final bool splitCorms;
  final String notes;

  SelfReproducing({
    required this.selfSeeding,
    required this.runners,
    required this.splitCorms,
    required this.notes,
  });

  factory SelfReproducing.fromJson(Map<String, dynamic> json) {
    return SelfReproducing(
      selfSeeding: json['selfSeeding'],
      runners: json['runners'],
      splitCorms: json['splitCorms'],
      notes: json['notes'],
    );
  }
}

class SeasonalTimeline {
  final List<String> sow;
  final List<String> transplant;
  final List<String> takeCuttings;
  final List<String> flower;
  final List<String> harvest;

  SeasonalTimeline({
    required this.sow,
    required this.transplant,
    required this.takeCuttings,
    required this.flower,
    required this.harvest,
  });

  factory SeasonalTimeline.fromJson(Map<String, dynamic> json) {
    return SeasonalTimeline(
      sow: List<String>.from(json['sow']),
      transplant: List<String>.from(json['transplant']),
      takeCuttings: List<String>.from(json['takeCuttings']),
      flower: List<String>.from(json['flower']),
      harvest: List<String>.from(json['harvest']),
    );
  }

  @override
  String toString() {
    return '''
SeasonalTimeline(
  sow: $sow,
  transplant: $transplant,
  takeCuttings: $takeCuttings,
  flower: $flower,
  harvest: $harvest
)''';
  }
}

class Propagation {
  final String method;
  final String description;

  Propagation({
    required this.method,
    required this.description,
  });

  factory Propagation.fromJson(Map<String, dynamic> json) {
    return Propagation(
      method: json['method'],
      description: json['description'],
    );
  }
}

class YieldPerPlant {
  final double estimatedWeightKg;
  final String harvestFrequency;

  YieldPerPlant({
    required this.estimatedWeightKg,
    required this.harvestFrequency,
  });

  factory YieldPerPlant.fromJson(Map<String, dynamic> json) {
    return YieldPerPlant(
      estimatedWeightKg: json['estimatedWeightKg'].toDouble(),
      harvestFrequency: json['harvestFrequency'],
    );
  }
}

class PurchaseLink {
  final String variety;
  final String type;
  final String supplier;
  final String url;

  PurchaseLink({
    required this.variety,
    required this.type,
    required this.supplier,
    required this.url,
  });

  factory PurchaseLink.fromJson(Map<String, dynamic> json) {
    return PurchaseLink(
      variety: json['variety'],
      type: json['type'],
      supplier: json['supplier'],
      url: json['url'],
    );
  }
}

class Resource {
  final String title;
  final String type;
  final String source;
  final String url;

  Resource({
    required this.title,
    required this.type,
    required this.source,
    required this.url,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'],
      type: json['type'],
      source: json['source'],
      url: json['url'],
    );
  }
}
