import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/flavor_profile.dart';
import '../models/recommendation.dart';

/// バックエンドAPI通信サービス
class ApiService {
  final String baseUrl;

  ApiService({
    this.baseUrl = 'http://localhost:8000',
  });

  /// 推薦結果をストリーミングで取得
  ///
  /// SSE (Server-Sent Events) を使用してリアルタイムで推薦結果を受信
  Stream<Map<String, dynamic>> getRecommendations(
    FlavorProfile flavorProfile,
  ) async* {
    final url = Uri.parse('$baseUrl/api/recommend');

    try {
      // POSTリクエストを送信
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'text/event-stream';
      request.body = jsonEncode({
        'flavor_profile': flavorProfile.toJson(),
      });

      final client = http.Client();
      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          'Failed to get recommendations: ${streamedResponse.statusCode}',
        );
      }

      // SSEストリームを処理
      await for (final chunk in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        // 空行はスキップ
        if (chunk.trim().isEmpty) continue;

        // "data: " プレフィックスを除去
        if (chunk.startsWith('data: ')) {
          final data = chunk.substring(6); // "data: " を削除

          // [DONE] で終了
          if (data == '[DONE]') {
            break;
          }

          try {
            // JSONをパース
            final jsonData = jsonDecode(data) as Map<String, dynamic>;
            yield jsonData;
          } catch (e) {
            print('Error parsing SSE data: $e');
            print('Raw data: $data');
          }
        }
      }

      client.close();
    } catch (e) {
      print('Error in getRecommendations: $e');
      rethrow;
    }
  }

  /// 推薦結果を取得（非ストリーミング版）
  Future<RecommendationResult?> getRecommendationsSync(
    FlavorProfile flavorProfile,
  ) async {
    RecommendationResult? result;

    await for (final event in getRecommendations(flavorProfile)) {
      if (event['type'] == 'complete') {
        final data = event['data'] as Map<String, dynamic>;
        result = RecommendationResult.fromJson(data);
      } else if (event['type'] == 'error') {
        throw Exception('Error: ${event['data']}');
      }
    }

    return result;
  }

  /// 全コーヒー豆データを取得（デバッグ用）
  Future<List<Map<String, dynamic>>> getAllBeans() async {
    final url = Uri.parse('$baseUrl/api/beans');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load beans: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllBeans: $e');
      rethrow;
    }
  }

  /// ヘルスチェック
  Future<bool> healthCheck() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
}
