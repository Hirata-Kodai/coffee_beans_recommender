import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/widgets/chat_widget.dart';
import 'package:bean_advisor/models/flavor_profile.dart';
import '../test_helpers.dart';

void main() {
  group('ChatWidget', () {
    testWidgets('displays loading indicator initially', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('あなたにぴったりのコーヒーを探しています...'), findsOneWidget);
    });

    testWidgets('displays header with title and reset button', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Bean Advisor'), findsOneWidget);
      expect(find.byIcon(Icons.coffee), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('calls onReset when reset button is tapped', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();
      bool resetCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {
                resetCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      // Assert
      expect(resetCalled, true);
    });

    testWidgets('header has correct background color', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Bean Advisor'),
          matching: find.byType(Container),
        ).first,
      );
      expect((container.decoration as BoxDecoration).color, const Color(0xFF6F4E37));
    });

    testWidgets('reset button has tooltip', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Find the IconButton
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.refresh),
          matching: find.byType(IconButton),
        ),
      );

      // Assert
      expect(iconButton.tooltip, 'もう一度選ぶ');
    });

    testWidgets('uses correct flavor profile', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = createTestFlavorProfile(
        acidity: 4.5,
        bitterness: 2.0,
        body: 5.0,
        clarity: 3.5,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert - widget should be created without errors
      expect(find.byType(ChatWidget), findsOneWidget);
    });

    testWidgets('loading indicator has correct color', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final animation = progressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(animation.value, const Color(0xFF6F4E37));
    });

    testWidgets('renders within column layout', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('can be rebuilt with different flavor profiles', (WidgetTester tester) async {
      // Arrange
      final profile1 = createTestFlavorProfile(acidity: 3.0);
      final profile2 = createTestFlavorProfile(acidity: 4.5);

      // Act - first build
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: profile1,
              onReset: () {},
            ),
          ),
        ),
      );

      // Rebuild with different profile
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: profile2,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert - widget should rebuild successfully
      expect(find.byType(ChatWidget), findsOneWidget);
    });

    testWidgets('header row layout is correct', (WidgetTester tester) async {
      // Arrange
      final flavorProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              flavorProfile: flavorProfile,
              onReset: () {},
            ),
          ),
        ),
      );

      // Assert - header should contain icon, text, spacer, and button in a row
      final headerRow = find.ancestor(
        of: find.text('Bean Advisor'),
        matching: find.byType(Row),
      );
      expect(headerRow, findsOneWidget);
    });
  });
}
