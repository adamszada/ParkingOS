from flask import jsonify, request
from app import app, db
from firebase_admin import auth


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


def check_ban_status(user_id):
    try:
        bans_ref = db.collection('Bans').where('user_id', '==', user_id).get()
        return len(bans_ref) > 0
    except Exception as e:
        print(f"Error checking ban status for user {user_id}: {str(e)}")
        return False


@app.route("/users", methods=["GET"])
def get_users_with_balances_and_bans():
    try:
        all_users = auth.list_users()
        users_data = []

        for user in all_users.users:
            user_data = {
                "uid": user.uid,
                "email": user.email,
                "saldo": get_user_balance(user.uid),
                "has_ban":  check_ban_status(user.uid)
            }
            users_data.append(user_data)

        return jsonify({"users": users_data}), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error retrieving users: {str(e)}"}), 500


def check_ban_status(user_id):
    try:
        bans_ref = db.collection('Bans').where('user_id', '==', user_id).get()
        return len(bans_ref) > 0
    except Exception as e:
        print(f"Error checking ban status for user {user_id}: {str(e)}")
        return False


@app.route("/ban_user", methods=["POST"])
def ban_user_from_parking():
    try:
        data = request.json

        # ban to wartość True/False
        if not all(key in data for key in ['user_id', 'parking_id', 'ban']):
            return jsonify({"message": "Missing required fields."}), 400

        user_id = data['user_id']
        parking_id = data['parking_id']
        ban = data['ban']

        ban_ref = db.collection('Bans').where('user_id', '==', user_id).where(
            'parking_id', '==', parking_id).limit(1).get()
        if ban and not ban_ref:
            db.collection('Bans').add({
                'user_id': user_id,
                'parking_id': parking_id
            })
        elif not ban and ban_ref:
            db.collection('Bans').document(ban_ref[0].id).delete()

        return jsonify({"message": "User ban status updated successfully."}), 200

    except auth.AuthError as e:
        return jsonify({"message": f"Error banning user: {str(e)}"}), 500


@app.route("/parking_history", methods=["GET"])
def parking_history():
    if request.method == "GET":
        user_id = request.args.get('user_id')
        parking_id = request.args.get('parking_id')

        if not user_id or not parking_id:
            return jsonify({"message": "Missing user_id or parking_id parameter."}), 400

        try:
            cars_history = db.collection('Cars').where(
                'owner_id', '==', user_id).get()
            cars_data = []

            for car in cars_history:
                car_data = car.to_dict()
                car_parking_history = db.collection('Tickets').where('userID', '==', user_id)\
                    .where('registration', '==', car_data['registration'])\
                    .where('parking_id', '==', parking_id)\
                    .where('realized', '==', True).get()
                if car_parking_history:
                    cars_data.append({
                        'brand': car_data['brand'],
                        'model': car_data['model'],
                        'registration': car_data['registration']
                    })

            return jsonify({"cars_history": cars_data}), 200

        except Exception as e:
            return jsonify({"message": f"Error retrieving parking history: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


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

        amount = max(round(float(amount), 2), float(0))
        # Sprawdź czy użytkownik istnieje
        user = auth.get_user_by_email(email)

        # Pobierz UID użytkownika
        user_id = user.uid

        # Pobierz aktualne saldo użytkownika
        current_balance = float(round(get_user_balance(user_id), 2))

        # Zwiększ saldo o podaną kwotę
        new_balance = amount + current_balance

        # Zapisz nowe saldo w profilu użytkownika
        auth.set_custom_user_claims(user_id, {"saldo": float(new_balance)})

        return jsonify({"message": f"Successfully topped up user balance. New balance: {new_balance}"}), 200
    except auth.AuthError as e:
        return jsonify({"message": f"Error topping up user balance: {str(e)}"}), 500


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


@app.route("/manage_balance", methods=["GET", "POST"])
def manage_balance():
    if request.method == "GET":
        owner_id = request.args.get('owner_id')

        if not owner_id:
            return jsonify({"message": "Missing owner_id parameter."}), 400

        user_ref = db.collection('Users').document(owner_id).get()
        if not user_ref.exists:
            return jsonify({"message": "User does not exist."}), 404

        user_data = user_ref.to_dict()
        current_balance = user_data.get('balance', 0)

        return jsonify({"owner_id": owner_id, "balance": current_balance}), 200

    elif request.method == "POST":
        data = request.json

        if not all(key in data for key in ['owner_id', 'amount', 'operation']):
            return jsonify({"message": "Missing required fields."}), 400

        owner_id = data['owner_id']
        amount = data['amount']
        operation = data['operation']

        if amount < 0:
            return jsonify({"message": "Amount cannot be negative."}), 400

        user_ref = db.collection('Users').document(owner_id).get()
        if not user_ref.exists:
            return jsonify({"message": "User does not exist."}), 404

        try:
            user_data = user_ref.to_dict()
            current_balance = user_data.get('balance', 0)

            if operation == "add":
                new_balance = current_balance + amount
            elif operation == "subtract":
                new_balance = current_balance - amount
                if new_balance < 0:
                    return jsonify({"message": "Insufficient funds."}), 400
            else:
                return jsonify({"message": "Invalid operation type."}), 400

            user_ref.update({"balance": new_balance})

            return jsonify({"message": "Balance updated successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error managing balance: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405
