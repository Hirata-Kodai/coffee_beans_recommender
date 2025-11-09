import 'package:flutter/material.dart';
import '../models/flavor_profile.dart';
import '../models/recommendation.dart';
import '../services/api_service.dart';
import 'bean_card_widget.dart';

/// チャットウィジェット
///
/// 推薦結果を表示
class ChatWidget extends StatefulWidget {
  final FlavorProfile flavorProfile;
  final VoidCallback onReset;

  const ChatWidget({
    super.key,
    required this.flavorProfile,
    required this.onReset,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ApiService _apiService = ApiService();
  RecommendationResult? _result;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await for (final event
          in _apiService.getRecommendations(widget.flavorProfile)) {
        if (event['type'] == 'complete') {
          final data = event['data'] as Map<String, dynamic>;
          setState(() {
            _result = RecommendationResult.fromJson(data);
            _isLoading = false;
          });
        } else if (event['type'] == 'error') {
          setState(() {
            _error = event['data'] as String;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = 'エラーが発生しました: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ヘッダー
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF6F4E37),
          child: Row(
            children: [
              const Icon(Icons.coffee, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Bean Advisor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: widget.onReset,
                tooltip: 'もう一度選ぶ',
              ),
            ],
          ),
        ),

        // コンテンツ
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6F4E37)),
            ),
            SizedBox(height: 16),
            Text(
              'あなたにぴったりのコーヒーを探しています...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchRecommendations,
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    if (_result == null) {
      return const Center(
        child: Text('推薦結果がありません'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 導入文
          Card(
            elevation: 2,
            color: const Color(0xFFF5DEB3).withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: Color(0xFF6F4E37),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _result!.introduction,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // タイトル
          const Text(
            'おすすめのコーヒー豆',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6F4E37),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 推薦豆カード（トップ3）
          ..._result!.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BeanCardWidget(recommendation: rec),
              )),

          // トップピックの特別説明
          if (_result!.topPickExplanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              color: const Color(0xFFFFD700).withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'イチオシポイント',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F4E37),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _result!.topPickExplanation,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
