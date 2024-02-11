from flask import jsonify, request
from app import app, db


@app.route("/clear_database_from_cars", methods=["POST"])
def clear_database_from_cars():
    if request.method == "POST":
        try:
            # Pobierz wszystkie dokumenty z kolekcji 'Cars'
            cars_collection = db.collection('Cars')
            cars = cars_collection.stream()

            # Usuń każdy dokument z kolekcji
            for car in cars:
                car.reference.delete()

            return jsonify({"message": "Database cleared successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error clearing the database: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/clear_database_from_parking_lots", methods=["POST"])
def clear_database_from_parking_lots():
    if request.method == "POST":
        try:
            cars_collection = db.collection('ParkingLots')
            cars = cars_collection.stream()
            for car in cars:
                car.reference.delete()

            return jsonify({"message": "Database cleared successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error clearing the database: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405