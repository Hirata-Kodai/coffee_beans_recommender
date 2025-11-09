import 'package:flutter/material.dart';
import '../models/recommendation.dart';

/// コーヒー豆カードウィジェット
///
/// 個別の豆情報を表示
class BeanCardWidget extends StatelessWidget {
  final BeanRecommendation recommendation;

  const BeanCardWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final bean = recommendation.bean;

    if (bean == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('豆の情報がありません'),
        ),
      );
    }

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ランクバッジと画像
          Stack(
            children: [
              // 画像（プレースホルダー）
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6F4E37).withOpacity(0.3),
                      const Color(0xFF8B4513).withOpacity(0.3),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.coffee,
                  size: 80,
                  color: Colors.white,
                ),
              ),

              // ランクバッジ
              Positioned(
                top: 16,
                left: 16,
                child: _buildRankBadge(recommendation.rank),
              ),
            ],
          ),

          // 豆の情報
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名前
                Text(
                  bean.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6F4E37),
                  ),
                ),
                const SizedBox(height: 8),

                // 産地・地区
                Row(
                  children: [
                    const Icon(Icons.place, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${bean.origin} (${bean.region})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 焙煎度
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      bean.roastLevel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 価格
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '¥${bean.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6F4E37),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // テイスティングノート
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bean.tastingNotes
                      .map((note) => Chip(
                            label: Text(
                              note,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: const Color(0xFFF5DEB3),
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // 推薦理由
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '推薦理由',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recommendation.reason,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ハイライト
                ...recommendation.highlights.map((highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFF6F4E37),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              highlight,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color color;
    IconData icon;

    switch (rank) {
      case 1:
        color = const Color(0xFFFFD700); // 金
        icon = Icons.emoji_events;
        break;
      case 2:
        color = const Color(0xFFC0C0C0); // 銀
        icon = Icons.emoji_events;
        break;
      case 3:
        color = const Color(0xFFCD7F32); // 銅
        icon = Icons.emoji_events;
        break;
      default:
        color = Colors.grey;
        icon = Icons.star;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            '$rank位',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
