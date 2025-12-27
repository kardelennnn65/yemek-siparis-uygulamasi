<?php
include "db.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn->query("
        INSERT INTO siparisler (user_id, restoran_id, toplam_tutar)
        VALUES (1, 1, 150)
    ");
    echo "<p>✅ Sipariş eklendi</p>";
}
?>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        padding: 30px;
    }

    h2, h3 {
        color: #333;
    }

    ul {
        background: #fff;
        padding: 15px 25px;
        width: 300px;
        border-radius: 6px;
    }

    li {
        margin-bottom: 8px;
    }

    button {
        padding: 10px 20px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #45a049;
    }

    a {
        display: inline-block;
        margin-top: 15px;
        text-decoration: none;
        color: #0066cc;
    }
</style>


<h2>Sipariş Ekle</h2>

<h3>Menü (Örnek Ürünler)</h3>

<ul>
<?php
$urunler = $conn->query("SELECT urun_adi, fiyat FROM urunler");

while ($u = $urunler->fetch_assoc()) {
    echo "<li>" . $u["urun_adi"] . " - " . $u["fiyat"] . " TL</li>";
}
?>
</ul>

<form method="post">
    <button type="submit">Sipariş Oluştur</button>
</form>

<a href="index.php">Geri</a>
