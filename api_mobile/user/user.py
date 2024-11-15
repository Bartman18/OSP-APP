import bcrypt
from flask import Blueprint, request, jsonify, make_response
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from flask_login import login_manager


from models.models import db, User

user_bp = Blueprint('user', __name__)


# @login_manager.user_loader
# def load_user(user_id):
#     return User.get(user_id)


@user_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get(user_id)
    if user is None:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "password_hash": user.password_hash
    })


@user_bp.route('/register', methods=['POST'])
def register_user():
    data = request.get_json()

    if not data or not data.get('username') or not data.get('password') or not data.get('email'):
        return jsonify({"error": "Invalid input"}), 400

    if User.query.filter_by(username=data['username']).first() or User.query.filter_by(email=data['email']).first():
        return jsonify({"error": "User already exists"}), 400

    # Hash the password using bcrypt
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), salt)

    # Create a new user with hashed password
    new_user = User(
        username=data['username'],
        email=data['email'],
        password_hash=hashed_password  # Save hashed password as binary
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully!"}), 201


from flask_jwt_extended import set_access_cookies

@user_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    # Validate input data
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({"error": "Invalid input"}), 400

    # Fetch the user from the database
    user = User.query.filter_by(username=data['username']).first()

    # Check if user exists and verify password
    if not user or not user.check_password(data['password']):
        return jsonify({"error": "Invalid username or password"}), 401

    # Generate access token
    access_token = create_access_token(identity=user.id)

    # Create a response object
    response = jsonify({"message": "Login successful"})
    set_access_cookies(response, access_token)  # Automatyczne ustawienie tokena w ciasteczku

    return response


@user_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    # Retrieve the identity of the user (usually user ID)
    current_user_id = get_jwt_identity()

    # Example response (you can access the database using the user ID)
    return jsonify({
        "message": "You are accessing a protected route!",
        "user_id": current_user_id
    }), 200