# from flask import Flask
# from flask_cors import CORS
# from flask_jwt_extended import JWTManager
#
# from models.models import db
# from flask_migrate import Migrate
# from user.user import user_bp  # Import blueprintu z katalogu `user`
# from events.event import event_bp
#
# def create_app():
#     app = Flask(__name__)
#
#     app.config.from_object('user.config.Config')  # Ładuje konfigurację z pliku `config.py`
#     CORS(app)
#     db.init_app(app)
#     migrate = Migrate(app, db)
#
#     jwt = JWTManager(app)
#     app.config['JWT_TOKEN_LOCATION'] = ['cookies']
#     app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token'
#     app.config['JWT_COOKIE_CSRF_PROTECT'] = False
#     # Rejestracja blueprintu użytkownika
#     app.register_blueprint(user_bp, url_prefix='/api/user')
#     app.register_blueprint(event_bp, url_prefix='/api/event')
#
#     return app
#
# if __name__ == '__main__':
#     app = create_app()
#     app.run(debug=True)
# from flask import Flask
# from flask_cors import CORS
# from flask_jwt_extended import JWTManager
#
# from models.models import db
# from flask_migrate import Migrate
# from user.user import user_bp  # Import blueprintu z katalogu `user`
# from events.event import event_bp
#
# def create_app():
#     app = Flask(__name__)
#
#     app.config.from_object('user.config.Config')  # Ładuje konfigurację z pliku `config.py`
#     CORS(app)
#     db.init_app(app)
#     migrate = Migrate(app, db)
#
#
#
#     jwt = JWTManager(app)
#     app.config['JWT_TOKEN_LOCATION'] = ['cookies']
#     app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token'
#     app.config['JWT_COOKIE_CSRF_PROTECT'] = False
#
#
#     # Rejestracja blueprintu użytkownika
#     app.register_blueprint(user_bp, url_prefix='/api/user')
#     app.register_blueprint(event_bp, url_prefix='/api/event')
#
#     return app
#
# if __name__ == '__main__':
#     app = create_app()
#     app.run(debug=True)


from flask import Flask, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_migrate import Migrate
from models.models import db
from user.user import user_bp
from events.event import event_bp
from course.course import course_bp

def create_app():
    app = Flask(__name__, instance_relative_config=True)

    # Ładowanie konfiguracji
    from user.config import Config  # Upewnij się, że import działa
    app.config.from_object(Config)
    # print("Loaded Config:", app.config)  # Debug: Wyświetl całą konfigurację

    # Inicjalizacja rozszerzeń
    CORS(app)
    db.init_app(app)
    migrate = Migrate(app, db)

    # Inicjalizacja JWT
    jwt = JWTManager(app)
    #
    # # Obsługa błędów JWT
    # @jwt.invalid_token_loader
    # def invalid_token_callback(callback):
    #     return jsonify({"error": "Invalid token"}), 422
    #
    # @jwt.unauthorized_loader
    # def unauthorized_callback(callback):
    #     return jsonify({"error": "Unauthorized access"}), 401

    # Rejestracja blueprintów
    app.register_blueprint(user_bp, url_prefix='/api/user')
    app.register_blueprint(event_bp, url_prefix='/api/event')
    app.register_blueprint(course_bp, url_prefix='/api/course')

    @app.route('/api/', methods=['GET'])
    def api_health():
        return jsonify({"message": "API is running!", "status": "success"}), 200

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
