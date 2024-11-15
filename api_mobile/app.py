from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager

from models.models import db
from flask_migrate import Migrate
from user.user import user_bp  # Import blueprintu z katalogu `user`
from events.event import event_bp

def create_app():
    app = Flask(__name__)

    app.config.from_object('user.config.Config')  # Ładuje konfigurację z pliku `config.py`
    CORS(app)
    db.init_app(app)
    migrate = Migrate(app, db)

    jwt = JWTManager(app)
    app.config['JWT_TOKEN_LOCATION'] = ['cookies']
    app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token'
    app.config['JWT_COOKIE_CSRF_PROTECT'] = False
    # Rejestracja blueprintu użytkownika
    app.register_blueprint(user_bp, url_prefix='/api/user')
    app.register_blueprint(event_bp, url_prefix='/api/event')

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
