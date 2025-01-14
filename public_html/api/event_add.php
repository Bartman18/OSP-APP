<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

// Sprawdzenie, czy użytkownik jest zalogowany jako admin
if (!isset($_SESSION['admin']) || !is_numeric($_SESSION['admin'])) {
    echo json_encode(['success' => false, 'error' => 'Brak dostępu. Zaloguj się jako administrator.']);
    exit;
}

// Pobranie ID zalogowanego administratora
$adminId = $_SESSION['admin'];

// Połączenie z bazą danych
try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Błąd połączenia z bazą danych: ' . $e->getMessage()]);
    exit;
}

// Obsługa żądania POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    // Walidacja danych
    if (!isset($data['title'], $data['description'], $data['date'], $data['place'], $data['person_limit'], $data['type'])) {
        echo json_encode(['success' => false, 'error' => 'Nieprawidłowe dane wejściowe.']);
        exit;
    }

    $title = $data['title'];
    $description = $data['description'];
    $date = $data['date'];
    $place = $data['place'];
    $type = $data['type'];
    $personLimit = $data['person_limit'];

    try {
        $stmt = $pdo->prepare("INSERT INTO event (title, description, event_date, place, type, person_limit, event_confirmed, user_id) 
                               VALUES (:title, :description, :event_date, :place, :type, :person_limit, 0, :user_id)");
        $stmt->execute([
            'title' => $title,
            'description' => $description,
            'event_date' => $date,
            'place' => $place,
            'type' => $type,
            'person_limit' => $personLimit,
            'user_id' => $adminId
        ]);
        echo json_encode(['success' => true, 'message' => 'Wydarzenie zostało dodane pomyślnie.']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd dodawania wydarzenia: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda żądania.']);
}
