import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'country_model.g.dart';

@JsonSerializable()
class Country extends INetworkModel<Country> {
  int? id;
  String? code;

  Map<String, String>? nameLocaleMap;

  Country({
    this.id,
    this.code,
    this.nameLocaleMap,
  });

  @override
  Country fromJson(Map<String, dynamic> json) => Country.fromJson(json);

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  @override
  Map<String, dynamic>? toJson() => _$CountryToJson(this);

  Country copyWith({
    int? id,
    String? code,
    Map<String, String>? nameLocaleMap,
  }) {
    return Country(
      id: id ?? this.id,
      code: code ?? this.code,
      nameLocaleMap: nameLocaleMap ?? this.nameLocaleMap,
    );
  }
}
