<?php
$conn = new mysqli("localhost", "root", "", "yemek_siparis");

if ($conn->connect_error) {
    die("Veritabanı bağlantı hatası");
}
?>
