from flask import jsonify, request
from app import app, db


@app.route("/add_car", methods=["POST"])
def add_car():
    if request.method == "POST":
        data = request.json  # Get car data from the request

        if not all(key in data for key in ['brand', 'model', 'license_plate']):
            return jsonify({"message": "Missing required fields."}), 400

        if not isinstance(data['brand'], str) or not isinstance(data['model'], str) or not isinstance(
                data['license_plate'], str):
            return jsonify({"message": "Invalid data types for fields."}), 400

        existing_car = db.collection('Cars').where('license_plate', '==', data['license_plate']).get()
        if existing_car:
            return jsonify({"message": "Car with this license plate already exists."}), 409

        # Extract car data from JSON
        brand = data.get('brand')
        model = data.get('model')
        license_plate = data.get('license_plate')

        try:
            # Create a new document in the 'Cars' collection
            car_ref = db.collection('Cars').document()
            car_ref.set({
                'brand': brand,
                'model': model,
                'license_plate': license_plate
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

