<?php
require_once 'config.php';

header('Content-Type: application/json');

$pdo = getDatabaseConnection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // Pobieranie tylko zatwierdzonych wydarzeń
        $stmt = $pdo->query("
            SELECT 
                e.event_id, 
                e.title, 
                e.event_date, 
                e.place, 
                e.type, 
                e.description, 
                e.person_limit, 
                (SELECT COUNT(*) FROM participation WHERE event_id = e.event_id) AS participants,
                GROUP_CONCAT(CONCAT(u.first_name, ' ', u.last_name) ORDER BY p.signed_data ASC SEPARATOR ', ') AS participant_list
            FROM event e
            LEFT JOIN participation p ON e.event_id = p.event_id
            LEFT JOIN user u ON p.user_id = u.user_id
            WHERE e.event_confirmed = 1 -- Tylko zatwierdzone wydarzenia
            GROUP BY e.event_id
            ORDER BY e.event_date DESC
        ");
        $events = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success' => true, 'events' => $events]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas pobierania wydarzeń: ' . $e->getMessage()]);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['user_id'], $data['event_id'], $data['status'])) {
        echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych (user_id, event_id, status).']);
        exit;
    }

    $userId = $data['user_id'];
    $eventId = $data['event_id'];
    $status = $data['status'];

    try {
        if ($status === 'accepted') {
            // Sprawdzanie limitu uczestników
            $stmt = $pdo->prepare("SELECT person_limit, (SELECT COUNT(*) FROM participation WHERE event_id = :event_id) AS participants FROM event WHERE event_id = :event_id");
            $stmt->execute(['event_id' => $eventId]);
            $event = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($event['participants'] >= $event['person_limit']) {
                echo json_encode(['success' => false, 'error' => 'Liczba uczestników osiągnęła maksymalny limit.']);
                exit;
            }

            // Dodawanie użytkownika do wydarzenia
            $stmt = $pdo->prepare('INSERT INTO participation (user_id, event_id, signed_data) VALUES (:user_id, :event_id, NOW())');
            $stmt->execute(['user_id' => $userId, 'event_id' => $eventId]);
            echo json_encode(['success' => true, 'message' => 'Udział zaakceptowany.']);
        } elseif ($status === 'rejected') {
            // Usuwanie użytkownika z wydarzenia
            $stmt = $pdo->prepare('DELETE FROM participation WHERE user_id = :user_id AND event_id = :event_id');
            $stmt->execute(['user_id' => $userId, 'event_id' => $eventId]);
            echo json_encode(['success' => true, 'message' => 'Udział odrzucony.']);
        } else {
            echo json_encode(['success' => false, 'error' => 'Nieprawidłowy status.']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas obsługi uczestnictwa: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
