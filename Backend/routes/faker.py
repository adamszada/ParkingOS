import random
import string
import requests


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


if __name__ == '__main__':
    #fill_database_with_random_users(10)
    #top_up_random_amount_for_all_users()
    #add_random_car_to_every_user()
    add_random_cars(3)

