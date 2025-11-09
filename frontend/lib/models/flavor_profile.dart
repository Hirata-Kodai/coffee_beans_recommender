/// フレーバープロファイルモデル
class FlavorProfile {
  final double acidity; // 酸味 (0.0-5.0)
  final double bitterness; // 苦味 (0.0-5.0)
  final double body; // コク (0.0-5.0)
  final double clarity; // クリアー (0.0-5.0)

  const FlavorProfile({
    required this.acidity,
    required this.bitterness,
    required this.body,
    required this.clarity,
  });

  /// 初期値（各3.0）
  factory FlavorProfile.initial() {
    return const FlavorProfile(
      acidity: 3.0,
      bitterness: 3.0,
      body: 3.0,
      clarity: 3.0,
    );
  }

  /// JSONから生成
  factory FlavorProfile.fromJson(Map<String, dynamic> json) {
    return FlavorProfile(
      acidity: (json['acidity'] as num).toDouble(),
      bitterness: (json['bitterness'] as num).toDouble(),
      body: (json['body'] as num).toDouble(),
      clarity: (json['clarity'] as num).toDouble(),
    );
  }

  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'acidity': acidity,
      'bitterness': bitterness,
      'body': body,
      'clarity': clarity,
    };
  }

  /// コピーを作成（一部の値を変更）
  FlavorProfile copyWith({
    double? acidity,
    double? bitterness,
    double? body,
    double? clarity,
  }) {
    return FlavorProfile(
      acidity: acidity ?? this.acidity,
      bitterness: bitterness ?? this.bitterness,
      body: body ?? this.body,
      clarity: clarity ?? this.clarity,
    );
  }

  @override
  String toString() {
    return 'FlavorProfile(acidity: $acidity, bitterness: $bitterness, body: $body, clarity: $clarity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlavorProfile &&
        other.acidity == acidity &&
        other.bitterness == bitterness &&
        other.body == body &&
        other.clarity == clarity;
  }

  @override
  int get hashCode {
    return acidity.hashCode ^
        bitterness.hashCode ^
        body.hashCode ^
        clarity.hashCode;
  }
}
