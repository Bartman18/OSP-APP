import enum

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Enum

import bcrypt

db = SQLAlchemy()


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.LargeBinary(60), nullable=False)  # Change to store binary data

    def set_password(self, password):
        # Hash the password using bcrypt
        salt = bcrypt.gensalt()
        self.password_hash = bcrypt.hashpw(password.encode('utf-8'), salt)

    def check_password(self, password):
        # Check the password using bcrypt
        return bcrypt.checkpw(password.encode('utf-8'), self.password_hash)

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    place = db.Column(db.String(80), nullable=False)
    type = db.Column(db.String(80),  nullable=False)
    description = db.Column(db.Text, nullable=False)
    person_limit = db.Column(db.Integer, nullable=False)
    # confirmed = db.Column(db.Boolean, nullable=False)
    # user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)


class Parcipitation(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    event_id = db.Column(db.Integer, db.ForeignKey('event.id'), nullable=False)
    status = db.Column(
        Enum('Participation','reserve','cancelled'), nullable=False)
    signed_data = db.Column(db.Text, nullable=False)


# 8. Tabela attendance (frekwencja na spotkaniach/szkoleniach)

#role id_roli nazwa roli enum