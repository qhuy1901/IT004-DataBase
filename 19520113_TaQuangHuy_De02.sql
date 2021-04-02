CREATE DATABASE QLythuexe
USE QLythuexe

--1.1
CREATE TABLE Loaixe
(
	maloaixe CHAR(4) CONSTRAINT LX_maloaixe_PK PRIMARY KEY,
	tenloaixe VARCHAR(20) NOT NULL
)

CREATE TABLE Xe
(
	bienso CHAR(10) CONSTRAINT X_bienso_PK PRIMARY KEY,
	maloaixe CHAR(4) CONSTRAINT X_maloaixe_FK FOREIGN KEY
			REFERENCES Loaixe(maloaixe)
)

CREATE TABLE Khachhang
(
	makh CHAR(4) CONSTRAINT KH_makh_PK PRIMARY KEY,
	hoten VARCHAR(20) NOT NULL,
	sdt VARCHAR(10),
	ngsinh SMALLDATETIME,
	gioitinh VARCHAR(3)
)

CREATE TABLE Trangthaidatcho
(
	matrangthai CHAR(4) CONSTRAINT TTDC_matrangthai_PK PRIMARY KEY,
	tentrangthai VARCHAR(50) NOT NULL
)

CREATE TABLE Datxe
(
	madatxe CHAR(10) CONSTRAINT DX_madatxe_PK PRIMARY KEY,
	makh CHAR(4) CONSTRAINT DX_makh_FK FOREIGN KEY
			REFERENCES Khachhang(makh),
	bienso CHAR(10) CONSTRAINT DX_bienso_FK FOREIGN KEY
			REFERENCES Xe(bienso),
	tungay SMALLDATETIME,
	denngay SMALLDATETIME,
	matrangthai CHAR(4) CONSTRAINT DX_matrangthai_FK FOREIGN KEY
			REFERENCES Trangthaidatcho(matrangthai),
	ghichu VARCHAR(50),
	ngaydat SMALLDATETIME
)

--1.2
ALTER TABLE Loaixe ADD ghichu VARCHAR(100)

--1.3 
ALTER TABLE Loaixe DROP COLUMN ghichu

--2.1
GO
CREATE TRIGGER TRG_Trangthaidatcho_tentrangthai_INS_UPD ON Trangthaidatcho
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @tentrangthai VARCHAR(50)

	SELECT @tentrangthai = tentrangthai
	FROM INSERTED

	IF(@tentrangthai NOT IN('hoan tat','khong thanh cong'))
	BEGIN
		PRINT('LOI: Ten trang thai chi co the la: "hoan tat" hoac "khong thanh cong"')
		ROLLBACK TRANSACTION
	END
END

--2.1
GO 
CREATE TRIGGER TRG_Datxe_INS ON Datxe
FOR INSERT
AS
BEGIN
	DECLARE @madatxe CHAR(10),
			@makh CHAR(4), 
			@tungay SMALLDATETIME,
			@ngsinh SMALLDATETIME

	SELECT @madatxe = madatxe, @makh = makh, @tungay = tungay
	FROM INSERTED

	SELECT @ngsinh ngsinh
	FROM Khachhang
	WHERE makh = @makh

	IF(DAY(@ngsinh) = DAY(@tungay) AND MONTH(@ngsinh) = MONTH(@tungay))
	BEGIN
		UPDATE Datxe
		SET ghichu = 'sinh nhat cua khach hang'
		WHERE madatxe = @madatxe
	END
END

--3.1
SELECT bienso, tenloaixe
FROM Xe X JOIN Loaixe LX ON X.maloaixe = LX.maloaixe

--3.2
SELECT KH.makh, hoten, COUNT(madatxe) Solandatxe
FROM Khachhang KH JOIN Datxe DX ON DX.makh = KH.makh
WHERE MONTH(ngsinh) = 6 AND YEAR(ngsinh) = 1975
GROUP BY KH.makh, hoten

--3.3
SELECT TOP 1 WITH TIES bienso
FROM Datxe
WHERE MONTH(ngaydat) = 9 AND YEAR(ngaydat) = 2020
GROUP BY bienso
ORDER BY COUNT(madatxe) DESC

--3.4
SELECT DX.bienso, maloaixe
FROM Datxe DX JOIN Xe X ON DX.bienso = X.bienso
WHERE MONTH(ngaydat) = 6 AND YEAR(ngaydat) = 2020
INTERSECT
SELECT DX.bienso, maloaixe
FROM Datxe DX JOIN Xe X ON DX.bienso = X.bienso
WHERE MONTH(ngaydat) = 7 AND YEAR(ngaydat) = 2020

--3.5
SELECT makh, hoten
FROM Khachhang KH
WHERE NOT EXISTS(	SELECT*
					FROM Xe X
					WHERE NOT EXISTS(		SELECT*
											FROM Datxe DX
											WHERE tungay = '4/4/2019'
											AND denngay = '6/4/2020'
											AND DX.makh = KH.makh
											AND DX.bienso = X.bienso))

----------------------------
SET DATEFORMAT DMY

INSERT INTO Loaixe VALUES('LX01','Loai xe A')
INSERT INTO Loaixe VALUES('LX02','Loai xe B')

INSERT INTO Xe VALUES('0001','LX01')
INSERT INTO Xe VALUES('0002','LX02')

INSERT INTO Khachhang VALUES('KH01','Khach hang A',0912345678,'1/6/1975','Nam')
INSERT INTO Khachhang VALUES('KH02','Khach hang B',0912345679,'12/6/1975','Nu')

INSERT INTO Trangthaidatcho VALUES('TT01','hoan tat')
INSERT INTO Trangthaidatcho VALUES('TT02','khong thanh cong')

INSERT INTO Datxe VALUES('DX001','KH01','0001','1/6/2020','3/6/2020','TT01','ghi chu A','5/5/2020')
INSERT INTO Datxe VALUES('DX002','KH01','0002','1/6/2020','3/6/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX003','KH01','0001','1/6/2020','3/6/2020','TT01','ghi chu A','5/7/2020')
INSERT INTO Datxe VALUES('DX004','KH01','0001','1/6/2020','3/6/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX005','KH01','0001','4/4/2019','6/2/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX006','KH01','0001','4/4/2019','6/2/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX007','KH01','0002','4/4/2019','6/2/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX008','KH01','0001','4/4/2019','6/4/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX009','KH01','0002','4/4/2019','6/4/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX010','KH01','0002','4/4/2019','6/4/2020','TT01','ghi chu A','5/6/2020')
INSERT INTO Datxe VALUES('DX010','KH01','0002','4/4/2019','6/9/2020','TT01','ghi chu A','5/6/2020')
