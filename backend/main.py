"""
Bean Advisor FastAPI Application
"""
import os
import json
from typing import List
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from dotenv import load_dotenv

from models import CoffeeBean, RecommendationRequest
from coffee_service import CoffeeService
from openai_service import OpenAIService


# 環境変数を読み込む
load_dotenv()

# サービスのグローバルインスタンス
coffee_service: CoffeeService | None = None
openai_service: OpenAIService | None = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """アプリケーションのライフサイクル管理"""
    global coffee_service, openai_service

    # 起動時: サービスを初期化
    coffee_service = CoffeeService()
    openai_service = OpenAIService()

    print("✅ Services initialized")
    print(f"📦 Loaded {len(coffee_service.beans)} coffee beans")

    yield

    # 終了時: クリーンアップ（必要に応じて）
    print("👋 Shutting down services")


# FastAPIアプリケーション
app = FastAPI(
    title="Bean Advisor API",
    description="コーヒー豆推薦チャットアプリのバックエンドAPI",
    version="1.0.0",
    lifespan=lifespan
)

# CORS設定（Flutter Webからのアクセスを許可）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 本番環境では適切に設定すること
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """ヘルスチェック"""
    return {"message": "Bean Advisor API"}


@app.get("/api/beans", response_model=List[CoffeeBean])
async def get_all_beans():
    """
    全コーヒー豆データを取得（デバッグ用）

    Returns:
        全10件の豆データ
    """
    if not coffee_service:
        raise HTTPException(status_code=500, detail="Service not initialized")

    return coffee_service.get_all_beans()


@app.post("/api/recommend")
async def recommend_beans(request: RecommendationRequest):
    """
    ユーザーのフレーバープロファイルに基づいてコーヒー豆を推薦

    Args:
        request: 推薦リクエスト（フレーバープロファイル）

    Returns:
        SSE (Server-Sent Events) ストリーミングレスポンス
    """
    if not coffee_service or not openai_service:
        raise HTTPException(status_code=500, detail="Service not initialized")

    async def event_generator():
        """SSEイベントジェネレーター"""
        try:
            # 1. 類似度計算でトップ3を取得
            similar_beans = coffee_service.find_similar_beans(
                request.flavor_profile,
                top_k=3
            )

            # 2. OpenAI APIで推薦文を生成（ストリーミング）
            async for chunk in openai_service.generate_recommendation_stream(
                request.flavor_profile,
                similar_beans
            ):
                # SSE形式でチャンクを送信
                event_data = {
                    "type": "complete",
                    "data": json.loads(chunk)
                }
                yield f"data: {json.dumps(event_data, ensure_ascii=False)}\n\n"

            # 3. 完了を通知
            yield "data: [DONE]\n\n"

        except Exception as e:
            # エラーを通知
            error_data = {
                "type": "error",
                "data": str(e)
            }
            yield f"data: {json.dumps(error_data, ensure_ascii=False)}\n\n"

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",  # nginxのバッファリングを無効化
        }
    )


if __name__ == "__main__":
    import uvicorn

    port = int(os.getenv("PORT", "8000"))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=True,
        log_level="info"
    )
