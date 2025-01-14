<?php
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['user_id'])) {
    $userId = $_GET['user_id'];
    $pdo = getDatabaseConnection();

    $userStmt = $pdo->prepare('SELECT * FROM user WHERE user_id = :user_id');
    $userStmt->execute(['user_id' => $userId]);
    $user = $userStmt->fetch(PDO::FETCH_ASSOC);

    $coursesStmt = $pdo->prepare('SELECT * FROM courses WHERE user_id = :user_id');
    $coursesStmt->execute(['user_id' => $userId]);
    $courses = $coursesStmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['user' => $user, 'courses' => $courses]);
}
?>
