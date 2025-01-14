<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $data = json_decode(file_get_contents('php://input'), true);

        if (!isset($data['email'], $data['password'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'error' => 'Nieprawidłowe dane wejściowe.']);
            exit;
        }

        $email = $data['email'];
        $password = $data['password'];

        $pdo = getDatabaseConnection();
        $stmt = $pdo->prepare('SELECT * FROM user WHERE email = :email');
        $stmt->execute(['email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password_hash'])) {
            if ((int)$user['user_confirmed'] !== 1) {
                http_response_code(403);
                echo json_encode(['success' => false, 'error' => 'Użytkownik nie został zatwierdzony przez administratora.']);
                exit;
            }

            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['user_name'] = $user['first_name'];
            $_SESSION['admin'] = (int)$user['admin'];

            echo json_encode([
                'success' => true,
                'user_id' => $user['user_id'],
                'name' => $user['first_name'],
                'admin' => (int)$user['admin']
            ]);
        } else {
            http_response_code(401);
            echo json_encode(['success' => false, 'error' => 'Niepoprawne dane logowania.']);
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Błąd serwera: ' . $e->getMessage()]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
