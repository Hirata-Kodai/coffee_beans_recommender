"""
Pydantic models for Bean Advisor API
"""
from typing import List, Optional
from pydantic import BaseModel, Field


class FlavorProfile(BaseModel):
    """フレーバープロファイルモデル"""
    acidity: float = Field(..., ge=0.0, le=5.0, description="酸味 (0.0-5.0)")
    bitterness: float = Field(..., ge=0.0, le=5.0, description="苦味 (0.0-5.0)")
    body: float = Field(..., ge=0.0, le=5.0, description="コク (0.0-5.0)")
    clarity: float = Field(..., ge=0.0, le=5.0, description="クリアー (0.0-5.0)")


class CoffeeBean(BaseModel):
    """コーヒー豆モデル"""
    id: int
    name: str
    origin: str
    region: str
    roast_level: str
    flavor_profile: FlavorProfile
    tasting_notes: List[str]
    description: str
    price: int
    image_url: str


class BeanRecommendation(BaseModel):
    """豆の推薦情報"""
    rank: int = Field(..., description="推薦順位 (1-3)")
    bean_id: int = Field(..., description="コーヒー豆ID")
    reason: str = Field(..., description="推薦理由")
    highlights: List[str] = Field(..., description="ハイライト（2-3個）")


class RecommendationResult(BaseModel):
    """推薦結果の構造化出力"""
    introduction: str = Field(..., description="推薦の導入文（100文字程度）")
    recommendations: List[BeanRecommendation] = Field(..., description="トップ3の推薦豆")
    top_pick_explanation: str = Field(..., description="1位の豆の特別な説明（150文字程度）")


class RecommendationRequest(BaseModel):
    """推薦リクエスト"""
    flavor_profile: FlavorProfile


class SimilarityScore(BaseModel):
    """類似度スコア"""
    bean: CoffeeBean
    score: float
    distance: float
