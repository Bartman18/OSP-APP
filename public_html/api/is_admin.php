<?php
session_start();

header('Content-Type: application/json');

// Sprawdź, czy użytkownik jest zalogowany
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'Użytkownik nie jest zalogowany.']);
    exit;
}

// Sprawdź, czy użytkownik jest administratorem
if (isset($_SESSION['admin']) && $_SESSION['admin'] === 1) {
    echo json_encode(['success' => true, 'is_admin' => true]);
} else {
    echo json_encode(['success' => true, 'is_admin' => false]);
}
