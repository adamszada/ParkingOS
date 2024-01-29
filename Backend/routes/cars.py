from flask import jsonify, request
from app import app, db


@app.route("/add_car", methods=["POST"])
def add_car():
    if request.method == "POST":
        data = request.json  # Get car data from the request

        if not all(key in data for key in ['brand', 'model', 'registration', 'owner_id']):
            return jsonify({"message": "Missing required fields."}), 400

        if not all(isinstance(data[key], str) for key in ['brand', 'model', 'registration', 'owner_id']):
            return jsonify({"message": "Invalid data types for fields."}), 400

        existing_car = db.collection('Cars').where('registration', '==', data['registration']).get()
        if existing_car:
            return jsonify({"message": "Car with this registration already exists."}), 409

        # Extract car data from JSON
        brand = data.get('brand')
        model = data.get('model')
        registration = data.get('registration')
        owner_id = data.get('owner_id')

        try:
            # Create a new document in the 'Cars' collection
            car_ref = db.collection('Cars').document()
            car_ref.set({
                'brand': brand,
                'model': model,
                'registration': registration,
                'owner_id': owner_id
            })
            return jsonify({"message": "Car added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding car: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_cars", methods=["GET"])
def get_cars():
    if request.method == "GET":
        try:
            cars_collection = db.collection('Cars').stream()

            cars_data = []
            for car_doc in cars_collection:
                carID = car_doc.id
                car_data = car_doc.to_dict()
                car_data['id'] = carID
                cars_data.append(car_data)

            return jsonify({"cars": cars_data}), 200

        except Exception as e:
            return jsonify({"message": f"Error retrieving cars: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_cars_by_owner/<owner_id>", methods=["GET"])
def get_cars_by_owner(owner_id):
    if request.method == "GET":
        try:
            # Pobierz samochody danego właściciela na podstawie owner_id
            cars_query = db.collection('Cars').where('owner_id', '==', owner_id).get()

            cars_list = []
            for car in cars_query:
                car_data = car.to_dict()
                cars_list.append({
                    'brand': car_data.get('brand'),
                    'model': car_data.get('model'),
                    'registration': car_data.get('registration'),
                    'owner_id': car_data.get('owner_id')
                })

            return jsonify({"cars": cars_list}), 200

        except Exception as e:
            return jsonify({"message": f"Error fetching cars: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_car_by_registration/<registration>", methods=["GET"])
def get_car_by_registration(registration):
    if request.method == "GET":
        try:
            # Pobierz informacje o samochodzie na podstawie numeru rejestracyjnego
            car_query = db.collection('Cars').where('registration', '==', registration).get()

            car_data = None
            for car in car_query:
                car_data = car.to_dict()

            if car_data:
                return jsonify({"car": {
                    'brand': car_data.get('brand'),
                    'model': car_data.get('model'),
                    'registration': car_data.get('registration'),
                    'owner_id': car_data.get('owner_id')
                }}), 200
            else:
                return jsonify({"message": "Car not found."}), 404

        except Exception as e:
            return jsonify({"message": f"Error fetching car: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405
