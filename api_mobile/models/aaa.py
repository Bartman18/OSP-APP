from werkzeug.security import generate_password_hash, check_password_hash

# Generowanie hasha dla hasła
password = "Haslo1"
hashed_password = generate_password_hash(password)
print(f"Generated hash: {hashed_password}")

# Sprawdzanie poprawności hasła
if check_password_hash(hashed_password, "Haslo1"):
    print("Hasło jest poprawne")
else:
    print("Hasło jest niepoprawne")
