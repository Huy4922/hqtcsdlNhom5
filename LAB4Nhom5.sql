use QLDA
go
--Bai 1
--1
declare @bangtam table (MaPB int, LuongTB float)
insert into @bangtam select PHG, AVG(LUONG) from NHANVIEN group by PHG
select TENNV, PHG, LUONG, LuongTB,
TinhTrang = case when LUONG > LuongTB then 'Khong tang luong' else 'Tang luong' end
from NHANVIEN inner join @bangtam b on NHANVIEN.PHG = b.MaPB
--2
declare @bangtamm table (MaPB int, LUONGTB float)
insert into @bangtamm select PHG, AVG(LUONG) from NHANVIEN group by PHG
select TENNV, PHG, LUONG, LUONGTB,
ChucVu = case when LUONG > LUONGTB then 'Truong phong' else 'Nhan vien' end
from NHANVIEN inner join @bangtamm a on NHANVIEN.PHG = a.MaPB
--3
select TENNV = case
when PHAI = 'Nam' then 'Mr. ' + TENNV 
when PHAI = N'Nữ' then 'Ms. ' + TENNV end
from NHANVIEN
--4
select TENNV, LUONG, Thue = case
when LUONG between 0 and 25000 then LUONG*0.1
when LUONG between 25000 and 30000 then LUONG*0.12
when LUONG between 30000 and 40000 then LUONG*0.15
when LUONG between 40000 and 50000 then LUONG*0.2
else LUONG*0.25 end
from NHANVIEN
--Bai 2
--1
declare @so int = 2, @dem int;
set @dem = (select count(*) from NHANVIEN)
while (@so <= @dem)
begin
	select MANV, HONV, TENLOT, TENNV from NHANVIEN
	where CAST(MANV as int) = @so;
	set @so = @so + 2;
end
--2
declare @s int = 2, @count int;
set @count = (select count(*) from NHANVIEN)
while (@s <= @count)
begin
	if (@s = 4)
		begin
			set @s += 2;
			continue;
		end
	select MANV, HONV, TENLOT, TENNV from NHANVIEN
	where CAST(MANV as int) = @s;
	set @s = @s + 2;
end
-- Bai 4
--1
begin try
	insert PHONGBAN (TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
	values ('Ke Hoach', 111, '017','2020-12-12')
	print 'chen thanh cong'
end try
begin catch
	print 'loi ' + convert(varchar, Error_number(),1) + '=>' + Error_message()
end catch
--2
declare @a int = 2, @b int = 0, @chia int;
begin try
	set @chia = @a / @b;
end try
begin catch
	declare @ErrorMessage nvarchar(2000), @ErrorSeverity int, @ErrorState int;
	select @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState)
end catch

