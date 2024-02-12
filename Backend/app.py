#!/usr/bin/env python3
import os
from flask import Flask, request, jsonify, render_template, redirect, url_for
import firebase_admin
from firebase_admin import credentials, auth, firestore, storage
from dotenv import load_dotenv
from flask_cors import CORS
import re



app = Flask(__name__)
CORS(app)
cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# --- main ---


def is_valid_email(email):
    pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    return re.match(pattern, email)


@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        email = request.json['email']       
        password = request.json['password']
        confirm_password = request.json['confirmPassword']

        if password != confirm_password:
            return jsonify({"message": "Passwords do not match."}), 400

        if not is_valid_email(email):
            return jsonify({"message": "Invalid email format."}), 400

        try:
            user = auth.get_user_by_email(email)
            return jsonify({"message": "A user with this email already exists."}), 400
        except auth.UserNotFoundError:
            try:
                user = auth.create_user(email=email, password=password)
                auth.set_custom_user_claims(user.uid, {"saldo": float(0.0)})
                return jsonify({"message": "User successfully registered."}), 200
            except auth.AuthError as e:
                return jsonify({"message": f"Error registering user: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/login", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        email = request.json['email']       
        password=request.json['password']

        if not is_valid_email(email):
            return jsonify({"message": "Invalid email format."}), 400
        # Todo logoawnie nie działa, hasło jest nie sprwdzane!!!!!!!!!!
        try:
            user = auth.get_user_by_email(email)
            return jsonify({"message": "User successfully logged in.",
                            "user_id": user.uid}), 200
        except auth.UserNotFoundError:
            return jsonify({"message": "User with provided email does not exist."}), 400

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/check_user", methods=["POST"])
def check_user():
    if request.method == "POST":
        email = request.json.get('email')

        if not is_valid_email(email):
            return jsonify({"message": "Invalid email format."}), 400

        try:
            # Attempt to get the user by email
            user = auth.get_user_by_email(email)
            return jsonify({"exists": True}), 200
        except auth.UserNotFoundError:
            return jsonify({"exists": False}), 200
        except Exception as e:
            return jsonify({"message": f"Error checking user: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/reset_password", methods=["POST"])
def reset_password():
    if request.method == "POST":
        email = request.json.get('email')

        try:
            auth.generate_password_reset_link(email)
            return jsonify({"message": "Password reset link sent successfully."}), 200

        except auth.UserNotFoundError:
            return jsonify({"message": "User with provided email does not exist."}), 400
        except Exception as e:
            return jsonify({"message": f"Error sending password reset link: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/change_email", methods=["POST"])
def change_email():
    if request.method == "POST":
        old_email = request.json.get('old_email')
        new_email = request.json.get('new_email')

        try:
            user = auth.get_user_by_email(old_email)
            auth.update_user(user.uid, email=new_email)
            return jsonify({"message": "Email updated successfully."}), 200

        except auth.UserNotFoundError:
            return jsonify({"message": "User with provided old email does not exist."}), 400
        except Exception as e:
            return jsonify({"message": f"Error updating email: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/change_password", methods=["POST"])
def change_password():
    if request.method == "POST":
        email = request.json.get('email')
        new_password = request.json.get('new_password')

        try:
            user = auth.get_user_by_email(email)
            auth.update_user(user.uid, password=new_password)
            return jsonify({"message": "Password changed successfully."}), 200

        except auth.UserNotFoundError:
            return jsonify({"message": "User with provided email does not exist."}), 400
        except Exception as e:
            return jsonify({"message": f"Error changing password: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/add_ticket", methods=["POST"])
def add_ticket():
    if request.method == "POST":
        data = request.json  # Get ticket data from the request

        # Extract ticket data from JSON
        userID = data.get('userID')
        registration = data.get('registration')
        parking_id = data.get('parking_id')
        entry_date = data.get('entry_date')
        # qr_code = data.get('qr_code')
        # Todo generate QR!!!!!!!!

        floor, parkingSpotNumber = generate_parkingSpot(parking_id)
        if floor == -1 and parkingSpotNumber == -1:
            error_msg = "All spots are already taken"
            return jsonify({"message": f"Error adding ticket: {str(error_msg)}"}), 500
        try:
            # Create a new ticket document in the 'Tickets' collection
            ticket_ref = db.collection('Tickets').document()
            ticket_ref.set({
                'userID': userID,
                'registration': registration,
                'parking_id': parking_id,
                'entry_date': entry_date,
                'realized': False,
                'exit_date': None,
                'QR': None,
                'floor': floor,
                'parkingSpotNumber': parkingSpotNumber,
                'moneyDue': 0
            })

            ticket_id = ticket_ref.id
            # Pobierz nowo utworzony bilet z bazy danych
            new_ticket = ticket_ref.get().to_dict()

            return jsonify({
                "message": "Ticket added successfully.",
                "ticket_id": ticket_id,
                "ticket": new_ticket
            }), 200

        except Exception as e:
            return jsonify({"message": f"Error adding ticket: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


def generate_parkingSpot(parkingID):
    parking_ref = db.collection('ParkingLots').document(parkingID)
    parking_doc = parking_ref.get().to_dict()

    floors = parking_doc['floors']
    parking_spaces_per_floor = parking_doc['spots_per_floor']
    parking_spaces = {floor: [False] * parking_spaces_per_floor for floor in range(1, floors + 1)}

    tickets_query = db.collection('Tickets').where("parking_id", "==", parkingID).where("realized", "==", False).stream()
    for ticket_doc in tickets_query:
        ticket_data = ticket_doc.to_dict()
        ticket_floor = ticket_data['floor']
        ticket_spot = ticket_data['parkingSpotNumber']
        parking_spaces[ticket_floor][ticket_spot-1] = True

    for floor in parking_spaces.keys():
        for spot in range(len(parking_spaces[floor])):
            if not parking_spaces[floor][spot]:
                return floor, spot+1

    return -1, -1




@app.route("/tickets", methods=["GET"])
def get_all_tickets():
    try:
        # Pobierz wszystkie bilety z kolekcji 'Tickets'
        tickets_query = db.collection('Tickets').stream()

        tickets_data = []
        for ticket_doc in tickets_query:
            ticket_data = ticket_doc.to_dict()
            ticket_data['id'] = ticket_doc.id
            tickets_data.append(ticket_data)

        return jsonify({"tickets": tickets_data}), 200

    except Exception as e:
        return jsonify({"message": f"Error retrieving tickets: {str(e)}"}), 500


@app.route("/update_exit_date/<ticket_id>", methods=["PATCH"])
def update_exit_date(ticket_id):
    if request.method == "PATCH":
        data = request.json  
        exit_date = data.get('exit_date')

        try:
            ticket_ref = db.collection('Tickets').document(ticket_id)
            ticket_ref.update({'exit_date': exit_date})

            return jsonify({"message": "Exit date updated successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error updating exit date: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

from routes import cars, parking, parkingSpace, clear_database, statistics

@app.route("/delete_all_users", methods=["POST"])
def delete_all_users():
    try:
        # Pobierz listę wszystkich użytkowników
        all_users = auth.list_users()

        # Iteracyjnie usuń każdego użytkownika
        for user in all_users.users:
            auth.delete_user(user.uid)

        return {"message": "All users deleted successfully."}, 200

    except Exception as e:
        return {"message": f"Error deleting users: {str(e)}"}, 500


if __name__ == "__main__":
    app.run(port=8080, host="0.0.0.0", debug=True)
