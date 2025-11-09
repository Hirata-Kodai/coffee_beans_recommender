"""
Coffee similarity calculation service
"""
import json
import math
from pathlib import Path
from typing import List

from models import CoffeeBean, FlavorProfile, SimilarityScore


class CoffeeService:
    """コーヒー豆の類似度計算サービス"""

    def __init__(self, data_path: str = "data/coffee_beans.json"):
        """
        初期化

        Args:
            data_path: コーヒー豆データのJSONファイルパス
        """
        self.data_path = Path(__file__).parent / data_path
        self.beans: List[CoffeeBean] = []
        self.load_beans()

    def load_beans(self):
        """JSONファイルからコーヒー豆データを読み込む"""
        with open(self.data_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            self.beans = [CoffeeBean(**bean) for bean in data]

    def calculate_distance(
        self,
        profile1: FlavorProfile,
        profile2: FlavorProfile
    ) -> float:
        """
        2つのフレーバープロファイル間のユークリッド距離を計算

        重み付け:
        - 酸味: 1.0
        - 苦味: 1.0
        - コク: 1.2 (重視)
        - クリアー: 1.0

        Args:
            profile1: フレーバープロファイル1
            profile2: フレーバープロファイル2

        Returns:
            ユークリッド距離
        """
        weights = {
            "acidity": 1.0,
            "bitterness": 1.0,
            "body": 1.2,
            "clarity": 1.0
        }

        distance_squared = (
            weights["acidity"] * (profile1.acidity - profile2.acidity) ** 2 +
            weights["bitterness"] * (profile1.bitterness - profile2.bitterness) ** 2 +
            weights["body"] * (profile1.body - profile2.body) ** 2 +
            weights["clarity"] * (profile1.clarity - profile2.clarity) ** 2
        )

        return math.sqrt(distance_squared)

    def calculate_similarity(self, distance: float) -> float:
        """
        距離から類似度スコアを計算

        Args:
            distance: ユークリッド距離

        Returns:
            類似度スコア (0.0-1.0に近い値)
        """
        return 1.0 / (1.0 + distance)

    def find_similar_beans(
        self,
        user_profile: FlavorProfile,
        top_k: int = 3
    ) -> List[SimilarityScore]:
        """
        ユーザーのフレーバープロファイルに似た豆を探す

        Args:
            user_profile: ユーザーのフレーバープロファイル
            top_k: 上位何件を返すか (デフォルト: 3)

        Returns:
            類似度スコアのリスト（降順）
        """
        scores = []

        for bean in self.beans:
            distance = self.calculate_distance(user_profile, bean.flavor_profile)
            similarity = self.calculate_similarity(distance)

            scores.append(SimilarityScore(
                bean=bean,
                score=similarity,
                distance=distance
            ))

        # 類似度スコアで降順ソート
        scores.sort(key=lambda x: x.score, reverse=True)

        return scores[:top_k]

    def get_all_beans(self) -> List[CoffeeBean]:
        """
        全てのコーヒー豆データを取得

        Returns:
            全コーヒー豆のリスト
        """
        return self.beans

    def get_bean_by_id(self, bean_id: int) -> CoffeeBean | None:
        """
        IDでコーヒー豆を取得

        Args:
            bean_id: コーヒー豆のID

        Returns:
            コーヒー豆データ（見つからない場合はNone）
        """
        for bean in self.beans:
            if bean.id == bean_id:
                return bean
        return None
