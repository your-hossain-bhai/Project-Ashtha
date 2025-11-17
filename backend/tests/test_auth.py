import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_signup():
    response = client.post("/api/v1/auth/signup", json={
        "name": "Test User",
        "email": "test@example.com",
        "password": "Test@1234"
    })
    assert response.status_code == 201
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data

def test_login():
    response = client.post("/api/v1/auth/login", json={
        "username": "test@example.com",
        "password": "Test@1234"
    })
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data

def test_login_invalid():
    response = client.post("/api/v1/auth/login", json={
        "username": "invalid@example.com",
        "password": "wrong"
    })
    assert response.status_code == 401
