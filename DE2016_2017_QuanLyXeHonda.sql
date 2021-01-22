CREATE DATABASE DE2016_2017_QuanLyXeHonda
USE DE2016_2017_QuanLyXeHonda drop database DE2016_2017_QuanLyXeHonda 
--Đề 1 
CREATE TABLE Xe
(
	maxe CHAR(4) CONSTRAINT XE_maxe_PK PRIMARY KEY,
	sokhung INT,
	somay INT,
	mau VARCHAR(10),
	kieuxe CHAR(4),
	sohd CHAR(4)
)

CREATE TABLE Banggia
(
	kieuxe CHAR(4) CONSTRAINT BG_kieuxe_PK PRIMARY KEY,
	giaban MONEY
)

CREATE TABLE Khachhang
(
	makh CHAR(4) CONSTRAINT KH_makh_PK PRIMARY KEY,
	tenkh VARCHAR(30) NOT NULL,
	thanhpho VARCHAR(25),
	sodienthoai VARCHAR(10),
	loaikh VARCHAR(10) DEFAULT(NULL)
)

CREATE TABLE Hoadon
(
	sohd CHAR(4) CONSTRAINT HD_sohd_PK PRIMARY KEY,
	ngayban SMALLDATETIME,
	makh CHAR(4)
)

ALTER TABLE Xe ADD CONSTRAINT XE_sohd_FK FOREIGN KEY(sohd)
	REFERENCES Hoadon(sohd)

ALTER TABLE Xe ADD CONSTRAINT XE_kieuxe_FK FOREIGN KEY(kieuxe)
	REFERENCES Banggia(kieuxe)

ALTER TABLE Hoadon ADD CONSTRAINT HD_makh_FK FOREIGN KEY(makh)
	REFERENCES Khachhang(makh)

INSERT INTO Banggia VALUES('KX01',100000)
INSERT INTO Banggia VALUES('KX02',200000)
INSERT INTO Banggia VALUES('KX03',300000)
INSERT INTO Banggia VALUES('KX04',400000)

INSERT INTO Khachhang VALUES('KH01','Khach hang A','TP.HCM','0912345678', NULL)
INSERT INTO Khachhang VALUES('KH02','Khach hang B','HUE','0912345678', NULL)
INSERT INTO Khachhang VALUES('KH03','Khach hang C','HANOI','0912345678', NULL)
INSERT INTO Khachhang VALUES('KH04','Nguyen Van X','TP.HCM','0909654321', NULL)

INSERT INTO Hoadon VALUES('HD01','1/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD02','2/12/2014','KH02')
INSERT INTO Hoadon VALUES('HD03','3/12/2014','KH03')
INSERT INTO Hoadon VALUES('HD04','4/12/2014','KH04')
INSERT INTO Hoadon VALUES('HD05','5/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD06','6/12/2014','KH02')

INSERT INTO Xe VALUES('X002',null,null,'Xanh','KX01','HD01')
INSERT INTO Xe VALUES('X001',null,null,'Xanh','KX02','HD02')
INSERT INTO Xe VALUES('X003',null,null,'Xanh','KX03','HD03')
INSERT INTO Xe VALUES('X004',null,null,'Xanh','KX03',NULL)
INSERT INTO Xe VALUES('X005',null,null,'Xanh','KX03','HD04')
INSERT INTO Xe VALUES('X006',null,null,'Xanh','KX02','HD01')
INSERT INTO Xe VALUES('X007',null,null,'Xanh','KX01','HD01')
INSERT INTO Xe VALUES('X008',null,null,'Xanh','KX03','HD01')
INSERT INTO Xe VALUES('X009',null,null,'Xanh','KX04','HD05')
INSERT INTO Xe VALUES('X010',null,null,'Xanh','KX04','HD01')
INSERT INTO Xe VALUES('X011',null,null,'Xanh','KX04','HD05')
INSERT INTO Xe VALUES('X012',null,null,'Xanh','KX04','HD03')

/*1 Loại khách hàng (loaikh) là ‘TT’ nếu khách hàng mua ít hơn 5 hóa đơn, là ‘TV’ nếu
khách hàng mua từ 5 hóa đơn trở lên.*/
GO --Chưa được
CREATE TRIGGER TRG_Hoadon_makh_INS_UPD_DEL ON Hoadon
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @makh CHAR(4),
			@loaikh VARCHAR(10),
			@sohoadonduocmua INT

	SELECT @makh = makh
	FROM INSERTED

	SELECT @makh = makh
	FROM DELETED

	SELECT @sohoadonduocmua = COUNT(sohd)
	FROM Hoadon
	WHERE makh = @makh

	IF(@sohoadonduocmua >= 5)
	BEGIN
		UPDATE Khachhang
		SET loaikh = 'TV'
		WHERE makh = @makh
	END
	ELSE
	BEGIN
		UPDATE Khachhang
		SET loaikh = 'TT'
		WHERE makh = @makh
	END
END	
--Kiểm tra Trigger
SELECT* FROM Khachhang
SELECT* FROM Hoadon
INSERT INTO Hoadon VALUES('HD07','1/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD08','1/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD09','1/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD10','1/12/2014','KH01')
INSERT INTO Hoadon VALUES('HD11','1/12/2014','KH01')
UPDATE Hoadon
SET makh = 'KH01'
WHERE sohd = 'HD09'

GO
CREATE TRIGGER TRG_Khachhang_loaikh_UPD ON Khachhang
FOR UPDATE
AS
BEGIN
	DECLARE @loaikh VARCHAR(10),
			@makh CHAR(4),
			@sohoadonduocmua INT

	SELECT @makh = makh, @loaikh = loaikh
	FROM INSERTED

	SELECT @sohoadonduocmua = COUNT(sohd)
	FROM Hoadon
	WHERE makh = @makh

	IF(@sohoadonduocmua >= 5 AND @loaikh <> 'TV') OR (@sohoadonduocmua < 5 AND @loaikh <> 'TT')
	BEGIN
		PRINT('TRG_Khachhang_loaikh_UPD: loaikh = "TT" neu khach hang mua it hon 5 hoa don, "TV" neu khach hang mua tu 5 hoa don tro len')
		ROLLBACK TRANSACTION
	END
END
	
/*2a. Một khách hàng mua xe của hãng nhưng chưa kịp làm giấy tờ và bị trộm mất.
Biết rằng, thông tin có được từ khách hàng là tên khách hàng (“Nguyễn Văn X”),
số điện thoại (0909654321), thành phố (“TP. HCM”). Hãy viết câu truy vấn tìm
thông tin chiếc xe gồm: số khung, số máy, kiểu xe đã được mua để giúp anh ta
trình báo với công an về chiếc xe bị đánh mất.*/
SELECT sokhung, somay, kieuxe
FROM (Hoadon HD JOIN Xe X ON X.sohd = HD.sohd)
		JOIN Khachhang KH ON KH.makh = HD.makh
WHERE tenkh = 'Nguyen Van X' 
AND sodienthoai = '0909654321'
AND thanhpho = 'TP.HCM'

/*2b. Cho biết doanh thu (tổng tiền bán) trong năm 2014 theo từng kiểu xe (kieuxe).*/
SELECT BG.kieuxe, SUM(giaban) tongtienban
FROM (Xe X JOIN Banggia BG ON X.kieuxe = BG.kieuxe)
		JOIN Hoadon HD ON HD.sohd = X.sohd
WHERE YEAR(ngayban) = 2014 AND X.sohd <> 'NULL'
GROUP BY BG.kieuxe

/*2c. Cho biết những kiểu xe (kieuxe, giaban) chưa có khách hàng nào mua.*/
SELECT kieuxe, giaban
FROM Banggia
EXCEPT
SELECT BG.kieuxe, giaban
FROM Xe X JOIN Banggia BG ON X.kieuxe = BG.kieuxe
WHERE sohd <> 'NULL'

/*2d. Cho biết các kiểu xe (kieuxe) có tổng số lượng xe đã bán cho khách hàng ở
TP.HCM (thanhpho=”TP. HCM”) đạt từ 500 chiếc trở lên.*/
SELECT BG.kieuxe, COUNT(*) Tongsoluongxedaban
FROM ((Xe X JOIN Banggia BG ON X.kieuxe = BG.kieuxe)
		JOIN Hoadon HD ON HD.sohd = X.sohd)
			JOIN Khachhang KH ON KH.makh = HD.makh
WHERE X.sohd <> 'NULL' AND thanhpho = 'TP.HCM'
GROUP BY BG.kieuxe
HAVING COUNT(*) >= 500

/*2e. Tìm số hóa đơn (sohd) đã mua tất cả các kiểu xe.*/
SELECT sohd
FROM Hoadon HD
WHERE NOT EXISTS(	SELECT*
					FROM Banggia BG
					WHERE NOT EXISTS(	SELECT*
										FROM Xe X
										WHERE X.kieuxe = BG.kieuxe
										AND X.sohd = HD.sohd))

/*2f. Cho biết những khách hàng (makh, tenkh) mua những kiểu xe có giá bán cao nhất.*/
SELECT DISTINCT KH.makh, tenkh
FROM ((Xe X JOIN Banggia BG ON X.kieuxe = BG.kieuxe)
		JOIN Hoadon HD ON HD.sohd = X.sohd)
			JOIN Khachhang KH ON KH.makh = HD.makh
WHERE X.sohd <> 'NULL' AND giaban IN (SELECT MAX(giaban) FROM Banggia)
