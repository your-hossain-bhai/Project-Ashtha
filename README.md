# Krishokdhoni App

A comprehensive farming app prototype with FastAPI backend and Flutter frontend for disease detection, crop recommendations, market prices, and more.

## Features

- **Authentication**: JWT-based login/signup with secure password hashing
- **Weather**: Current weather and forecast (OpenWeatherMap integration or fallback)
- **Disease Detection**: Upload images for plant disease prediction (stub with realistic responses)
- **Crop Recommendation**: Get crop suggestions based on soil parameters
- **Market Prices**: View latest crop prices with trends
- **Courses**: Browse farming courses (minimal implementation)

## Tech Stack

### Backend
- FastAPI (Python 3.11+)
- MongoDB (via Motor)
- JWT Authentication (python-jose)
- Password hashing (passlib bcrypt)
- CORS, rate limiting, logging

### Frontend
- Flutter 3.13+ (null-safety)
- Provider for state management
- Dio for HTTP with interceptors
- Flutter Secure Storage for tokens
- Image Picker for camera/gallery

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Flutter SDK (for frontend development)
- Android/iOS emulator or device

### Backend Setup

1. Clone the repository
2. Navigate to backend directory
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run with Docker Compose:
   ```bash
   docker-compose up --build
   ```
   Backend will be available at http://localhost:8000
   MongoDB at localhost:27017

### Frontend Setup

1. Navigate to frontend directory
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run on emulator:
   ```bash
   flutter run
   ```

## API Documentation

FastAPI auto-generates OpenAPI docs at http://localhost:8000/docs

### Key Endpoints

- `POST /api/v1/auth/signup` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/weather?city=Dhaka` - Get weather data
- `POST /api/v1/disease/predict` - Predict plant disease from image
- `POST /api/v1/crop/recommend` - Get crop recommendations
- `GET /api/v1/market/latest` - Get market prices
- `GET /api/v1/courses` - List courses
- `POST /api/v1/market/posts` - Create market post

## Demo User

- Email: demo@demo.com
- Password: Demo@1234

## Seed Data

Run the seed script to populate demo data:
```bash
python backend/seed.py
```

## Testing

### Backend Tests
```bash
cd backend
python -m pytest tests/
```

### Frontend Tests
```bash
cd frontend
flutter test
```

## Example API Calls

### Login
```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "demo@demo.com", "password": "Demo@1234"}'
```

### Get Weather
```bash
curl -X GET "http://localhost:8000/api/v1/weather?city=Dhaka"
```

### Disease Prediction (with image)
```bash
curl -X POST "http://localhost:8000/api/v1/disease/predict" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "image=@path/to/image.jpg"
```

## Project Structure

```
krishokdhoni/
├── backend/
│   ├── main.py
│   ├── models.py
│   ├── auth.py
│   ├── routers/
│   │   ├── auth.py
│   │   ├── weather.py
│   │   ├── disease.py
│   │   ├── crop.py
│   │   ├── market.py
│   │   └── courses.py
│   ├── seed.py
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   ├── screens/
│   │   ├── utils/
│   │   └── theme.dart
│   └── pubspec.yaml
├── docker-compose.yml
└── README.md
```

## Notes

- ML features use realistic stubs for demo purposes
- Weather falls back to seeded data if OpenWeatherMap API key not provided
- CORS configured for Flutter development (adjust for production)
- Rate limiting implemented with in-memory store (use Redis for production)
