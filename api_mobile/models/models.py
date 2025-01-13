import enum

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Enum

import bcrypt

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'user'  # Explicit table name
    user_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    phone = db.Column(db.Numeric(11), unique=True, nullable=False)
    joined_at = db.Column(db.DateTime, nullable=False)
    admin = db.Column(db.Integer, nullable=False, default=False)
    password_hash = db.Column(db.LargeBinary(60), nullable=False)  # Change to store binary data
    user_confirmed = db.Column(db.Boolean, nullable=False, default=True)

    def set_password(self, password):
        # Hash the password using bcrypt
        salt = bcrypt.gensalt()
        self.password_hash = bcrypt.hashpw(password.encode('utf-8'), salt)

    def check_password(self, password):
        # Check the password using bcrypt
        return bcrypt.checkpw(password.encode('utf-8'), self.password_hash)

class Event(db.Model):
    __tablename__ = 'event'  # Ensure this table name is set to 'event'
    event_id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(80), nullable=False)
    event_date = db.Column(db.DateTime, nullable=False)
    place = db.Column(db.String(80), nullable=False)
    type = db.Column(db.String(80), nullable=False)
    description = db.Column(db.Text, nullable=False)
    person_limit = db.Column(db.Integer, nullable=False)
    event_confirmed = db.Column(db.Boolean, nullable=False, default = True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)


class Participation(db.Model):
    __tablename__ = 'participation'  # Make sure table name is correct
    participation_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)
    event_id = db.Column(db.Integer, db.ForeignKey('event.event_id'), nullable=False)
    status = db.Column(
        Enum('Participation', 'reserve', 'cancelled', name='status_enum'), nullable=False
    )
    signed_data = db.Column(db.Text, nullable=False)

class Courses(db.Model):
    __tablename__ = 'courses'  # Make sure table name is correct
    course_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)
    course_type = db.Column(db.String(80), nullable=False)
    obtained_date = db.Column(db.DateTime, nullable=False)
    expiry_date = db.Column(db.DateTime, nullable=False)