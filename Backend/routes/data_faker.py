
import json
import random
import string
from datetime import datetime, timedelta

import requests
from faker import Faker


def register_random_user(url='http://127.0.0.1:5000/register'):
    try:
        # Generowanie losowego adresu email
        email = ''.join(random.choices(string.ascii_lowercase, k=8)) + '@example.com'

        # Generowanie losowego hasła
        password = email

        # Tworzenie danych JSON dla żądania POST
        data = {
            'email': email,
            'password': password,
            'confirmPassword': password  # Potwierdzenie hasła jest takie same jak hasło
        }

        # Wysłanie żądania POST do endpointu /register
        response = requests.post(url, json=data)

        # Zwrócenie odpowiedzi serwera
        return response.json()

    except Exception as e:
        # Obsługa błędów, jeśli wystąpią
        return {"message": f"Error registering user: {str(e)}"}


def fill_database_with_random_users(num_users_to_add):
    # Dodawanie losowych użytkowników do bazy danych
    for _ in range(num_users_to_add):
        result = register_random_user()
        print(result)


def top_up_random_amount(email, url='http://127.0.0.1:5000/topup'):
    try:
        # Losowanie kwoty pieniędzy
        amount = round(random.uniform(1, 100), 2)

        # Tworzenie danych JSON dla żądania POST
        data = {
            'email': email,
            'amount': amount
        }

        # Wysłanie żądania POST do endpointu /topup
        response = requests.post(url, json=data)

        # Zwrócenie odpowiedzi serwera
        return response.json()

    except Exception as e:
        # Obsługa błędów, jeśli wystąpią
        return {"message": f"Error topping up user balance: {str(e)}"}


def top_up_random_amount_for_all_users():
    users_response = requests.get('http://127.0.0.1:5000/users')
    users_data = users_response.json().get('users', [])

    # Zwiększ saldo dla każdego użytkownika
    for user in users_data:
        result = top_up_random_amount(user['email'])
        print(result)


def add_random_car(owners_ids, url='http://127.0.0.1:5000/add_car'):
    try:
        # Losowanie danych dla samochodu
        brand = random.choice(["Toyota", "Ford", "Honda", "Chevrolet", "BMW", "Mercedes-Benz", "Audi"])
        model = random.choice(["Camry", "Fusion", "Civic", "Malibu", "X5", "E-Class", "A4"])
        registration = ''.join(random.choices(string.ascii_uppercase + string.digits, k=7))
        owner_id = random.choice(owners_ids)

        # Tworzenie danych JSON dla żądania POST
        data = {
            'brand': brand,
            'model': model,
            'registration': registration,
            'owner_id': owner_id
        }

        # Wysłanie żądania POST do endpointu /add_car
        response = requests.post(url, json=data)

        # Zwrócenie odpowiedzi serwera
        return response.json()

    except Exception as e:
        # Obsługa błędów, jeśli wystąpią
        return {"message": f"Error adding random car: {str(e)}"}


def add_random_cars(num_cars_to_add):
    # Dodawanie losowych samochodów do bazy danych

    users_response = requests.get('http://127.0.0.1:5000/users')
    users_data = users_response.json().get('users', [])
    user_ids = []
    for user in users_data:
        user_ids.append(user['uid'])

    for _ in range(num_cars_to_add):
        result = add_random_car(user_ids)
        print(result)


def add_random_car_to_user(owner_id, url='http://127.0.0.1:5000/add_car'):
    try:
        # Losowanie danych dla samochodu
        brand = random.choice(["Toyota", "Ford", "Honda", "Chevrolet", "BMW", "Mercedes-Benz", "Audi"])
        model = random.choice(["Camry", "Fusion", "Civic", "Malibu", "X5", "E-Class", "A4"])
        registration = ''.join(random.choices(string.ascii_uppercase + string.digits, k=7))

        # Tworzenie danych JSON dla żądania POST
        data = {
            'brand': brand,
            'model': model,
            'registration': registration,
            'owner_id': owner_id
        }

        # Wysłanie żądania POST do endpointu /add_car
        response = requests.post(url, json=data)

        # Zwrócenie odpowiedzi serwera
        return response.json()

    except Exception as e:
        # Obsługa błędów, jeśli wystąpią
        return {"message": f"Error adding random car: {str(e)}"}


def add_random_car_to_every_user():
    users_response = requests.get('http://127.0.0.1:5000/users')
    users_data = users_response.json().get('users', [])
    for user in users_data:
        result = add_random_car_to_user(user['uid'])
        print(result)



def add_random_ticket():


    # Generowanie obecnego daty i czasu jako string

    users_response = requests.get('http://127.0.0.1:5000/users')
    users_data = users_response.json().get('users', [])
    currentDate = datetime.now()

    for user in users_data:
        cars = requests.get('http://127.0.0.1:5000/get_cars_by_owner/' + user['uid']).json()['cars']
        car = random.choice(cars)

        delta = random.randint(-5, 8)
        enterDate = currentDate + timedelta(hours=delta)
        # Ticket data
        ticket_data = {
            "userID": user['uid'],
            "registration": car['registration'],
            "parking_id": "2UzF6R7ba7qs8afnJJhP",
            "entry_date": str(enterDate),
            "parkingSpotNumber": "place456"
        }
        # Convert data to JSON format
        ticket_json = json.dumps(ticket_data)

        # Ustawienie nagłówka Content-Type na application/json
        headers = {'Content-Type': 'application/json'}

        # Send POST request to the endpoint with JSON data and headers
        response = requests.post('http://127.0.0.1:5000/add_ticket', data=ticket_json, headers=headers)

        exit_date = {
            "exit_date": str(enterDate + timedelta(hours=random.randint(1, 8)))
        }
        ej = json.dumps(exit_date)
        result = requests.patch('http://127.0.0.1:5000/update_exit_date/' + response.json()['ticket_id'], data=ej, headers=headers)
        break

def parking_day_cycle(days):
    users_response = requests.get('http://127.0.0.1:5000/users')
    users_data = users_response.json().get('users', [])
    currentDate = datetime.now()
    for _ in range(days):

        #for user in users_data:
            user = users_data[0]
            cars = requests.get('http://127.0.0.1:5000/get_cars_by_owner/' + user['uid']).json()['cars']
            car = random.choice(cars)

            delta = random.randint(-5, 8)
            enterDate = currentDate + timedelta(hours=delta)
            # Ticket data
            ticket_data = {
                "userID": user['uid'],
                "registration": car['registration'],
                "parking_id": "parking123",
                "entry_date": str(enterDate),
                "place_id": "place456"
            }
            # Convert data to JSON format
            ticket_json = json.dumps(ticket_data)

            # Ustawienie nagłówka Content-Type na application/json
            headers = {'Content-Type': 'application/json'}

            # Send POST request to the endpoint with JSON data and headers
            response = requests.post('http://127.0.0.1:5000/add_ticket', data=ticket_json, headers=headers)

            exit_date = {
                "exit_date": str(enterDate + timedelta(hours=random.randint(1, 8)))
            }
            ej = json.dumps(exit_date)
            result = requests.patch('http://127.0.0.1:5000/update_exit_date/' + response.json()['ticket_id'], data=ej, headers=headers)
            currentDate += timedelta(days=1)


def generate_parking():

    fake = Faker()
    name = fake.company()

    street_name = fake.street_name()[:10]  # Maksymalnie 10 znaków na nazwę ulicy
    street_type = fake.street_suffix()[:2]  # Skrót typu ulicy, maksymalnie 2 znaki
    short_address = f"{street_type}. {street_name}"

    floors = random.randint(1, 5)
    spots_per_floor = random.randint(10, 50)
    day_tariff = round(random.uniform(5, 20), 2)
    night_tariff = round(day_tariff * random.uniform(0.5, 0.8), 2)
    operating_hours = f"{random.randint(0, 23)}:00 - {random.randint(0, 23)}:00"

    parking_data = {
        "name": name,
        "address": short_address,
        "floors": floors,
        "spots_per_floor": spots_per_floor,
        "dayTariff": day_tariff,
        "nightTariff": night_tariff,
        "operatingHours": operating_hours
    }

    return parking_data

def add_parking(number, url="http://127.0.0.1:5000/add_parking"):
    headers = {'Content-Type': 'application/json'}
    for i in range(number):
        parking_data = generate_parking()
        response = requests.post(url, json=parking_data, headers=headers)


def add_costs_to_every_parking_lot(url="http://127.0.0.1:5000/add_parking"):
    users_response = requests.get('http://127.0.0.1:5000/get_parking_lots')
    parkingLots = users_response.json().get('parkingLots', [])
    for parkingLot in parkingLots:
        parkingLot['id']


if __name__ == '__main__':
    #fill_database_with_random_users(10)
    #top_up_random_amount_for_all_users()
    #add_random_car_to_every_user()
    #add_random_cars(3)
    #add_random_ticket()
    #parking_day_cycle(30)
    add_parking(5)