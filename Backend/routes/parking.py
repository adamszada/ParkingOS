import random

from flask import jsonify, request
from app import app, db
from geopy.distance import geodesic

@app.route("/add_parking", methods=["POST"])
def add_parking():
    if request.method == "POST":

        data = request.json
        if not all(key in data for key in ['name', 'address', 'capacity', 'dayTariff', 'nightTariff', 'operatingHours']):
            return jsonify({"message": "Missing required fields."}), 400

        name = data.get("name")
        address = data.get("address")
        capacity = data.get("capacity")
        dayTariff = data.get("dayTariff")
        nightTariff = data.get("nightTariff")
        operatingHours = data.get("operatingHours")
        lon = random.uniform(0, 1000)
        lat = random.uniform(0, 1000)

        try:
            # Create a new document in the 'Cars' collection
            jsonFile = {
                "name": name,
                "address": address,
                "capacity": capacity,
                "dayTariff": dayTariff,
                "nightTariff": nightTariff,
                "operatingHours": operatingHours,
                "lon": lon,
                "lat": lat
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
                car_id = car_doc.id
                car_data = car_doc.to_dict()
                car_data["id"] = car_id
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


@app.route("/get_closest_parking_lots", methods=["GET"])
def getClosestParkingLots():
    if request.method == "GET":
        data = request.json
        if not all(key in data for key in ['lat', 'lon']):
            return jsonify({"message": "Missing required fields."}), 400

        user_lat = data.get("lat")
        user_lon = data.get("lon")
        try:
            parking_lots = db.collection("ParkingLots").get()
            user_location = (user_lat, user_lon)
            sorted_parkings = []
            for parking_lot in parking_lots:
                parking_data = parking_lot.to_dict()
                parking_location = (parking_data.get("lat"), parking_data.get("lon"))
                distance = geodesic(user_location, parking_location).kilometers
                parking_data["distance"] = distance
                sorted_parkings.append(parking_data)

            sorted_parkings = sorted(sorted_parkings, key=lambda x: x["distance"])
            return jsonify({"parking lots": sorted_parkings}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking lots: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/get_cheapest_parking_lots", methods=["GET"])
def getCheapestParkingLots():
    if request.method == "GET":

        try:
            parking_lots = db.collection("ParkingLots").get()
            result_parkings =[]
            for parking_lot in parking_lots:
                parking_data = parking_lot.to_dict()
                dayTariff = parking_data.get("dayTariff")
                nightTariff = parking_data.get("nightTariff")
                avgTariff = (dayTariff+nightTariff)/2
                parking_data["avgTariff"] = avgTariff
                result_parkings.append(parking_data)
            sorted_parkings = sorted(result_parkings, key=lambda x: x["avgTariff"])
            return jsonify({"parkingLots": sorted_parkings}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking lots: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405