use QLDA
go
--1a
create trigger trig_lab6_b1a on NhanVien
for insert
as
	if (select luong from inserted) < 15000
		begin
			print 'Luong phai > 15000'
			rollback transaction
		end
insert into NHANVIEN values ('Ch', 'Ba', 'Den', '020', '2022-06-10', 'Hue', 'Nam', 16000, '004', '1')
--1b
create trigger trig_lab6_b1b on NhanVien
for insert
as 
	declare @age int
	set @age = Year(getdate()) - (select Year(NGSINH) from inserted)
	if (@age < 18 or @age > 65)
		begin
			print 'Tuoi khong hop le'
			rollback transaction
		end
insert into NHANVIEN values ('Ch', 'Ba', 'Den', '021', '1960-06-10', 'Hue', 'Nam', 16000, '004', '1')
--1c
create trigger trig_lab6_b1c on NhanVien
for update
as
	if (select DCHI from inserted) like '%HCM%'
	begin
		print 'Dia chi k hop le'
		rollback transaction
	end
update NHANVIEN set TENNV = 'HuyNV' where MANV = '005'
--2a
create trigger trig_lab6_b2a on NhanVien after insert
as
begin
	select count(case when PHAI = 'Nam' then 1 end) Nam, count(case when PHAI = N'Nữ' then 1 end) Nữ
	from NHANVIEN
end
insert into NHANVIEN values ('Ch', 'Ba', 'Den', '023', '1960-06-10', 'Hue', 'Nam', 16000, '004', '1')
--2b
create trigger trig_lab6_b2b on NhanVien after update
as
begin
	if update(PHAI)
		begin
			select count(case when PHAI = 'Nam' then 1 end) Nam, count(case when PHAI = N'Nữ' then 1 end) Nữ
			from NHANVIEN
		end
end
update NHANVIEN set PHAI = N'Nữ' where MANV = '004'
select * from NHANVIEN
--2c
create trigger trig_lab6_b2c on DeAn after delete
as
	begin
		select MA_NVIEN, count(MADA) as 'So luong de an moi nv phai lam' from PHANCONG group by MA_NVIEN
	end
delete DEAN where MADA = 23
--3a
create trigger trig_lab6_b3a on NhanVien instead of delete
as
	begin
		delete from THANNHAN where MA_NVIEN in (select MANV from deleted)
		delete from NHANVIEN where MANV in (select MANV from deleted)
	end
delete from NHANVIEN where MANV = '020'
--3b
create trigger trig_lab6_b3b on NhanVien after insert
as
	begin
		insert into PHANCONG values ((select MaNV from inserted),1,2,70)
	end
insert into NHANVIEN values ('Ch', 'Ba', 'Den', '027', '1960-06-10', 'Hue', 'Nam', 16000, '004', '1')