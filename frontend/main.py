from pokeapi import get_random_pokemon_name, get_pokemon_details
from db import get_pokemon_from_db, add_pokemon_to_db


def print_pokemon(pokemon):
    print(f"\n You got {pokemon['name']}!")
    print(f"  Height: {pokemon['height']}")
    print(f"  Weight: {pokemon['weight']}\n")


def main():
    print("Welcome to Pokémon Drawer!")

    while True:
        choice = input("Would you like to draw a Pokémon? (yes/no): ").strip().lower()
        if choice == 'yes':
            try:
                name = get_random_pokemon_name()
                existing = get_pokemon_from_db(name)
                if existing:
                    print("Already in database.")
                    print_pokemon(existing)
                else:
                    details = get_pokemon_details(name)
                    add_pokemon_to_db(details)
                    print_pokemon(details)
            except Exception as e:
                print(f"Error: {e}")
                print("Please try again.")

        elif choice == 'no':
            print("Goodbye! See you next time.")
            break
        else:
            print("Please type 'yes' or 'no'.")


if __name__ == "__main__":
    main()