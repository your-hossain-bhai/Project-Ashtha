from fastapi import APIRouter
from models import Course
from motor.motor_asyncio import AsyncIOMotorClient
import os

router = APIRouter()

client = AsyncIOMotorClient(os.getenv("MONGODB_URL", "mongodb://localhost:27017"))
db = client.krishokdhoni

@router.get("/")
async def get_courses():
    courses = await db.courses.find().to_list(100)
    return courses

@router.get("/{course_id}")
async def get_course(course_id: str):
    course = await db.courses.find_one({"_id": course_id})
    return course

@router.post("/")
async def create_course(course: Course):
    course_dict = course.dict()
    result = await db.courses.insert_one(course_dict)
    return {"id": str(result.inserted_id)}
