# Bean Advisor - コーヒー豆推薦チャットアプリ

ユーザーが好みのコーヒーフレーバープロファイルを視覚的に選択し、AIエージェントが最適なコーヒー豆を推薦するWebアプリケーションです。

## 特徴

- **直感的なフレーバー選択**: 2Dチャートとスライダーで好みの味わいを調整
- **AIによる推薦**: OpenAI GPT-4oが最適なコーヒー豆トップ3を推薦
- **リアルタイム応答**: SSE (Server-Sent Events) でストリーミング表示
- **詳細な豆情報**: 産地、焙煎度、テイスティングノート、価格などの情報

## 技術スタック

### フロントエンド
- Flutter Web
- Provider（状態管理）
- HTTP client（SSE対応）

### バックエンド
- FastAPI (Python 3.10+)
- OpenAI GPT-4o API
- Server-Sent Events (SSE)
- Pydantic（データバリデーション）

## プロジェクト構造

```
coffee_beans_recommender/
├── backend/
│   ├── data/
│   │   └── coffee_beans.json      # コーヒー豆データ（10件）
│   ├── main.py                     # FastAPIアプリケーション
│   ├── models.py                   # Pydanticモデル
│   ├── coffee_service.py           # 類似度計算サービス
│   ├── openai_service.py           # OpenAI API連携
│   ├── requirements.txt            # Python依存パッケージ
│   └── .env.example                # 環境変数サンプル
├── frontend/
│   ├── lib/
│   │   ├── models/                 # データモデル
│   │   ├── services/               # APIサービス
│   │   ├── widgets/                # UIウィジェット
│   │   ├── screens/                # 画面
│   │   └── main.dart               # エントリーポイント
│   ├── web/                        # Webリソース
│   └── pubspec.yaml                # Flutter依存関係
└── README.md
```

## セットアップ

### 前提条件

- Python 3.10以上
- Flutter 3.0以上
- OpenAI APIキー

### バックエンドのセットアップ

1. 仮想環境を作成して有効化:

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

2. 依存パッケージをインストール:

```bash
pip install -r requirements.txt
```

3. 環境変数を設定:

```bash
cp .env.example .env
# .envファイルを編集してOpenAI APIキーを設定
```

`.env`ファイル:
```
OPENAI_API_KEY=sk-your-api-key-here
PORT=8000
```

4. バックエンドサーバーを起動:

```bash
python main.py
```

サーバーは `http://localhost:8000` で起動します。

### フロントエンドのセットアップ

1. 依存パッケージをインストール:

```bash
cd frontend
flutter pub get
```

2. Webアプリを起動:

```bash
flutter run -d chrome
```

または、ビルドして静的ファイルを生成:

```bash
flutter build web
```

## 使い方

1. **フレーバープロファイル選択**
   - スライダーで酸味、苦味、コク、クリアーを調整（0.0-5.0）
   - 2Dチャートで視覚的に確認
   - 「この味でコーヒーを探す」ボタンをクリック

2. **推薦結果表示**
   - AIが分析した導入文を表示
   - トップ3のコーヒー豆をカード形式で表示
   - 各豆の推薦理由とハイライトを確認
   - 1位の豆の特別な説明を表示

3. **リセット**
   - 右上の更新ボタンで最初から選び直し

## API仕様

### エンドポイント

#### `GET /`
ヘルスチェック

**レスポンス:**
```json
{
  "message": "Bean Advisor API"
}
```

#### `GET /api/beans`
全コーヒー豆データを取得（デバッグ用）

**レスポンス:**
```json
[
  {
    "id": 1,
    "name": "マンデリン・リントン",
    "origin": "インドネシア",
    "region": "スマトラ島リントン地区",
    "roast_level": "フレンチロースト",
    "flavor_profile": {
      "acidity": 3.0,
      "bitterness": 4.0,
      "body": 5.0,
      "clarity": 2.0
    },
    "tasting_notes": ["ダークチョコレート", "ハーブ", "グレープフルーツ"],
    "description": "濃厚なコクとシロップのようなとろみ...",
    "price": 1800,
    "image_url": "https://example.com/images/mandheling.jpg"
  },
  ...
]
```

#### `POST /api/recommend`
コーヒー豆の推薦（SSEストリーミング）

**リクエスト:**
```json
{
  "flavor_profile": {
    "acidity": 3.5,
    "bitterness": 2.5,
    "body": 4.0,
    "clarity": 3.0
  }
}
```

**レスポンス (SSE):**
```
data: {"type": "complete", "data": {...}}

data: [DONE]
```

## 類似度計算アルゴリズム

ユークリッド距離ベースの類似度計算を使用:

```python
# 重み付け
weights = {
    "acidity": 1.0,
    "bitterness": 1.0,
    "body": 1.2,      # コクを重視
    "clarity": 1.0
}

# 距離計算
distance = sqrt(
    w_acidity * (p1.acidity - p2.acidity)^2 +
    w_bitterness * (p1.bitterness - p2.bitterness)^2 +
    w_body * (p1.body - p2.body)^2 +
    w_clarity * (p1.clarity - p2.clarity)^2
)

# 類似度スコア
similarity = 1 / (1 + distance)
```

## 開発

### バックエンドのテスト

```bash
cd backend
python -m pytest  # テストがある場合
```

### フロントエンドのテスト

```bash
cd frontend
flutter test
```

### リント

```bash
# Python
cd backend
flake8 .

# Flutter
cd frontend
flutter analyze
```

## ライセンス

MIT License

## 作成者

Bean Advisor Development Team

## 今後の拡張予定

- ユーザー認証機能
- 会話履歴の保存
- お気に入り機能
- レビュー機能
- 購入リンク連携
- モバイルアプリ対応（iOS/Android）
