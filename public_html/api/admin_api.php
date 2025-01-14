<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Błąd połączenia z bazą danych: ' . $e->getMessage()]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

if (!isset($_SESSION['admin'])) {
    echo json_encode(['success' => false, 'error' => 'Brak dostępu. Zaloguj się jako administrator.']);
    exit;
}

// Pobieranie użytkowników
if ($method === 'GET' && $action === 'users') {
    try {
        // Zatwierdzeni użytkownicy
        $stmtAccepted = $pdo->query("SELECT user_id, first_name, last_name, email, admin FROM user WHERE user_confirmed = 1");
        $acceptedUsers = $stmtAccepted->fetchAll(PDO::FETCH_ASSOC);

        // Oczekujący użytkownicy
        $stmtPending = $pdo->query("SELECT user_id, first_name, last_name, email FROM user WHERE user_confirmed = 0");
        $pendingUsers = $stmtPending->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'accepted_users' => $acceptedUsers,
            'pending_users' => $pendingUsers
        ]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd pobierania użytkowników: ' . $e->getMessage()]);
    }
    exit;
}

// Pobieranie wydarzeń
if ($method === 'GET' && $action === 'events') {
    try {
        $stmtEvents = $pdo->query("SELECT event_id, title, event_date, place, event_confirmed FROM event");
        $events = $stmtEvents->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'events' => $events]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd pobierania wydarzeń: ' . $e->getMessage()]);
    }
    exit;
}

// Aktualizacja użytkowników i wydarzeń
if ($method === 'POST' && $action === 'update') {
    $data = json_decode(file_get_contents('php://input'), true);

    // Operacje na użytkownikach
    if (isset($data['user_id'], $data['operation'])) {
        try {
            $userId = $data['user_id'];
            if ($data['operation'] === 'nadaj_admin') {
                $stmt = $pdo->prepare("UPDATE user SET admin = 1 WHERE user_id = :user_id");
            } elseif ($data['operation'] === 'odbierz_admin') {
                $stmt = $pdo->prepare("UPDATE user SET admin = 0 WHERE user_id = :user_id");
            } elseif ($data['operation'] === 'zatwierdz_uzytkownika') {
                $stmt = $pdo->prepare("UPDATE user SET user_confirmed = 1 WHERE user_id = :user_id");
            } elseif ($data['operation'] === 'odrzuc_uzytkownika') {
                $stmt = $pdo->prepare("DELETE FROM user WHERE user_id = :user_id");
            } else {
                echo json_encode(['success' => false, 'error' => 'Nieprawidłowa operacja użytkownika.']);
                exit;
            }
            $stmt->execute(['user_id' => $userId]);
            echo json_encode(['success' => true, 'message' => 'Operacja na użytkowniku wykonana pomyślnie.']);
        } catch (PDOException $e) {
            echo json_encode(['success' => false, 'error' => 'Błąd aktualizacji użytkownika: ' . $e->getMessage()]);
        }
        exit;
    }

    // Operacje na wydarzeniach
    if (isset($data['event_id'], $data['operation'])) {
        try {
            $eventId = $data['event_id'];
            if ($data['operation'] === 'zatwierdz_wydarzenie') {
                $stmt = $pdo->prepare("UPDATE event SET event_confirmed = 1 WHERE event_id = :event_id");
            } elseif ($data['operation'] === 'usun_wydarzenie') {
                $stmt = $pdo->prepare("DELETE FROM event WHERE event_id = :event_id");
            } else {
                echo json_encode(['success' => false, 'error' => 'Nieprawidłowa operacja wydarzenia.']);
                exit;
            }
            $stmt->execute(['event_id' => $eventId]);
            echo json_encode(['success' => true, 'message' => 'Operacja na wydarzeniu wykonana pomyślnie.']);
        } catch (PDOException $e) {
            echo json_encode(['success' => false, 'error' => 'Błąd aktualizacji wydarzenia: ' . $e->getMessage()]);
        }
        exit;
    }

    echo json_encode(['success' => false, 'error' => 'Nieprawidłowe dane wejściowe.']);
    exit;
}

// Wylogowanie administratora
if ($method === 'GET' && $action === 'logout') {
    session_unset();
    session_destroy();
    echo json_encode(['success' => true, 'message' => 'Wylogowano pomyślnie.']);
    exit;
}

echo json_encode(['success' => false, 'error' => 'Nieprawidłowe żądanie.']);
