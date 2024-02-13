from datetime import datetime, timedelta

from app import app, db
from flask import jsonify, request


def generate_parkingSpot(parkingID):
    parking_ref = db.collection('ParkingLots').document(parkingID)
    parking_doc = parking_ref.get().to_dict()

    floors = parking_doc['floors']
    parking_spaces_per_floor = parking_doc['capacityPerFloor']
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

            # update parking occupancy
            parking_ref = db.collection('ParkingLots').document(parking_id)
            parking_data = parking_ref.get().to_dict()
            currentOccupancy = calculate_occupancy(parking_id)
            parking_ref.update({'currentOccupancy': currentOccupancy})

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
            ticket_data = ticket_ref.get().to_dict()
            if ticket_data['exit_date'] != None:
                return jsonify({"message": f"Exit date has been already added: {str(ticket_data['exit_date'])}"}), 406

            parking_ref = db.collection('ParkingLots').document(ticket_data['parking_id'])
            parking_data = parking_ref.get().to_dict()

            dayTariff = parking_data['dayTariff']
            nightTariff = parking_data['nightTariff']

            # Todo calculate money Due
            entry_date = datetime.strptime(ticket_data['entry_date'], '%Y-%m-%d %H:%M:%S.%f')
            exit_date_time = datetime.strptime(exit_date, '%Y-%m-%d %H:%M:%S.%f')
            dayh, nightH = calculate_tariffs_to_exit(entry_date, exit_date_time, 6, 22)
            print(dayh, nightH, dayTariff, nightTariff)
            moneyDue = dayTariff * dayh + nightTariff * nightH

            ticket_ref.update({'exit_date': exit_date})
            ticket_ref.update({'moneyDue': moneyDue})

            return jsonify({"message": "Exit date updated successfully."}), 200

        except Exception as e:
            return jsonify({"message": f"Error updating exit date: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


def calculate_tariffs(entry_time, day_tariff_start_hour, night_tariff_start_hour, parking_id=0,):
    # try:
        # # Pobierz dane o parkingu
        # parking_ref = db.collection('ParkingLots').document(parking_id)
        # parking_data = parking_ref.get().to_dict()

        # # Pobierz taryfy
        # day_tariff = parking_data.get('dayTariff')
        # night_tariff = parking_data.get('nightTariff')

        # Obecny czas
        current_time = datetime.now()
        night_h = 0
        day_h = 0
        while entry_time < current_time:
            if night_tariff_start_hour <= entry_time.hour < 24 or entry_time.hour >= 0 and entry_time.hour < day_tariff_start_hour:
                night_h += 1
            else:
                day_h += 1

            entry_time += timedelta(hours=1)

        return day_h, night_h

    # except Exception as e:
    #     return jsonify({"message": f"Error getting tariffs: {str(e)}"}), 500

def calculate_tariffs_to_exit(entry_time, exit_date, day_tariff_start_hour, night_tariff_start_hour, parking_id=0,):
    # try:
        # # Pobierz dane o parkingu
        # parking_ref = db.collection('ParkingLots').document(parking_id)
        # parking_data = parking_ref.get().to_dict()

        # # Pobierz taryfy
        # day_tariff = parking_data.get('dayTariff')
        # night_tariff = parking_data.get('nightTariff')

        night_h = 0
        day_h = 0
        while entry_time < exit_date:
            if night_tariff_start_hour <= entry_time.hour < 24 or entry_time.hour >= 0 and entry_time.hour < day_tariff_start_hour:
                night_h += 1
            else:
                day_h += 1

            entry_time += timedelta(hours=1)

        return day_h, night_h

@app.route("/tickets_data/<userID>", methods=["GET"])
def user_tickets_data(userID):
    """
    returns a list of active tickets for user with
    :param userID:
    :return:
    """
    tickets_query = db.collection('Tickets').where("userID", "==", userID)\
                                            .where("realized", "==", False)\
                                            .where("exit_date", "==", None).stream()
    tickets_data = []
    for ticket_doc in tickets_query:
        ticket = ticket_doc.to_dict()

        car_query = db.collection('Cars').where('registration', '==', ticket['registration']).get()
        car = car_query[0].to_dict()

        parking_ref = db.collection('ParkingLots').document(ticket['parking_id'])
        parking_data = parking_ref.get()
        parking_doc = parking_data.to_dict()
        parkingAddress = parking_doc['address']
        dayTariff = parking_doc['dayTariff']
        nightTariff = parking_doc['nightTariff']
        #Todo calculate money Due
        entry_date = datetime.strptime(ticket['entry_date'], '%Y-%m-%d %H:%M:%S.%f')
        dayh, nightH = calculate_tariffs(entry_date, 6, 22)
        moneyDue = dayTariff * dayh + nightTariff * nightH,

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
        tickets_data.append(ticket_d)

    return jsonify({"tickets": tickets_data}), 200

@app.route("/get_ticket_moneyDue/<ticket_id>", methods=["GET"])
def get_ticket_moneyDue(ticket_id):
    if request.method == "GET":
        try:
            ticket_ref = db.collection('Tickets').document(ticket_id)
            ticket_data = ticket_ref.get().to_dict()
            if ticket_data['exit_date'] == None:
                return jsonify({"message": f"Ticket has no exit date!"}), 406

            if ticket_data['realized']:
                return jsonify({"message": f"Ticket has already been realized!"}), 407

            return jsonify({"message": "Sucess",
                            "moneyDue": ticket_data["moneyDue"]}), 200

        except Exception as e:
            return jsonify({"message": f"Error updating exit date: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405

@app.route("/change_ticket_status_for_realized/<ticket_id>", methods=["POST"])
def change_ticket_status_for_Realized(ticket_id):
    if request.method == "POST":
        try:

            ticket_ref = db.collection('Tickets').document(ticket_id)
            ticket_ref.update({'realized': True})

            # update parking occupancy
            ticket_data = ticket_ref.get().to_dict()
            parking_ref = db.collection('ParkingLots').document(ticket_data['parking_id'])
            currentOccupancy = calculate_occupancy(ticket_data['parking_id'])
            today_earnings = calculate_today_earing(ticket_data['parking_id'])

            parking_ref.update({'currentOccupancy': currentOccupancy})
            parking_ref.update({'earningsToday': today_earnings})

            currentTime = max(datetime.now().hour,1)
            parking_ref.update({'curEarnings': today_earnings/currentTime})
            return jsonify({"message": "Bilet opłacony pomyślnie."}), 200

        except Exception as e:
            return jsonify({"message": f"Błąd płatności biletu: {str(e)}"}), 500

    return jsonify({"message": "Nieprawidłowa metoda żądania."}), 405

def calculate_today_earing(parkingID):
    today_date = datetime.now()
    tickets_query = db.collection('Tickets').where("parking_id", "==", parkingID)\
                                            .where("realized", "==", True).stream()

    today_earnings = 0
    for ticket_doc in tickets_query:
        ticket_data = ticket_doc.to_dict()
        enterDate = ticket_data['entry_date']
        date = datetime.strptime(enterDate, '%Y-%m-%d %H:%M:%S.%f')
        print("Today DAte: ", today_date.date())
        print("file date", date.date())
        if today_date.date() == date.date():
            today_earnings += ticket_data['moneyDue']

    return today_earnings


def calculate_occupancy(parkingID):
    tickets_query = db.collection('Tickets').where("parking_id", "==", parkingID).where("realized", "==", False).stream()
    current_occupancy = 0
    for ticket_doc in tickets_query:
        current_occupancy +=1

    return current_occupancy