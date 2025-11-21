from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import timedelta, datetime
from models import UserCreate, User, Token, SignupResponse
from auth import authenticate_user, create_access_token, create_refresh_token, get_password_hash, verify_token
from motor.motor_asyncio import AsyncIOMotorClient
import pymongo.errors
import os

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# MongoDB client
client = AsyncIOMotorClient(os.getenv("MONGODB_URL", "mongodb://localhost:27017"))
db = client.krishokdhoni

@router.post("/signup", response_model=SignupResponse)
async def signup(user: UserCreate):
    try:
        existing_user = await db.users.find_one({"email": user.email})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"success": False, "message": "Database error"})
    if existing_user:
        raise HTTPException(status_code=409, detail={"success": False, "message": "Email already registered"})

    try:
        hashed_password = get_password_hash(user.password)
    except Exception as e:
        raise HTTPException(status_code=400, detail={"success": False, "message": "Invalid password format"})

    user_dict = {
        "name": user.name,
        "email": user.email,
        "hashed_password": hashed_password,
        "created_at": datetime.utcnow()
    }
    try:
        result = await db.users.insert_one(user_dict)
        user_id = str(result.inserted_id)
    except pymongo.errors.DuplicateKeyError:
        raise HTTPException(status_code=409, detail={"success": False, "message": "Email already registered"})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"success": False, "message": "Database error"})

    try:
        access_token = create_access_token(data={"sub": user.email})
        refresh_token = create_refresh_token(data={"sub": user.email})
    except Exception as e:
        raise HTTPException(status_code=500, detail={"success": False, "message": "Token creation error"})

    return SignupResponse(
        message="User created successfully",
        user={"id": user_id, "email": user.email, "name": user.name},
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer"
    )

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = await authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(data={"sub": user["email"]})
    refresh_token = create_refresh_token(data={"sub": user["email"]})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}

@router.post("/refresh", response_model=dict)
async def refresh_token(refresh_token: str):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    token_data = verify_token(refresh_token, credentials_exception)
    access_token = create_access_token(data={"sub": token_data.email})
    return {"access_token": access_token}

async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    token_data = verify_token(token, credentials_exception)
    user = await db.users.find_one({"email": token_data.email})
    if user is None:
        raise credentials_exception
    return user

async def authenticate_user(db, email: str, password: str):
    user = await db.users.find_one({"email": email})
    if not user:
        return False
    if not verify_password(password, user["hashed_password"]):
        return False
    return user
