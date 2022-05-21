from flask import Flask,jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

orm = SQLAlchemy(app)



@app.route('/')
def index():
    return jsonify({'msg':'Hello World!'})


if __name__ == '__main__':
    app.run(debug=True)