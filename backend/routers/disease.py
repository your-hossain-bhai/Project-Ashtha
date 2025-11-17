from fastapi import APIRouter, UploadFile, File, Depends
from models import DiseasePredictResponse
import os
import shutil
from routers.auth import get_current_user

router = APIRouter()

@router.post("/predict", response_model=DiseasePredictResponse)
async def predict_disease(file: UploadFile = File(...), current_user: dict = Depends(get_current_user)):
    # Save uploaded file temporarily
    upload_dir = "/tmp/uploads"
    os.makedirs(upload_dir, exist_ok=True)
    file_path = os.path.join(upload_dir, file.filename)
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    
    # Stub inference: check filename for "leaf" or "tomato"
    if "leaf" in file.filename.lower() or "tomato" in file.filename.lower():
        disease = "Early Blight"
        confidence = 0.92
        advice = ["Remove infected leaves", "Apply fungicide X per 10L"]
        recommendations = [{"name": "Fungicide X", "dose": "5ml/L", "apply": "Spray once every 7 days"}]
    else:
        disease = "Healthy"
        confidence = 0.95
        advice = ["No action needed"]
        recommendations = []
    
    # Clean up
    os.remove(file_path)
    
    return {
        "crop": "Tomato",  # Assume tomato for demo
        "disease": disease,
        "confidence": confidence,
        "advice": advice,
        "recommendations": recommendations
    }
