-- Phần I: Tạo CSDL và các bảng
create database hackathon;
use hackathon;

create table guests (
	guest_id varchar(5) primary key,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null unique
);

create table roomTypes (
	type_id varchar(5) primary key,
    type_name varchar(100) not null unique
);

create table rooms (
	room_id varchar(5) primary key,
    room_name varchar(100) not null unique,
    type_id varchar(5),
    foreign key (type_id) references roomTypes (type_id),
    price_per_night decimal(10, 2) not null,
    capacity int not null
);

create table reservations (
	reservation_id int primary key auto_increment,
    guest_id varchar(5) not null,
    foreign key (guest_id) references guests (guest_id),
    room_id varchar(5) not null,
    foreign key (room_id) references rooms (room_id),
    status varchar(20) check(status in ('booked', 'checked-in', 'cancelled')),
    check_in_date date not null
);

insert guests values
('G01', 'Lê Văn Tám', 'tam.lv@gmail.com', '0901111111'),
('G02', 'Bùi Thị Lan', 'lan.bt@gmail.com', '0902222222'),
('G03', 'Đỗ Hữu Trọng', 'trong.dh@gmail.com', '0903333333'),
('G04', 'Lý Thanh Hà', 'ha.lt@gmail.com', '0904444444'),
('G05', 'Trương Vĩnh Ký', 'ky.tv@gmail.com', '0905555555');

insert roomTypes values
('T01', 'Standard'),
('T02', 'Superior'),
('T03', 'Deluxe'),
('T04', 'Suite');

insert rooms values
('R01', 'Phòng 101', 'T01', 500000, 2),
('R02', 'Phòng 102', 'T01', 500000, 2),
('R03', 'Phòng 201', 'T02', 800000, 2),
('R04', 'Phòng 301', 'T03', 1200000, 3),
('R05', 'Phòng 401', 'T04', 2500000, 4);

insert reservations (guest_id, room_id, status, check_in_date) values
('G01', 'R01', 'booked', '2025-10-01'),
('G02', 'R03', 'checked-in', '2025-10-02'),
('G01', 'R02', 'checked-in', '2025-10-03'),
('G04', 'R05', 'cancelled', '2025-10-04'),
('G05', 'R01', 'booked', '2025-10-05');

update rooms
set capacity = capacity + 2, price_per_night = price_per_night * 1.05
where room_name = 'Phòng 401';

update guests
set phone = '0999999999'
where guest_id = 'G03';

delete from reservations
where status = 'cancelled' and check_in_date < '2025-10-03';

-- Phần II: Truy vấn dữ liệu cơ bản
select room_id, room_name, price_per_night
from rooms
where (price_per_night between 800000 and 2000000) and capacity > 2;

select full_name, email
from guests
where full_name like 'Lê%';

select reservation_id, guest_id, check_in_date
from reservations
order by check_in_date desc;

select room_name, price_per_night
from rooms
order by price_per_night desc
limit 3;

select room_name, capacity
from rooms
limit 2
offset 2;

-- Phần III: Truy vấn dữ liệu nâng cao
select re.reservation_id, g.full_name, r.room_name, re.check_in_date
from reservations re
inner join guests g on g.guest_id = re.guest_id
inner join rooms r on r.room_id = re.room_id
where re.status = 'booked';

select rt.type_name, r.room_name
from rooms r
right join roomTypes rt on rt.type_id = r.type_id;

select status, count(status) as total_reservations
from reservations
group by status
having count(status);

select g.full_name
from reservations re
inner join guests g on g.guest_id = re.guest_id
group by re.guest_id
having count(re.guest_id) >= 2;

select room_id, room_name, price_per_night
from rooms
where price_per_night < (
	select avg(price_per_night)
    from rooms
);

select g.full_name, g.phone
from guests g
inner join reservations re on re.guest_id = g.guest_id
inner join rooms r on r.room_id = re.room_id
where room_name = 'Phòng 101';