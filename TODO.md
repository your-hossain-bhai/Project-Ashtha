# TODO: Fix Signup 500 Error

## 1. Update models.py
- Add SignupResponse model with message, user, access_token, refresh_token, token_type
- Add password min_length=6 to UserCreate

## 2. Update seed.py
- Add unique index creation on email for users collection

## 3. Update routers/auth.py
- Import pymongo.errors and SignupResponse
- Change response_model to SignupResponse
- Add try/except for DB operations and hashing/JWT
- Change duplicate error to 409 with JSON detail
- Modify return to SignupResponse instance

## 4. Update tests/test_auth.py
- Change expected status to 200 (since response_model changed, but actually FastAPI returns 200 for success)
- Update assertions to check for message, user, access_token, etc.

## 5. Set up environment
- Create virtual environment
- Install dependencies
- Start MongoDB with docker-compose
- Run seed.py to create index
- Run backend with uvicorn

## 6. Test the endpoint
- Test valid signup: expect 200 with JSON
- Test duplicate email: expect 409 with JSON
- Test invalid password: expect 422
- Test invalid email: expect 422
