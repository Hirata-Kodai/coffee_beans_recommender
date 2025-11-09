import 'package:bean_advisor/models/coffee_bean.dart';
import 'package:bean_advisor/models/flavor_profile.dart';
import 'package:bean_advisor/models/recommendation.dart';

/// テスト用のヘルパー関数とモックデータ

// テスト用のFlavorProfile
FlavorProfile createTestFlavorProfile({
  double acidity = 3.0,
  double bitterness = 3.0,
  double body = 3.0,
  double clarity = 3.0,
}) {
  return FlavorProfile(
    acidity: acidity,
    bitterness: bitterness,
    body: body,
    clarity: clarity,
  );
}

// テスト用のCoffeeBean
CoffeeBean createTestCoffeeBean({
  int id = 1,
  String name = 'Test Bean',
  String origin = 'Test Origin',
  String region = 'Test Region',
  String roastLevel = 'Test Roast',
  FlavorProfile? flavorProfile,
  List<String>? tastingNotes,
  String description = 'Test Description',
  int price = 1000,
  String imageUrl = 'https://test.com/test.jpg',
}) {
  return CoffeeBean(
    id: id,
    name: name,
    origin: origin,
    region: region,
    roastLevel: roastLevel,
    flavorProfile: flavorProfile ?? createTestFlavorProfile(),
    tastingNotes: tastingNotes ?? ['Note1', 'Note2'],
    description: description,
    price: price,
    imageUrl: imageUrl,
  );
}

// テスト用のBeanRecommendation
BeanRecommendation createTestBeanRecommendation({
  int rank = 1,
  int beanId = 1,
  String reason = 'Test reason',
  List<String>? highlights,
  CoffeeBean? bean,
}) {
  return BeanRecommendation(
    rank: rank,
    beanId: beanId,
    reason: reason,
    highlights: highlights ?? ['Highlight 1', 'Highlight 2'],
    bean: bean,
  );
}

// テスト用のRecommendationResult
RecommendationResult createTestRecommendationResult({
  String introduction = 'Test introduction',
  List<BeanRecommendation>? recommendations,
  String topPickExplanation = 'Test top pick explanation',
}) {
  return RecommendationResult(
    introduction: introduction,
    recommendations: recommendations ??
        [
          createTestBeanRecommendation(
            rank: 1,
            beanId: 1,
            bean: createTestCoffeeBean(id: 1, name: 'Bean 1'),
          ),
          createTestBeanRecommendation(
            rank: 2,
            beanId: 2,
            bean: createTestCoffeeBean(id: 2, name: 'Bean 2'),
          ),
          createTestBeanRecommendation(
            rank: 3,
            beanId: 3,
            bean: createTestCoffeeBean(id: 3, name: 'Bean 3'),
          ),
        ],
    topPickExplanation: topPickExplanation,
  );
}

// サンプルのコーヒー豆リスト
List<CoffeeBean> createSampleCoffeeBeans() {
  return [
    createTestCoffeeBean(
      id: 1,
      name: 'マンデリン・リントン',
      origin: 'インドネシア',
      region: 'スマトラ島リントン地区',
      roastLevel: 'フレンチロースト',
      flavorProfile: const FlavorProfile(
        acidity: 3.0,
        bitterness: 4.0,
        body: 5.0,
        clarity: 2.0,
      ),
      tastingNotes: ['ダークチョコレート', 'ハーブ', 'グレープフルーツ'],
      description: '濃厚なコクとシロップのようなとろみ',
      price: 1800,
    ),
    createTestCoffeeBean(
      id: 2,
      name: 'エチオピア・イルガチェフ',
      origin: 'エチオピア',
      region: 'イルガチェフ地区',
      roastLevel: 'ミディアムロースト',
      flavorProfile: const FlavorProfile(
        acidity: 4.5,
        bitterness: 1.5,
        body: 2.5,
        clarity: 4.5,
      ),
      tastingNotes: ['ベリー', 'フローラル', 'レモン'],
      description: '華やかな香りと明るい酸味',
      price: 2000,
    ),
    createTestCoffeeBean(
      id: 3,
      name: 'ブラジル・サントスNo.2',
      origin: 'ブラジル',
      region: 'ミナスジェライス州',
      roastLevel: 'ハイロースト',
      flavorProfile: const FlavorProfile(
        acidity: 2.5,
        bitterness: 3.0,
        body: 4.0,
        clarity: 2.5,
      ),
      tastingNotes: ['ナッツ', 'キャラメル', 'カカオ'],
      description: 'マイルドで柔らかい口当たり',
      price: 1200,
    ),
  ];
}
