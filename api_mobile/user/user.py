import bcrypt
from flask import Blueprint, request, jsonify, make_response
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from flask_login import login_manager
from flask_jwt_extended import set_access_cookies,unset_jwt_cookies
from models.models import db, User
from datetime import datetime


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

    if not data or not data.get('email') or not data.get('password') or not data.get('email'):
        return jsonify({"error": "Invalid input"}), 400

    if User.query.filter_by(email=data['email']).first() or User.query.filter_by(phone=data['phone']).first():
        return jsonify({"error": "User already exists"}), 400

    # Hash the password using bcrypt
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), salt)

    # Create a new user with hashed password
    new_user = User(
        first_name=data['first_name'],
        last_name =data['last_name'],
        joined_at = datetime.now(),
        email=data['email'],
        phone=data['phone'],
        password_hash=hashed_password  # Save hashed password as binary
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully!"}), 201




@user_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    # Validate input
    if not data or not data.get('email') or not data.get('password'):
        return jsonify({"error": "Invalid input"}), 400

    # Fetch user
    user = User.query.filter_by(email=data['email']).first()
    if not user or not user.check_password(data['password']):
        return jsonify({"error": "Invalid email or password"}), 401

    # Generate JWT access token
    access_token = create_access_token(identity=str(user.user_id))  # Zamieniamy na string

    # Create response
    response = jsonify({"message": "Login successful"})
    set_access_cookies(response, access_token)

    return response, 200

@user_bp.route('/logout', methods=['POST'])
def logout():
    # Tworzymy odpowiedź
    response = jsonify({"message": "Logout successful"})

    # Usuwamy ciasteczka JWT
    unset_jwt_cookies(response)

    return response, 200



@user_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    # Retrieve the identity of the user (usually user ID)

    current_user_id = get_jwt_identity()
    if not current_user_id:
        return jsonify({"error": "Unauthorized"}), 401
    # Example response (you can access the database using the user ID)
    return jsonify({
        "message": "You are accessing a protected route!",
        "user_id": current_user_id
    }), 200




@user_bp.route('/confirmed', methods=['GET'])
def not_confirmed_user():

    users = User.query.filter_by(user_confirmed='false')

    return jsonify([
        {
            "user_id":user.id,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "email":user.email,
            "phone":user.phone,
            "confirmed":user.user_confirmed,
        }
        for user in users
    ])


@user_bp.route('/edit_user', methods=['PUT'])
@jwt_required()  # Używamy dekoratora do weryfikacji tokena JWT
def edit_user():
    # Pobierz dane z zapytania
    data = request.get_json()


    if not data:
        return jsonify({"error": "Invalid input"}), 400


    user_id = get_jwt_identity()


    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404


    if 'email' in data:
        if not isinstance(data['email'], str) or '@' not in data['email']:
            return jsonify({"error": "Invalid email format"}), 400
        user.email = data['email']

    if 'first_name' in data:
        if not isinstance(data['first_name'], str) or len(data['first_name']) < 2:
            return jsonify({"error": "Invalid first name format"}), 400
        user.first_name = data['first_name']

    if 'last_name' in data:
        if not isinstance(data['last_name'], str) or len(data['last_name']) < 2:
            return jsonify({"error": "Invalid last name format"}), 400
        user.last_name = data['last_name']

    if 'phone' in data:
        if not isinstance(data['phone'], (int, str)) or len(str(data['phone'])) != 11:
            return jsonify({"error": "Invalid phone format"}), 400
        user.phone = data['phone']




    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Failed to update user data", "details": str(e)}), 500

    return jsonify({"message": "User data updated successfully"}), 200
