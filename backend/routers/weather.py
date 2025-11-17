from fastapi import APIRouter
import requests
import os
from models import WeatherResponse

router = APIRouter()

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")

@router.get("/weather", response_model=WeatherResponse)
async def get_weather(city: str = "Dhaka"):
    if OPENWEATHER_API_KEY:
        # Proxy to OpenWeatherMap
        url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={OPENWEATHER_API_KEY}&units=metric"
        response = requests.get(url)
        data = response.json()
        # Parse and return
        return {
            "city": city,
            "temp": data["main"]["temp"],
            "condition": data["weather"][0]["description"],
            "humidity": data["main"]["humidity"],
            "wind_kmh": data["wind"]["speed"] * 3.6,  # m/s to km/h
            "forecast": []  # Stub for forecast
        }
    else:
        # Return seeded data
        return {
            "city": city,
            "temp": 32.0,
            "condition": "Partly Cloudy",
            "humidity": 65,
            "wind_kmh": 15.0,
            "forecast": [
                {"day": "Tomorrow", "temp": "33°C - Sunny"},
                {"day": "Day 3", "temp": "31°C - Cloudy"}
            ]
        }
