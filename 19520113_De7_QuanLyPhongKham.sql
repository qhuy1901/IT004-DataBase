﻿CREATE DATABASE DE7_QuanLyPhongKham
USE DE7_QuanLyPhongKham
--(Done)
CREATE TABLE PHONGKHAM
(
	MAPK CHAR(4) CONSTRAINT PHONGKHAM_MAPK_PK PRIMARY KEY,
	TENPK VARCHAR(25) NOT NULL,
	MABS CHAR(4) DEFAULT(NULL)
)

CREATE TABLE BENHNHAN
(
	MABN CHAR(4) CONSTRAINT BENHNHAN_MABN_PK PRIMARY KEY,
	TENBN VARCHAR(25) NOT NULL,
	NGSINH SMALLDATETIME,
	DT INT,
	GIOITINH VARCHAR(3) CONSTRAINT BENHNHAN_GIOITINH_CK
			CHECK(GIOITINH IN('nam','nu'))
)

CREATE TABLE BACSY
(
	MABS CHAR(4) CONSTRAINT BACSI_MABS_PK PRIMARY KEY,
	TENBS VARCHAR(25) NOT NULL,
	MAPK CHAR(4) DEFAULT(NULL)
)

CREATE TABLE KHAMBENH
(
	MAKB CHAR(4) CONSTRAINT KHAMBENH_MAKB_PK PRIMARY KEY,
	MABN CHAR(4),
	MABS CHAR(4),
	NGKHAM SMALLDATETIME,
	KETLUAN VARCHAR(30)
)

ALTER TABLE PHONGKHAM ADD CONSTRAINT PHONGKHAM_MABS_FK FOREIGN KEY(MABS)
		REFERENCES BACSY(MABS)

ALTER TABLE BACSY ADD CONSTRAINT BACSY_MAPK_FK FOREIGN KEY(MAPK)
		REFERENCES PHONGKHAM(MAPK)

ALTER TABLE KHAMBENH ADD CONSTRAINT KHAMBENH_MABN_FK FOREIGN KEY(MABN)
		REFERENCES BENHNHAN(MABN)

ALTER TABLE KHAMBENH ADD CONSTRAINT KHAMBENH_MABS_FK FOREIGN KEY(MABS)
		REFERENCES BACSY(MABS)

SET DATEFORMAT DMY

INSERT INTO BENHNHAN VALUES('BN01','Nguyen Van A','02/03/1984','001122334','nam')
INSERT INTO BENHNHAN VALUES('BN02','Tran Van B','04/01/1985','002211334','nam')
INSERT INTO BENHNHAN VALUES('BN03','Huynh Thi C','24/12/1986','331122004','nu')

INSERT INTO PHONGKHAM VALUES('PK01','HCM',NULL)
INSERT INTO PHONGKHAM VALUES('PK02','Binh Duong',NULL)
INSERT INTO PHONGKHAM VALUES('PK03','Dong Nai',NULL)

INSERT INTO BACSY VALUES('BS01','Ngo Tien Sy','PK01')
INSERT INTO BACSY VALUES('BS02','Dinh Cong Trang','PK02')
INSERT INTO BACSY VALUES('BS03','Trinh My Ngoc','PK03')

UPDATE PHONGKHAM 
SET MABS = 'BS01'
WHERE MAPK = 'PK01'

UPDATE PHONGKHAM 
SET MABS = 'BS02'
WHERE MAPK = 'PK02'

UPDATE PHONGKHAM 
SET MABS = 'BS03'
WHERE MAPK = 'PK03'

INSERT INTO KHAMBENH VALUES('KB01','BN01','BS01','01/01/2019','Viem phe quan')
INSERT INTO KHAMBENH VALUES('KB02','BN02','BS02','22/12/2018','Thieu mau nao')
INSERT INTO KHAMBENH VALUES('KB03','BN03','BS01','03/04/2019','Thoat vi dia dem')

/*3. Hiện thực ràng buộc toàn vẹn sau: bác sỹ làm trưởng phòng khám nào thì phải làm việc tại
phòng khám đó*/ 
GO 
CREATE TRIGGER TRG_BACSY_INS_UPD ON BACSY
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MAPK CHAR(4),
			@MABS_BS CHAR(4),
			@MABS_PK CHAR(4)

	SELECT @MAPK = MAPK, @MABS_BS = MABS
	FROM INSERTED

	SELECT @MABS_PK = MABS
	FROM PHONGKHAM
	WHERE @MAPK = MAPK

	IF(@MABS_PK <> @MABS_BS)
	BEGIN
		PRINT('TRG_BACSY_INS_UPD: BAC SY LAM TRUONG PHONG KHAM NAO THI PHAI LAM VIEC TAI PHONG KHAM DO.')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
INSERT INTO BACSY VALUES('BS04','Nguyen Van A','PK01') --Error
UPDATE BACSY
SET MAPK = 'PK01' --Error
WHERE MABS = 'BS03'

GO
CREATE TRIGGER TRG_PHONGKHAM_MABS_UPD ON PHONGKHAM
FOR UPDATE
AS
BEGIN
	DECLARE @MAPK CHAR(4),
			@MABS_BS CHAR(4),
			@MABS_PK CHAR(4)

	SELECT @MAPK = MAPK, @MABS_PK = MABS
	FROM INSERTED 

	SELECT @MABS_BS = MABS
	FROM BACSY
	WHERE MAPK = @MAPK

	IF(@MABS_BS <> @MABS_PK)
	BEGIN
		PRINT('TRG_PHONGKHAM_MABS_UPD: BAC SY LAM TRUONG PHONG KHAM NAO THI PHAI LAM VIEC TAI PHONG KHAM DO.')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
UPDATE PHONGKHAM
SET MABS = 'BS02' --Error
WHERE MAPK = 'PK01'

/*4. Tìm các bệnh nhân đã ở từng khám bệnh bởi bác sỹ ‘Dinh Cong Trang’ vào tháng 12 năm
2018 (TENBN, DT).*/
SELECT TENBN, DT
FROM (BENHNHAN BN JOIN KHAMBENH KB ON BN.MABN = KB.MABN)
		JOIN BACSY BS ON BS.MABS = KB.MABS
WHERE TENBS = 'Dinh Cong Trang'
AND MONTH(NGKHAM) = 12 AND YEAR(NGKHAM) = 2018

/*5. Tìm phòng khám có nhiều lượt bệnh nhân đến khám nhất năm 2018 (MAPK, SOLUOTKHAM).*/
SELECT TOP 1 PK.MAPK, COUNT(KB.MAKB) SOLUOTKHAM
FROM (KHAMBENH KB JOIN BACSY BS ON KB.MABS = BS.MABS)
		JOIN PHONGKHAM PK ON PK.MAPK = BS.MAPK
WHERE YEAR(NGKHAM) = 2018
GROUP BY PK.MAPK
ORDER BY SOLUOTKHAM DESC

/*6. Liệt kê các phòng khám và những người đã từng khám ở đó (nếu có) (MAPK, TENPK, TENBN).*/ --Đúng, xem lại
SELECT PK.MAPK, TENPK, TENBN
FROM ((KHAMBENH KB JOIN BACSY BS ON BS.MABS = KB.MABS)
		JOIN BENHNHAN BN ON KB.MABN = BN.MABN)
			RIGHT JOIN PHONGKHAM PK ON PK.MABS = BS.MABS

/*7. Tìm các bệnh nhân đã từng khám ở tất cả các phòng khám (MABN, TENBN).*/
SELECT MABN, TENBN
FROM BENHNHAN BN
WHERE NOT EXISTS(	SELECT*
					FROM PHONGKHAM PK
					WHERE NOT EXISTS(	SELECT*
										FROM KHAMBENH KB JOIN BACSY BS ON KB.MABS = BS.MABS
										WHERE BN.MABN = KB.MABN
										AND PK.MAPK = BS.MAPK))

