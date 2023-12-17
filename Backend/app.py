#!/usr/bin/env python3
import os
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, auth, db as firebase_db
from dotenv import load_dotenv


app = Flask(__name__)
load_dotenv()

person = {
    "is_logged_in": False,
    "email": "",
    "uid": "",
    "name": "",
}

cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': os.getenv('DATABASE_URL') 
})
ref = firebase_db.reference('/')

ref.child('users').child(person['uid']).set({
    'name': person['name'],
    'email': person['email']
})

# --- main ---


@app.route("/welcome")
def welcome():
    if person["is_logged_in"]:
        return render_template("welcome.html", email=person["email"], name=person["name"])
    else:
        return redirect(url_for('login'))

# Logowanie
@app.route("/result", methods=["POST", "GET"])
def result():
    if request.method == "POST":
        result = request.form
        email = result["email"]
        password = result["pass"]
        try:
            user = auth.sign_in_with_email_and_password(email, password)
            global person
            person["is_logged_in"] = True
            person["email"] = user["email"]
            person["uid"] = user["localId"]
            user_data = firebase_db.reference('users').child(person["uid"]).get()
            person["name"] = user_data.get("name", "")
            return redirect(url_for('welcome'))
        except:
            return redirect(url_for('login'))
    else:
        if person["is_logged_in"]:
            return redirect(url_for('welcome'))
        else:
            return redirect(url_for('login'))

@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        result = request.form
        email = result["email"]
        password = result["pass"]
        name = result["name"]
        try:
            auth.create_user_with_email_and_password(email, password)
            user = auth.sign_in_with_email_and_password(email, password)
            global person
            person["is_logged_in"] = True
            person["email"] = user["email"]
            person["uid"] = user["localId"]
            person["name"] = name
            data = {"name": name, "email": email}
            firebase_db.reference('users').child(person["uid"]).set(data)
            return redirect(url_for('welcome'))
        except:
            return redirect(url_for('register'))
    else:
        if person["is_logged_in"]:
            return redirect(url_for('welcome'))
        else:
            return redirect(url_for('register'))


app.run(port=8080, host='0.0.0.0')