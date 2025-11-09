import 'package:flutter/material.dart';
import '../models/flavor_profile.dart';

/// フレーバーチャートウィジェット
///
/// 2Dチャート（横軸: 酸味-苦味、縦軸: クリアー-コク）とスライダーで
/// ユーザーのフレーバープロファイルを選択
class FlavorChartWidget extends StatefulWidget {
  final FlavorProfile initialProfile;
  final Function(FlavorProfile) onSearch;

  const FlavorChartWidget({
    super.key,
    required this.initialProfile,
    required this.onSearch,
  });

  @override
  State<FlavorChartWidget> createState() => _FlavorChartWidgetState();
}

class _FlavorChartWidgetState extends State<FlavorChartWidget> {
  late FlavorProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.initialProfile;
  }

  void _updateProfile({
    double? acidity,
    double? bitterness,
    double? body,
    double? clarity,
  }) {
    setState(() {
      _currentProfile = _currentProfile.copyWith(
        acidity: acidity,
        bitterness: bitterness,
        body: body,
        clarity: clarity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // タイトル
            Text(
              'あなたの好みを教えてください',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6F4E37),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // 2Dチャート
            AspectRatio(
              aspectRatio: 1.0,
              child: _FlavorChart(profile: _currentProfile),
            ),
            const SizedBox(height: 32),

            // スライダー群
            _buildSlider(
              label: '酸味',
              value: _currentProfile.acidity,
              onChanged: (value) => _updateProfile(acidity: value),
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: '苦味',
              value: _currentProfile.bitterness,
              onChanged: (value) => _updateProfile(bitterness: value),
              color: Colors.brown,
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'コク',
              value: _currentProfile.body,
              onChanged: (value) => _updateProfile(body: value),
              color: const Color(0xFF8B4513),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'クリアー',
              value: _currentProfile.clarity,
              onChanged: (value) => _updateProfile(clarity: value),
              color: Colors.blue,
            ),
            const SizedBox(height: 32),

            // 検索ボタン
            ElevatedButton(
              onPressed: () => widget.onSearch(_currentProfile),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('この味でコーヒーを探す'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label: value.toStringAsFixed(1),
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.toStringAsFixed(1),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

/// 2Dフレーバーチャート
class _FlavorChart extends StatelessWidget {
  final FlavorProfile profile;

  const _FlavorChart({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: CustomPaint(
        painter: _FlavorChartPainter(profile: profile),
      ),
    );
  }
}

/// フレーバーチャートのペインター
class _FlavorChartPainter extends CustomPainter {
  final FlavorProfile profile;

  _FlavorChartPainter({required this.profile});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // グリッド線を描画
    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );

      final x = size.width * i / 5;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // 中心線を描画
    final centerPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      centerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerPaint,
    );

    // ラベルを描画
    _drawLabel(canvas, size, '酸味', Alignment.bottomLeft);
    _drawLabel(canvas, size, '苦味', Alignment.bottomRight);
    _drawLabel(canvas, size, 'クリアー', Alignment.topCenter);
    _drawLabel(canvas, size, 'コク', Alignment.bottomCenter);

    // 選択位置を描画
    // X軸: 酸味(0.0) ← → 苦味(5.0) を 苦味 - 酸味 の差で計算
    final x = size.width * (profile.bitterness + (5.0 - profile.acidity)) / 10.0;
    // Y軸: クリアー(0.0) ← → コク(5.0) を コク - クリアー の差で計算
    final y = size.height * (profile.body + (5.0 - profile.clarity)) / 10.0;

    final pointPaint = Paint()
      ..color = const Color(0xFF6F4E37)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 8, pointPaint);

    // 外側の円
    final outerPaint = Paint()
      ..color = const Color(0xFF6F4E37).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(x, y), 16, outerPaint);
  }

  void _drawLabel(Canvas canvas, Size size, String text, Alignment alignment) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF6F4E37),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    Offset offset;
    if (alignment == Alignment.bottomLeft) {
      offset = Offset(8, size.height - textPainter.height - 8);
    } else if (alignment == Alignment.bottomRight) {
      offset = Offset(
        size.width - textPainter.width - 8,
        size.height - textPainter.height - 8,
      );
    } else if (alignment == Alignment.topCenter) {
      offset = Offset((size.width - textPainter.width) / 2, 8);
    } else {
      // bottomCenter
      offset = Offset(
        (size.width - textPainter.width) / 2,
        size.height - textPainter.height - 8,
      );
    }

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _FlavorChartPainter oldDelegate) {
    return oldDelegate.profile != profile;
  }
}
