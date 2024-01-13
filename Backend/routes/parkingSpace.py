from flask import jsonify, request
from app import app, db


@app.route("/add_parking_space", methods=["POST"])
def add_parking_space():
    if request.method == "POST":

        acceptable_types = ["standard", "narrow", "large"]

        data = request.json
        parkingID = data.get("parkingID")
        spaceType = data.get("type")
        floor = data.get("floor")

        if spaceType.lower() not in acceptable_types:
            # todo check error number
            return jsonify({"message": f"Invalid parking space type. Acceptable types: {acceptable_types}"}), 500
        try:
            jsonFile = {
                'parkingID': parkingID,
                'type': spaceType,
                'floor': floor,
                'isTaken': False
            }
            db.collection("ParkingSpaces").add(jsonFile)
            return jsonify({"message": "Parking space added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding parking: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/all_parking_spaces", methods=["GET"])
def get_parking_spaces():
    if request.method == "GET":
        try:
            spaces = db.collection('ParkingSpaces').stream()

            parkingSpaces = []
            for space in spaces:
                spaceID = space.id
                space_data = space.to_dict()
                space_data["id"] = spaceID
                parkingSpaces.append(space_data)

            return jsonify({"ParkingSpaces": parkingSpaces}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking spaces: {str(e)}"}), 500
    return jsonify({"message": "Invalid request method."}), 405


@app.route("/count_parking_spaces", methods=["GET"])
def count_parking_spaces():
    data = request.json
    parkingID = data.get("parkingID")
    spaceType = data.get("type")
    try:
        parking_spaces_ref = db.collection("ParkingSpaces")\
            .where("parkingID", "==", parkingID)\
            .where("type", "==", spaceType)
        parking_spaces_snapshot = parking_spaces_ref.get()
        count = len(parking_spaces_snapshot)

        return jsonify({"parking_id": parkingID, "space_type": spaceType, "count": count}), 200

    except Exception as e:
        return jsonify({"message": f"Error counting parking spaces: {str(e)}"}), 500


@app.route("/count_parking_spaces_per_floor", methods=["GET"])
def count_parking_spaces_per_floor():

    data = request.json
    parkingID = data.get("parkingID")
    spaceType = data.get("type")
    floor = data.get("floor")
    try:
        if parkingID and spaceType and floor:
            parking_spaces_ref = db.collection("ParkingSpaces")\
                .where("parkingID", "==", parkingID)\
                .where("floor", "==", floor)\
                .where("type", "==", spaceType)
            parking_spaces_snapshot = parking_spaces_ref.get()
            count = len(parking_spaces_snapshot)
            return jsonify({"parking_id": parkingID, "space_type": spaceType, "floor": floor, "count": count}), 200
        return jsonify({"message": f"Missing arguments"}), 500

    except Exception as e:
        return jsonify({"message": f"Error counting parking spaces: {str(e)}"}), 500
