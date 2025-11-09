import 'coffee_bean.dart';

/// 豆の推薦情報
class BeanRecommendation {
  final int rank; // 推薦順位 (1-3)
  final int beanId; // コーヒー豆ID
  final String reason; // 推薦理由
  final List<String> highlights; // ハイライト（2-3個）
  final CoffeeBean? bean; // 豆の詳細情報（オプション）

  const BeanRecommendation({
    required this.rank,
    required this.beanId,
    required this.reason,
    required this.highlights,
    this.bean,
  });

  /// JSONから生成
  factory BeanRecommendation.fromJson(Map<String, dynamic> json) {
    return BeanRecommendation(
      rank: json['rank'] as int,
      beanId: json['bean_id'] as int,
      reason: json['reason'] as String,
      highlights: (json['highlights'] as List)
          .map((e) => e as String)
          .toList(),
      bean: json['bean'] != null
          ? CoffeeBean.fromJson(json['bean'] as Map<String, dynamic>)
          : null,
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'bean_id': beanId,
      'reason': reason,
      'highlights': highlights,
      if (bean != null) 'bean': bean!.toJson(),
    };
  }
}

/// 推薦結果
class RecommendationResult {
  final String introduction; // 推薦の導入文
  final List<BeanRecommendation> recommendations; // トップ3の推薦豆
  final String topPickExplanation; // 1位の豆の特別な説明

  const RecommendationResult({
    required this.introduction,
    required this.recommendations,
    required this.topPickExplanation,
  });

  /// JSONから生成
  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      introduction: json['introduction'] as String,
      recommendations: (json['recommendations'] as List)
          .map((e) => BeanRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      topPickExplanation: json['top_pick_explanation'] as String,
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'introduction': introduction,
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
      'top_pick_explanation': topPickExplanation,
    };
  }
}
