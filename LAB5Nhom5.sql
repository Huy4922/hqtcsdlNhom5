use QLDA
go
--lab5
--1a
create proc sp_lab5_b1a @ten nvarchar(20)
as
	begin
		print 'Xin chao: ' + @ten
	end

execute sp_lab5_b1a 'Huy'
--1b
create proc sp_lab5_b1b @s1 int, @s2 int
as
	begin
		declare @tg int = 0;
		set @tg = @s1 + @s2
		print 'Tong: ' + cast(@tg as varchar(10))
	end

exec sp_lab5_b1b 4,6
--1c
create proc sp_lab5_b1c @n int
as
	begin
		declare @tong int = 0, @dem int = 0;
		while @dem < @n
			begin
				set @tong = @tong + @dem
				set @dem = @dem + 2
			end
		print 'Tong cac so chan: ' + cast(@tong as varchar(10))
	end

exec sp_lab5_b1c 10
--1d
create proc sp_lab5_b1d @a int, @b int
as
	begin
		while (@a != @b)
			begin
				if (@a > @b) set @a = @a - @b
				else set @b = @b - @a
			end
			return @a
	end

declare @c int
exec @c = sp_lab5_b1d 20, 25
print 'Uoc chung lon nhat la: ' + cast(@c as varchar(10))
--2a
create proc sp_lab5_b2a @Manv varchar(3)
as
	begin
		select * from NHANVIEN where MANV = @Manv
	end

exec sp_lab5_b2a '005'
--2b
alter proc sp_lab5_b2b @manv varchar(3)
as
	begin
		select count(MANV)as 'So luong nhan vien', MADA, TENPHG from NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
		inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG where MADA = @manv
		group by TENPHG, MADA
	end

exec sp_lab5_b2b 1
--2c
alter proc sp_lab5_b2c @manv int, @Diem_DA nvarchar(15)
as
	begin
		select count(MANV) as 'So luong nhan vien', MADA, TENPHG, DDIEM_DA from NHANVIEN inner join PHONGBAN on NHANVIEN.PHG = PHONGBAN.MAPHG
		inner join DEAN on DEAN.PHONG = NHANVIEN.PHG
		where MADA = @manv and DDIEM_DA = @Diem_DA group by TENPHG, MADA, DDIEM_DA
	end

exec sp_lab5_b2c '30', N'Hà Nội'
--2d
create proc sp_lab5_b2d @Matp varchar(5)
as
begin
	select HONV, TENNV, TENPHG, NHANVIEN.MANV, THANNHAN.* from NHANVIEN inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
	left outer join THANNHAN on THANNHAN.MA_NVIEN = NHANVIEN.MANV
	where THANNHAN.MA_NVIEN is null
	and TRPHG = @Matp
end

exec sp_lab5_b2d '008'
--2e
alter proc sp_lab5_b2e @manv varchar(5), @mapb varchar(5)
as 
begin
	if exists(select * from NHANVIEN where MANV = @manv and PHG = @mapb)
	print 'Nhan Vien' + @manv + 'co trong phong ban' + @mapb
	else print 'Nhan vien ' + @manv + ' khong co trong phong ban' + @mapb
end

exec sp_lab5_b2e '004', '1'
--3a
alter proc sp_lab5_b3a @mapb int, @tenpb nvarchar(15), @matp nvarchar(9), @NgayNhanChuc date
as
begin
	if (exists (select * from PHONGBAN where MAPHG = @mapb))
		print  'Them that bai'
	else
	begin
		insert into PHONGBAN (MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
		values (@mapb, @tenpb, @matp, @NgayNhanChuc)
		print 'Them thanh cong'
	end
end

exec sp_lab5_b3a '8', 'CNTT', '008', '2020-10-06'
--3b
create proc sp_lab5_b3b @mapb int, @tenpb nvarchar(15), @matp nvarchar(9), @NgayNhanChuc date
as
begin
	if (exists (select * from PHONGBAN where MAPHG = @mapb))
		update PHONGBAN set TENPHG = @tenpb, TRPHG = @matp, NG_NHANCHUC = @NgayNhanChuc where MAPHG = @mapb
	else
	begin
		insert into PHONGBAN (MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
		values (@mapb, @tenpb, @matp, @NgayNhanChuc)
		print 'Them thanh cong'
	end
end

exec sp_lab5_b3b '8', 'IT', '008', '2020-10-06'
--3c
alter proc sp_lab5_b3c @honv nvarchar(15), @tenlot nvarchar(15), 
@tennv nvarchar(15), @manv nvarchar(6), @ngsinh date, @dchi nvarchar(50), @phai nvarchar(3),
@luong float, @manql nvarchar(3) = null, @phg int
as
begin
	declare @age int
	set @age = Year(getdate()) - year(@ngsinh)
	if @phg = (select MAPHG from PHONGBAN where TENPHG = 'IT')
		begin
			if @luong < 25000 set @manql ='009'
			else set @manql = '005'
			if ((@phai = 'Nam') and (@age between 18 and 65)) or ((@phai = N'Nữ' and @age between 18 and 60))
				begin
					insert into NHANVIEN(MANV, HONV, TENLOT, TENNV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
					values (@manv, @honv, @tenlot, @tennv, @ngsinh, @dchi, @phai, @luong, @manql, @phg)
					print 'Them thanh cong'
				end
			else print 'Khong phai do tuoi lao dong'
		end
	else print 'Khong phai phong IT'
end

exec sp_lab5_b3c 'Nguyen', 'Van', 'A', '018', '1957-06-11', 'Hue', 'Nam', '25000', '004', '8'