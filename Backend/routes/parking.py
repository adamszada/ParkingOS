from flask import jsonify, request
from app import app, db


@app.route("/add_parking", methods=["POST"])
def add_parking():
    if request.method == "POST":

        data = request.json

        name = data.get("name")
        discount = data.get("discount")
        freeHour = data.get("free hour")
        pricePerH = data.get("price per hour")
        pricePerD = data.get("price per day")
        pricePerM = data.get("price per month")
        address = data.get("address")
        openingTime = data.get("opening time")
        closingTime = data.get("closing time")
        lon = data.get("lon")
        lat = data.get("lan")

        try:
            # Create a new document in the 'Cars' collection
            jsonFile = {
                'name': name,
                'discount': discount,
                'free hour': freeHour,
                'price per hour': pricePerH,
                'price per day': pricePerD,
                'price per month': pricePerM,
                'address': address,
                'opening time': openingTime,
                'closing time': closingTime,
                'lon': lon,
                'lat': lat
            }
            db.collection("ParkingLots").add(jsonFile)
            return jsonify({"message": "Parking added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding parking: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_parking_lots", methods=["GET"])
def get_parking_lots():
    if request.method == "GET":
        try:
            cars_collection = db.collection('ParkingLots').stream()

            parkingLots = []
            for car_doc in cars_collection:
                id = car_doc.id
                car_data = car_doc.to_dict()
                car_data["id"] = id
                parkingLots.append(car_data)

            return jsonify({"parkingLots": parkingLots}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking lots: {str(e)}"}), 500
    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_parking/<parking_id>", methods=["GET"])
def get_parking_lot(parking_id):
    if request.method == "GET":
        try:
            parking_ref = db.collection('ParkingLots').document(parking_id)
            parking_doc = parking_ref.get()

            if parking_doc.exists:
                return jsonify({"id": parking_doc.id, **parking_doc.to_dict()}), 200
            else:
                return jsonify({"message": f"Parking with ID {parking_id} not found."}), 404
        except Exception as e:
            return jsonify({"message": f"Error getting parking lot: {str(e)}"}), 500
    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_parking_lots_count", methods=["GET"])
def get_parking_space_count():
    pass


