<?php
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    // Walidacja danych wejściowych
    if (!isset($data['email'], $data['password'], $data['first_name'], $data['last_name'], $data['phone'])) {
        echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych (email, password, first_name, last_name, phone).']);
        exit;
    }

    $email = $data['email'];
    $password = $data['password'];
    $firstName = $data['first_name'];
    $lastName = $data['last_name'];
    $phone = $data['phone'];

    try {
        $pdo = getDatabaseConnection();

        // Sprawdzenie, czy użytkownik już istnieje
        $stmt = $pdo->prepare('SELECT user_id FROM user WHERE email = :email');
        $stmt->execute(['email' => $email]);
        if ($stmt->fetch()) {
            echo json_encode(['success' => false, 'error' => 'Użytkownik o tym adresie email już istnieje.']);
            exit;
        }

        // Rejestracja użytkownika
        $passwordHash = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $pdo->prepare('INSERT INTO user (email, password_hash, first_name, last_name, phone, user_confirmed, admin, joined_at) 
        VALUES (:email, :password_hash, :first_name, :last_name, :phone, 0, 0, NOW())');

        $stmt->execute([
            'email' => $email,
            'password_hash' => $passwordHash,
            'first_name' => $firstName,
            'last_name' => $lastName,
            'phone' => $phone
        ]);

        echo json_encode(['success' => true, 'message' => 'Rejestracja zakończona sukcesem.']);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas rejestracji: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
