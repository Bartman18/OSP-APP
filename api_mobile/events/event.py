from flask import Blueprint, jsonify, request
from flask_jwt_extended import get_jwt_identity, jwt_required
from sqlalchemy import desc
import logging

from models.models import Event, db ,Participation
import datetime

event_bp = Blueprint('event', __name__)






@event_bp.route('/create', methods=['POST'])
@jwt_required()
def create_event():
    data = request.get_json()
    errors = []
    if not data.get('title') or not isinstance(data['title'], str):
        errors.append("Title is required and must be a string.")
    if not data.get('event_date'):
        errors.append("Event date is required.")
    else:
        try:
            datetime.datetime.strptime(data['event_date'], "%Y-%m-%d %H:%M:%S")
        except ValueError:
            errors.append("Invalid date format. Use YYYY-MM-DD HH:MM:SS.")

    if not data.get('place') or not isinstance(data['place'], str):
        errors.append("Place is required and must be a string.")
    if not data.get('type') or not isinstance(data['type'], str):
        errors.append("Type is required and must be a string.")
    if not data.get('description') or not isinstance(data['description'], str):
        errors.append("Description is required and must be a string.")
    if not data.get('person_limit') or not isinstance(data['person_limit'], int):
        errors.append("Person limit is required and must be an integer.")

    if errors:
        return jsonify({"errors": errors}), 400

    try:
        event_date = datetime.datetime.strptime(data['event_date'], "%Y-%m-%d %H:%M:%S")
        new_event = Event(
            title=data['title'],
            event_date=event_date,
            place=data['place'],
            type=data['type'],
            description=data['description'],
            person_limit=data['person_limit'],
            event_confirmed=True,
            user_id=get_jwt_identity()
        )
        db.session.add(new_event)
        db.session.commit()
        return jsonify({"message": "Event created successfully!"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

    return jsonify({"success": True}), 201


@event_bp.route('/<int:event_id>', methods=['GET'])
def get_event(event_id):
    event = Event.query.get(event_id)
    if event is None:
        return jsonify({"error": "Event not found"}), 404
    return jsonify({
        "id": event.id,
        "name": event.name,
        "date": event.date,
        "place": event.place,
        "person_limit": event.person_limit,
        "type": event.type,
        "description": event.description
    })


@event_bp.route('/all_events', methods=['GET'])
def get_selection():
    events = Event.query.order_by(desc(Event.event_date)).all()

    return jsonify([
        {
            "event_id":event.event_id,
            "title": event.title,
            "event_date": event.event_date,
            "place": event.place,
            "person_limit": event.person_limit,
            "type": event.type,
            "description": event.description
        }
        for event in events
    ])



@event_bp.route('/<int:event_id>', methods=['DELETE'])
def delete_event(event_id):
    obj= Event.query.filter_by(id=event_id).one()
    db.session.delete(obj)
    db.session.commit()
    return jsonify({"success": True}), 200


@event_bp.route('/signup', methods=['POST'])
@jwt_required()
def signup():
    data = request.get_json()

    # Pobranie user_id z tokena JWT
    user_id = get_jwt_identity()

    # Walidacja danych wejściowych
    if not data or 'event_id' not in data:
        return jsonify({"error": "event_id is required"}), 400

    event_id = data['event_id']

    # Pobranie wydarzenia z bazy
    event = Event.query.filter_by(event_id=event_id).first()
    if not event:
        return jsonify({"error": "Event not found"}), 404

    # Sprawdzenie, czy użytkownik już jest zapisany na wydarzenie
    existing_participation = Participation.query.filter_by(user_id=user_id, event_id=event_id).first()
    if existing_participation:
        return jsonify({"error": "You are already signed up for this event"}), 400

    # Zliczenie uczestników z potwierdzonym statusem "Participation"
    confirmed_participations = Participation.query.filter_by(event_id=event_id, status='Participation').count()

    # Decyzja o statusie użytkownika
    if confirmed_participations < event.person_limit:
        status = 'Participation'
    else:
        status = 'reserve'

    # Tworzenie nowego rekordu uczestnictwa
    signed_date = datetime.datetime.now()
    participation = Participation(
        user_id=user_id,
        event_id=event_id,
        signed_data=signed_date,
        status=status
    )
    db.session.add(participation)
    db.session.commit()

    return jsonify({"success": True, "status": status}), 201

@event_bp.route('/cancel', methods=['DELETE'])
def cancel_parcipitation():
    data = request.get_json()
    event_id = data['event_id']
    user_id = get_jwt_identity()
    obj = Parcipitation.query.filter_by(user_id=user_id).one()
    db.session.delete(obj)
    db.session.commit()

    return jsonify({"success": True}), 200



@event_bp.route('/count', methods=['POST'])  # Zmiana na POST dla poprawnej obsługi body JSON
def count_users():
    data = request.get_json()

    # Sprawdzanie, czy `event_id` jest obecny w danych wejściowych
    if not data or 'event_id' not in data:
        return jsonify({"error": "event_id is required"}), 400

    event_id = data['event_id']

    # Pobieranie wszystkich udziałów w wydarzeniu
    participations = Participation.query.filter_by(event_id=event_id).all()
    event = Event.query.filter_by(event_id=event_id).first()


    # Liczenie osób z potwierdzonym udziałem
    user_saved = sum(1 for participation in participations if participation.status == 'Participation')


    return jsonify({"user_register": user_saved,
                    "person_limit" :event.person_limit}), 200



@event_bp.route('/date', methods=['GET'])
def event_date():
    events = Event.query.order_by(desc(Event.event_date)).all()

    if not events:
        return jsonify({"error": "Event not found"}), 404





    return jsonify([
        {
            "event_id": event.event_id,
            "event_date": event.event_date,


        }
        for event in events
    ])



@event_bp.route('/count_participations', methods=['GET'])
@jwt_required()
def count_participations():
    user_id = get_jwt_identity()

    # Pobieramy wszystkie uczestnictwa użytkownika
    participations = Participation.query.filter_by(user_id=user_id).all()

    # Liczymy tylko te, które mają status 'Participation'
    participation_count = sum(1 for p in participations if p.status == 'Participation')

    return jsonify({'participations': participation_count}), 200
