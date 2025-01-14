<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'host74075_test');
define('DB_USER', 'host74075_test');
define('DB_PASS', 'egLsmHT4VXRbH3TZJBKz');

function getDatabaseConnection() {
    try {
        $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch (PDOException $e) {
        die(json_encode(['error' => 'Błąd połączenia z bazą danych: ' . $e->getMessage()]));
    }
}
?>
