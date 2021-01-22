CREATE DATABASE DE2019_2020_QuanLyTheVanHoiOlympic
USE DE2019_2020_QuanLyTheVanHoiOlympic

CREATE TABLE Quocgia
(
	MaQG CHAR(4) CONSTRAINT QG_MaQG_PK PRIMARY KEY,
	TenQG NVARCHAR(25) NOT NULL,
	ChauLuc NVARCHAR(25),
	DienTich NUMERIC(6,3)
)

CREATE TABLE Thevanhoi
(
	MaTVH CHAR(5) CONSTRAINT TVH_MaTVH_PK PRIMARY KEY,
	TenTVH NVARCHAR(30) NOT NULL,
	MaQG CHAR(4) CONSTRAINT TVH_MaQG_FK FOREIGN KEY(MaQG)
		REFERENCES Quocgia(MaQG),
	Nam SMALLINT
)

CREATE TABLE Vandongvien
(
	MaVDV CHAR(5) CONSTRAINT VDV_MaVDV_PK PRIMARY KEY,
	HoTen NVARCHAR(25) NOT NULL,
	NgSinh SMALLDATETIME,
	GioiTinh NCHAR(3) CONSTRAINT VDV_GioiTinh_CK
		CHECK(GioiTinh IN(N'Nam',N'Nữ')),
	QuocTich CHAR(4) CONSTRAINT VDV_QuocTich_FK FOREIGN KEY(QuocTich)
		REFERENCES Quocgia(MaQG)
)

CREATE TABLE Noidungthi
(
	MaNDT CHAR(5) CONSTRAINT NDT_MaNDT_PK PRIMARY KEY,
	TenNDT NVARCHAR(20) NOT NULL,
	GhiChu NVARCHAR(30) CONSTRAINT NDT_GhiChu_DF DEFAULT(NULL)
)

CREATE TABLE Thamgia
(
	MaVDV CHAR(5) CONSTRAINT TG_MaVDV_FK FOREIGN KEY(MaVDV)
		REFERENCES Vandongvien(MaVDV),
	MaNDT CHAR(5) CONSTRAINT TG_MaNDT_FK FOREIGN KEY(MaNDT)
		REFERENCES Noidungthi(MaNDT),
	MaTVH CHAR(5) CONSTRAINT TG_MaTVH_FK FOREIGN KEY(MaTVH)
		REFERENCES Thevanhoi(MaTVH),
	CONSTRAINT TG_MaVDV_MaNDT_MaTVH_PK PRIMARY KEY(MaVDV, MaNDT, MaTVH),
	HuyChuong TINYINT
)

INSERT INTO Quocgia VALUES('UK',N'Anh Quốc',N'Châu Âu',	130.279)
INSERT INTO Quocgia VALUES('JP',N'Nhật Bản',N'Châu Á', 377.972)

INSERT INTO Thevanhoi VALUES('TVH01',N'Olympic Rio 2016','UK',2016)
INSERT INTO Thevanhoi VALUES('TVH02',N'Olympic Tokyo 2020','JP',2020)

INSERT INTO Vandongvien VALUES('VDV01',N'Vận động viên A','1/12/1989',N'Nữ','UK')
INSERT INTO Vandongvien VALUES('VDV02',N'Vận động viên B','1/8/1989',N'Nữ','JP')
INSERT INTO Vandongvien VALUES('VDV03',N'Vận động viên C','8/12/1989',N'Nam','UK')
INSERT INTO Vandongvien VALUES('VDV04',N'Vận động viên D','1/5/1989',N'Nam','JP')

INSERT INTO Noidungthi VALUES('NDT01',N'Bắn Cung',null)
INSERT INTO Noidungthi VALUES('NDT02',N'100m bơi ngửa',null)
INSERT INTO Noidungthi VALUES('NDT03',N'200m tự do',null)

INSERT INTO Thamgia VALUES('VDV02','NDT02','TVH01',2)
INSERT INTO Thamgia VALUES('VDV02','NDT03','TVH01',1)
INSERT INTO Thamgia VALUES('VDV02','NDT03','TVH02',1)
INSERT INTO Thamgia VALUES('VDV04','NDT02','TVH02',1)
INSERT INTO Thamgia VALUES('VDV03','NDT01','TVH02',1)
INSERT INTO Thamgia VALUES('VDV01','NDT01','TVH02',3)
INSERT INTO Thamgia VALUES('VDV01','NDT03','TVH01',2)
INSERT INTO Thamgia VALUES('VDV02','NDT01','TVH01',1)
INSERT INTO Thamgia VALUES('VDV04','NDT01','TVH01',2)

/*1. RBTV: Tại một kỳ thế vận hội, mỗi nội dung thi chỉ có duy nhất một huy chương vàng*/
GO 
CREATE TRIGGER TRG_Thamgia_HuyChuong_INS_UPD ON Thamgia
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaNDT CHAR(5),
			@HuyChuong TINYINT,
			@MaTVH CHAR(5)
	
	SELECT @MaNDT = MaNDT, @MaTVH = MaTVH, @HuyChuong = HuyChuong
	FROM INSERTED

	IF(@HuyChuong = 1)
	BEGIN 
		IF EXISTS(	SELECT*
					FROM Thamgia
					WHERE MaNDT = @MaNDT AND MaTVH = @MaTVH AND HuyChuong = 1
					EXCEPT 
					SELECT*
					FROM INSERTED)
		BEGIN
			PRINT('LOI: TAI MOI KY THE VAN HOI, MOI NOI DUNG THI CHI CO DUY NHAT MOT HUY CUONG VANG')
			ROLLBACK TRANSACTION
		END
	END
END
--Kiểm tra Trigger
SELECT* FROM Thamgia WHERE HuyChuong = 1
INSERT INTO Thamgia VALUES('VDV04','NDT01','TVH01',1)
UPDATE Thamgia
SET HuyChuong = 1
WHERE MaVDV = 'VDV04' AND MaNDT = 'NDT01' AND MaTVH = 'TVH01'

/*2a Liệt kê danh sách VDV có Quốc tịch là 'UK' và sắp xếp danh sách theo HoTen tăng dần)*/
SELECT HoTen, NgSinh, GioiTinh
FROM Vandongvien
WHERE QuocTich = 'UK'
ORDER BY HoTen ASC

/*2b In danh sách VDV tham gia NDT 'Bắn Cung' ở TVH 'Olympic Tokyo 2020'*/
SELECT VDV.MaVDV, HoTen
FROM ((Vandongvien VDV JOIN Thamgia TG ON VDV.MaVDV = TG.MaVDV)
		JOIN Noidungthi NDT ON NDT.MaNDT = TG.MaNDT)
			JOIN Thevanhoi TVH ON TVH.MaTVH = TG.MaTVH
WHERE TenNDT = N'Bắn Cung'
AND TenTVH = N'Olympic Tokyo 2020'

/*2c Cho biết số lượng huy chương vàng mà các VDV 'Nhật Bản' đạt được ở TVH diễn ra vào năm 2020*/
SELECT COUNT(HuyChuong) SoLuongHuyChuongVang
FROM ((Thamgia TG JOIN Vandongvien VDV ON TG.MaVDV = VDV.MaVDV)
		JOIN Quocgia QG ON QG.MaQG = VDV.QuocTich)
			JOIN Thevanhoi TVH ON TVH.MaTVH = TG.MaTVH
WHERE TenQG = N'Nhật Bản'
AND Nam = 2020
AND HuyChuong = 1

/*2d Liệt kê họ tên và quốc tịch những VDV tham gia cả 2 NDT '100m bơi ngửa' và '200m tự do'*/
SELECT HoTen, QuocTich
FROM (Vandongvien VDV JOIN Thamgia TG ON TG.MaVDV = VDV.MaVDV)
		JOIN Noidungthi NDT ON NDT.MaNDT = TG.MaNDT
WHERE TenNDT = N'100m bơi ngửa'
INTERSECT
SELECT HoTen, QuocTich
FROM (Vandongvien VDV JOIN Thamgia TG ON TG.MaVDV = VDV.MaVDV)
		JOIN Noidungthi NDT ON NDT.MaNDT = TG.MaNDT
WHERE TenNDT = N'200m tự do'

/*2e In ra thông tin của những VDV nữ người Anh(QuocTich = UK) tham gia tất cả kỳ TVH từ năm 2008 tới nay*/
SELECT MaVDV, HoTen
FROM Vandongvien VDV
WHERE GioiTinh = N'Nữ'
AND QuocTich = 'UK'
AND NOT EXISTS(		SELECT*
					FROM Thevanhoi TVH
					WHERE Nam >= 2008
					AND NOT EXISTS(	SELECT*
									FROM Thamgia TG
									WHERE TG.MaTVH = TVH.MaTVH
									AND VDV.MaVDV = TG.MaVDV))				

/*2f Tìm VDV đạt từ 2 huy chương vàng trở lên tại TVH 'Olympic Rio 2016'*/
SELECT VDV.MaVDV, HoTen
FROM (Thamgia TG JOIN Vandongvien VDV ON VDV.MaVDV = TG.MaVDV)
		JOIN Thevanhoi TVH ON TVH.MaTVH = TG.MaTVH
WHERE TenTVH = N'Olympic Rio 2016'
AND HuyChuong = 1
GROUP BY VDV.MaVDV, HoTen
HAVING COUNT(*) >= 2
