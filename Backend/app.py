#!/usr/bin/env python3
import json
import os
from flask import Flask, request, jsonify, render_template, redirect, url_for
import firebase_admin
from firebase_admin import credentials, auth, firestore, storage
import pyrebase
from dotenv import load_dotenv
from flask_cors import CORS
import re


config = {
  "apiKey": "AIzaSyAN-uMaHsuuFaqVx3TAl6IyqCHqAccM7nM",
  "authDomain": "bazadanych-59e48.firebaseapp.com",
  "databaseURL": "https://bazadanych-59e48-default-rtdb.europe-west1.firebasedatabase.app",
  "storageBucket": "bazadanych-59e48.appspot.com",
  "serviceAccount": "credentials.json"
}


app = Flask(__name__)
CORS(app)
cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
pb = pyrebase.initialize_app(config)


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
        password = request.json['password']

        if not is_valid_email(email):
            return jsonify({"message": "Invalid email format."}), 400

        try:
            user = pb.auth().sign_in_with_email_and_password(email, password)
            print(user)
            return jsonify({"message": "User successfully logged in.",
                            "user_id": user['localId']}), 200
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













from routes import cars, parking, parkingSpace, clear_database, statistics, tickets

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
