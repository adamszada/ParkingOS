from flask import jsonify, request
from app import app, db
from firebase_admin import  auth

@app.route("/get_users", methods=["GET"])
def get_users():
    if request.method == "GET":
        try:
            cars_collection = db.collection('Users').stream()

            cars_data = []
            for car_doc in cars_collection:
                car_data = car_doc.to_dict()
                cars_data.append(car_data)

            return jsonify({"users": cars_data}), 200

        except Exception as e:
            return jsonify({"message": f"Error retrieving cars: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405



@app.route("/users", methods=["GET"])
def get_all_users_with_balances():
    try:
        all_users = auth.list_users()
        users_data = []

        for user in all_users.users:
            user_data = {
                "uid": user.uid,
                "email": user.email,
                "saldo": get_user_balance(user.uid)  # Pobierz saldo użytkownika
            }
            users_data.append(user_data)

        return jsonify({"users": users_data}), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error retrieving users: {str(e)}"}), 500


@app.route("/get_user/<email>", methods=["GET"])
def get_user_by_email(email):
    try:
        if not email:
            return jsonify({"message": "Email is required."}), 400

        # Sprawdź czy użytkownik istnieje
        user = auth.get_user_by_email(email)

        # Zwróć informacje o użytkowniku
        user_data = {
            "uid": user.uid,
            "email": user.email,
            "saldo": get_user_balance(user.uid)  # Pobierz saldo użytkownika
        }

        return jsonify(user_data), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error getting user by email: {str(e)}"}), 500


@app.route("/topup_id", methods=["POST"])
def top_up_balance_id():
    try:
        # Pobierz dane z żądania
        user_id = request.json.get('userId')
        amount = request.json.get('amount')

        if not user_id or not amount:
            return jsonify({"message": "User ID and amount are required."}), 400

        # Sprawdź czy użytkownik istnieje
        user = auth.get_user(user_id)

        # Pobierz aktualne saldo użytkownika
        current_balance = get_user_balance(user_id)

        # Zwiększ saldo o podaną kwotę
        new_balance = current_balance + amount

        # Zapisz nowe saldo w profilu użytkownika
        auth.set_custom_user_claims(user_id, {"saldo": new_balance})

        return jsonify({"message": f"Successfully topped up user balance. New balance: {new_balance}"}), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error topping up user balance: {str(e)}"}), 500

@app.route("/topup", methods=["POST"])
def top_up_balance():
    try:
        # Pobierz dane z żądania
        email = request.json.get('email')
        amount = request.json.get('amount')

        if not email or not amount:
            return jsonify({"message": "Email and amount are required."}), 400


        # Sprawdź czy użytkownik istnieje
        user = auth.get_user_by_email(email)

        # Pobierz UID użytkownika
        user_id = user.uid

        # Pobierz aktualne saldo użytkownika
        current_balance = get_user_balance(user_id)

        # Zwiększ saldo o podaną kwotę
        new_balance = amount #current_balance + amount

        # Zapisz nowe saldo w profilu użytkownika
        auth.set_custom_user_claims(user_id, {"saldo": str(new_balance)})

        return jsonify({"message": f"Successfully topped up user balance. New balance: {new_balance}"}), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error topping up user balance: {str(e)}"}), 501


def get_user_balance(uid):
    try:
        # Pobierz użytkownika na podstawie UID
        user = auth.get_user(uid)
        custom_claims = user.custom_claims
        if custom_claims and "saldo" in custom_claims:
            saldo = custom_claims["saldo"]
            return saldo
        else:
            return 0  #
    except auth.AuthError as e:
        print(f"Error retrieving user balance: {str(e)}")
        return 0  # W przypadku błędu, zwróć 0


