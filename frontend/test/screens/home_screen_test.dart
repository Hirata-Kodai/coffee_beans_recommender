import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bean_advisor/screens/home_screen.dart';
import 'package:bean_advisor/widgets/flavor_chart_widget.dart';
import 'package:bean_advisor/widgets/chat_widget.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('initially displays FlavorChartWidget', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(FlavorChartWidget), findsOneWidget);
      expect(find.byType(ChatWidget), findsNothing);
    });

    testWidgets('displays AppBar with title when in selection mode',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Bean Advisor'), findsOneWidget);
      expect(find.byIcon(Icons.coffee), findsOneWidget);
    });

    testWidgets('AppBar has correct background color', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF6F4E37));
    });

    testWidgets('displays welcome message', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.text('あなたにぴったりのコーヒー豆を見つけましょう'), findsOneWidget);
      expect(find.text('スライダーで好みの味わいを調整してください'), findsOneWidget);
    });

    testWidgets('transitions to ChatWidget when search is performed',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Act - tap the search button
      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ChatWidget), findsOneWidget);
      expect(find.byType(FlavorChartWidget), findsNothing);
    });

    testWidgets('ChatWidget does not have AppBar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Act - transition to ChatWidget
      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pumpAndSettle();

      // Assert - ChatWidget has its own header, so no AppBar should be present
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('returns to FlavorChartWidget when reset is called',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Transition to ChatWidget
      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pumpAndSettle();

      // Verify we're in chat mode
      expect(find.byType(ChatWidget), findsOneWidget);

      // Act - tap the reset button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Assert - should be back to flavor selection
      expect(find.byType(FlavorChartWidget), findsOneWidget);
      expect(find.byType(ChatWidget), findsNothing);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('maintains state transition correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Act & Assert - initial state
      expect(find.byType(FlavorChartWidget), findsOneWidget);
      expect(find.byType(ChatWidget), findsNothing);

      // Transition to chat
      await tester.tap(find.text('この味でコーヒーを探す'));
      await tester.pumpAndSettle();

      expect(find.byType(FlavorChartWidget), findsNothing);
      expect(find.byType(ChatWidget), findsOneWidget);

      // Transition back to flavor selection
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.byType(FlavorChartWidget), findsOneWidget);
      expect(find.byType(ChatWidget), findsNothing);
    });

    testWidgets('FlavorChartWidget is centered on screen', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
      final center = find.ancestor(
        of: find.byType(FlavorChartWidget),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });

    testWidgets('has max width constraint for FlavorChartWidget',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(FlavorChartWidget),
          matching: find.byType(Container),
        ).first,
      );
      final constraints = container.constraints as BoxConstraints;
      expect(constraints.maxWidth, 800);
    });

    testWidgets('is scrollable when content is long', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('scaffold is properly structured', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
