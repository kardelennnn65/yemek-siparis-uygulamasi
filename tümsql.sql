-- =========================================
-- Veritabanını Kullan
-- =========================================
USE yemek_siparis;

-- =========================================
-- 10 Örnek Sorgu
-- =========================================
-- 1. Tüm kullanıcılar
SELECT * FROM kullanicilar;

-- 2. Tüm siparişler
SELECT * FROM siparisler;

-- 3. Bir kullanıcının sipariş detayları
SELECT sd.*, s.kullanici_id, u.urun_adi
FROM siparis_detay sd
JOIN siparisler s ON sd.siparis_id = s.siparis_id
JOIN urunler u ON sd.urun_id = u.urun_id
WHERE s.kullanici_id = 1;

-- 4. Kullanıcıya göre sipariş sayısı
SELECT s.kullanici_id, COUNT(*) AS siparis_sayisi
FROM siparisler s
GROUP BY s.kullanici_id;

-- 5. Kullanıcıya göre toplam harcama
SELECT s.kullanici_id, SUM(sd.ara_toplam) AS toplam_harcama
FROM siparis_detay sd
JOIN siparisler s ON sd.siparis_id = s.siparis_id
GROUP BY s.kullanici_id;

-- 6. En yüksek tutarlı sipariş
SELECT * FROM siparis_detay
ORDER BY ara_toplam DESC
LIMIT 1;

-- 7. Son 7 günün siparişleri
SELECT * FROM siparisler
WHERE siparis_tarihi >= DATE_SUB(NOW(), INTERVAL 7 DAY);

-- 8. Kullanıcı ve sipariş detayları
SELECT s.siparis_id, k.ad_soyad, u.urun_adi, sd.adet, sd.ara_toplam
FROM siparis_detay sd
JOIN siparisler s ON sd.siparis_id = s.siparis_id
JOIN kullanicilar k ON s.kullanici_id = k.kullanici_id
JOIN urunler u ON sd.urun_id = u.urun_id;

-- 9. Adedi 2’den fazla olan siparişler
SELECT * FROM siparis_detay WHERE adet > 2;

-- 10. Restoran bazında toplam satış
SELECT r.restoran_id, r.restoran_adi, SUM(sd.ara_toplam) AS toplam_satis
FROM siparis_detay sd
JOIN urunler u ON sd.urun_id = u.urun_id
JOIN restoranlar r ON u.restoran_id = r.restoran_id
GROUP BY r.restoran_id, r.restoran_adi;

-- =========================================
-- 3 Stored Procedure
-- =========================================
DELIMITER $$

-- 1. Kullanıcı ekleme
CREATE PROCEDURE sp_KullaniciEkle(IN adsoyad VARCHAR(100), IN mail VARCHAR(100))
BEGIN
    INSERT INTO kullanicilar(ad_soyad, email) VALUES(adsoyad, mail);
END$$

-- 2. Sipariş ekleme
CREATE PROCEDURE sp_SiparisEkle(IN k_id INT, IN u_id INT, IN miktar INT)
BEGIN
    DECLARE toplam DECIMAL(10,2);
    SELECT fiyat * miktar INTO toplam FROM urunler WHERE urun_id = u_id;
    INSERT INTO siparisler(kullanici_id) VALUES(k_id);
    INSERT INTO siparis_detay(siparis_id, urun_id, adet, ara_toplam)
    VALUES(LAST_INSERT_ID(), u_id, miktar, toplam);
END$$

-- 3. Kullanıcı sil ve log ekle
CREATE PROCEDURE sp_KullaniciSil(IN k_id INT)
BEGIN
    DELETE FROM kullanicilar WHERE kullanici_id = k_id;
    INSERT INTO log_kayitlari(aciklama) VALUES(CONCAT('Kullanıcı silindi: ', k_id));
END$$

DELIMITER ;

-- =========================================
-- 3 View
-- =========================================
-- 1. Kullanıcı ve toplam harcaması
CREATE VIEW vw_KullaniciToplam AS
SELECT k.kullanici_id, k.ad_soyad, SUM(sd.ara_toplam) AS toplam_harcama
FROM kullanicilar k
LEFT JOIN siparisler s ON k.kullanici_id = s.kullanici_id
LEFT JOIN siparis_detay sd ON s.siparis_id = sd.siparis_id
GROUP BY k.kullanici_id, k.ad_soyad;

-- 2. Son 5 sipariş detayları
CREATE VIEW vw_SonSiparisDetay AS
SELECT * FROM siparis_detay
ORDER BY detay_id DESC
LIMIT 5;

-- 3. Çok sipariş veren kullanıcılar
CREATE VIEW vw_CokSiparisVeren AS
SELECT s.kullanici_id, COUNT(*) AS siparis_sayisi
FROM siparisler s
GROUP BY s.kullanici_id
HAVING COUNT(*) > 2;

-- =========================================
-- 3 Transaction
-- =========================================
-- 1. Sipariş ekleme
START TRANSACTION;
INSERT INTO siparis_detay(siparis_id, urun_id, adet, ara_toplam)
VALUES(7, 3, 2, 100.00);
COMMIT;

-- 2. Kullanıcı sil ve siparişlerini temizle
START TRANSACTION;
DELETE FROM siparis_detay WHERE siparis_id IN (SELECT siparis_id FROM siparisler WHERE kullanici_id = 2);
DELETE FROM siparisler WHERE kullanici_id = 2;
DELETE FROM kullanicilar WHERE kullanici_id = 2;
COMMIT;

-- 3. Sipariş güncelleme
START TRANSACTION;
UPDATE siparis_detay SET adet = 3, ara_toplam = 150.00 WHERE detay_id = 6;
COMMIT;
