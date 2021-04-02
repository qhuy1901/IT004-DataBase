CREATE DATABASE DE9_QuanLyThiTotNghiep
USE DE9_QuanLyThiTotNghiep

CREATE TABLE PHONGTHI
(
	SoPT VARCHAR(3) CONSTRAINT PT_MaPT_PK PRIMARY KEY,
	SucChua INT
)

CREATE TABLE THISINH
(
	SoBD VARCHAR(5) CONSTRAINT TS_SoBD_PK PRIMARY KEY,
	HoTen VARCHAR(30) NOT NULL,
	NgaySinh SMALLDATETIME,
	DiaChi VARCHAR(50),
	SoPT VARCHAR(3) CONSTRAINT TS_SoPT_FK FOREIGN KEY
		REFERENCES PHONGTHI(SoPT)
)

CREATE TABLE MONTHI
(
	MaMT VARCHAR(5) CONSTRAINT MT_MaMT_PK PRIMARY KEY,
	TenMT VARCHAR(20) NOT NULL,
	Buoi VARCHAR(10),
	NgayThi SMALLDATETIME
)

CREATE TABLE KETQUA
(
	SoBD VARCHAR(5) CONSTRAINT KQ_SoBD_FK FOREIGN KEY
		REFERENCES THISINH(SoBD),
	MaMT VARCHAR(5) CONSTRAINT KQ_MaMT_FK FOREIGN KEY
		REFERENCES MONTHI(MaMT),
	CONSTRAINT KQ_SoBD_MaMT_PK PRIMARY KEY(SoBD,MaMT),
	DiemThi NUMERIC(3,1),
	VangThi BIT
)

INSERT INTO PHONGTHI VALUES('P02',20)
INSERT INTO PHONGTHI VALUES('P03',3)

INSERT INTO MONTHI VALUES ('L','Mon thi A','Sang','1/12/2006')
INSERT INTO MONTHI VALUES ('M','Mon thi B','Chieu','1/12/2006')
INSERT INTO MONTHI VALUES ('N','Mon thi C','Chieu','2/12/2006')

INSERT INTO THISINH VALUES('TS01','Thi sinh A','1/2/1990','Dia chi cua A','P03')
INSERT INTO THISINH VALUES('TS02','Thi sinh B','5/2/1990','Dia chi cua B','P02')
INSERT INTO THISINH VALUES('TS010','Thi sinh C','5/3/1990','Dia chi cua C','P02')
INSERT INTO THISINH VALUES('TS03','Thi sinh D','8/2/1990','Dia chi cua D','P02')

INSERT INTO KETQUA VALUES('TS01','L',0,1,NULL)
INSERT INTO KETQUA VALUES('TS01','M',9,0,NULL)
INSERT INTO KETQUA VALUES('TS02','L',6,0,NULL)
INSERT INTO KETQUA VALUES('TS02','M',8,0,NULL)
INSERT INTO KETQUA VALUES('TS010','L',5,0,NULL)
INSERT INTO KETQUA VALUES('TS010','M',5.5,0,NULL)
INSERT INTO KETQUA VALUES('TS02','N',10,0,NULL)
INSERT INTO KETQUA VALUES('TS03','N',10,0,NULL)
INSERT INTO KETQUA VALUES('TS03','M',8,0,NULL)
INSERT INTO KETQUA VALUES('TS03','L',9,0,NULL)

/*I.1. Tạo các quan hệ với các kiểu dữ liệu mô tả trong bảng trên.*/
/*I.2. Thêm thuộc tính ghichu varchar(20) vào quan hệ KETQUA. Đổi kiểu dữ liệu của thuộc
tính ghichu trong KETQUA thành varchar(300)*/
ALTER TABLE KETQUA ADD GhiChu VARCHAR(20)
ALTER TABLE KETQUA ALTER COLUMN GhiChu VARCHAR(200)

/*II.1. Điểm thi của thí sinh phải trong khoảng từ 0-10. (Viết ràng buộc check)*/
ALTER TABLE KETQUA ADD CONSTRAINT KQ_DiemThi_CK 
		CHECK(DiemThi BETWEEN 0 AND 10)

/*II.2. Tổng số thí sinh thi tại một phòng thi phải nhỏ hơn hay bằng sức chứa (SucChua) của
phòng thi đó. (Viết trigger cho việc thêm dữ liệu vào bảng THISINH) */
GO
CREATE TRIGGER TRG_PHONGTHI_SucChua_UPD ON PHONGTHI
FOR UPDATE
AS
BEGIN
	DECLARE @SucChua INT,
			@SoPT VARCHAR(3),
			@TongSoSV INT

	SELECT @SoPT = SoPT, @SucChua = SucChua
	FROM INSERTED

	SELECT @TongSoSV = COUNT(SoBD)
	FROM THISINH
	WHERE SoPT = @SoPT

	IF(@SucChua < @TongSoSV)
	BEGIN
		PRINT('TRG_PHONGTHI_SucChua_UPD: Tong so thi sinh tai mot phong thi phai nho hon hay bang suc cua cua phong thi do.')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
UPDATE PHONGTHI
SET SucChua = 2
WHERE SoPT = 'P02'

GO
CREATE TRIGGER TRG_THISINH_SoPT_INS_UPD ON THISINH
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @SucChua INT,
			@SoPT VARCHAR(3),
			@TongSoSV INT

	SELECT @SoPT = SoPT
	FROM INSERTED

	SELECT @SucChua = SucChua
	FROM PHONGTHI
	WHERE SoPT = @SoPT

	SELECT @TongSoSV = COUNT(SoBD)
	FROM THISINH
	WHERE SoPT = @SoPT

	IF(@SucChua < @TongSoSV)
	BEGIN
		PRINT('TRG_THISINH_SoPT_INS_UPD: Tong so thi sinh tai mot phong thi phai nho hon hay bang suc cua cua phong thi do.')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
SELECT * FROM PHONGTHI
INSERT INTO THISINH VALUES('TS144','Thi sinh F','5/8/1990','Dia chi cua F','P03')
UPDATE THISINH
SET SoPT = 'P03'
WHERE SoBD = 'TS010'

/*III.1.Tìm những thí sinh thi ở phòng ‘P03’*/
SELECT DISTINCT TS.SoBD, HoTen
FROM KETQUA KQ JOIN THISINH TS ON KQ.SoBD = TS.SoBD
WHERE SoPT = 'P03'

/*III.2. Tìm những thí sinh (SoBD,HoTen,NgaySinh,DiaChi,SoPT) đã thi đậu môn có mã số ‘L’.*/
SELECT TS.SoBD,HoTen,NgaySinh,DiaChi,SoPT
FROM KETQUA KQ JOIN THISINH TS ON KQ.SoBD = TS.SoBD
WHERE MaMT = 'L' AND DiemThi >= 5 

/*III.3. Phòng thi nào có sức chứa lớn nhất.*/
SELECT TOP 1 WITH TIES SoPT
FROM PHONGTHI
ORDER BY SucChua DESC

/*III.4. Thống kê những thí sinh (SoBD,HoTen) có tổng điểm thi lớn hơn 20.*/
SELECT KQ.SoBD, HoTen 
FROM KETQUA KQ JOIN THISINH TS ON KQ.SoBD = TS.SoBD
GROUP BY KQ.SoBD, HoTen 
HAVING SUM(DiemThi) > 20

/*III.5. Hiển thị những thí sinh (t.soBd, hoten) sinh năm 1990 có điểm thi trung bình lớn hơn
điểm thi trung bình của thí sinh có mã số ‘TS010’.*/
SELECT KQ.SoBD, HoTen 
FROM KETQUA KQ JOIN THISINH TS ON KQ.SoBD = TS.SoBD
WHERE YEAR(NgaySinh) = 1990
GROUP BY KQ.SoBD, HoTen 
HAVING AVG(DiemThi) > ALL(	SELECT AVG(DiemThi)
							FROM KETQUA KQ 
							WHERE SoBD = 'TS010'
							GROUP BY SoBD)