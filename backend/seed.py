import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from auth import get_password_hash
from datetime import datetime
import os

async def seed_data():
    client = AsyncIOMotorClient(os.getenv("MONGODB_URL", "mongodb://localhost:27017"))
    db = client.krishokdhoni
    
    # Seed user
    hashed_password = get_password_hash("Demo@1234")
    user = {
        "name": "Demo User",
        "email": "demo@demo.com",
        "hashed_password": hashed_password,
        "created_at": datetime.utcnow()
    }
    await db.users.insert_one(user)
    
    # Seed courses
    courses = [
        {
            "title": "Introduction to Organic Farming",
            "description": "Learn the basics of organic farming practices.",
            "instructor": "Dr. Green",
            "price": 50.0,
            "created_at": datetime.utcnow()
        },
        {
            "title": "Pest Control Techniques",
            "description": "Effective methods to control pests in crops.",
            "instructor": "Prof. Pest",
            "price": 75.0,
            "created_at": datetime.utcnow()
        }
    ]
    await db.courses.insert_many(courses)
    
    # Seed market prices (static for demo)
    # Already handled in router
    
    print("Seeded demo data")

if __name__ == "__main__":
    asyncio.run(seed_data())
