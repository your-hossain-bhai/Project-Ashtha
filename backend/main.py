from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from slowapi.middleware import SlowAPIMiddleware
import logging
from routers import auth, weather, disease, crop, market, courses

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Rate limiter
limiter = Limiter(key_func=get_remote_address)

app = FastAPI(
    title="Krishokdhoni API",
    description="API for Krishokdhoni app",
    version="1.0.0"
)

# Add rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
app.add_middleware(SlowAPIMiddleware)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:8080"],  # Adjust for Flutter
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(weather.router, prefix="/api/v1", tags=["weather"])
app.include_router(disease.router, prefix="/api/v1/disease", tags=["disease"])
app.include_router(crop.router, prefix="/api/v1/crop", tags=["crop"])
app.include_router(market.router, prefix="/api/v1/market", tags=["market"])
app.include_router(courses.router, prefix="/api/v1/courses", tags=["courses"])

@app.get("/")
def read_root():
    return {"message": "Welcome to Krishokdhoni API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
