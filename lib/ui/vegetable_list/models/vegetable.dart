import 'package:dart_mappable/dart_mappable.dart';

part 'vegetable.mapper.dart';

/// Harvest state indicating the availability of a vegetable
@MappableEnum()
enum HarvestState {
  scarce,
  enough,
  plenty,
}

/// Vegetable class representing a vegetable item with name, harvest state, and timestamps
@MappableClass()
class Vegetable with VegetableMappable {
  final String name;
  final HarvestState harvestState;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  Vegetable({
    required this.name,
    this.harvestState = HarvestState.scarce,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUpdatedAt = lastUpdatedAt ?? DateTime.now();
}
