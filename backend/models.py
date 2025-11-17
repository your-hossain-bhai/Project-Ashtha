from pydantic import BaseModel, EmailStr
from typing import List, Optional
from datetime import datetime

class User(BaseModel):
    id: Optional[str] = None
    name: str
    email: EmailStr
    hashed_password: str
    created_at: Optional[datetime] = None

class UserInDB(User):
    pass

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"

class TokenData(BaseModel):
    email: Optional[str] = None

class WeatherResponse(BaseModel):
    city: str
    temp: float
    condition: str
    humidity: int
    wind_kmh: float
    forecast: List[dict]

class DiseasePredictRequest(BaseModel):
    pass  # For multipart

class DiseasePredictResponse(BaseModel):
    crop: str
    disease: str
    confidence: float
    advice: List[str]
    recommendations: List[dict]

class CropRecommendRequest(BaseModel):
    soil_ph: float
    moisture: float
    temperature: float

class CropRecommendResponse(BaseModel):
    recommendations: List[dict]

class MarketPrice(BaseModel):
    crop: str
    price_per_kg: float
    trend: str

class MarketLatestResponse(BaseModel):
    city: str
    prices: List[MarketPrice]

class Course(BaseModel):
    id: Optional[str] = None
    title: str
    description: str
    instructor: str
    price: float
    created_at: Optional[datetime] = None

class MarketPost(BaseModel):
    id: Optional[str] = None
    user_id: str
    title: str
    description: str
    price: float
    created_at: Optional[datetime] = None
