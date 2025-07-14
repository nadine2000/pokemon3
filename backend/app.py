from flask import Flask, jsonify, request
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure
import os

app = Flask(__name__)
MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://localhost:27017/')
DATABASE_NAME = 'pokemon_db'
COLLECTION_NAME = 'pokemons'

try:
    client = MongoClient(MONGODB_URI)
    client.admin.command('ping')
    db = client[DATABASE_NAME]
    collection = db[COLLECTION_NAME]
    collection.create_index("name", unique=True)
except ConnectionFailure as e:
    print(f"MongoDB connection failed: {e}")
    raise e

@app.route('/pokemon/<name>', methods=['GET'])
def get_pokemon(name):
    try:
        pokemon = collection.find_one({"name": name})
        if pokemon:
            pokemon.pop('_id', None)
            return jsonify({"success": True, "data": pokemon})
        else:
            return jsonify({"success": False, "error": "Pokemon not found"}), 404
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/pokemon', methods=['POST'])
def add_pokemon():
    try:
        pokemon_data = request.get_json()
        if not pokemon_data or 'name' not in pokemon_data:
            return jsonify({"success": False, "error": "Missing 'name' field"}), 400

        result = collection.update_one(
            {"name": pokemon_data['name']},
            {"$set": pokemon_data},
            upsert=True
        )

        return jsonify({
            "success": True,
            "acknowledged": result.acknowledged
        })
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
