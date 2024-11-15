from flask import Blueprint, jsonify, request
from flask_jwt_extended import get_jwt_identity, jwt_required
from sqlalchemy import desc

from models.models import Event, db ,Parcipitation
import datetime

event_bp = Blueprint('event', __name__)



@event_bp.route('/add', methods=['POST'])
def create_event():
    data = request.get_json()

    if not data or not data.get('name') or not data.get("date") or not data.get("place")or not data.get("person_limit") or not data.get("type") or not data.get("description"):
        return jsonify({"error": "Missing data"}), 400

    new_event = Event(
        name=data['name'],
        date=data['date'],
        place=data['place'],
        person_limit=data['person_limit'],
        type=data['type'],
        description=data['description']

    )

    db.session.add(new_event)
    db.session.commit()

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
    events = Event.query.order_by(desc(Event.date)).all()

    return jsonify([
        {
            "id":event.id,
            "name": event.name,
            "date": event.date,
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
    user_id = get_jwt_identity()
    event_id = data['event_id']
    event = Event.query.filter_by(id=event_id).one
    event = db.session.query(Event).filter_by(id=event_id).first()

    # Sprawdzenie, czy event istnieje
    if event:
        person_limit = event.person_limit



    event = Event.query.filter_by(id=event_id).first()
    if not event:
        return jsonify({"error": "Event not found"}), 404

    existing_parcipation = Parcipitation.query.filter_by(user_id=user_id, event_id=event_id).first()
    if existing_parcipation:
        return jsonify({"error": "Parcipitation already exists"}), 400


    parcripation_number = Parcipitation.query.filter_by(user_id=user_id, event_id=event_id).all()
    i = 0
    for parcipitation in parcripation_number:
        i=+1

    if i < person_limit:
        status = 'Participation'
    else:
        status ='reserve'


    signed_data = datetime.datetime.now()
    parcipation = Parcipitation(user_id=user_id, event_id=event_id, signed_data = signed_data, status=status)
    db.session.add(parcipation)
    db.session.commit()
    return jsonify({"success": True}), 201

@event_bp.route('/cancel', methods=['DELETE'])
def cancel_parcipitation():
    data = request.get_json()
    event_id = data['event_id']
    user_id = get_jwt_identity()
    obj = Parcipitation.query.filter_by(user_id=user_id).one()
    db.session.delete(obj)
    db.session.commit()

    return jsonify({"success": True}), 200