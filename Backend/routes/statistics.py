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

from datetime import datetime
from dateutil.relativedelta import relativedelta

from datetime import datetime
from dateutil.relativedelta import relativedelta

from datetime import datetime
from dateutil.relativedelta import relativedelta

@app.route("/parking_summary/<string:parking_id>", methods=["GET"])
def get_parking_summary(parking_id):
    if request.method == "GET":
        try:
            summaries = []

            start_date = datetime(2020, 1, 1)  

            today = datetime.now()

            current_date = start_date
            while current_date <= today:
                start_of_month = current_date.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
                end_of_month = start_of_month + relativedelta(months=1) - relativedelta(days=1)

                costs_ref = db.collection("parking_costs").where("parking_id", "==", parking_id)\
                                                          .where("date", ">=", start_of_month)\
                                                          .where("date", "<=", end_of_month).get()

                total_costs = 0
                for cost in costs_ref:
                    cost_data = cost.to_dict()
                    if cost_data["type"] == "cykliczny":
                        total_costs += cost_data["amount"]
                    elif cost_data["type"] == "jednorazowy":
                        total_costs = cost_data["amount"]

                ticket_ref = db.collection("Tickets").where("parking_id", "==", parking_id)\
                                                     .where("entry_date", ">=", start_of_month)\
                                                     .where("entry_date", "<=", end_of_month).get()

                total_revenue = 0
                for ticket in ticket_ref:
                    ticket_data = ticket.to_dict()
                    total_revenue += ticket_data["moneyDue"]

                summaries.append({
                    "month": start_of_month.strftime("%B"),
                    "year": start_of_month.year,
                    "total_costs": total_costs,
                    "total_revenue": total_revenue
                })

                current_date = current_date + relativedelta(months=1)

            return jsonify({"parking_id": parking_id, "summaries": summaries}), 200

        except Exception as e:
            return jsonify({"message": f"Error getting parking summary: {str(e)}"}), 500

    return jsonify({"message": "Invalid request method."}), 405