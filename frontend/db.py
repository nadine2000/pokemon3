import requests

API_BASE_URL = "http://<backend_server_private_ip>:5000"


def get_pokemon_from_db(name):
    try:
        response = requests.get(f"{API_BASE_URL}/pokemon/{name}")
        if response.status_code == 200:
            data = response.json()
            if data['success']:
                return data['data']
        return None
    except Exception as e:
        print(f"Error connecting to API: {e}")
        return None


def add_pokemon_to_db(pokemon):
    try:
        response = requests.post(f"{API_BASE_URL}/pokemon", json=pokemon)
        if response.status_code == 200:
            data = response.json()
            if data['success']:
                return {'ResponseMetadata': {'HTTPStatusCode': 200}}
        return {'ResponseMetadata': {'HTTPStatusCode': 500}}
    except Exception as e:
        print(f"Error connecting to API: {e}")
        return {'ResponseMetadata': {'HTTPStatusCode': 500}}
