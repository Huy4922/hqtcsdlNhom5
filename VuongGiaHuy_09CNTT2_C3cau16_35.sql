--16. in ra ds sp k ban duoc trong 2006
SELECT D.MASP, TENSP FROM SANPHAM D WHERE D.MASP NOT IN(SELECT C.MASP 
FROM CTHD C INNER JOIN HOADON H ON C.SOHD = H.SOHD
WHERE YEAR(NGHD) = 2006)
--17. in ra ds sp do trung quoc san xuat khong ban duoc trong 2006
SELECT S.MASP, TENSP FROM SANPHAM S
WHERE NUOCSX = 'TRUNG QUOC' AND S.MASP NOT IN(SELECT C.MASP 
FROM CTHD C INNER JOIN HOADON H ON C.SOHD = H.SOHD WHERE YEAR(NGHD) = 2006)
--18. so hoa don da mua tat ca cac san pham do singapore san xuat
SELECT A.SOHD FROM HOADON A
WHERE EXISTS(SELECT * FROM SANPHAM S WHERE NUOCSX = 'SINGAPORE'
AND EXISTS(SELECT * FROM CTHD C WHERE C.SOHD = A.SOHD AND C.MASP = S.MASP))
--19. so hoa don trong nam 2006 mua it nhat cac san pham do singapore san xuat
SELECT D.SOHD FROM HOADON D 
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS(SELECT * FROM SANPHAM S
WHERE NUOCSX = 'SINGAPORE' AND NOT EXISTS(SELECT * FROM CTHD C
WHERE C.SOHD = D.SOHD AND C.MASP = S.MASP))
--20. co bao nhieu hoa don k phai cua khach hang dang ki thanh vien mua
SELECT COUNT(*) FROM HOADON H
WHERE MAKH NOT IN(SELECT MAKH FROM KHACHHANG K WHERE K.MAKH = H.MAKH)
--21. co bao nhieu san pham khac nhau dc ban trong nam 2006
SELECT COUNT(DISTINCT MASP) 
FROM CTHD C INNER JOIN HOADON H ON C.SOHD = H.SOHD WHERE YEAR(NGHD) = 2006
--22. cho biet hoa don gia tri cao nhat, thap nhat
SELECT MAX(TRIGIA) AS 'Hoa don gia tri cao nhat', MIN(TRIGIA) AS 'Hoa don gia tri thap nhat' FROM HOADON
--23. gia tri trung binh cua tat ca cac hoa don trong nam 2006 
SELECT AVG(TRIGIA) as 'Gia tri trung binh cua cac hoa don nam 2006' FROM HOADON
--24. doanh thu ban hang trong nam 2006
SELECT SUM(TRIGIA) AS 'Doanh thu ban hang nam 2006'
FROM HOADON WHERE YEAR(NGHD) = 2006
--25. tim so hoa don co gia tri cao nhat trong 2006
SELECT SOHD FROM HOADON WHERE TRIGIA = (SELECT MAX(TRIGIA) FROM HOADON) and YEAR(NGHD) = 2006
--26. tim ho ten khach hang da mua hoa don co gia cao nhat nam 2006
SELECT HOTEN FROM KHACHHANG K INNER JOIN HOADON H ON K.MAKH = H.MAKH 
AND SOHD = (SELECT SOHD FROM HOADON WHERE TRIGIA = (SELECT MAX(TRIGIA) FROM HOADON) and YEAR(NGHD) = 2006)
--27. danh sach 3 khach hang co doanh so cao nhat
SELECT TOP 3 MAKH, HOTEN FROM KHACHHANG ORDER BY DOANHSO DESC
--28. in ra danh sach cac san pham co gia ban = 1 trong 3 muc gia cao nhat
SELECT MASP, TENSP FROM SANPHAM WHERE GIA IN (SELECT DISTINCT TOP 3 GIA
FROM SANPHAM ORDER BY GIA DESC)
--29. in ra danh sach cac san pham do thai lan san xuat co gia = 1 trong 3 muc cao nhat cua tat ca cac san pham
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'THAI LAN' 
AND GIA IN (SELECT DISTINCT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)
--30. in ra danh sach cac san pham do trung quoc san xuat co gia = 1 trong 3 muc cao nhat cua san pham cua trung quoc
SELECT MASP, TENSP FROM SANPHAM WHERE NUOCSX = 'TRUNG QUOC'
AND GIA IN (SELECT DISTINCT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)
--31. danh sach 3 khach hang co doanh so cao nhat
SELECT TOP 3 MAKH, HOTEN FROM KHACHHANG ORDER BY DOANHSO DESC
--32. tong so san pham do trung quoc san xuat
SELECT COUNT(MASP) FROM SANPHAM WHERE NUOCSX = 'TRUNG QUOC'
--33. tong so san pham cua tung nuoc san xuat
SELECT NUOCSX, COUNT(MASP) AS TONGSOSANPHAM FROM SANPHAM GROUP BY NUOCSX
--34. voi tung nc san xuat, tim gia cao nhat, thap nhat, trung binh cac san pham
SELECT NUOCSX, MAX(GIA) AS MAX, MIN(GIA) AS MIN, AVG(GIA) AS AVG FROM SANPHAM GROUP BY NUOCSX
--35. tinh doanh thu ban hang moi ngay
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU FROM HOADON GROUP BY NGHD