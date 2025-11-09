import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/models/flavor_profile.dart';

void main() {
  group('FlavorProfile', () {
    test('initial() creates profile with default values', () {
      // Arrange & Act
      final profile = FlavorProfile.initial();

      // Assert
      expect(profile.acidity, 3.0);
      expect(profile.bitterness, 3.0);
      expect(profile.body, 3.0);
      expect(profile.clarity, 3.0);
    });

    test('constructor creates profile with given values', () {
      // Arrange & Act
      const profile = FlavorProfile(
        acidity: 4.5,
        bitterness: 2.0,
        body: 5.0,
        clarity: 3.5,
      );

      // Assert
      expect(profile.acidity, 4.5);
      expect(profile.bitterness, 2.0);
      expect(profile.body, 5.0);
      expect(profile.clarity, 3.5);
    });

    test('fromJson creates profile from JSON', () {
      // Arrange
      final json = {
        'acidity': 4.0,
        'bitterness': 3.0,
        'body': 2.5,
        'clarity': 4.5,
      };

      // Act
      final profile = FlavorProfile.fromJson(json);

      // Assert
      expect(profile.acidity, 4.0);
      expect(profile.bitterness, 3.0);
      expect(profile.body, 2.5);
      expect(profile.clarity, 4.5);
    });

    test('fromJson handles integer values', () {
      // Arrange
      final json = {
        'acidity': 4,
        'bitterness': 3,
        'body': 2,
        'clarity': 5,
      };

      // Act
      final profile = FlavorProfile.fromJson(json);

      // Assert
      expect(profile.acidity, 4.0);
      expect(profile.bitterness, 3.0);
      expect(profile.body, 2.0);
      expect(profile.clarity, 5.0);
    });

    test('toJson returns correct JSON map', () {
      // Arrange
      const profile = FlavorProfile(
        acidity: 4.5,
        bitterness: 2.0,
        body: 5.0,
        clarity: 3.5,
      );

      // Act
      final json = profile.toJson();

      // Assert
      expect(json['acidity'], 4.5);
      expect(json['bitterness'], 2.0);
      expect(json['body'], 5.0);
      expect(json['clarity'], 3.5);
    });

    test('copyWith creates new instance with updated values', () {
      // Arrange
      const original = FlavorProfile(
        acidity: 3.0,
        bitterness: 3.0,
        body: 3.0,
        clarity: 3.0,
      );

      // Act
      final updated = original.copyWith(
        acidity: 4.5,
        body: 5.0,
      );

      // Assert
      expect(updated.acidity, 4.5);
      expect(updated.bitterness, 3.0); // unchanged
      expect(updated.body, 5.0);
      expect(updated.clarity, 3.0); // unchanged
    });

    test('copyWith with no parameters returns identical values', () {
      // Arrange
      const original = FlavorProfile(
        acidity: 4.0,
        bitterness: 2.0,
        body: 5.0,
        clarity: 3.0,
      );

      // Act
      final copy = original.copyWith();

      // Assert
      expect(copy.acidity, original.acidity);
      expect(copy.bitterness, original.bitterness);
      expect(copy.body, original.body);
      expect(copy.clarity, original.clarity);
    });

    test('equality operator works correctly', () {
      // Arrange
      const profile1 = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 5.0,
        clarity: 2.0,
      );

      const profile2 = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 5.0,
        clarity: 2.0,
      );

      const profile3 = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 4.5, // different
        clarity: 2.0,
      );

      // Assert
      expect(profile1 == profile2, true);
      expect(profile1 == profile3, false);
    });

    test('hashCode is consistent', () {
      // Arrange
      const profile1 = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 5.0,
        clarity: 2.0,
      );

      const profile2 = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 5.0,
        clarity: 2.0,
      );

      // Assert
      expect(profile1.hashCode, profile2.hashCode);
    });

    test('toString returns readable string', () {
      // Arrange
      const profile = FlavorProfile(
        acidity: 4.0,
        bitterness: 3.0,
        body: 5.0,
        clarity: 2.0,
      );

      // Act
      final str = profile.toString();

      // Assert
      expect(str, contains('FlavorProfile'));
      expect(str, contains('4.0'));
      expect(str, contains('3.0'));
      expect(str, contains('5.0'));
      expect(str, contains('2.0'));
    });

    test('roundtrip JSON serialization preserves data', () {
      // Arrange
      const original = FlavorProfile(
        acidity: 4.5,
        bitterness: 2.0,
        body: 5.0,
        clarity: 3.5,
      );

      // Act
      final json = original.toJson();
      final restored = FlavorProfile.fromJson(json);

      // Assert
      expect(restored, original);
    });
  });
}
