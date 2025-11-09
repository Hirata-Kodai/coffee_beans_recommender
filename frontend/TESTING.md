# Bean Advisor - テスト仕様書

## テスト概要

このドキュメントでは、Bean Advisorフロントエンドの単体テストについて説明します。

## テストの種類

### 1. モデルテスト (`test/models/`)
データモデルのシリアライゼーション、デシリアライゼーション、データ変換をテストします。

#### FlavorProfile Tests (`flavor_profile_test.dart`)
- 初期値の生成
- JSON変換（toJson / fromJson）
- copyWith メソッド
- 等価性とハッシュコード
- ラウンドトリップ変換

#### CoffeeBean Tests (`coffee_bean_test.dart`)
- JSON からのデータ読み込み
- JSON へのデータ出力
- 複数のテイスティングノートの処理
- 空のリストの処理

#### Recommendation Tests (`recommendation_test.dart`)
- BeanRecommendation のシリアライゼーション
- RecommendationResult の完全なデータ構造テスト
- 豆データの有無による処理の違い

### 2. サービステスト (`test/services/`)

#### ApiService Tests (`api_service_test.dart`)
- ベースURLの設定
- SSEレスポンスのパース
- エラーハンドリング
- リクエストボディの形式

**注意**: 完全なHTTPモックテストを実装するには、ApiServiceクラスにHTTPクライアントの依存性注入を追加する必要があります。

### 3. ウィジェットテスト (`test/widgets/`)

#### BeanCardWidget Tests (`bean_card_widget_test.dart`)
- 豆情報の表示
- ランクバッジの表示（1位: 金、2位: 銀、3位: 銅）
- テイスティングノートのチップ表示
- 推薦理由とハイライトの表示
- null データのハンドリング

#### FlavorChartWidget Tests (`flavor_chart_widget_test.dart`)
- 初期値の表示
- 4つのスライダーの表示
- 検索ボタンの動作
- コールバックの呼び出し
- スライダーの範囲設定（0.0 - 5.0、0.5刻み）

#### ChatWidget Tests (`chat_widget_test.dart`)
- ローディングインジケーターの表示
- ヘッダーとリセットボタン
- リセット機能の動作
- スタイリングとレイアウト

### 4. 画面テスト (`test/screens/`)

#### HomeScreen Tests (`home_screen_test.dart`)
- 初期状態でのFlavorChartWidget表示
- AppBarの表示と設定
- ChatWidgetへの遷移
- リセット機能による元の画面への戻り
- 状態管理のテスト

### 5. テストヘルパー (`test/test_helpers.dart`)
再利用可能なテストデータとヘルパー関数を提供:
- `createTestFlavorProfile()` - テスト用フレーバープロファイル
- `createTestCoffeeBean()` - テスト用コーヒー豆
- `createTestBeanRecommendation()` - テスト用推薦
- `createTestRecommendationResult()` - テスト用推薦結果
- `createSampleCoffeeBeans()` - サンプル豆リスト

## テストの実行方法

### すべてのテストを実行

```bash
cd frontend
flutter test
```

### 特定のテストファイルを実行

```bash
# モデルテストのみ
flutter test test/models/

# ウィジェットテストのみ
flutter test test/widgets/

# 特定のファイル
flutter test test/models/flavor_profile_test.dart
```

### カバレッジ付きでテストを実行

```bash
flutter test --coverage
```

カバレッジレポートを生成:

```bash
# lcovがインストールされている場合
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### テストを監視モードで実行

ファイルの変更を監視して自動的にテストを再実行:

```bash
flutter test --watch
```

## モックの生成

ApiServiceテストで使用するモックを生成:

```bash
cd frontend
flutter pub run build_runner build
```

既存のモックを削除して再生成:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## テストのベストプラクティス

### 1. Arrange-Act-Assert パターン
すべてのテストでAAA パターンを使用しています:

```dart
test('description', () {
  // Arrange - テストデータの準備
  final data = createTestData();

  // Act - テスト対象の実行
  final result = performAction(data);

  // Assert - 結果の検証
  expect(result, expectedValue);
});
```

### 2. 明確なテスト名
テスト名は以下の形式を推奨:
- `'メソッド名 returns 期待値 when 条件'`
- `'displays ウィジェット名 correctly'`
- `'handles エラーケース gracefully'`

### 3. テストの独立性
各テストは他のテストに依存せず、独立して実行可能であるべきです。

### 4. エッジケースのテスト
- 空のリスト
- null 値
- 境界値（0.0, 5.0）
- 異常な入力

## 今後の改善案

### 1. HTTPモックの完全な実装
現在のApiServiceテストは概念的なものです。完全なモックテストを実装するには:

```dart
class ApiService {
  final http.Client client;

  ApiService({http.Client? client})
    : client = client ?? http.Client();

  // メソッド内でthis.clientを使用
}
```

### 2. 統合テスト
`integration_test`ディレクトリでエンドツーエンドのテストを追加:

```bash
mkdir integration_test
```

### 3. ゴールデンテスト
UIの視覚的な回帰テストを追加:

```dart
testWidgets('golden test', (tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('golden/my_widget.png'),
  );
});
```

### 4. パフォーマンステスト
大量データでのパフォーマンスをテスト

### 5. アクセシビリティテスト
Semanticsツリーのテスト

## テストカバレッジ目標

- **モデル**: 100%
- **サービス**: 80%以上
- **ウィジェット**: 70%以上
- **全体**: 75%以上

## 継続的インテグレーション

GitHub Actionsでテストを自動実行する設定例:

```yaml
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

## トラブルシューティング

### モックが生成されない
```bash
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### テストが失敗する
```bash
# キャッシュをクリア
flutter clean
flutter pub get
flutter test
```

### ウィジェットテストでのタイムアウト
```dart
testWidgets('description', (tester) async {
  // ...
}, timeout: const Timeout(Duration(seconds: 10)));
```

## 参考資料

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Golden Testing](https://github.com/flutter/flutter/wiki/Writing-a-golden-file-test-for-package:flutter)
