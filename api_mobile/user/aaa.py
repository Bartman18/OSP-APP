from werkzeug.security import generate_password_hash, check_password_hash

# Hash a password
hashed_password = generate_password_hash("mypassword")

# Verify a password
is_valid = check_password_hash(hashed_password, "mypassword")

print(f"Hashed Password: {hashed_password}")
print("Password is valid:", is_valid)