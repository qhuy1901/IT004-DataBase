CREATE DATABASE DE2017_2018_QuanLyTheTaiKhoan
USE DE2017_2018_QuanLyTheTaiKhoan

CREATE TABLE KhachHang
(
	MaKH CHAR(5) CONSTRAINT KH_MaKH_PK PRIMARY KEY,
	HoTen NVARCHAR(25) NOT NULL,
	NgaySinh SMALLDATETIME,
	DiaChi VARCHAR(25),
	SoDT INT,
	CMND INT,
)

CREATE TABLE LoaiTaiKhoan
(
	MaLTK CHAR(5) CONSTRAINT LTK_MaLTK_PK PRIMARY KEY,
	TenLTK VARCHAR(25) NOT NULL,
	MoTa VARCHAR(25)
)

CREATE TABLE TaiKhoan
(
	SoTK INT CONSTRAINT TK_SoTK_PK PRIMARY KEY,
	MaKH CHAR(5) CONSTRAINT TK_MaKH_FK FOREIGN KEY(MaKH)
		REFERENCES KhachHang(MaKH),
	MaLTK CHAR(5) CONSTRAINT TK_MaLTK_FK FOREIGN KEY(MaLTK)
		REFERENCES LoaiTaiKhoan(MaLTK),
	NgayMo SMALLDATETIME,
	SoDu MONEY,
	LaiSuat NUMERIC(4,2),
	TrangThai VARCHAR(20)
)

CREATE TABLE LoaiGiaoDich
(
	MaLGD CHAR(5) CONSTRAINT LGD_MaLGD_PK PRIMARY KEY,
	TenLGD VARCHAR(25) NOT NULL,
	MoTa VARCHAR(25)
)

CREATE TABLE GiaoDich
(
	MaGD CHAR(5) CONSTRAINT GD_MaGD_PK PRIMARY KEY,
	SoTK INT CONSTRAINT GD_SoTK_FK FOREIGN KEY(SoTK)
		REFERENCES TaiKhoan(SoTK),
	MaLGD CHAR(5) CONSTRAINT GD_MaLGD_FK FOREIGN KEY(MaLGD)
		REFERENCES LoaiGiaoDich(MaLGD),
	NgayGD SMALLDATETIME,
	SoTien MONEY,
	NoiDung VARCHAR(35)
)

SELECT * FROM KHACHHANG
INSERT INTO KhachHang VALUES('KH001','Nguyen Van A', '1/12/1998', 'Dia chi A', 0912345678, 272929321)
INSERT INTO KhachHang VALUES('KH002','Nguyen Van B', '2/12/1998', 'Dia chi B', 0912345678, 272929321)
INSERT INTO KhachHang VALUES('KH003','Nguyen Thi C', '3/12/1998', 'Dia chi C', 0912345678, 272929321)
INSERT INTO KhachHang VALUES('KH004','Nguyen Thi D', '3/12/1998', 'Dia chi D', 0912345678, 272929321)

INSERT INTO LoaiTaiKhoan VALUES('LTK01', 'Tiet kiem', 'Mo ta 1')
INSERT INTO LoaiTaiKhoan VALUES('LTK02', 'Thanh toan', 'Mo ta 2')

INSERT INTO TaiKhoan VALUES(1001940, 'KH001', 'LTK01', '1/4/2017', 100000, 1.4, 'Trang thai A')
INSERT INTO TaiKhoan VALUES(1001941, 'KH001', 'LTK02', '1/4/2016', 100000, 1.5, 'Trang thai B')
INSERT INTO TaiKhoan VALUES(1001942, 'KH002', 'LTK01', '1/4/2017', 100000, 1.4, 'Trang thai C')
INSERT INTO TaiKhoan VALUES(1001943, 'KH003', 'LTK01', '1/4/2017', 100000, 1.1, 'Trang thai D')
INSERT INTO TaiKhoan VALUES(1001944, 'KH003', 'LTK02', '1/4/2016', 100000, 1.46, 'Trang thai E')
INSERT INTO TaiKhoan VALUES(1001945, 'KH004', 'LTK02', '1/1/2017', 100000, 1.46, 'Trang thai F')
SELECT* FROM TaiKhoan

INSERT INTO LoaiGiaoDich VALUES('LGD01', 'Loai giao dich 1','Mo ta 1')
INSERT INTO LoaiGiaoDich VALUES('LGD02', 'Loai giao dich 2','Mo ta 2')

INSERT INTO GiaoDich VALUES('GD001',1001940, 'LGD01','1/5/2017',1100000, 'Noi dung A')
INSERT INTO GiaoDich VALUES('GD002',1001945, 'LGD02','1/5/2017',100000, 'Noi dung B')
INSERT INTO GiaoDich VALUES('GD003',1001940, 'LGD02','12/5/2017',500000, 'Noi dung C')
INSERT INTO GiaoDich VALUES('GD004',1001941, 'LGD01','12/5/2017',1000000, 'Noi dung D')
INSERT INTO GiaoDich VALUES('GD005',1001940, 'LGD01','12/5/2017',800000, 'Noi dung E')
INSERT INTO GiaoDich VALUES('GD006',1001940, 'LGD02','1/5/2017',100000, 'Noi dung F')
INSERT INTO GiaoDich VALUES('GD007',1001941, 'LGD01','12/5/2017',100000, 'Noi dung G')
INSERT INTO GiaoDich VALUES('GD008',1001943, 'LGD01','12/5/2017',1800000, 'Noi dung H')
INSERT INTO GiaoDich VALUES('GD009',1001945, 'LGD02','1/5/2017',1200000, 'Noi dung I')
INSERT INTO GiaoDich VALUES('GD010',1001944, 'LGD02','12/8/2017',1200000, 'Noi dung J')

/*1 Khách hàng chỉ được mở tài khoản (SoTK) khi khách hàng có tuổi từ 14 trở lên.*/
GO
CREATE TRIGGER TRG_TaiKhoan_NgayMo_MaKH_UPD_INS ON TaiKhoan
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @NgayMo SMALLDATETIME,
			@MaKH CHAR(5),
			@NgaySinh SMALLDATETIME

	SELECT @NgayMo = NgayMo, @MaKH = MaKH
	FROM INSERTED

	SELECT @NgaySinh = NgaySinh
	FROM KhachHang
	WHERE MaKH = @MaKH

	IF(YEAR(@NgayMo) - YEAR(@NgaySinh) < 14)
	BEGIN
		PRINT('LOI: KHACH HANG CHI DUOC MO TAI KHOAN KHI KHACH HANG CO TUOI TU 14 TRO LEN')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
INSERT INTO TaiKhoan VALUES(1001946, 'KH004', 'LTK02', '1/1/1999', 100000, 1.46, 'Trang thai G') -- Error
UPDATE TaiKhoan
SET NgayMo = '1/1/1999' --Error
WHERE SoTK = 1001945

GO
CREATE TRIGGER TRG_KhachHang_NgaySinh_UPD ON KhachHang
FOR UPDATE
AS
BEGIN
	DECLARE @NgayMo SMALLDATETIME,
			@NgaySinh SMALLDATETIME,
			@MaKH CHAR(5),
			@SoTK INT

	SELECT @MaKH = MaKH, @NgaySinh = NgaySinh
	FROM INSERTED

	DECLARE cur_TaiKhoan CURSOR 
	FOR
		SELECT SoTK
		FROM TaiKhoan
		WHERE MaKH = @MaKH
	
	OPEN cur_TaiKhoan
		FETCH NEXT FROM cur_TaiKhoan INTO @SoTK
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @NgayMo = NgayMo
			FROM TaiKhoan
			WHERE SoTK = @SoTK

			IF(YEAR(@NgayMo) - YEAR(@NgaySinh) < 14)
			BEGIN
				PRINT('TRG_KhachHang_NgaySinh_UPD: KHACH HANG CHI DUOC MO TAI KHOAN KHI KHACH HANG CO TUOI TU 14 TRO LEN')
				ROLLBACK TRANSACTION
			END
			ELSE
			BEGIN
				FETCH NEXT FROM cur_TaiKhoan INTO @SoTK
			END
		END
	CLOSE cur_TaiKhoan
	DEALLOCATE cur_TaiKhoan
END
--Kiểm tra Trigger
SELECT* FROM TaiKhoan
SELECT* FROM KhachHang
UPDATE KhachHang
SET NgaySinh = '1/1/2015' --Error
WHERE MaKH = 'KH001'

/*2a Hiển thị thông tin các tài khoản của các khách hàng (SoTK, TrangThai, SoDu) đã
mở tài khoản vào ngày ‘01/01/2017’ (NgayMo) và sắp xếp kết quả theo số dư
tăng dần.*/
SELECT SoTK, TrangThai, SoDu
FROM TaiKhoan 
WHERE NgayMo = '01/01/2017'
ORDER BY SODU ASC

/*2b Liệt kê mã loại giao dịch (MaLGD) cùng với tổng số tiền (SoTien) giao dịch của
từng loại giao dịch.*/
SELECT MaLGD, SUM(SoTien) TongSoTien
FROM GiaoDich
GROUP BY MALGD

/*2c Cho biết những khách hàng (MaKH, HoTen, CMND) đã mở cả hai loại tài khoản:
tiết kiệm (TenLTK= ‘Tiết kiệm’) và thanh toán (TenLTK= ‘Thanh toán’).*/
SELECT KH.MaKH, HoTen, CMND
FROM (KhachHang KH JOIN TaiKhoan TK ON KH.MaKH = TK.MaKH)
		JOIN LoaiTaiKhoan LTK ON LTK.MaLTK = TK.MaLTK
WHERE TenLTK = 'Tiet kiem'
INTERSECT
SELECT KH.MaKH, HoTen, CMND
FROM (KhachHang KH JOIN TaiKhoan TK ON KH.MaKH = TK.MaKH)
		JOIN LoaiTaiKhoan LTK ON LTK.MaLTK = TK.MaLTK
WHERE TenLTK = 'Thanh toan'

/*2d Liệt kê thông tin các giao dịch (MaGD, SoTK, MaLGD, NgayGD, SoTien,
NoiDung) có số tiền lớn nhất trong tháng 12 năm 2017.*/
SELECT MaGD, SoTK, MaLGD, NgayGD, SoTien, NoiDung
FROM GiaoDich
WHERE MONTH(NgayGD) = 12 AND YEAR(NgayGD) = 2017
AND SoTien IN (SELECT MAX(SoTien) FROM GiaoDich)

SELECT TOP 1 WITH TIES *
FROM GiaoDich
WHERE MONTH(NgayGD) = 12 AND YEAR(NgayGD) = 2017
ORDER BY SoTien DESC

/*2e Liệt kê danh sách các khách hàng (MaKH, HoTen, SoDT) đã mở tất cả các loại
tài khoản.*/
SELECT MaKH, HoTen, SoDT
FROM KhachHang KH
WHERE NOT EXISTS(	SELECT*
					FROM LoaiTaiKhoan LTK
					WHERE NOT EXISTS(	SELECT*
										FROM TaiKhoan TK
										WHERE KH.MaKH = TK.MaKH
										AND LTK.MaLTK = TK.MaLTK))

/*2f Liệt kê những loại tài khoản (MaLTK, TenLTK) được mở nhiều nhất trong năm 2016.*/
SELECT TOP 1 WITH TIES TK.MaLTK, TenLTK, COUNT(TK.MaLTK) SoLanDuocMo
FROM TaiKhoan TK JOIN LoaiTaiKhoan LTK ON LTK.MaLTK = TK.MaLTK
WHERE YEAR(NgayMo) = 2016
GROUP BY TK.MaLTK, TenLTK
ORDER BY SoLanDuocMo DESC
