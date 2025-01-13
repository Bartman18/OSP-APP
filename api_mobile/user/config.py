import os
from datetime import timedelta
class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your_secret_key'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:@localhost:3306/test'  # Możesz użyć MySQL, PostgreSQL, itp.
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = "your_jwt_secret_key"  # Klucz JWT (zmień na unikalny w produkcji)
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=15)
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=7)
    JWT_TOKEN_LOCATION = ["cookies"]
    JWT_ACCESS_COOKIE_NAME = "access_token"
    JWT_COOKIE_SECURE = True  # Powinno być True w produkcji (HTTPS)
    JWT_COOKIE_HTTPONLY = True
    JWT_COOKIE_CSRF_PROTECT = False