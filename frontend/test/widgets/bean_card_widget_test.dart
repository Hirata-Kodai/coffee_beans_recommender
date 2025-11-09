import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/widgets/bean_card_widget.dart';
import 'package:bean_advisor/models/recommendation.dart';
import '../test_helpers.dart';

void main() {
  group('BeanCardWidget', () {
    testWidgets('displays bean information correctly', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        rank: 1,
        beanId: 1,
        reason: 'This is a great bean for you',
        highlights: ['Rich flavor', 'Smooth finish'],
        bean: createTestCoffeeBean(
          name: 'Test Coffee Bean',
          origin: 'Ethiopia',
          region: 'Yirgacheffe',
          roastLevel: 'Medium',
          price: 2000,
          tastingNotes: ['Berry', 'Floral', 'Citrus'],
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Coffee Bean'), findsOneWidget);
      expect(find.text('Ethiopia (Yirgacheffe)'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('¥2000'), findsOneWidget);
    });

    testWidgets('displays rank badge for first place', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        rank: 1,
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('1位'), findsOneWidget);
    });

    testWidgets('displays rank badge for second place', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        rank: 2,
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('2位'), findsOneWidget);
    });

    testWidgets('displays rank badge for third place', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        rank: 3,
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('3位'), findsOneWidget);
    });

    testWidgets('displays tasting notes as chips', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: createTestCoffeeBean(
          tastingNotes: ['Chocolate', 'Nuts', 'Caramel'],
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('Chocolate'), findsOneWidget);
      expect(find.text('Nuts'), findsOneWidget);
      expect(find.text('Caramel'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(3));
    });

    testWidgets('displays recommendation reason', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        reason: 'Perfect match for your taste preferences',
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('推薦理由'), findsOneWidget);
      expect(find.text('Perfect match for your taste preferences'), findsOneWidget);
    });

    testWidgets('displays highlights with check icons', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        highlights: ['Strong body', 'Low acidity', 'Smooth finish'],
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('Strong body'), findsOneWidget);
      expect(find.text('Low acidity'), findsOneWidget);
      expect(find.text('Smooth finish'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    });

    testWidgets('shows message when bean is null', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: null, // No bean data
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.text('豆の情報がありません'), findsOneWidget);
    });

    testWidgets('displays coffee icon in image placeholder', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.coffee), findsOneWidget);
    });

    testWidgets('card has proper elevation', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('displays location and roast icons', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.place), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('handles empty tasting notes', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        bean: createTestCoffeeBean(
          tastingNotes: [],
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('handles empty highlights', (WidgetTester tester) async {
      // Arrange
      final recommendation = createTestBeanRecommendation(
        highlights: [],
        bean: createTestCoffeeBean(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BeanCardWidget(recommendation: recommendation),
          ),
        ),
      );

      // Assert
      // Should still show the recommendation reason section
      expect(find.text('推薦理由'), findsOneWidget);
    });
  });
}
