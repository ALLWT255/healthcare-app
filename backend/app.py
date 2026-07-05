from flask import Flask 
import psycopg2
app = Flask(__name__)

connection = psycopg2.connect(
    host="database",
    database="healthcare",
    user="admin",
    password="password123"
)
cursor = connection.cursor()

create_table_query = (
    "CREATE TABLE IF NOT EXISTS patients ("
    "patient_id SERIAL PRIMARY KEY, "
    "first_name VARCHAR(50), "
    "last_name VARCHAR(50), "
    "email VARCHAR(100) UNIQUE, "
    "age INT, "
    "insurance_provider VARCHAR(100), "
    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    ");"
)


cursor.execute(create_table_query)
connection.commit()
cursor.execute(
    "INSERT INTO patients "
    "(first_name, last_name, email, age, insurance_provider) "
    "VALUES (%s, %s, %s, %s, %s)"
    "",
    ("Ashton", "Woolard", "ashton2@email.com",22, "Blue Cross")
)
connection.commit()
cursor.execute("SELECT * FROM patients;")

patients = cursor.fetchall()
print(patients)



@app.route("/")
def home():
    return "Healthcare API is running"


@app.route("/api/health")
def health():
    return {
        "status": "healthy",
        "service": "Healthcare API",
        "version": "1.0"
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)