<?php
require_once 'config.php';

header('Content-Type: application/json');

$pdo = getDatabaseConnection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $userId = $_GET['user_id'] ?? null;

    if (!$userId) {
        echo json_encode(['success' => false, 'error' => 'Brak ID użytkownika.']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("SELECT first_name, last_name, email, phone FROM user WHERE user_id = :user_id");
        $stmt->execute(['user_id' => $userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            echo json_encode(['success' => false, 'error' => 'Nie znaleziono użytkownika.']);
            exit;
        }

        $stmt = $pdo->prepare("SELECT course_id, course_type, obtained_date, expiry_date FROM courses WHERE user_id = :user_id");
        $stmt->execute(['user_id' => $userId]);
        $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'user' => $user,
            'courses' => $courses
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas pobierania danych: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
