#!/usr/bin/env python3
import os
from flask import Flask, request, jsonify, render_template, redirect, url_for
import firebase_admin
from firebase_admin import credentials, auth, firestore
from dotenv import load_dotenv

app = Flask(__name__)

cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# --- main ---

@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        email = request.json['email']       
        password=request.json['password']

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

if __name__ == "__main__":
    app.run(port=8080, host="0.0.0.0")
