import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/models/coffee_bean.dart';
import 'package:bean_advisor/models/flavor_profile.dart';

void main() {
  group('CoffeeBean', () {
    final sampleJson = {
      'id': 1,
      'name': 'マンデリン・リントン',
      'origin': 'インドネシア',
      'region': 'スマトラ島リントン地区',
      'roast_level': 'フレンチロースト',
      'flavor_profile': {
        'acidity': 3.0,
        'bitterness': 4.0,
        'body': 5.0,
        'clarity': 2.0,
      },
      'tasting_notes': ['ダークチョコレート', 'ハーブ', 'グレープフルーツ'],
      'description': '濃厚なコクとシロップのようなとろみ',
      'price': 1800,
      'image_url': 'https://example.com/images/mandheling.jpg',
    };

    test('fromJson creates bean from JSON', () {
      // Act
      final bean = CoffeeBean.fromJson(sampleJson);

      // Assert
      expect(bean.id, 1);
      expect(bean.name, 'マンデリン・リントン');
      expect(bean.origin, 'インドネシア');
      expect(bean.region, 'スマトラ島リントン地区');
      expect(bean.roastLevel, 'フレンチロースト');
      expect(bean.flavorProfile.acidity, 3.0);
      expect(bean.flavorProfile.bitterness, 4.0);
      expect(bean.flavorProfile.body, 5.0);
      expect(bean.flavorProfile.clarity, 2.0);
      expect(bean.tastingNotes, ['ダークチョコレート', 'ハーブ', 'グレープフルーツ']);
      expect(bean.description, '濃厚なコクとシロップのようなとろみ');
      expect(bean.price, 1800);
      expect(bean.imageUrl, 'https://example.com/images/mandheling.jpg');
    });

    test('toJson returns correct JSON map', () {
      // Arrange
      const bean = CoffeeBean(
        id: 2,
        name: 'エチオピア・イルガチェフ',
        origin: 'エチオピア',
        region: 'イルガチェフ地区',
        roastLevel: 'ミディアムロースト',
        flavorProfile: FlavorProfile(
          acidity: 4.5,
          bitterness: 1.5,
          body: 2.5,
          clarity: 4.5,
        ),
        tastingNotes: ['ベリー', 'フローラル', 'レモン'],
        description: '華やかな香りと明るい酸味',
        price: 2000,
        imageUrl: 'https://example.com/images/yirgacheffe.jpg',
      );

      // Act
      final json = bean.toJson();

      // Assert
      expect(json['id'], 2);
      expect(json['name'], 'エチオピア・イルガチェフ');
      expect(json['origin'], 'エチオピア');
      expect(json['region'], 'イルガチェフ地区');
      expect(json['roast_level'], 'ミディアムロースト');
      expect(json['flavor_profile']['acidity'], 4.5);
      expect(json['flavor_profile']['bitterness'], 1.5);
      expect(json['tasting_notes'], ['ベリー', 'フローラル', 'レモン']);
      expect(json['description'], '華やかな香りと明るい酸味');
      expect(json['price'], 2000);
      expect(json['image_url'], 'https://example.com/images/yirgacheffe.jpg');
    });

    test('roundtrip JSON serialization preserves data', () {
      // Arrange
      final original = CoffeeBean.fromJson(sampleJson);

      // Act
      final json = original.toJson();
      final restored = CoffeeBean.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.origin, original.origin);
      expect(restored.region, original.region);
      expect(restored.roastLevel, original.roastLevel);
      expect(restored.flavorProfile, original.flavorProfile);
      expect(restored.tastingNotes, original.tastingNotes);
      expect(restored.description, original.description);
      expect(restored.price, original.price);
      expect(restored.imageUrl, original.imageUrl);
    });

    test('toString returns readable string with key info', () {
      // Arrange
      final bean = CoffeeBean.fromJson(sampleJson);

      // Act
      final str = bean.toString();

      // Assert
      expect(str, contains('CoffeeBean'));
      expect(str, contains('1'));
      expect(str, contains('マンデリン・リントン'));
      expect(str, contains('インドネシア'));
    });

    test('handles empty tasting notes list', () {
      // Arrange
      final json = Map<String, dynamic>.from(sampleJson);
      json['tasting_notes'] = [];

      // Act
      final bean = CoffeeBean.fromJson(json);

      // Assert
      expect(bean.tastingNotes, isEmpty);
    });

    test('handles multiple tasting notes', () {
      // Arrange
      final json = Map<String, dynamic>.from(sampleJson);
      json['tasting_notes'] = ['Note1', 'Note2', 'Note3', 'Note4', 'Note5'];

      // Act
      final bean = CoffeeBean.fromJson(json);

      // Assert
      expect(bean.tastingNotes.length, 5);
      expect(bean.tastingNotes, ['Note1', 'Note2', 'Note3', 'Note4', 'Note5']);
    });

    test('all fields are preserved in const constructor', () {
      // Arrange & Act
      const bean = CoffeeBean(
        id: 99,
        name: 'Test Bean',
        origin: 'Test Origin',
        region: 'Test Region',
        roastLevel: 'Test Roast',
        flavorProfile: FlavorProfile(
          acidity: 1.0,
          bitterness: 2.0,
          body: 3.0,
          clarity: 4.0,
        ),
        tastingNotes: ['Test1', 'Test2'],
        description: 'Test Description',
        price: 9999,
        imageUrl: 'https://test.com/test.jpg',
      );

      // Assert
      expect(bean.id, 99);
      expect(bean.name, 'Test Bean');
      expect(bean.origin, 'Test Origin');
      expect(bean.region, 'Test Region');
      expect(bean.roastLevel, 'Test Roast');
      expect(bean.flavorProfile.acidity, 1.0);
      expect(bean.tastingNotes, ['Test1', 'Test2']);
      expect(bean.description, 'Test Description');
      expect(bean.price, 9999);
      expect(bean.imageUrl, 'https://test.com/test.jpg');
    });
  });
}
