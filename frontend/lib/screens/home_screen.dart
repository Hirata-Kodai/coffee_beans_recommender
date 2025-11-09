import 'package:flutter/material.dart';
import '../models/flavor_profile.dart';
import '../widgets/flavor_chart_widget.dart';
import '../widgets/chat_widget.dart';

/// メイン画面
///
/// フレーバーチャート選択 ⇔ 推薦結果表示 を切り替え
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlavorProfile? _selectedProfile;

  void _onSearch(FlavorProfile profile) {
    setState(() {
      _selectedProfile = profile;
    });
  }

  void _onReset() {
    setState(() {
      _selectedProfile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedProfile == null
          ? AppBar(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Bean Advisor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF6F4E37),
              centerTitle: true,
            )
          : null,
      body: _selectedProfile == null
          ? _buildFlavorSelection()
          : _buildRecommendation(),
    );
  }

  Widget _buildFlavorSelection() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ウェルカムメッセージ
            const Text(
              'あなたにぴったりのコーヒー豆を見つけましょう',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6F4E37),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'スライダーで好みの味わいを調整してください',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // フレーバーチャート
            Expanded(
              child: SingleChildScrollView(
                child: FlavorChartWidget(
                  initialProfile: FlavorProfile.initial(),
                  onSearch: _onSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation() {
    return ChatWidget(
      flavorProfile: _selectedProfile!,
      onReset: _onReset,
    );
  }
}
