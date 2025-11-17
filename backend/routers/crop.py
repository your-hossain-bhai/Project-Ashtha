from fastapi import APIRouter
from models import CropRecommendRequest, CropRecommendResponse

router = APIRouter()

@router.post("/recommend", response_model=CropRecommendResponse)
async def recommend_crop(request: CropRecommendRequest):
    # Stub recommendations based on inputs
    recommendations = []
    if 6.0 <= request.soil_ph <= 7.0 and request.moisture > 50 and request.temperature > 20:
        recommendations.append({"crop": "Rice", "score": 0.92, "reason": "pH suited & moisture ok"})
        recommendations.append({"crop": "Tomato", "score": 0.78, "reason": "Temperature suitable"})
    else:
        recommendations.append({"crop": "Wheat", "score": 0.85, "reason": "General conditions"})
    
    return {"recommendations": recommendations}
