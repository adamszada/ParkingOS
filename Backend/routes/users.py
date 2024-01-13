from flask import jsonify, request
from app import app, db


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