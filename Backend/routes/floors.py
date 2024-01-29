from flask import jsonify, request
from app import app, db

@app.route("/add_floor", methods=["POST"])
def add_floor():
    if request.method == "POST":

        data = request.json

        parkingID = data.get("parkingID")
        floorNum = data.get("floor number")
        try:
            jsonFile = {
                'parkingID': parkingID,
                'floor number': floorNum
            }
            db.collection("ParkingLots").add(jsonFile)
            return jsonify({"message": "Parking added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error adding parking: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

