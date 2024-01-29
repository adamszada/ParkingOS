#!/usr/bin/env python3
import os
from flask import Flask, request, jsonify, render_template, redirect, url_for
import firebase_admin
from firebase_admin import credentials, auth, firestore, storage
from dotenv import load_dotenv
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# --- main ---

@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        email = request.json['email']       
        password = request.json['password']

        try:
            user = auth.get_user_by_email(email)
            return jsonify({"message": "A user with this email already exists."}), 400
        except auth.UserNotFoundError:
            try:
                user = auth.create_user(email=email, password=password)
                return jsonify({"message": "User successfully registered."}), 200
            except auth.AuthError as e:
                return jsonify({"message": f"Error registering user: {str(e)}"}), 500

    return render_template("signup.html")  

@app.route("/login", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        email = request.json['email']       
        password=request.json['password']

        try:
            user = auth.get_user_by_email(email)
            return jsonify({"message": "User successfully logged in."}), 200
        except auth.UserNotFoundError:
            return jsonify({"message": "User with provided email does not exist."}), 400

    return render_template("login.html")  

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
        vehicle_id = data.get('vehicle_id')
        parking_id = data.get('parking_id')
        entry_date = data.get('entry_date')
        # qr_code = data.get('qr_code')
        place_id = data.get('place_id')

        try:
            # Create a new ticket document in the 'Tickets' collection
            ticket_ref = db.collection('Tickets').document()
            ticket_ref.set({
                'vehicle_id': vehicle_id,
                'parking_id': parking_id,
                'entry_date': entry_date,
                # 'exit_date': exit_date,
                # 'qr_code': qr_code,
                'place_id': place_id
            })

            return jsonify({"message": "Ticket added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding ticket: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

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

from routes import cars, parking, parkingSpace

if __name__ == "__main__":
    app.run(port=8080, host="0.0.0.0", debug=True)
