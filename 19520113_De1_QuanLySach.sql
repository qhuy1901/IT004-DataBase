CREATE DATABASE DE1_QuanLySach
USE DE1_QuanLySach

CREATE TABLE TACGIA
(
	MaTG char(5) CONSTRAINT TACGIA_MaTG_PK PRIMARY KEY,
	HoTen varchar(20) NOT NULL,
	DiaChi varchar(50),
	NgSinh smalldatetime,
	SoDT varchar(15)
)

CREATE TABLE SACH
(
	MaSach char(5) CONSTRAINT SACH_MaSach_PK PRIMARY KEY,
	TenSach varchar(25),
	TheLoai varchar(25)
)

CREATE TABLE TACGIA_SACH
(
	MaTG char(5) CONSTRAINT TACGIA_SACH_MaTG_FK FOREIGN KEY(MaTG)
		REFERENCES TACGIA(MaTG),
	MaSach char(5) CONSTRAINT SACH_MaSach_FK FOREIGN KEY(MaSach)
		REFERENCES SACH(MaSach),
	CONSTRAINT TACGIA_SACH_MaTG_MaSach_PK PRIMARY KEY(MaTG, MaSach)
)

CREATE TABLE PHATHANH
(
	MaPH char(5) CONSTRAINT PHATHANH_MaPH_PK PRIMARY KEY,
	MaSach char(5) CONSTRAINT PHATHANH_MaSach_FK FOREIGN KEY(MaSach)
		REFERENCES SACH(MaSach),
	NgayPH smalldatetime,
	SoLuong int,
	NhaXuatBan varchar(20)
)

SELECT* FROM TACGIA
SELECT* FROM SACH
SELECT* FROM TACGIA_SACH
SELECT* FROM PHATHANH

DELETE FROM TACGIA_SACH
DELETE FROM PHATHANH
DELETE FROM SACH
DELETE FROM TACGIA

SET DATEFORMAT DMY

INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG001', 'Nguyen Nhat Anh', '731 TRAN HUNG DAO,Q5,TPHCM','7/5/1955','0882345142')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG002', 'Le Van Truong', '23/5 NGUYEN TRAI,Q5,TPHCM','22/09/1988','0908256478')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG003', 'Nguyen Ngoc Thach', '45 NGUYEN CANH CHAN,Q1,TPHCM','02/01/1987','0938776266')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG004', 'Do Nhat Nam', '50/34LE DAI HANH,Q10,TPHCM','01/05/2001','0917325476')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG005', 'Nguyen Minh Nhat', '34 TRUONG DINH,Q3,TPHCM','03/03/1987','0824610875')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG006', 'Cao Bich Thuy', '227 NGUYEN VAN CU,Q5,TPHCM','14/03/1988','0863173842')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG007', 'Quach Le Anh Khang', '32/3 TRAN BINH TRONG,Q5,TPHCM','11/08/1987','0916783565')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG008', 'Le Thi Hong Phuong', '45/2 AN DUONG VUONG','21/04/1992','0938435756')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG009', 'Vu Phuong Thanh', '85/6 MAI CHI THO,Q2,TPHCM','08/07/1988','0917437792')
INSERT INTO TACGIA(MaTG, HoTen, DiaChi, NgSinh, SoDT) 
VALUES ('TG010', 'Nhieu tac gia', NULL, NULL, NULL)

INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S001','Mat biec', 'Truyen dai')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S002','La nam trong la', 'Truyen dai')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S003','Vien ngoc', 'Truyen ngan')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S004','Buoi chieu Windows', 'Truyen dai')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S005','Mot giot dan ba', 'Truyen ngan')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S006','Khoc giua Sai gon', 'Tieu Thuyet')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S007','Am thanh cua im lang', 'Tieu Thuyet')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S008','Cu phat den', 'Truyen ngan')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S009','Ngay troi ve phia cu', 'Tan van')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S010','Mim cuoi cho qua', 'Tan van')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S011','Tieng Viet Lop 1 - Tap 1', 'Giao Khoa')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S012','Tieng Viet Lop 1 - Tap 2', 'Giao Khoa')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S013','Tieng Anh Lop 10', 'Giao Khoa')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S014','Tieng Anh Lop 11', 'Giao Khoa')
INSERT INTO SACH(MaSach, TenSach, TheLoai)
VALUES ('S015','Tieng Anh Lop 12', 'Giao Khoa') 


INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG001','S001')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG001','S002')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG001','S003')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG001','S004')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG003','S005')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG003','S006')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG001','S008')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG006','S009')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG006','S010')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG010','S011')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG010','S012')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG010','S013')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG010','S014')
INSERT INTO TACGIA_SACH(MaTG, MaSach)
VALUES ('TG010','S015')

INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH001','S009', '23/6/2013', '1000', 'Minh Chau')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH002','S010', '20/4/2010', '1500', 'Minh Chau')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH003','S005', '7/4/2015', '1200', 'Ha Noi')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH004','S001', '3/10/2017', '5000', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH006','S002', '30/11/2014', '4000', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH005','S003', '25/5/2011', '4500', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH007','S007', '9/5/2014', '1000', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH008','S011', '5/5/1990', '15000', 'Giao duc')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH009','S011', '20/6/1995', '10000', 'Giao duc')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH010','S012', '5/6/1990', '10000', 'Giao duc')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH011','S013', '5/7/1990', '20000', 'Giao duc')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH012','S014', '25/6/1992', '15000', 'Giao duc')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH013','S004', '5/9/2012', '500', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH014','S004', '28/5/2016', '700', 'Tre')
INSERT INTO PHATHANH(MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES ('PH015','S001', '20/2/2017', '1200', 'Tre')

/*2.1. Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.*/
GO
CREATE TRIGGER TRIGGER_PHATHANH_THEMSUA_NgPH_MaSach ON PHATHANH
FOR INSERT, UPDATE 
AS
BEGIN
	DECLARE @NgPH SMALLDATETIME, 
			@NgSinh SMALLDATETIME, 
			@MaSach CHAR(5), 
			@MaTG CHAR(5)
	
	SELECT @MaSach = MaSach, @NgPH = NgayPH
	FROM INSERTED

	SELECT @MaTG = MaTG
	FROM TACGIA_SACH
	WHERE MaSach = @MaSach

	SELECT @NgSinh = NgSinh
	FROM TACGIA
	WHERE MaTG = @MaTG

	IF(@NgPH < @NgSinh)
	BEGIN 
        PRINT 'TRIGGER_PHATHANH_THEMSUA_NgPH_MaSach: NgPH > NgSinh'
        ROLLBACK TRANSACTION 
    END
    ELSE
    BEGIN
        PRINT 'Thanh cong'
    END
END

--Kiểm tra Trigger
INSERT INTO PHATHANH VALUES ('PH101','S001', '1954-06-23 00:00:00',100,'Tre')

GO 
CREATE TRIGGER TRIGGER_TACGIA_SUA_NgSinh_MaSach ON TACGIA --chưa đúng, làm lại
FOR UPDATE AS
BEGIN
	DECLARE @NgSinh SMALLDATETIME, 
			@NgPH SMALLDATETIME, 
			@MaPH CHAR(5), 
			@MaTG CHAR(5), 
			@MaSach CHAR(5)

	SELECT @NgSinh = NgSinh, @MaTG = MaTG
	FROM INSERTED

	SELECT @MaSach = MaSach
	FROM TACGIA_SACH
	WHERE MaTG = @MaTG

	DECLARE cur_PHATHANH CURSOR FOR
		SELECT MaPH
		FROM PHATHANH
		WHERE MaSach = @MaSach
	
	OPEN cur_PHATHANH
	FETCH NEXT FROM cur_PHATHANH
	INTO @MaPH

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @NgPH = NgayPH
		FROM PHATHANH
		WHERE MaPH = @MaPH
		IF(@NgSinh > @NgPH )
		BEGIN 
			PRINT 'TRIGGER_TACGIA_SUA_NgSinh_MaSach: NgPH > NgSinh'
			ROLLBACK TRANSACTION 
		END
		ELSE
		BEGIN
			FETCH NEXT FROM cur_PHATHANH 
			INTO @MaPH
		END
	END

	CLOSE cur_PHATHANH
	PRINT 'Update thanh cong'
	DEALLOCATE cur_PHATHANH
END

--Kiểm tra Trigger
UPDATE TACGIA
SET NgSinh = '2020-05-07 00:00:00'
WHERE MaTG = 'TG001'

/*2.2. Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành.*/
GO 
CREATE TRIGGER TRG_PHATHANH_THEMSUA_NXB_MaSach ON PHATHANH
FOR UPDATE, INSERT AS
BEGIN
	DECLARE @NXB VARCHAR(20),
			@MaSach CHAR(5),
			@TheLoai VARCHAR(25)

	SELECT @MaSach = MaSach, @NXB = NhaXuatBan
	FROM INSERTED
	
	IF(@NXB <> 'Giao duc')
	BEGIN
		SELECT @TheLoai = TheLoai
		FROM SACH
		WHERE MaSach = @MaSach

		IF(@TheLoai = 'Giao khoa')
		BEGIN
			PRINT 'LOI: SACH GIAO KHOA PHAI DO NXB GIAO DUC PHAT HANH'
			ROLLBACK TRANSACTION
		END
	END
END

--Kiểm tra Trigger
INSERT INTO PHATHANH VALUES('PH144','S011','2013-06-23 00:00:00',10,'Tre') 


/*Cách 1: dùng con trỏ*/
GO
CREATE TRIGGER TRG_SACH_SUA_TheLoai1 ON SACH
FOR UPDATE AS
BEGIN
	DECLARE @TheLoai VARCHAR(25), 
			@MaSach CHAR(5),
			@NXB VARCHAR(20)

	SELECT @TheLoai = TheLoai, @MaSach = MaSach
	FROM INSERTED

	DECLARE cur_PHATHANH CURSOR FOR
		SELECT MaSach
		FROM PHATHANH
		WHERE MaSach = @MaSach

	OPEN cur_PHATHANH
	FETCH NEXT FROM cur_PHATHANH INTO @MaSach
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SELECT @NXB = NhaXuatBan
		FROM PHATHANH
		WHERE MaSach = @MaSach

		IF(@NXB <> 'Giao duc')
		BEGIN 
			SELECT @TheLoai = TheLoai
			FROM SACH
			WHERE MaSach = @MaSach

			IF(@TheLoai = 'Giao khoa')
			BEGIN
				PRINT 'TRG_SACH_SUA_TheLoai: Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành.'
				ROLLBACK TRANSACTION 
			END	
		END
		FETCH NEXT FROM cur_PHATHANH INTO @MaSach
	END
	CLOSE cur_PHATHANH
	PRINT 'Update thanh cong'
	DEALLOCATE cur_PHATHANH
END

/*Cách 2*/
GO
CREATE TRIGGER TRG_SACH_SUA_TheLoai2 ON SACH
FOR UPDATE
AS
BEGIN
	IF EXISTS(	SELECT*
				FROM INSERTED I JOIN PHATHANH PH ON I.MaSach = PH.MaSach
				WHERE I.TheLoai = 'Giao khoa' AND PH.NhaXuatBan <> 'Giao duc')
	BEGIN
		RAISERROR('LOI: SACH GIAO KHOA PHAI DO NXB GIAO DUC PHAT HANH', 16, 1)
		ROLLBACK TRANSACTION
	END
END

--Kiểm tra Trigger
UPDATE SACH 
SET TheLoai = 'Giao khoa'
WHERE MaSach = 'S001'


/*3.1 Tìm tác giả (MaTG,HoTen,SoDT) của những quyển sách thuộc thể loại “Truyện dài” do nhà xuất bản Trẻ phát hành.*/  
--Cách 1: Phép kết mở mệnh đề WHERE
SELECT TG.MaTG, HoTen, SoDT
FROM TACGIA TG, PHATHANH PH, SACH S, TACGIA_SACH TGS
WHERE TheLoai = 'Truyen dai'
AND NhaXuatBan = 'Tre'
AND PH.MaSach = S.MaSach
AND TG.MaTG = TGS.MaTG
AND S.MaSach = TGS.MaSach

--Cách 2: Phép kết mở mệnh đề FROM
SELECT TG.MaTG, HoTen, SoDT, TenSach
FROM ((TACGIA_SACH TGS INNER JOIN TACGIA TG ON TG.MaTG = TGS.MaTG)
	INNER JOIN SACH S ON S.MaSach= TGS.MaSach)
		INNER JOIN PHATHANH PH ON S.MaSach = PH.MaSach
WHERE TheLoai = 'Truyen dai'AND NhaXuatBan = 'Tre'

/*3.2 Tìm nhà xuất bản phát hành nhiều thể loại sách nhất.*/
-- Cách 1:
SELECT TOP 1 WITH TIES NhaXuatBan, COUNT(DISTINCT TheLoai)
FROM PHATHANH PH, SACH S
WHERE PH.MaSach = S.MaSach
GROUP BY NhaXuatBan
ORDER BY COUNT(DISTINCT TheLoai) DESC

--Cách 2:
SELECT NhaXuatBan
FROM PHATHANH PH INNER JOIN SACH S ON PH.MaSach = S.MaSach
GROUP BY NhaXuatBan
HAVING COUNT(DISTINCT TheLoai)>= ALL(
										SELECT COUNT(DISTINCT TheLoai)
										FROM PHATHANH PH INNER JOIN SACH S 
												ON PH.MaSach = S.MaSach
										GROUP BY NhaXuatBan
								    )

/*3.3 Trong mỗi nhà xuất bản, tìm tác giả (MaTG,HoTen) có số lần phát hành nhiều sách nhất. */
SELECT NhaXuatBan, TG.MaTG, HoTen, COUNT(MaPH) SoLuongPH
FROM (TACGIA TG INNER JOIN TACGIA_SACH TGS ON TG.MaTG = TGS.MaTG)
		INNER JOIN PHATHANH PH1 ON PH1.MaSach = TGS.MaSach
GROUP BY NhaXuatBan, TG.MaTG, HoTen
HAVING COUNT(MaPH) >= ALL(
							SELECT COUNT(MaPH) SoLuongPH
							FROM (TACGIA TG INNER JOIN TACGIA_SACH TGS ON TG.MaTG = TGS.MaTG)
									INNER JOIN PHATHANH PH2 ON PH2.MaSach = TGS.MaSach
							GROUP BY NhaXuatBan, TG.MaTG
							HAVING PH2.NhaXuatBan = PH1.NhaXuatBan
						)
