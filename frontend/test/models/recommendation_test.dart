import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/models/recommendation.dart';
import 'package:bean_advisor/models/coffee_bean.dart';
import 'package:bean_advisor/models/flavor_profile.dart';

void main() {
  group('BeanRecommendation', () {
    final sampleBeanJson = {
      'id': 1,
      'name': 'Test Bean',
      'origin': 'Test Origin',
      'region': 'Test Region',
      'roast_level': 'Test Roast',
      'flavor_profile': {
        'acidity': 3.0,
        'bitterness': 4.0,
        'body': 5.0,
        'clarity': 2.0,
      },
      'tasting_notes': ['Note1', 'Note2'],
      'description': 'Test Description',
      'price': 1000,
      'image_url': 'https://test.com/test.jpg',
    };

    final sampleRecommendationJson = {
      'rank': 1,
      'bean_id': 1,
      'reason': 'This is a test reason',
      'highlights': ['Highlight 1', 'Highlight 2', 'Highlight 3'],
    };

    test('fromJson creates recommendation without bean', () {
      // Act
      final recommendation = BeanRecommendation.fromJson(sampleRecommendationJson);

      // Assert
      expect(recommendation.rank, 1);
      expect(recommendation.beanId, 1);
      expect(recommendation.reason, 'This is a test reason');
      expect(recommendation.highlights, ['Highlight 1', 'Highlight 2', 'Highlight 3']);
      expect(recommendation.bean, isNull);
    });

    test('fromJson creates recommendation with bean', () {
      // Arrange
      final json = Map<String, dynamic>.from(sampleRecommendationJson);
      json['bean'] = sampleBeanJson;

      // Act
      final recommendation = BeanRecommendation.fromJson(json);

      // Assert
      expect(recommendation.rank, 1);
      expect(recommendation.beanId, 1);
      expect(recommendation.reason, 'This is a test reason');
      expect(recommendation.highlights.length, 3);
      expect(recommendation.bean, isNotNull);
      expect(recommendation.bean!.id, 1);
      expect(recommendation.bean!.name, 'Test Bean');
    });

    test('toJson without bean excludes bean field', () {
      // Arrange
      const recommendation = BeanRecommendation(
        rank: 2,
        beanId: 5,
        reason: 'Test reason',
        highlights: ['H1', 'H2'],
      );

      // Act
      final json = recommendation.toJson();

      // Assert
      expect(json['rank'], 2);
      expect(json['bean_id'], 5);
      expect(json['reason'], 'Test reason');
      expect(json['highlights'], ['H1', 'H2']);
      expect(json.containsKey('bean'), false);
    });

    test('toJson with bean includes bean data', () {
      // Arrange
      const recommendation = BeanRecommendation(
        rank: 1,
        beanId: 1,
        reason: 'Test reason',
        highlights: ['H1'],
        bean: CoffeeBean(
          id: 1,
          name: 'Test Bean',
          origin: 'Origin',
          region: 'Region',
          roastLevel: 'Roast',
          flavorProfile: FlavorProfile(
            acidity: 3.0,
            bitterness: 4.0,
            body: 5.0,
            clarity: 2.0,
          ),
          tastingNotes: ['Note'],
          description: 'Desc',
          price: 1000,
          imageUrl: 'url',
        ),
      );

      // Act
      final json = recommendation.toJson();

      // Assert
      expect(json.containsKey('bean'), true);
      expect(json['bean']['id'], 1);
      expect(json['bean']['name'], 'Test Bean');
    });

    test('handles empty highlights list', () {
      // Arrange
      final json = Map<String, dynamic>.from(sampleRecommendationJson);
      json['highlights'] = [];

      // Act
      final recommendation = BeanRecommendation.fromJson(json);

      // Assert
      expect(recommendation.highlights, isEmpty);
    });

    test('handles multiple highlights', () {
      // Arrange
      final json = Map<String, dynamic>.from(sampleRecommendationJson);
      json['highlights'] = ['H1', 'H2', 'H3', 'H4', 'H5'];

      // Act
      final recommendation = BeanRecommendation.fromJson(json);

      // Assert
      expect(recommendation.highlights.length, 5);
    });

    test('roundtrip JSON serialization without bean', () {
      // Arrange
      final original = BeanRecommendation.fromJson(sampleRecommendationJson);

      // Act
      final json = original.toJson();
      final restored = BeanRecommendation.fromJson(json);

      // Assert
      expect(restored.rank, original.rank);
      expect(restored.beanId, original.beanId);
      expect(restored.reason, original.reason);
      expect(restored.highlights, original.highlights);
      expect(restored.bean, original.bean);
    });
  });

  group('RecommendationResult', () {
    final sampleBeanJson = {
      'id': 1,
      'name': 'Test Bean 1',
      'origin': 'Origin 1',
      'region': 'Region 1',
      'roast_level': 'Roast 1',
      'flavor_profile': {
        'acidity': 3.0,
        'bitterness': 4.0,
        'body': 5.0,
        'clarity': 2.0,
      },
      'tasting_notes': ['Note1'],
      'description': 'Description 1',
      'price': 1000,
      'image_url': 'url1',
    };

    final sampleResultJson = {
      'introduction': 'This is an introduction',
      'recommendations': [
        {
          'rank': 1,
          'bean_id': 1,
          'reason': 'Reason 1',
          'highlights': ['H1', 'H2'],
          'bean': sampleBeanJson,
        },
        {
          'rank': 2,
          'bean_id': 2,
          'reason': 'Reason 2',
          'highlights': ['H3', 'H4'],
        },
        {
          'rank': 3,
          'bean_id': 3,
          'reason': 'Reason 3',
          'highlights': ['H5', 'H6'],
        },
      ],
      'top_pick_explanation': 'This is the top pick explanation',
    };

    test('fromJson creates result with all fields', () {
      // Act
      final result = RecommendationResult.fromJson(sampleResultJson);

      // Assert
      expect(result.introduction, 'This is an introduction');
      expect(result.recommendations.length, 3);
      expect(result.recommendations[0].rank, 1);
      expect(result.recommendations[1].rank, 2);
      expect(result.recommendations[2].rank, 3);
      expect(result.topPickExplanation, 'This is the top pick explanation');
    });

    test('toJson returns complete JSON map', () {
      // Arrange
      const result = RecommendationResult(
        introduction: 'Intro text',
        recommendations: [
          BeanRecommendation(
            rank: 1,
            beanId: 10,
            reason: 'R1',
            highlights: ['HL1'],
          ),
        ],
        topPickExplanation: 'Top explanation',
      );

      // Act
      final json = result.toJson();

      // Assert
      expect(json['introduction'], 'Intro text');
      expect(json['recommendations'].length, 1);
      expect(json['recommendations'][0]['rank'], 1);
      expect(json['recommendations'][0]['bean_id'], 10);
      expect(json['top_pick_explanation'], 'Top explanation');
    });

    test('handles multiple recommendations', () {
      // Act
      final result = RecommendationResult.fromJson(sampleResultJson);

      // Assert
      expect(result.recommendations.length, 3);
      expect(result.recommendations[0].beanId, 1);
      expect(result.recommendations[1].beanId, 2);
      expect(result.recommendations[2].beanId, 3);
      expect(result.recommendations[0].bean, isNotNull);
      expect(result.recommendations[1].bean, isNull);
      expect(result.recommendations[2].bean, isNull);
    });

    test('handles empty recommendations list', () {
      // Arrange
      final json = {
        'introduction': 'Intro',
        'recommendations': [],
        'top_pick_explanation': 'Explanation',
      };

      // Act
      final result = RecommendationResult.fromJson(json);

      // Assert
      expect(result.recommendations, isEmpty);
    });

    test('roundtrip JSON serialization preserves data', () {
      // Arrange
      final original = RecommendationResult.fromJson(sampleResultJson);

      // Act
      final json = original.toJson();
      final restored = RecommendationResult.fromJson(json);

      // Assert
      expect(restored.introduction, original.introduction);
      expect(restored.recommendations.length, original.recommendations.length);
      expect(restored.topPickExplanation, original.topPickExplanation);
      expect(restored.recommendations[0].rank, original.recommendations[0].rank);
      expect(restored.recommendations[0].beanId, original.recommendations[0].beanId);
    });

    test('const constructor works correctly', () {
      // Arrange & Act
      const result = RecommendationResult(
        introduction: 'Test intro',
        recommendations: [
          BeanRecommendation(
            rank: 1,
            beanId: 1,
            reason: 'Test reason',
            highlights: ['H1', 'H2'],
          ),
        ],
        topPickExplanation: 'Test explanation',
      );

      // Assert
      expect(result.introduction, 'Test intro');
      expect(result.recommendations.length, 1);
      expect(result.topPickExplanation, 'Test explanation');
    });
  });
}
