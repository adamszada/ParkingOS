from flask import jsonify, request
from app import app, db

@app.route("/fill_database_with_cars", methods=["POST"])
def fill_database():
    import random
    import string
    if request.method == "POST":
        try:
            # Ilosc samochodow, jakie chcesz dodac
            num_cars_to_add = 10

            # Przykładowe marki i modele
            brands = ["Toyota", "Ford", "Honda", "Chevrolet", "BMW", "Mercedes-Benz", "Audi"]
            models = ["Camry", "Fusion", "Civic", "Malibu", "X5", "E-Class", "A4"]

            for _ in range(num_cars_to_add):
                # Generowanie losowych danych dla samochodu
                brand = random.choice(brands)
                model = random.choice(models)
                registration = ''.join(random.choices(string.ascii_uppercase + string.digits, k=7))

                # Sprawdzenie, czy samochód z tym numerem rejestracyjnym już istnieje
                existing_car = db.collection('Cars').where('registration', '==', registration).get()

                if existing_car:
                    continue  # Jeśli samochód już istnieje, omiń ten krok i przejdź do kolejnego losowania

                existing_users = db.collection('Users').where('id', '==',)
                # Dodanie nowego samochodu do bazy danych
                car_ref = db.collection('Cars').document()
                car_ref.set({
                    'brand': brand,
                    'model': model,
                    'registration': registration
                })

            return jsonify({"message": f"{num_cars_to_add} cars added successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error filling the database: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


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