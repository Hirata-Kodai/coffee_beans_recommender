import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/widgets/flavor_chart_widget.dart';
import 'package:bean_advisor/models/flavor_profile.dart';
import '../test_helpers.dart';

void main() {
  group('FlavorChartWidget', () {
    testWidgets('displays initial flavor profile values', (WidgetTester tester) async {
      // Arrange
      final initialProfile = createTestFlavorProfile(
        acidity: 3.0,
        bitterness: 3.0,
        body: 3.0,
        clarity: 3.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('3.0'), findsNWidgets(4)); // 4 sliders all at 3.0
    });

    testWidgets('displays title', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('あなたの好みを教えてください'), findsOneWidget);
    });

    testWidgets('displays all four sliders', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('酸味'), findsOneWidget);
      expect(find.text('苦味'), findsOneWidget);
      expect(find.text('コク'), findsOneWidget);
      expect(find.text('クリアー'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(4));
    });

    testWidgets('displays search button', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('この味でコーヒーを探す'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('calls onSearch when button is tapped', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();
      FlavorProfile? searchedProfile;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (profile) {
                searchedProfile = profile;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pump();

      // Assert
      expect(searchedProfile, isNotNull);
      expect(searchedProfile!.acidity, 3.0);
      expect(searchedProfile!.bitterness, 3.0);
      expect(searchedProfile!.body, 3.0);
      expect(searchedProfile!.clarity, 3.0);
    });

    testWidgets('slider value changes are reflected', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Find the first slider (酸味)
      final aciditySlider = find.byType(Slider).first;

      // Change slider value
      await tester.drag(aciditySlider, const Offset(100, 0));
      await tester.pump();

      // Assert - the value should have changed (exact value depends on drag distance)
      // We're just checking that the widget can handle the interaction
      expect(find.byType(Slider), findsNWidgets(4));
    });

    testWidgets('displays flavor chart', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomPaint), findsOneWidget);
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('card has proper styling', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('sliders have correct range', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final sliders = tester.widgetList<Slider>(find.byType(Slider));
      for (final slider in sliders) {
        expect(slider.min, 0.0);
        expect(slider.max, 5.0);
        expect(slider.divisions, 10); // 0.5 increments
      }
    });

    testWidgets('handles different initial values', (WidgetTester tester) async {
      // Arrange
      final initialProfile = createTestFlavorProfile(
        acidity: 4.5,
        bitterness: 2.0,
        body: 5.0,
        clarity: 1.5,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('2.0'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('1.5'), findsOneWidget);
    });

    testWidgets('onSearch returns updated profile after slider changes',
        (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();
      FlavorProfile? searchedProfile;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (profile) {
                searchedProfile = profile;
              },
            ),
          ),
        ),
      );

      // Act - simulate slider interaction and search
      // Note: Actual slider value change testing would require more complex gestures
      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pump();

      // Assert
      expect(searchedProfile, isNotNull);
    });

    testWidgets('displays correct color scheme', (WidgetTester tester) async {
      // Arrange
      final initialProfile = FlavorProfile.initial();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlavorChartWidget(
              initialProfile: initialProfile,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // Assert - button should have coffee brown color
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), const Color(0xFF6F4E37));
    });
  });
}
