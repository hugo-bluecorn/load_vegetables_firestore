// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vegetable.dart';

class HarvestStateMapper extends EnumMapper<HarvestState> {
  HarvestStateMapper._();

  static HarvestStateMapper? _instance;
  static HarvestStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HarvestStateMapper._());
    }
    return _instance!;
  }

  static HarvestState fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  HarvestState decode(dynamic value) {
    switch (value) {
      case r'scarce':
        return HarvestState.scarce;
      case r'enough':
        return HarvestState.enough;
      case r'plenty':
        return HarvestState.plenty;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(HarvestState self) {
    switch (self) {
      case HarvestState.scarce:
        return r'scarce';
      case HarvestState.enough:
        return r'enough';
      case HarvestState.plenty:
        return r'plenty';
    }
  }
}

extension HarvestStateMapperExtension on HarvestState {
  String toValue() {
    HarvestStateMapper.ensureInitialized();
    return MapperContainer.globals.toValue<HarvestState>(this) as String;
  }
}

class VegetableMapper extends ClassMapperBase<Vegetable> {
  VegetableMapper._();

  static VegetableMapper? _instance;
  static VegetableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VegetableMapper._());
      HarvestStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Vegetable';

  static String _$name(Vegetable v) => v.name;
  static const Field<Vegetable, String> _f$name = Field('name', _$name);
  static HarvestState _$harvestState(Vegetable v) => v.harvestState;
  static const Field<Vegetable, HarvestState> _f$harvestState = Field(
    'harvestState',
    _$harvestState,
    opt: true,
    def: HarvestState.scarce,
  );
  static DateTime _$createdAt(Vegetable v) => v.createdAt;
  static const Field<Vegetable, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );
  static DateTime _$lastUpdatedAt(Vegetable v) => v.lastUpdatedAt;
  static const Field<Vegetable, DateTime> _f$lastUpdatedAt = Field(
    'lastUpdatedAt',
    _$lastUpdatedAt,
    opt: true,
  );

  @override
  final MappableFields<Vegetable> fields = const {
    #name: _f$name,
    #harvestState: _f$harvestState,
    #createdAt: _f$createdAt,
    #lastUpdatedAt: _f$lastUpdatedAt,
  };

  static Vegetable _instantiate(DecodingData data) {
    return Vegetable(
      name: data.dec(_f$name),
      harvestState: data.dec(_f$harvestState),
      createdAt: data.dec(_f$createdAt),
      lastUpdatedAt: data.dec(_f$lastUpdatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Vegetable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Vegetable>(map);
  }

  static Vegetable fromJson(String json) {
    return ensureInitialized().decodeJson<Vegetable>(json);
  }
}

mixin VegetableMappable {
  String toJson() {
    return VegetableMapper.ensureInitialized().encodeJson<Vegetable>(
      this as Vegetable,
    );
  }

  Map<String, dynamic> toMap() {
    return VegetableMapper.ensureInitialized().encodeMap<Vegetable>(
      this as Vegetable,
    );
  }

  VegetableCopyWith<Vegetable, Vegetable, Vegetable> get copyWith =>
      _VegetableCopyWithImpl<Vegetable, Vegetable>(
        this as Vegetable,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VegetableMapper.ensureInitialized().stringifyValue(
      this as Vegetable,
    );
  }

  @override
  bool operator ==(Object other) {
    return VegetableMapper.ensureInitialized().equalsValue(
      this as Vegetable,
      other,
    );
  }

  @override
  int get hashCode {
    return VegetableMapper.ensureInitialized().hashValue(this as Vegetable);
  }
}

extension VegetableValueCopy<$R, $Out> on ObjectCopyWith<$R, Vegetable, $Out> {
  VegetableCopyWith<$R, Vegetable, $Out> get $asVegetable =>
      $base.as((v, t, t2) => _VegetableCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VegetableCopyWith<$R, $In extends Vegetable, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    HarvestState? harvestState,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  });
  VegetableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VegetableCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Vegetable, $Out>
    implements VegetableCopyWith<$R, Vegetable, $Out> {
  _VegetableCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Vegetable> $mapper =
      VegetableMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    HarvestState? harvestState,
    Object? createdAt = $none,
    Object? lastUpdatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (harvestState != null) #harvestState: harvestState,
      if (createdAt != $none) #createdAt: createdAt,
      if (lastUpdatedAt != $none) #lastUpdatedAt: lastUpdatedAt,
    }),
  );
  @override
  Vegetable $make(CopyWithData data) => Vegetable(
    name: data.get(#name, or: $value.name),
    harvestState: data.get(#harvestState, or: $value.harvestState),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    lastUpdatedAt: data.get(#lastUpdatedAt, or: $value.lastUpdatedAt),
  );

  @override
  VegetableCopyWith<$R2, Vegetable, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VegetableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

