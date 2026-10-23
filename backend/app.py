from flask import Flask, jsonify
app = Flask(__name__)

@app.get("/api/hello")
def hello():
    return jsonify(message="Привет от бэкенда!")

app.run(host="0.0.0.0", port=5000)
