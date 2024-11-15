# OSP-APP
## Konfiguracja i migracja bazy danych

Aby skonfigurować bazę danych i przeprowadzić migrację, wykonaj poniższe kroki:

### 1. Skonfiguruj URI bazy danych
Otwórz plik `config.py` i zaktualizuj wartość `SQLALCHEMY_DATABASE_URI`, aby odpowiadała Twojej konfiguracji bazy danych.

Przykład konfiguracji:
```python
# config.py

SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost/dbname'
pip install Flask-Migrate

flask db migrate
flask db upgrade
