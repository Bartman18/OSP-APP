from flask import Blueprint, jsonify, request
from flask_jwt_extended import get_jwt_identity, jwt_required
from models.models import Courses, db
from datetime import datetime

course_bp = Blueprint('course', __name__)

@course_bp.route('/add', methods=['POST'])
@jwt_required()
def add_course():
    data = request.get_json()
    user_id = get_jwt_identity()

    if not data or not data.get('course_type') or not data.get('obtained_date') or not data.get('expiry_date'):
        return jsonify({"error": "Missing data"}), 400

    try:
        obtained_date = datetime.strptime(data['obtained_date'], '%Y-%m-%d')
        expiry_date = datetime.strptime(data['expiry_date'], '%Y-%m-%d')
    except ValueError:
        return jsonify({"error": "Invalid date format. Use YYYY-MM-DD."}), 400

    new_course = Courses(
        user_id=user_id,
        course_type=data['course_type'],
        obtained_date=obtained_date,
        expiry_date=expiry_date
    )

    db.session.add(new_course)
    db.session.commit()

    return jsonify({"success": True, "course_id": new_course.course_id}), 201


@course_bp.route('/<int:course_id>', methods=['GET'])
@jwt_required()
def get_course(course_id):
    course = Courses.query.get(course_id)
    if not course:
        return jsonify({"error": "Course not found"}), 404

    return jsonify({
        "course_id": course.course_id,
        "user_id": course.user_id,
        "course_type": course.course_type,
        "obtained_date": course.obtained_date.strftime('%Y-%m-%d'),
        "expiry_date": course.expiry_date.strftime('%Y-%m-%d')
    })


@course_bp.route('/all', methods=['GET'])
@jwt_required()
def get_all_courses():
    user_id = get_jwt_identity()
    courses = Courses.query.filter_by(user_id=user_id).order_by(Courses.obtained_date.desc()).all()

    return jsonify([
        {
            "course_id": course.course_id,
            "course_type": course.course_type,
            "obtained_date": course.obtained_date.strftime('%Y-%m-%d'),
            "expiry_date": course.expiry_date.strftime('%Y-%m-%d')
        }
        for course in courses
    ])


@course_bp.route('/<int:course_id>', methods=['DELETE'])
@jwt_required()
def delete_course(course_id):
    user_id = get_jwt_identity()
    course = Courses.query.filter_by(course_id=course_id, user_id=user_id).first()

    if not course:
        return jsonify({"error": "Course not found or not authorized to delete"}), 404

    db.session.delete(course)
    db.session.commit()

    return jsonify({"success": True}), 200


@course_bp.route('/<int:course_id>', methods=['PUT'])
@jwt_required()
def update_course(course_id):
    user_id = get_jwt_identity()
    course = Courses.query.filter_by(course_id=course_id, user_id=user_id).first()

    if not course:
        return jsonify({"error": "Course not found or not authorized to edit"}), 404

    data = request.get_json()

    if 'course_type' in data:
        course.course_type = data['course_type']

    if 'obtained_date' in data:
        try:
            course.obtained_date = datetime.strptime(data['obtained_date'], '%Y-%m-%d')
        except ValueError:
            return jsonify({"error": "Invalid obtained_date format. Use YYYY-MM-DD."}), 400

    if 'expiry_date' in data:
        try:
            course.expiry_date = datetime.strptime(data['expiry_date'], '%Y-%m-%d')
        except ValueError:
            return jsonify({"error": "Invalid expiry_date format. Use YYYY-MM-DD."}), 400

    db.session.commit()

    return jsonify({"success": True}), 200
