<?php
include "db.php";

$result = $conn->query("SELECT restoran_adi FROM restoranlar");
?>

<h2>Restoranlar</h2>

<ul>
<?php
while ($row = $result->fetch_assoc()) {
    echo "<li>" . $row["restoran_adi"] . "</li>";
}
?>
</ul>

<a href="index.php">Geri</a>
