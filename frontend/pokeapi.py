import requests
import random

POKEAPI_BASE_URL = "https://pokeapi.co/api/v2"


def get_all_pokemon_names():
    response = requests.get(f"{POKEAPI_BASE_URL}/pokemon?limit=100")
    response.raise_for_status()
    return [pokemon['name'] for pokemon in response.json()['results']]


def get_random_pokemon_name():
    all_names = get_all_pokemon_names()
    return random.choice(all_names)


def get_pokemon_details(name):
    response = requests.get(f"{POKEAPI_BASE_URL}/pokemon/{name.lower()}")
    response.raise_for_status()
    data = response.json()
    return {
        "name": data["name"],
        "height": data["height"],
        "weight": data["weight"]
    }
