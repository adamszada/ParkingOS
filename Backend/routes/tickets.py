from datetime import datetime, timedelta

from app import app, db
from flask import jsonify, request


def generate_parkingSpot(parkingID):
    parking_ref = db.collection('ParkingLots').document(parkingID)
    parking_doc = parking_ref.get().to_dict()

    floors = parking_doc['floors']
    parking_spaces_per_floor = parking_doc['spots_per_floor']
    parking_spaces = {floor: [False] * parking_spaces_per_floor for floor in range(1, floors + 1)}

    tickets_query = db.collection('Tickets').where("parking_id", "==", parkingID).where("realized", "==", False).stream()
    for ticket_doc in tickets_query:
        ticket_data = ticket_doc.to_dict()
        ticket_floor = ticket_data['floor']
        ticket_spot = ticket_data['parkingSpotNumber']
        parking_spaces[ticket_floor][ticket_spot-1] = True

    for floor in parking_spaces.keys():
        for spot in range(len(parking_spaces[floor])):
            if not parking_spaces[floor][spot]:
                return floor, spot+1

    return -1, -1


@app.route("/add_ticket", methods=["POST"])
def add_ticket():
    if request.method == "POST":
        data = request.json  # Get ticket data from the request

        # Extract ticket data from JSON
        userID = data.get('userID')
        registration = data.get('registration')
        parking_id = data.get('parking_id')
        entry_date = data.get('entry_date')
        # qr_code = data.get('qr_code')
        # Todo generate QR!!!!!!!!

        existing_ticket = db.collection('Tickets').where('userID', '==', userID)\
                                                  .where('registration', '==', registration)\
                                                  .where('parking_id', '==',  parking_id)\
                                                  .where('realized', "==", False).limit(1).get()
        if existing_ticket:
            return jsonify({"message": "Active ticket for this user and registration already exists."}), 400

        floor, parkingSpotNumber = generate_parkingSpot(parking_id)
        if floor == -1 and parkingSpotNumber == -1:
            error_msg = "All spots are already taken"
            return jsonify({"message": f"Error adding ticket: {str(error_msg)}"}), 500
        try:
            # Create a new ticket document in the 'Tickets' collection
            ticket_ref = db.collection('Tickets').document()
            ticket_ref.set({
                'userID': userID,
                'registration': registration,
                'parking_id': parking_id,
                'entry_date': entry_date,
                'realized': False,
                'exit_date': None,
                'QR': None,
                'floor': floor,
                'parkingSpotNumber': parkingSpotNumber,
                'moneyDue': 0
            })

            ticket_id = ticket_ref.id
            # Pobierz nowo utworzony bilet z bazy danych
            new_ticket = ticket_ref.get().to_dict()

            return jsonify({
                "message": "Ticket added successfully.",
                "ticket_id": ticket_id,
                "ticket": new_ticket
            }), 200

        except Exception as e:
            return jsonify({"message": f"Error adding ticket: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

@app.route("/tickets", methods=["GET"])
def get_all_tickets():
    try:
        # Pobierz wszystkie bilety z kolekcji 'Tickets'
        tickets_query = db.collection('Tickets').stream()

        tickets_data = []
        for ticket_doc in tickets_query:
            ticket_data = ticket_doc.to_dict()
            ticket_data['id'] = ticket_doc.id
            tickets_data.append(ticket_data)

        return jsonify({"tickets": tickets_data}), 200

    except Exception as e:
        return jsonify({"message": f"Error retrieving tickets: {str(e)}"}), 500


@app.route("/update_exit_date/<ticket_id>", methods=["PATCH"])
def update_exit_date(ticket_id):
    if request.method == "PATCH":
        data = request.json
        exit_date = data.get('exit_date')

        try:
            ticket_ref = db.collection('Tickets').document(ticket_id)
            ticket_ref.update({'exit_date': exit_date})

            return jsonify({"message": "Exit date updated successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error updating exit date: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


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

@app.route("/tickets_data/<userID>", methods=["GET"])
def user_tickets_data(userID):

    tickets_query = db.collection('Tickets').where("userID","==", userID).stream()
    tickets_data = []
    for ticket_doc in tickets_query:
        ticket = ticket_doc.to_dict()

        car_query = db.collection('Cars').where('registration', '==', ticket['registration']).get()
        car = car_query[0].to_dict()

        parking_ref = db.collection('ParkingLots').document(ticket['parking_id'])
        parking_data = parking_ref.get()
        parking_doc = parking_data.to_dict()
        parkingAddress = parking_doc['address']

        #Todo calculate money Due
        moneyDue = get_tariffs(ticket['parking_id'], )
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