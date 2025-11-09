import 'flavor_profile.dart';

/// コーヒー豆モデル
class CoffeeBean {
  final int id;
  final String name;
  final String origin;
  final String region;
  final String roastLevel;
  final FlavorProfile flavorProfile;
  final List<String> tastingNotes;
  final String description;
  final int price;
  final String imageUrl;

  const CoffeeBean({
    required this.id,
    required this.name,
    required this.origin,
    required this.region,
    required this.roastLevel,
    required this.flavorProfile,
    required this.tastingNotes,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  /// JSONから生成
  factory CoffeeBean.fromJson(Map<String, dynamic> json) {
    return CoffeeBean(
      id: json['id'] as int,
      name: json['name'] as String,
      origin: json['origin'] as String,
      region: json['region'] as String,
      roastLevel: json['roast_level'] as String,
      flavorProfile: FlavorProfile.fromJson(
        json['flavor_profile'] as Map<String, dynamic>,
      ),
      tastingNotes: (json['tasting_notes'] as List)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      price: json['price'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'region': region,
      'roast_level': roastLevel,
      'flavor_profile': flavorProfile.toJson(),
      'tasting_notes': tastingNotes,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return 'CoffeeBean(id: $id, name: $name, origin: $origin)';
  }
}
