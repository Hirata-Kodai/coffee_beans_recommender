"""
OpenAI API service with Structured Output support
"""
import os
from typing import List, AsyncIterator
import json

from openai import AsyncOpenAI
from pydantic import BaseModel

from models import (
    FlavorProfile,
    SimilarityScore,
    RecommendationResult,
    BeanRecommendation
)


class OpenAIService:
    """OpenAI API連携サービス"""

    def __init__(self, api_key: str | None = None):
        """
        初期化

        Args:
            api_key: OpenAI APIキー（Noneの場合は環境変数から取得）
        """
        self.api_key = api_key or os.getenv("OPENAI_API_KEY")
        if not self.api_key:
            raise ValueError("OPENAI_API_KEY is not set")

        self.client = AsyncOpenAI(api_key=self.api_key)
        self.model = "gpt-4o"

    def create_system_prompt(self) -> str:
        """システムプロンプトを生成"""
        return """あなたはコーヒー推薦AIエージェント「ビーンズ」です。
ユーザーの好みのフレーバープロファイルに基づいて、最適なコーヒー豆を推薦します。

あなたの役割:
- ユーザーの味覚の好みを理解する
- トップ3のコーヒー豆を推薦する
- 各豆の特徴を分かりやすく説明する
- フレンドリーで親しみやすい口調で話す

推薦のポイント:
- 1位は最も近い味わい
- 2位と3位は異なる魅力を持つ豆
- 各豆の個性を引き出す
- テイスティングノートを活用する
"""

    def create_user_prompt(
        self,
        user_profile: FlavorProfile,
        similar_beans: List[SimilarityScore]
    ) -> str:
        """
        ユーザープロンプトを生成

        Args:
            user_profile: ユーザーのフレーバープロファイル
            similar_beans: 類似度スコアのリスト（トップ3）

        Returns:
            ユーザープロンプト
        """
        beans_info = []
        for i, score in enumerate(similar_beans, 1):
            bean = score.bean
            beans_info.append(f"""
【候補{i}】{bean.name}
- 産地: {bean.origin} ({bean.region})
- 焙煎度: {bean.roast_level}
- 価格: ¥{bean.price}
- フレーバープロファイル:
  * 酸味: {bean.flavor_profile.acidity}
  * 苦味: {bean.flavor_profile.bitterness}
  * コク: {bean.flavor_profile.body}
  * クリアー: {bean.flavor_profile.clarity}
- テイスティングノート: {', '.join(bean.tasting_notes)}
- 説明: {bean.description}
- 類似度スコア: {score.score:.3f}
""")

        return f"""ユーザーが求めているフレーバープロファイル:
- 酸味: {user_profile.acidity}
- 苦味: {user_profile.bitterness}
- コク: {user_profile.body}
- クリアー: {user_profile.clarity}

類似度計算により選出されたトップ3のコーヒー豆:
{''.join(beans_info)}

上記の3つの豆を推薦してください。以下のルールに従ってください:

1. introduction: ユーザーの好みを踏まえた推薦の導入文を100文字程度で書く
2. recommendations: 各豆について:
   - rank: 1-3の順位
   - bean_id: 豆のID
   - reason: その豆を推薦する理由（80文字程度）
   - highlights: その豆の魅力的なポイント2-3個（各20文字以内）
3. top_pick_explanation: 1位の豆について特別な説明を150文字程度で書く

必ず候補1を1位、候補2を2位、候補3を3位として推薦してください。
親しみやすく、コーヒーへの愛が伝わる文章にしてください。
"""

    async def generate_recommendation_stream(
        self,
        user_profile: FlavorProfile,
        similar_beans: List[SimilarityScore]
    ) -> AsyncIterator[str]:
        """
        推薦文をストリーミングで生成（Structured Output版）

        Args:
            user_profile: ユーザーのフレーバープロファイル
            similar_beans: 類似度スコアのリスト（トップ3）

        Yields:
            JSONチャンク文字列
        """
        system_prompt = self.create_system_prompt()
        user_prompt = self.create_user_prompt(user_profile, similar_beans)

        # Structured Outputを使用
        # 注意: OpenAI APIのStructured OutputはPydanticモデルを直接サポート
        response = await self.client.beta.chat.completions.parse(
            model=self.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            response_format=RecommendationResult,
        )

        # 構造化された結果を取得
        result = response.choices[0].message.parsed

        if result:
            # 結果をJSON形式で返す
            result_dict = result.model_dump()

            # 豆の情報を追加
            for rec in result_dict["recommendations"]:
                bean_id = rec["bean_id"]
                for score in similar_beans:
                    if score.bean.id == bean_id:
                        rec["bean"] = score.bean.model_dump()
                        break

            yield json.dumps(result_dict, ensure_ascii=False)
        else:
            raise ValueError("Failed to generate recommendation")

    async def generate_recommendation(
        self,
        user_profile: FlavorProfile,
        similar_beans: List[SimilarityScore]
    ) -> RecommendationResult:
        """
        推薦結果を生成（非ストリーミング版）

        Args:
            user_profile: ユーザーのフレーバープロファイル
            similar_beans: 類似度スコアのリスト（トップ3）

        Returns:
            推薦結果
        """
        system_prompt = self.create_system_prompt()
        user_prompt = self.create_user_prompt(user_profile, similar_beans)

        response = await self.client.beta.chat.completions.parse(
            model=self.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            response_format=RecommendationResult,
        )

        result = response.choices[0].message.parsed

        if not result:
            raise ValueError("Failed to generate recommendation")

        return result
