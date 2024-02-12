from collections import defaultdict
from datetime import datetime

from flask import jsonify, request
from app import app, db


@app.route("/count_transactions", methods=["GET"])
def count_transactions():
    if request.method == "GET":
        try:
            # Get parking_id from query parameters
            parking_id = request.json.get('parking_id')

            # Query the database for tickets with the specified parking_id
            tickets_ref = db.collection('Tickets').where('parking_id', '==', parking_id).get()
            print(tickets_ref)
            # Count the number of tickets
            num_transactions = len(tickets_ref)

            return jsonify({"num_transactions": num_transactions}), 200

        except Exception as e:
            return jsonify({"message": f"Error counting transactions: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405


@app.route("/count_transactions_by_month", methods=["GET"])
def count_transactions_by_month():
    if request.method == "GET":
        try:
            # Get parking_id from query parameters
            parking_id = request.json.get('parking_id')

            # Query the database for tickets with the specified parking_id
            tickets_ref = db.collection('Tickets').where('parking_id', '==', parking_id).get()

            # Initialize a defaultdict to store counts for each month
            transactions_by_month = defaultdict(int)

            # Iterate through tickets and count transactions for each month
            for ticket in tickets_ref:
                entry_date = ticket.get('entry_date')
                if entry_date:
                    entry_month = datetime.strptime(entry_date, "%Y-%m-%d %H:%M:%S.%f").strftime("%Y-%m")
                    transactions_by_month[entry_month] += 1

            return jsonify(transactions_by_month), 200

        except Exception as e:
            return jsonify({"message": f"Error counting transactions by month: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405
