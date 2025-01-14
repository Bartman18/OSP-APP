<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false]);
} else {
    echo json_encode(['success' => true, 'admin' => $_SESSION['admin']]);
}
?>