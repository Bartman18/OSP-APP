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
        $stmt = $pdo->prepare("
            SELECT e.event_id, e.title, e.event_date
            FROM event e
            INNER JOIN participation p ON e.event_id = p.event_id
            WHERE p.user_id = :user_id
            ORDER BY p.signed_data ASC
        ");
        $stmt->execute(['user_id' => $userId]);
        $events = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'events' => $events]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas pobierania wydarzeń: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
?>