use QLDA
go
--BAI 1
--TONG GIO LAM VIEC VA TEN DE AN
----CAST----
SELECT TENDEAN, cast(sum(THOIGIAN) as decimal(5,2)) as 'Tong so gio lam viec 1 tuan' 
FROM CONGVIEC inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA
			  inner join DEAN on CONGVIEC.MADA = DEAN.MADA
GROUP BY TENDEAN
SELECT TENDEAN, cast(sum(THOIGIAN) as varchar(10)) as 'Tong so gio lam viec 1 tuan' 
FROM CONGVIEC inner join DEAN on CONGVIEC.MADA = DEAN.MADA
			  inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA
GROUP BY TENDEAN
----CONVERT----
SELECT TENDEAN, convert(decimal(5,2), sum(THOIGIAN)) as 'Tong so gio lam viec 1 tuan' 
FROM CONGVIEC inner join DEAN on CONGVIEC.MADA = DEAN.MADA
			  inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA
GROUP BY TENDEAN
SELECT TENDEAN, convert(varchar(10), sum(THOIGIAN)) as 'Tong so gio lam viec 1 tuan' 
FROM CONGVIEC inner join DEAN on CONGVIEC.MADA = DEAN.MADA
			  inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA
GROUP BY TENDEAN
-- TEN PHONG va LUONG TB cua nhung nhan vien phong do
--1
SELECT TENPHG, cast(AVG(LUONG) as decimal(10,2)) as 'Luong tb' 
FROM NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
GROUP BY TENPHG
SELECT TENPHG, convert(decimal(10,2), AVG(LUONG)) as 'Luong tb' 
FROM NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
GROUP BY TENPHG
--2
SELECT TENPHG, Left(cast(AVG(LUONG) as varchar(10)),3) + REPLACE(cast(AVG(LUONG) as varchar(10)), Left(cast(AVG(LUONG) as varchar(10)),3),',')
as 'luong tb' 
FROM NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
GROUP BY TENPHG
SELECT TENPHG, Left(convert(varchar(10), AVG(LUONG)),3) + REPLACE(convert(varchar(10), AVG(LUONG)), Left(convert(varchar(10), AVG(LUONG)),3),',')
as 'luong tb' 
FROM NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG GROUP BY TENPHG
-- Bai 2
--1
SELECT TENDEAN, cast(sum(THOIGIAN) as decimal(5,2)) as 'Tong so gio lam viec 1 tuan', 
ceiling(cast(sum(THOIGIAN) as decimal(5,2))) as 'Tong gio lam tron can tren'
FROM DEAN inner join CONGVIEC on CONGVIEC.MADA = DEAN.MADA inner join PHANCONG on PHANCONG.MADA = CONGVIEC.MADA
GROUP BY TENDEAN
SELECT TENDEAN, CAST(SUM(THOIGIAN) as decimal(5,2)) as 'Tong gio lam tron can duoi',
FLOOR(CAST(SUM(THOIGIAN) as decimal(5,2))) as 'Tong gio moi'
FROM DEAN inner join CONGVIEC on CONGVIEC.MADA = DEAN.MADA inner join PHANCONG on PHANCONG.MADA = CONGVIEC.MADA 
group by TENDEAN
SELECT TENDEAN, cast(sum(THOIGIAN) as decimal(5,2)) as 'Tong gio lam tron thap phan',
ROUND(cast(sum(THOIGIAN) as decimal(5,2)),2) as 'Tong gio moi'
from DEAN inner join CONGVIEC on CONGVIEC.MADA = DEAN.MADA inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA
group by TENDEAN
--2
select HONV + ' ' + TENLOT + ' ' + TENNV, LUONG from NHANVIEN 
where LUONG >(select ROUND(AVG(LUONG),2) from NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG 
where PHONGBAN.TENPHG = N'Nghiên cứu')
-- Bai 3
select UPPER(HONV) as 'Ho nv (viet hoa)', LOWER(TENLOT) as 'Ten lot (viet thuong)', 
LOWER(LEFT(TENNV,1)) + UPPER(SUBSTRING(TENNV,2,1)) + SUBSTRING(TENNV,3,LEN(TENNV)-2) as 'Ki tu t2 trong ten viet hoa', 
DCHI, COUNT(MA_NVIEN) as 'So than nhan' 
from NHANVIEN inner join THANNHAN on THANNHAN.MA_NVIEN = NHANVIEN.MANV group by HONV, TENLOT, TENNV, DCHI
having count(MA_NVIEN) > 2

select DCHI, SUBSTRING(DCHI,CHARINDEX(' ', DCHI),CHARINDEX(',', DCHI)-3) as 'Ten duong' from NHANVIEN
-- Bai 4
--1
select * from NHANVIEN
where YEAR(NGSINH) between 1960 and 1965
--2
select HONV, TENLOT, TENNV, NGSINH, YEAR(GETDATE()) - YEAR(NGSINH) as 'Tuoi' from NHANVIEN
--3
select HONV, TENLOT, TENNV, NGSINH, DATENAME(weekday,NGSINH) as 'Thu' from NHANVIEN
--4
select TENPHG, TRPHG, trgphong.TENNV, NG_NHANCHUC, COUNT(nv.MANV) as 'So luong nv' 
from NHANVIEN nv inner join PHONGBAN on PHONGBAN.MAPHG = nv.PHG
inner join NHANVIEN trgphong on trgphong.MANV = PHONGBAN.TRPHG group by TENPHG,TRPHG,NG_NHANCHUC,trgphong.TENNV