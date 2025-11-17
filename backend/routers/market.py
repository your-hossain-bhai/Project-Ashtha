from fastapi import APIRouter, Depends
from models import MarketLatestResponse, MarketPost
from routers.auth import get_current_user
from motor.motor_asyncio import AsyncIOMotorClient
import os

router = APIRouter()

client = AsyncIOMotorClient(os.getenv("MONGODB_URL", "mongodb://localhost:27017"))
db = client.krishokdhoni

@router.get("/latest", response_model=MarketLatestResponse)
async def get_market_latest(city: str = "Dhaka"):
    # Stub data
    prices = [
        {"crop": "Rice", "price_per_kg": 45.5, "trend": "up"},
        {"crop": "Potato", "price_per_kg": 25.0, "trend": "down"}
    ]
    return {"city": city, "prices": prices}

@router.post("/posts")
async def create_market_post(post: MarketPost, current_user: dict = Depends(get_current_user)):
    post_dict = post.dict()
    post_dict["user_id"] = current_user["_id"]
    result = await db.market_posts.insert_one(post_dict)
    return {"id": str(result.inserted_id)}

@router.get("/posts")
async def get_market_posts():
    posts = await db.market_posts.find().to_list(100)
    return posts
