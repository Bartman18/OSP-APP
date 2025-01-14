<?php
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['user_id'])) {
        echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych (user_id).']);
        exit;
    }

    $userId = $data['user_id'];
    $action = $data['action'] ?? '';

    try {
        $pdo = getDatabaseConnection();

        if ($action === 'add_course') {
            if (!isset($data['course_type'], $data['obtained_date'], $data['expiry_date'])) {
                echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych dla dodania kursu.']);
                exit;
            }

            $stmt = $pdo->prepare("INSERT INTO courses (user_id, course_type, obtained_date, expiry_date) VALUES (:user_id, :course_type, :obtained_date, :expiry_date)");

            $stmt->execute([
                'user_id' => $userId,
                'course_type' => $data['course_type'],
                'obtained_date' => $data['obtained_date'],
                'expiry_date' => $data['expiry_date']
            ]);
            echo json_encode(['success' => true, 'message' => 'Kurs został dodany.']);
        } elseif ($action === 'edit_course') {
            if (!isset($data['course_id'], $data['course_type'], $data['obtained_date'], $data['expiry_date'])) {
                echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych dla edycji kursu.']);
                exit;
            }

            $stmt = $pdo->prepare("UPDATE courses SET course_type = :course_type, obtained_date = :obtained_date, expiry_date = :expiry_date WHERE course_id = :course_id AND user_id = :user_id");
            $stmt->execute([
                'course_type' => $data['course_type'],
                'obtained_date' => $data['obtained_date'],
                'expiry_date' => $data['expiry_date'],
                'course_id' => $data['course_id'],
                'user_id' => $userId
            ]);
            echo json_encode(['success' => true, 'message' => 'Kurs został zaktualizowany.']);
        } elseif ($action === 'delete_course') {
            if (!isset($data['course_id'])) {
                echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych dla usunięcia kursu.']);
                exit;
            }

            $stmt = $pdo->prepare("DELETE FROM courses WHERE course_id = :course_id AND user_id = :user_id");
            $stmt->execute([
                'course_id' => $data['course_id'],
                'user_id' => $userId
            ]);
            echo json_encode(['success' => true, 'message' => 'Kurs został usunięty.']);
        } elseif ($action === 'edit_user') {
            if (!isset($data['first_name'], $data['last_name'], $data['email'], $data['phone'])) {
                echo json_encode(['success' => false, 'error' => 'Brak wymaganych danych dla edycji użytkownika.']);
                exit;
            }

            $stmt = $pdo->prepare("UPDATE user SET first_name = :first_name, last_name = :last_name, email = :email, phone = :phone WHERE user_id = :user_id");
            $stmt->execute([
                'first_name' => $data['first_name'],
                'last_name' => $data['last_name'],
                'email' => $data['email'],
                'phone' => $data['phone'],
                'user_id' => $userId
            ]);
            echo json_encode(['success' => true, 'message' => 'Dane użytkownika zostały zaktualizowane.']);
        } else {
            echo json_encode(['success' => false, 'error' => 'Nieprawidłowa akcja.']);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => 'Błąd podczas operacji: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Nieprawidłowa metoda HTTP.']);
}
