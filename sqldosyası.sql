-- ============================
-- VERİTABANI OLUŞTUR
-- ============================
CREATE DATABASE IF NOT EXISTS yemek_siparis;
USE yemek_siparis;

-- ============================
-- TABLOLAR
-- ============================

-- Kullanıcılar
CREATE TABLE IF NOT EXISTS kullanicilar (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(100),
    email VARCHAR(150)
);

-- Log kayıtları
CREATE TABLE IF NOT EXISTS log_kayitlari (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    aciklama VARCHAR(255),
    log_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Restoranlar
CREATE TABLE IF NOT EXISTS restoranlar (
    restoran_id INT AUTO_INCREMENT PRIMARY KEY,
    restoran_adi VARCHAR(255),
    adres VARCHAR(255)
);

-- Ürünler
CREATE TABLE IF NOT EXISTS urunler (
    urun_id INT AUTO_INCREMENT PRIMARY KEY,
    urun_adi VARCHAR(255),
    restoran_id INT,
    fiyat DECIMAL(10,2),
    stok INT DEFAULT 0,
    FOREIGN KEY (restoran_id) REFERENCES restoranlar(restoran_id)
);

-- Siparişler
CREATE TABLE IF NOT EXISTS siparisler (
    siparis_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    siparis_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    toplam_tutar DECIMAL(10,2) DEFAULT 0,
    durum ENUM('Hazırlanıyor','Yolda','Teslim Edildi','İptal') DEFAULT 'Hazırlanıyor',
    FOREIGN KEY (user_id) REFERENCES kullanicilar(user_id)
);

-- Sipariş detayları
CREATE TABLE IF NOT EXISTS siparis_detay (
    siparis_detay_id INT AUTO_INCREMENT PRIMARY KEY,
    siparis_id INT,
    urun_id INT,
    adet INT DEFAULT 1,
    fiyat DECIMAL(10,2),
    FOREIGN KEY (siparis_id) REFERENCES siparisler(siparis_id),
    FOREIGN KEY (urun_id) REFERENCES urunler(urun_id)
);

-- ============================
-- TRIGGER ÖRNEKLERİ
-- ============================

DELIMITER $$
CREATE TRIGGER trg_siparis_silme
AFTER DELETE ON siparisler
FOR EACH ROW
BEGIN
    INSERT INTO log_kayitlari (aciklama)
    VALUES (CONCAT('Sipariş silindi: ', OLD.siparis_id));
END$$
DELIMITER ;

-- ============================
-- ÖRNEK VERİLER
-- ============================

-- Kullanıcılar
INSERT INTO kullanicilar (ad,email) VALUES
('Ahmet Yılmaz','ahmet@example.com'),
('Ayşe Demir','ayse@example.com');

-- Restoranlar
INSERT INTO restoranlar (restoran_adi) VALUES
('PİZZA HOUSE'),
('Kudret Et');

-- Ürünler
INSERT INTO urunler (urun_adi,restoran_id,fiyat) VALUES
('pizza',1,1,110);

-- Siparişler
INSERT INTO siparisler (user_id,toplam_tutar) VALUES (1,55.0);

-- Sipariş detayları
INSERT INTO siparis_detay (siparis_id,urun_id,adet,fiyat) VALUES
(7,1,1,110);