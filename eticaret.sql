CREATE TABLE Musteri (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad VARCHAR(50),
    soyad VARCHAR(50),
    email VARCHAR(100),
    sehir VARCHAR(50),
    kayit_tarihi DATE
);

CREATE TABLE Kategori (
    id INT IDENTITY(1,1) PRIMARY KEY ,
    ad VARCHAR(50)
);

CREATE TABLE Satici (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad VARCHAR(50),
    adres VARCHAR(100)
);

CREATE TABLE Urun (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad VARCHAR(50),
    fiyat DECIMAL(10,2),
    stok INT,
    kategori_id INT,
    satici_id INT,
    FOREIGN KEY (kategori_id) REFERENCES Kategori(id),
    FOREIGN KEY (satici_id) REFERENCES Satici(id)
);

CREATE TABLE Siparis (
    id INT IDENTITY(1,1) PRIMARY KEY ,
    musteri_id INT,
    tarih DATE,
    toplam_tutar DECIMAL(10,2),
    odeme_turu VARCHAR(20),
    FOREIGN KEY (musteri_id) REFERENCES Musteri(id)
);

CREATE TABLE Siparis_Detay (
    id INT IDENTITY(1,1) PRIMARY KEY ,
    siparis_id INT,
    urun_id INT,
    adet INT,
    fiyat DECIMAL(10,2),
    FOREIGN KEY (siparis_id) REFERENCES Siparis(id),
    FOREIGN KEY (urun_id) REFERENCES Urun(id)
);
-- Müşteriler
INSERT INTO Musteri (ad, soyad, email, sehir, kayit_tarihi)
VALUES 
('Elif', 'UYGUN', 'elif@example.com', 'Malatya', '2025-01-10'),
('Melike', 'BAKIRCI', 'melike@example.com', 'Malatya', '2025-02-15'),
('Mehmet', 'Demir', 'mehmet@example.com', 'İzmir', '2025-03-05');

-- Kategoriler
INSERT INTO Kategori (ad) VALUES ('Elektronik'), ('Giyim'), ('Kitap');

-- Satıcılar
INSERT INTO Satici (ad, adres) VALUES ('TeknoMarket', 'İstanbul'), ('ModaStore', 'Ankara');

-- Ürünler
INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id)
VALUES 
('Laptop', 15000, 10, 1, 1),
('T-shirt', 200, 50, 2, 2),
('Roman Kitap', 50, 100, 3, 2);

-- Sipariş ve Sipariş Detay
INSERT INTO Siparis (musteri_id, tarih, toplam_tutar, odeme_turu)
VALUES (1, '2025-09-01', 15250, 'Kredi Kartı');

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES (1, 1, 1, 15000), (1, 3, 5, 50);
-- Stok güncelleme
UPDATE Urun SET stok = stok - 1 WHERE id = 1;

-- Ürün silme
DELETE FROM Urun WHERE id = 2;

-- Tüm sipariş detaylarını temizleme
TRUNCATE TABLE Siparis_Detay;
-- Sipariş + müşteri + ürün + satıcı
SELECT s.id AS siparis_id, m.ad AS musteri, u.ad AS urun, sd.adet, u.fiyat, sa.ad AS satici
FROM Siparis s
JOIN Musteri m ON s.musteri_id = m.id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
JOIN Urun u ON sd.urun_id = u.id
JOIN Satici sa ON u.satici_id = sa.id;

-- Hiç satılmamış ürünler
SELECT * FROM Urun WHERE id NOT IN (SELECT urun_id FROM Siparis_Detay);

-- Hiç sipariş vermemiş müşteriler
SELECT * FROM Musteri WHERE id NOT IN (SELECT musteri_id FROM Siparis);
-- Şehirlere göre müşteri sayısı
SELECT sehir, COUNT(*) AS musteri_sayisi FROM Musteri GROUP BY sehir;

-- Kategori bazlı toplam satışlar
SELECT k.ad AS kategori, SUM(sd.adet * sd.fiyat) AS toplam_satis
FROM Kategori k
JOIN Urun u ON k.id = u.kategori_id
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY k.id;

--Aylara göre sipariş sayısı
SELECT DATE_FORMAT(tarih, '%Y-%m') AS ay, COUNT(*) AS siparis_sayisi
FROM Siparis
GROUP BY ay;
--1000 TL’den fazla toplam satış yapan kategoriler
SELECT k.ad AS kategori, SUM(sd.adet * sd.fiyat) AS toplam_satis
FROM Kategori k
JOIN Urun u ON k.id = u.kategori_id
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY k.id
HAVING toplam_satis > 1000;
