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
        spaceNumber = data.get("number")

        if spaceType.lower() not in acceptable_types:
            # todo check error number
            return jsonify({"message": f"Invalid parking space type. Acceptable types: {acceptable_types}"}), 500
        try:
            jsonFile = {
                'parkingID': parkingID,
                'type': spaceType,
                'floor': floor,
                'number': spaceNumber,
                'isOccupied': False
            }
            db.collection("ParkingSpaces").add(jsonFile)
            return jsonify({"message": "Parking space added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding parking: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/change_parking_space_for_occupied", methods=["POST"])
def change_space_status_for_occupied():

    try:
        data = request.json
        parkingID = data.get("parkingID")
        number = data.get("number")
        floor = data.get("floor")

        parking_spaces_ref = db.collection("ParkingSpaces").where("parkingID", "==", parkingID)\
                                                           .where("number", "==", number) \
                                                           .where("floor", "==", floor)
        parking_spaces_snapshot = parking_spaces_ref.get()
        if not parking_spaces_snapshot:
            return jsonify({"message": "Parking space not found."}), 404

        for doc in parking_spaces_snapshot:
            doc.reference.update({"isOccupied": True})

        return jsonify({"message": "Parking space occupied successfully."}), 200
    except Exception as e:
        return jsonify({"message": f"Error occupying parking space: {str(e)}"}), 500


@app.route("/change_parking_space_for_unoccupied", methods=["POST"])
def change_space_status_for_unoccupied():
    try:
        data = request.json
        parkingID = data.get("parkingID")
        number = data.get("number")
        floor = data.get("floor")

        parking_spaces_ref = db.collection("ParkingSpaces").where("parkingID", "==", parkingID) \
            .where("number", "==", number) \
            .where("floor", "==", floor)
        parking_spaces_snapshot = parking_spaces_ref.get()
        if not parking_spaces_snapshot:
            return jsonify({"message": "Parking space not found."}), 404

        for doc in parking_spaces_snapshot:
            doc.reference.update({"isOccupied": False})

        return jsonify({"message": "Parking space occupied successfully."}), 200
    except Exception as e:
        return jsonify({"message": f"Error occupying parking space: {str(e)}"}), 500


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
        if parkingID and spaceType:
            parking_spaces_ref = db.collection("ParkingSpaces")\
                .where("parkingID", "==", parkingID)\
                .where("type", "==", spaceType)
            parking_spaces_snapshot = parking_spaces_ref.get()
            count = len(parking_spaces_snapshot)

            return jsonify({"parking_id": parkingID, "space_type": spaceType, "count": count}), 200
        return jsonify({"message": f"Missing arguments"}), 500
    except Exception as e:
        return jsonify({"message": f"Error counting parking spaces: {str(e)}"}), 500


@app.route("/count_unoccupied_parking_spaces", methods=["GET"])
def count_unoccupied_parking_spaces():
    data = request.json
    parkingID = data.get("parkingID")
    spaceType = data.get("type")
    try:
        if parkingID and spaceType:
            parking_spaces_ref = db.collection("ParkingSpaces")\
                .where("parkingID", "==", parkingID)\
                .where("type", "==", spaceType)\
                .where("isOccupied", "==", False)
            parking_spaces_snapshot = parking_spaces_ref.get()
            count = len(parking_spaces_snapshot)

            return jsonify({"parking_id": parkingID, "space_type": spaceType, "count": count}), 200
        return jsonify({"message": f"Missing arguments"}), 500
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


@app.route("/count_parking_unoccupied_spaces_per_floor", methods=["GET"])
def count_parking_unoccupied_spaces_per_floor():
    data = request.json
    parkingID = data.get("parkingID")
    spaceType = data.get("type")
    floor = data.get("floor")
    try:
        if parkingID and spaceType and floor:
            parking_spaces_ref = db.collection("ParkingSpaces")\
                .where("parkingID", "==", parkingID)\
                .where("floor", "==", floor)\
                .where("type", "==", spaceType)\
                .where("isOccupied", "==", False)
            parking_spaces_snapshot = parking_spaces_ref.get()
            count = len(parking_spaces_snapshot)
            return jsonify({"parking_id": parkingID, "space_type": spaceType, "floor": floor, "count": count}), 200
        return jsonify({"message": f"Missing arguments"}), 500

    except Exception as e:
        return jsonify({"message": f"Error counting parking spaces: {str(e)}"}), 500