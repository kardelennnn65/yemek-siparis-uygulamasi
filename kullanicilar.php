<?php
include "db.php";

$result = $conn->query("SELECT ad, email FROM kullanicilar");
?>

<h2>Kullanıcılar</h2>

<ul>
<?php
while ($row = $result->fetch_assoc()) {
    echo "<li>" . $row["ad"] . " - " . $row["email"] . "</li>";
}
?>
</ul>

<a href="index.php">Geri</a>
