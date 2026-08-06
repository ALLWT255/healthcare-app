import os
from flask import Flask, request
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2 import IntegrityError
from secrets import get_db_credentials
credentials = get_db_credentials()
app = Flask(__name__)

connection = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    database=os.getenv("DB_NAME"),
    user=credentials["username"],
    password=credentials["password"],
    cursor_factory=RealDictCursor
)

cursor = connection.cursor()

create_table_query = """
CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    age INT,
    insurance_provider VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);
"""

cursor.execute(create_table_query)
connection.commit()


@app.route("/")
def home():
    return "Healthcare API is running"


@app.route("/api/health")
def health():
    return {
        "status": "healthy",
        "service": "Healthcare API",
        "version": "1.0"
    }, 200


@app.route("/api/patients", methods=["POST"])
def add_patient():
    data = request.get_json(silent=True)

    if not data:
        return {"error": "Request body must be valid JSON"}, 400

    if (
        not data.get("first_name") or
        not data.get("last_name") or
        not data.get("email") or
        not data.get("insurance_provider")
    ):
        return {"error": "Missing required fields"}, 400

    first_name = data["first_name"]
    last_name = data["last_name"]
    email = data["email"]
    age = data.get("age")
    insurance_provider = data["insurance_provider"]

    try:
        cursor.execute(
            """
            INSERT INTO patients 
            (first_name, last_name, email, age, insurance_provider)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING *;
            """,
            (first_name, last_name, email, age, insurance_provider)
        )
        patient = cursor.fetchone()
        connection.commit()

    except IntegrityError:
        connection.rollback()
        return {"error": "A patient with this email already exists"}, 409

    return {
        "message": "Patient registered successfully",
        "patient": patient
    }, 201


@app.route("/api/patients", methods=["GET"])
def get_patients():
    cursor.execute("SELECT * FROM patients WHERE is_active = TRUE ORDER BY patient_id;")
    patients = cursor.fetchall()

    return {"patients": patients}, 200


@app.route("/api/patients/<int:patient_id>", methods=["GET"])
def get_patient(patient_id):
    cursor.execute(
        "SELECT * FROM patients WHERE patient_id = %s AND is_active = TRUE;",
        (patient_id,)
    )
    patient = cursor.fetchone()

    if not patient:
        return {"error": "Patient not found"}, 404

    return {"patient": patient}, 200

@app.route("/api/patients/<int:patient_id>", methods=["PUT"])
def update_patient(patient_id):
    data = request.get_json(silent=True)

    if not data:
        return {"error": "Request body must be valid JSON"}, 400

    allowed_fields = {
        "first_name",
        "last_name",
        "email",
        "age",
        "insurance_provider"
    }

    update_fields = {
        key: value
        for key, value in data.items()
        if key in allowed_fields
    }
    if not update_fields:
    
        return {"error": "No valid fields to update"}, 400
    
    cursor.execute(
        "SELECT * FROM patients WHERE patient_id = %s AND is_active = TRUE;",
        (patient_id,)
    )
    patient = cursor.fetchone()

    if not patient:
        return {
            "error": "Patient not found"
        },404

    set_clause = ", ".join(
        f"{field} = %s" for field in update_fields
    )
    values = list(update_fields.values())
    values.append(patient_id)

    try:
        cursor.execute(
            f"UPDATE patients SET {set_clause} WHERE patient_id = %s AND is_active = TRUE RETURNING *;",
            tuple(values)
        )

        updated_patient = cursor.fetchone()
        connection.commit()

    except IntegrityError:
        connection.rollback()
        return {"error": "A patient with this email already exists"}, 409

    return {
        "message": "Patient updated successfully",
        "patient": updated_patient
    }, 200
@app.route("/api/patients/<int:patient_id>", methods=["DELETE"])
def delete_patient(patient_id):
    cursor.execute(
        "SELECT * FROM patients WHERE patient_id = %s AND is_active = TRUE;",
        (patient_id,)
    )
    patient = cursor.fetchone()

    if not patient:
        return {"error": "Patient not found"}, 404

    cursor.execute(
        "UPDATE patients SET is_active = FALSE WHERE patient_id = %s AND is_active = TRUE RETURNING *;",
        (patient_id,)
    )
    deactivated_patient = cursor.fetchone()
    connection.commit()

    return {
        "message": "Patient deactivated successfully",
        "patient": deactivated_patient
    }, 200
@app.route("/routes")
def routes():
    return {
        "routes": [str(rule) + " " + ",".join(rule.methods) for rule in app.url_map.iter_rules()]
    }
print(app.url_map)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000) 