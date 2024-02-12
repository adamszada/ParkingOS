import random
from datetime import datetime, timedelta

from flask import jsonify, request
from geopy.distance import geodesic

from app import app, db
from geopy.geocoders import Nominatim

geolocator = Nominatim(user_agent="parking_locator")


@app.route("/add_parking", methods=["POST"])
def add_parking():
    if request.method == "POST":
        data = request.json
        if not all(key in data for key in
                   ['name', 'address', 'floors', 'spots_per_floor', 'dayTariff', 'nightTariff', 'operatingHours']):
            return jsonify({"message": "Missing required fields."}), 400

        name = data.get("name")
        address = data.get("address")
        floors = int(data.get("floors"))
        spots_per_floor = int(data.get("spots_per_floor"))
        dayTariff = data.get("dayTariff")
        nightTariff = data.get("nightTariff")
        operatingHours = data.get("operatingHours")

        if floors <= 0 or spots_per_floor <= 0 or dayTariff <= 0 or nightTariff <= 0:
            return jsonify({"message": "Invalid field values. Values must be greater than zero."}), 400

        try:
            location = geolocator.geocode(address)
            if location:
                lat = location.latitude
                lon = location.longitude
            else:
                lat = random.uniform(-90, 90)
                lon = random.uniform(-180, 180)

            capacity = floors * spots_per_floor

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


@app.route("/delete_parking/<parking_id>", methods=["DELETE"])
def delete_parking_lot(parking_id):
    if request.method == "DELETE":
        try:
            parking_ref = db.collection('ParkingLots').document(parking_id)
            parking_doc = parking_ref.get()

            if parking_doc.exists:
                parking_ref.delete()
                return jsonify({"message": f"Parking with ID {parking_id} deleted successfully."}), 200
            else:
                return jsonify({"message": f"Parking with ID {parking_id} not found."}), 404
        except Exception as e:
            return jsonify({"message": f"Error deleting parking lot: {str(e)}"}), 500

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
            result_parkings = []
            for parking_lot in parking_lots:
                parking_data = parking_lot.to_dict()
                dayTariff = parking_data.get("dayTariff")
                nightTariff = parking_data.get("nightTariff")
                avgTariff = (dayTariff + nightTariff) / 2
                parking_data["avgTariff"] = avgTariff
                result_parkings.append(parking_data)
            sorted_parkings = sorted(result_parkings, key=lambda x: x["avgTariff"])
            return jsonify({"parkingLots": sorted_parkings}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking lots: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/parking_costs/add", methods=["POST"])
def add_parking_cost():
    if request.method == "POST":
        try:
            data = request.json
            if not all(key in data for key in ['parking_id', 'amount', 'title', 'type']):
                return jsonify({"message": "Missing required fields."}), 400

            parking_id = data.get("parking_id")
            amount = data.get("amount")
            title = data.get("title")
            cost_type = data.get("type")

            if not isinstance(amount, (int, float)) or amount <= 0:
                return jsonify({"message": "Invalid amount. Amount must be a positive number."}), 400

            db.collection("parking_costs").add(data)
            return jsonify({"message": "Parking cost added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding parking cost: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/parking_costs/<string:parking_id>", methods=["GET"])
def get_parking_costs(parking_id):
    if request.method == "GET":
        try:
            costs_ref = db.collection("parking_costs").where("parking_id", "==", parking_id).get()

            parking_costs = []

            for cost in costs_ref:
                parking_costs.append(cost.to_dict())

            return jsonify({"parking_costs": parking_costs}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking costs: {str(e)}"}), 500
    return jsonify({"message": "Invalid request method."}), 405



@app.route("/parking_costs/delete/<string:parking_id>", methods=["DELETE"])
def delete_parking_cost(parking_id):
    if request.method == "DELETE":
        try:
            data = request.json
            title = data.get("title")
            amount = data.get("amount")
            cost_type = data.get("type")

            if not all([title, amount, cost_type]):
                return jsonify({"message": "Missing required fields."}), 400

            costs_ref = db.collection("parking_costs").where("parking_id", "==", parking_id).where("title", "==",
                                                                                                   title).where(
                "amount", "==", amount).where("type", "==", cost_type).get()

            if len(costs_ref) == 0:
                return jsonify({"message": "Parking cost not found."}), 404

            for cost in costs_ref:
                cost.reference.delete()

            return jsonify({"message": "Parking cost deleted successfully."}), 200

        except Exception as e:
                return jsonify({"message": f"Error getting parking costs: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

@app.route("/tickets_data/<userID>", methods=["GET"])
def user_tickets_data(userID):

    tickets_query = db.collection('Tickets').where("userID","==", userID).stream()
    tickets_data = []
    for ticket_doc in tickets_query:
        ticket = ticket_doc.to_dict()

        car_query = db.collection('Cars').where('registration', '==', ticket['registration']).get()
        car =  car_query[0].to_dict()

        parking_ref = db.collection('ParkingLots').document(ticket['parking_id'])
        parking_data = parking_ref.get()
        parking_doc = parking_data.to_dict()
        parkingAddress = parking_doc['address']

        #Todo calculate money Due
        moneyDue = 0
        ticket_d = {
            "registration": ticket['registration'],
            "carName":  car.get('brand'),
            "parkTime": ticket['entry_date'],
            "parkingAddress": parkingAddress,
            "parkingSpotNumber": ticket['parkingSpotNumber'],
            "floor": ticket['floor'],
            "moneyDue": moneyDue,
            "qrCode":  ticket['QR'],
            "parkingId": ticket['parking_id']
        }
        print("Ticket!!!!!!", ticket_d)
        tickets_data.append(ticket_d)

    return jsonify({"tickets": tickets_data}), 200


def get_tariffs(parking_id, entry_time, day_tariff_start_hour, night_tariff_start_hour):
    try:
        # Pobierz dane o parkingu
        parking_ref = db.collection('ParkingLots').document(parking_id)
        parking_data = parking_ref.get().to_dict()

        # Pobierz taryfy
        day_tariff = parking_data.get('dayTariff')
        night_tariff = parking_data.get('nightTariff')

        # Obecny czas
        current_time = datetime.now()

        current_time = datetime.now()
        night_h = 0
        day_h = 0
        while entry_time < current_time:
            if night_tariff_start_hour <= entry_time.hour < 24 or entry_time.hour >= 0 and entry_time.hour < day_tariff_start_hour:
                night_h += 1
            else:
                day_h += 1

            entry_time += timedelta(hours=1)

        return jsonify({
            "day_tariff": day_tariff,
            "night_tariff": night_tariff,
            "hours_in_day_tariff": day_h,
            "hours_in_night_tariff": night_h
        }), 200

    except Exception as e:
        return jsonify({"message": f"Error getting tariffs: {str(e)}"}), 500




