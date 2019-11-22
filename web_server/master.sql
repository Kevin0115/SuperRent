drop table vehicle_return;
drop table rental;
drop table reservation;
drop table vehicle;
drop table vehicle_type;
drop table customer;
drop table branch;

-- this table might not be necessary
create table branch (
    branch_location varchar(20) not null,
    branch_city varchar(20) not null,
    primary key (branch_location, branch_city)
);

create table customer (
    dlicense integer not null primary key,
    cellphone bigint not null,
    customer_name varchar(50) not null,
    customer_address varchar(50) not null
);

create table vehicle_type (
    -- vtname will be something like compact_hybrid or suv_gas
    vtname varchar(20) not null primary key,
    -- could make features an ARRAY
    features varchar(50) not null,
    w_rate integer not null,
    d_rate integer not null,
    h_rate integer not null,
    wi_rate integer not null,
    di_rate integer not null,
    hi_rate integer not null,
    k_rate integer not null
);

create table vehicle (
    vlicense integer not null primary key,
    make varchar(20) not null,
    model varchar(20) not null,
    year integer not null,
    color varchar(20) not null,
    odometer integer not null,
    status varchar(20) not null,
    vtname varchar(20) not null,
    -- branch location and city might not be necessary as foreign keys
    branch_location varchar(20) not null,
    branch_city varchar(20) not null,
    foreign key (branch_location, branch_city) references branch,
    foreign key (vtname) references vehicle_type
);

create table reservation (
    -- This will be 7 digits
    conf_no integer not null primary key,
    -- I added this to be able to reference which vehicles are reserved
    vlicense integer not null,
    vtname varchar(20) not null,
    dlicense integer not null,
    from_date date not null,
    from_time time not null,
    to_date date not null,
    to_time time not null,
    branch_location varchar(20) not null,
    branch_city varchar(20) not null,
    foreign key (vlicense) references vehicle,
    foreign key (vtname) references vehicle_type,
    foreign key (dlicense) references customer,
    -- Added location/city to reservation because that makes sense
    foreign key (branch_location, branch_city) references branch
    -- foreign key (from_date, from_time, to_date, to_time) references time_period
);

create table rental (
    rid integer not null primary key,
    vlicense integer not null,
    dlicense integer not null,
    from_date date not null,
    from_time time not null,
    to_date date not null,
    to_time time not null,
    odometer integer not null,
    card_name varchar(50),
    card_no bigint not null,
    exp_date date not null,
    conf_no integer, -- NO NEED FOR A PRIOR RESERVATION
    branch_location varchar(20) not null,
    branch_city varchar(20) not null,
    -- This will help track the status (active, complete) of a rental
    status varchar(20) not null,
    foreign key (vlicense) references vehicle,
    foreign key (dlicense) references customer,
    foreign key (conf_no) references reservation,
    -- Added location/city to reservation because that makes sense
    foreign key (branch_location, branch_city) references branch
    -- foreign key (from_date, from_time, to_date, to_time) references time_period
);

create table vehicle_return (
    rid integer not null primary key,
    return_date date not null,
    return_time time not null,
    odometer integer not null,
    fulltank boolean not null,
    tank_value integer not null,
    branch_location varchar(20) not null,
    branch_city varchar(20) not null,
    vlicense integer not null,
    price real not null,
    foreign key (vlicense) references vehicle,
    foreign key (rid) references rental,
    -- Added location/city to reservation because that makes sense
    foreign key (branch_location, branch_city) references branch
);

insert into branch values ('Downtown','Vancouver');
insert into branch values ('Midtown','Vancouver');
insert into branch values ('Downtown','Burnaby');
insert into branch values ('Midtown','Burnaby');
insert into branch values ('Downtown','Surrey');
insert into branch values ('Midtown','Surrey');

insert into vehicle_type values ('economy_electric','Air Conditioning',352,84,10,67,16,2,2);
insert into vehicle_type values ('economy_gas','Heated Seats',281,67,8,67,16,2,2);
insert into vehicle_type values ('economy_hybrid','Bluetooth',420,100,12,67,16,2,2);
insert into vehicle_type values ('compact_electric','Air Conditioning',386,92,11,67,16,2,2);
insert into vehicle_type values ('compact_gas','Heated Seats',315,75,9,67,16,2,2);
insert into vehicle_type values ('compact_hybrid','Heated Seats',457,109,13,67,16,2,2);
insert into vehicle_type values ('midsize_electric','Bluetooth',420,100,12,105,25,3,3);
insert into vehicle_type values ('midsize_gas','Bluetooth',352,84,10,105,25,3,3);
insert into vehicle_type values ('midsize_hybrid','Air Conditioning',491,117,14,105,25,3,3);
insert into vehicle_type values ('standard_electric','Bluetooth',457,109,13,105,25,3,3);
insert into vehicle_type values ('standard_gas','Bluetooth',386,92,11,105,25,3,3);
insert into vehicle_type values ('standard_hybrid','Heated Seats',529,126,15,105,25,3,3);
insert into vehicle_type values ('fullsize_electric','Bluetooth',491,117,14,138,33,4,4);
insert into vehicle_type values ('fullsize_gas','Bluetooth',420,100,12,138,33,4,4);
insert into vehicle_type values ('fullsize_hybrid','Air Conditioning',562,134,16,138,33,4,4);
insert into vehicle_type values ('suv_electric','Air Conditioning',529,126,15,176,42,5,5);
insert into vehicle_type values ('suv_gas','Bluetooth',457,109,13,176,42,5,5);
insert into vehicle_type values ('suv_hybrid','Bluetooth',596,142,17,176,42,5,5);
insert into vehicle_type values ('truck_electric','Bluetooth',562,134,16,176,42,5,5);
insert into vehicle_type values ('truck_gas','Air Conditioning',491,117,14,176,42,5,5);
insert into vehicle_type values ('truck_hybrid','Heated Seats',634,151,18,176,42,5,5);


insert into vehicle values (285834,'Toyota','Prius',2015,'blue',80000,'available','economy_electric','Downtown','Vancouver');
insert into vehicle values (401853,'Kia','Niro',2016,'white',22000,'available','economy_gas','Downtown','Vancouver');
insert into vehicle values (395267,'Toyota','Prius',2016,'blue',35500,'available','economy_hybrid','Downtown','Vancouver');
insert into vehicle values (977841,'Kia','Forte',2016,'purple',35500,'available','compact_electric','Downtown','Vancouver');
insert into vehicle values (323642,'Honda','Civic',2016,'red',35500,'available','compact_gas','Downtown','Vancouver');
insert into vehicle values (134772,'Honda','Civic',2010,'red',200000,'available','compact_hybrid','Downtown','Vancouver');
insert into vehicle values (485830,'Nissan','Sentra',2010,'blue',200000,'available','midsize_electric','Downtown','Vancouver');
insert into vehicle values (294121,'Ford','Focus',2010,'blue',200000,'available','midsize_gas','Downtown','Vancouver');
insert into vehicle values (195921,'Ford','Focus',2010,'blue',200000,'available','midsize_hybrid','Downtown','Vancouver');
insert into vehicle values (701740,'Toyota','Corolla',2012,'blue',150000,'available','standard_electric','Downtown','Vancouver');
insert into vehicle values (575370,'Toyota','Corolla',2014,'blue',100000,'available','standard_gas','Downtown','Vancouver');
insert into vehicle values (610034,'Toyota','Corolla',2015,'blue',68000,'available','standard_hybrid','Downtown','Vancouver');
insert into vehicle values (549587,'Ford','Fusion',2015,'white',73000,'available','fullsize_electric','Downtown','Vancouver');
insert into vehicle values (385674,'Nissan','Altima',2015,'black',59000,'available','fullsize_gas','Downtown','Vancouver');
insert into vehicle values (715498,'Nissan','Altima',2015,'brick orange',33000,'available','fullsize_hybrid','Downtown','Vancouver');
insert into vehicle values (500207,'Toyota','Rav4',2015,'white',80000,'available','suv_electric','Downtown','Vancouver');
insert into vehicle values (686376,'Ford','Edge',2015,'yellow',15000,'available','suv_gas','Downtown','Vancouver');
insert into vehicle values (801741,'Ford','Edge',2015,'brown',56500,'available','suv_hybrid','Downtown','Vancouver');
insert into vehicle values (603872,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_electric','Downtown','Vancouver');
insert into vehicle values (621265,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_gas','Downtown','Vancouver');
insert into vehicle values (757250,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_hybrid','Downtown','Vancouver');
insert into vehicle values (294725,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_electric','Midtown','Vancouver');
insert into vehicle values (857098,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_gas','Midtown','Vancouver');
insert into vehicle values (137979,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_hybrid','Midtown','Vancouver');
insert into vehicle values (141114,'Hyundai','Elantra',2019,'metallic grey',12500,'available','compact_electric','Midtown','Vancouver');
insert into vehicle values (921418,'Hyundai','Veloster',2019,'metallic grey',11500,'available','compact_gas','Midtown','Vancouver');
insert into vehicle values (656721,'Volkswagen ','GTI',2019,'metallic grey',18000,'available','compact_hybrid','Midtown','Vancouver');
insert into vehicle values (371258,'Toyota','Corolla',2019,'red',5000,'available','midsize_electric','Midtown','Vancouver');
insert into vehicle values (253004,'Ford','Focus',2019,'red',7800,'available','midsize_gas','Midtown','Vancouver');
insert into vehicle values (158144,'Ford','Focus',2011,'red',64500,'available','midsize_hybrid','Midtown','Vancouver');
insert into vehicle values (924288,'Toyota','Corolla',2011,'red',146000,'available','standard_electric','Midtown','Vancouver');
insert into vehicle values (993740,'Toyota','Corolla',2011,'red',150000,'available','standard_gas','Midtown','Vancouver');
insert into vehicle values (514812,'Toyota','Corolla',2011,'red',150000,'available','standard_hybrid','Midtown','Vancouver');
insert into vehicle values (153742,'Chevrolet','Impala',2011,'red',150000,'available','fullsize_electric','Midtown','Vancouver');
insert into vehicle values (572503,'Ford','Taurus',2011,'green marble',150000,'available','fullsize_gas','Midtown','Vancouver');
insert into vehicle values (221306,'Nissan','Altima',2011,'purple',135000,'available','fullsize_hybrid','Midtown','Vancouver');
insert into vehicle values (344154,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_electric','Midtown','Vancouver');
insert into vehicle values (620317,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_gas','Midtown','Vancouver');
insert into vehicle values (573872,'Chevrolet','Tahoe',2013,'black',135000,'available','suv_hybrid','Midtown','Vancouver');
insert into vehicle values (230826,'Nissan','Frontier',2013,'black',67000,'available','truck_electric','Midtown','Vancouver');
insert into vehicle values (845989,'Ford','F150',2013,'black',48000,'available','truck_gas','Midtown','Vancouver');
insert into vehicle values (445060,'Ford','F150',2013,'black',48500,'available','truck_hybrid','Midtown','Vancouver');
insert into vehicle values (346255,'Chevrolet','Aveo',2013,'black',99000,'available','economy_electric','Downtown','Burnaby');
insert into vehicle values (945494,'Chevrolet','Aveo',2013,'black',34000,'available','economy_gas','Downtown','Burnaby');
insert into vehicle values (487381,'Chevrolet','Aveo',2019,'black',20000,'available','economy_hybrid','Downtown','Burnaby');
insert into vehicle values (262707,'Kia','Forte',2019,'white',50000,'available','compact_electric','Downtown','Burnaby');
insert into vehicle values (381894,'Honda','Civic',2017,'white',35000,'available','compact_gas','Downtown','Burnaby');
insert into vehicle values (239301,'Mazda','Mazda3',2017,'white',35000,'available','compact_hybrid','Downtown','Burnaby');
insert into vehicle values (143409,'Dodge','Avenger',2017,'white',35000,'available','midsize_electric','Downtown','Burnaby');
insert into vehicle values (196097,'Dodge','Avenger',2017,'white',35000,'available','midsize_gas','Downtown','Burnaby');
insert into vehicle values (624874,'Dodge','Avenger',2017,'white',35000,'available','midsize_hybrid','Downtown','Burnaby');
insert into vehicle values (705051,'Toyota','Corolla',2017,'blue',35000,'available','standard_electric','Downtown','Burnaby');
insert into vehicle values (882332,'Toyota','Corolla',2010,'blue',100000,'available','standard_gas','Downtown','Burnaby');
insert into vehicle values (819395,'Toyota','Corolla',2010,'blue',100000,'available','standard_hybrid','Downtown','Burnaby');
insert into vehicle values (931496,'Nissan','Armada',2010,'blue',100000,'available','fullsize_electric','Downtown','Burnaby');
insert into vehicle values (699174,'Nissan','Armada',2010,'blue',100000,'available','fullsize_gas','Downtown','Burnaby');
insert into vehicle values (165953,'Nissan','Armada',2010,'blue',100000,'available','fullsize_hybrid','Downtown','Burnaby');
insert into vehicle values (300654,'Ford','Escape',2012,'blue',100000,'available','suv_electric','Downtown','Burnaby');
insert into vehicle values (659270,'Toyota','Rav4',2012,'yellow',100000,'available','suv_gas','Downtown','Burnaby');
insert into vehicle values (651780,'Nissan','Armada',2018,'pink',40000,'available','suv_hybrid','Downtown','Burnaby');
insert into vehicle values (975961,'Ford','F150',2012,'ochre',140000,'available','truck_electric','Downtown','Burnaby');
insert into vehicle values (419980,'Nissan','Frontier',2012,'violet',140000,'available','truck_gas','Downtown','Burnaby');
insert into vehicle values (750256,'Nissan','Frontier',2012,'black',140000,'available','truck_hybrid','Downtown','Burnaby');
insert into vehicle values (267075,'Hyundai','Accent',2013,'black',140000,'available','economy_electric','Midtown','Burnaby');
insert into vehicle values (954621,'Hyundai','Accent',2013,'black',80000,'available','economy_gas','Midtown','Burnaby');
insert into vehicle values (456047,'Hyundai','Accent',2013,'black',90000,'available','economy_hybrid','Midtown','Burnaby');
insert into vehicle values (116050,'Mazda','Mazda3',2013,'black',400000,'available','compact_electric','Midtown','Burnaby');
insert into vehicle values (998775,'Kia','Forte',2013,'black',120000,'available','compact_gas','Midtown','Burnaby');
insert into vehicle values (731007,'Chevrolet','Cobalt',2013,'black',120000,'available','compact_hybrid','Midtown','Burnaby');
insert into vehicle values (627791,'Toyota','Corolla',2016,'black',50000,'available','midsize_electric','Midtown','Burnaby');
insert into vehicle values (752963,'Dodge','Avenger',2015,'black',70000,'available','midsize_gas','Midtown','Burnaby');
insert into vehicle values (696700,'Ford','Focus',2010,'black',200000,'available','midsize_hybrid','Midtown','Burnaby');
insert into vehicle values (744097,'Toyota','Corolla',2011,'black',200000,'available','standard_electric','Midtown','Burnaby');
insert into vehicle values (195875,'Toyota','Corolla',2017,'black',40000,'available','standard_gas','Midtown','Burnaby');
insert into vehicle values (976051,'Toyota','Corolla',2017,'black',45000,'available','standard_hybrid','Midtown','Burnaby');
insert into vehicle values (365757,'Ford','Fusion',2017,'black',45000,'available','fullsize_electric','Midtown','Burnaby');
insert into vehicle values (136841,'Dodge','Charger',2017,'green',45000,'available','fullsize_gas','Midtown','Burnaby');
insert into vehicle values (303804,'Chevrolet','Impala',2017,'blue',45000,'available','fullsize_hybrid','Midtown','Burnaby');
insert into vehicle values (150743,'Toyota','Rav4',2017,'blue',45000,'available','suv_electric','Midtown','Burnaby');
insert into vehicle values (949941,'Toyota','Rav5',2017,'blue',45000,'available','suv_gas','Midtown','Burnaby');
insert into vehicle values (636018,'Toyota','Rav6',2017,'blue',45000,'available','suv_hybrid','Midtown','Burnaby');
insert into vehicle values (788703,'Nissan','Frontier',2017,'blue',45000,'available','truck_electric','Midtown','Burnaby');
insert into vehicle values (443261,'Nissan','Frontier',2010,'brown',180000,'available','truck_gas','Midtown','Burnaby');
insert into vehicle values (675239,'Nissan','Frontier',2010,'brown',180000,'available','truck_hybrid','Midtown','Burnaby');
insert into vehicle values (945896,'Chevrolet','Spark',2010,'brown',180000,'available','economy_electric','Downtown','Surrey');
insert into vehicle values (767163,'Hyundai','Accent',2010,'brown',180000,'available','economy_gas','Downtown','Surrey');
insert into vehicle values (632524,'Hyundai','Accent',2010,'brown',180000,'available','economy_hybrid','Downtown','Surrey');
insert into vehicle values (296357,'Hyundai','Veloster',2010,'red',180000,'available','compact_electric','Downtown','Surrey');
insert into vehicle values (992341,'Ford','Focus',2010,'red',180000,'available','compact_gas','Downtown','Surrey');
insert into vehicle values (656281,'Hyundai','Elantra',2010,'red',180000,'available','compact_hybrid','Downtown','Surrey');
insert into vehicle values (369152,'Toyota','Corolla',2010,'grey',180000,'available','midsize_electric','Downtown','Surrey');
insert into vehicle values (439697,'Toyota','Corolla',2010,'grey',180000,'available','midsize_gas','Downtown','Surrey');
insert into vehicle values (995148,'Toyota','Corolla',2010,'blue',180000,'available','midsize_hybrid','Downtown','Surrey');
insert into vehicle values (554710,'Toyota','Corolla',2012,'white',75000,'available','standard_electric','Downtown','Surrey');
insert into vehicle values (888524,'Toyota','Corolla',2012,'black',75000,'available','standard_gas','Downtown','Surrey');
insert into vehicle values (445901,'Toyota','Corolla',2012,'white',75000,'available','standard_hybrid','Downtown','Surrey');
insert into vehicle values (764105,'Ford','Taurus',2012,'white',85000,'available','fullsize_electric','Downtown','Surrey');
insert into vehicle values (212952,'Ford','Taurus',2012,'red',85000,'available','fullsize_gas','Downtown','Surrey');
insert into vehicle values (847471,'Ford','Taurus',2012,'pink',45000,'available','fullsize_hybrid','Downtown','Surrey');
insert into vehicle values (723417,'Ford','Edge',2012,'baby blue',55000,'available','suv_electric','Downtown','Surrey');
insert into vehicle values (990459,'Ford','Edge',2012,'silver',90000,'available','suv_gas','Downtown','Surrey');
insert into vehicle values (203101,'Ford','Edge',2012,'silver',90000,'available','suv_hybrid','Downtown','Surrey');
insert into vehicle values (715006,'Nissan','Frontier',2012,'silver',90000,'available','truck_electric','Downtown','Surrey');
insert into vehicle values (683644,'Nissan','Frontier',2018,'silver',15000,'available','truck_gas','Downtown','Surrey');
insert into vehicle values (795381,'Nissan','Frontier',2018,'silver',40000,'available','truck_hybrid','Downtown','Surrey');
insert into vehicle values (354683,'Chevrolet','Aveo',2018,'silver',40000,'available','economy_electric','Midtown','Surrey');
insert into vehicle values (208323,'Chevrolet','Aveo',2018,'light brown',25000,'available','economy_gas','Midtown','Surrey');
insert into vehicle values (297758,'Chevrolet','Aveo',2018,'bright red',10000,'available','economy_hybrid','Midtown','Surrey');
insert into vehicle values (809697,'Hyundai','Elantra',2018,'gold',18000,'available','compact_electric','Midtown','Surrey');
insert into vehicle values (295844,'Volkswagen ','GTI',2018,'white',18000,'available','compact_gas','Midtown','Surrey');
insert into vehicle values (670660,'Subaru ','Impreza',2018,'white',18000,'available','compact_hybrid','Midtown','Surrey');
insert into vehicle values (113773,'Dodge','Avenger',2018,'white',18000,'available','midsize_electric','Midtown','Surrey');
insert into vehicle values (338856,'Dodge','Avenger',2018,'white',18000,'available','midsize_gas','Midtown','Surrey');
insert into vehicle values (331297,'Dodge','Avenger',2018,'white',18000,'available','midsize_hybrid','Midtown','Surrey');
insert into vehicle values (117183,'Toyota','Corolla',2018,'white',18000,'available','standard_electric','Midtown','Surrey');
insert into vehicle values (410133,'Toyota','Corolla',2019,'white',10000,'available','standard_gas','Midtown','Surrey');
insert into vehicle values (929195,'Toyota','Corolla',2010,'white',150000,'available','standard_hybrid','Midtown','Surrey');
insert into vehicle values (942664,'Dodge','Charger',2010,'black',160000,'available','fullsize_electric','Midtown','Surrey');
insert into vehicle values (670097,'Dodge','Charger',2010,'black',130000,'available','fullsize_gas','Midtown','Surrey');
insert into vehicle values (544775,'Dodge','Charger',2010,'black',120000,'available','fullsize_hybrid','Midtown','Surrey');
insert into vehicle values (198981,'Jeep','Cherokee',2010,'black',150000,'available','suv_electric','Midtown','Surrey');
insert into vehicle values (115342,'Jeep','Cherokee',2010,'black',150000,'available','suv_gas','Midtown','Surrey');
insert into vehicle values (991706,'Jeep','Cherokee',2010,'dark grey',150000,'available','suv_hybrid','Midtown','Surrey');
insert into vehicle values (678170,'Nissan','Frontier',2010,'red',150000,'available','truck_electric','Midtown','Surrey');
insert into vehicle values (451887,'Nissan','Frontier',2010,'black',150000,'available','truck_gas','Midtown','Surrey');
insert into vehicle values (152277,'Nissan','Frontier',2010,'black',150000,'available','truck_hybrid','Midtown','Surrey');
-- RESERVATION TEST THIS VEHICLE
insert into vehicle values (802694,'Acura','NSX',1999,'Green',364527,'available','fullsize_gas','Midtown','Burnaby');

insert into customer values (9999990,9541328538,'Simonette Oleszkiewicz','7 Hazelcrest Court');
insert into customer values (9999991,9676249844,'Judah Rippen','447 Oakridge Plaza');
insert into customer values (9999992,1784171243,'Ephraim Anthon','806 Oriole Plaza');
insert into customer values (9999993,6348001182,'Gavrielle Belfit','34619 Jackson Plaza');
insert into customer values (9999994,1827915328,'Vanni Audsley','4771 Clyde Gallagher Court');
insert into customer values (9999995,2898683042,'Jeniece Napolione','78 Cottonwood Circle');
insert into customer values (9999996,8518410079,'Gerry Skedgell','1579 Summit Court');
insert into customer values (9999997,3487343955,'Jarred Saintpierre','769 American Park');
insert into customer values (9999998,8195730351,'Cherry Fulks','880 Iowa Way');
insert into customer values (9999999,7753439700,'Johnnie Jerwood','4098 Morning Way');
insert into customer values (9999910,1211420847,'Renado De Brett','835 David Road');
insert into customer values (9999911,4059058071,'Fern Bartalini','73 Ohio Crossing');
insert into customer values (9999912,4783456807,'Renado Fowlds','90 Fallview Plaza');
insert into customer values (9999913,9273666685,'Rivi Tyres','622 Valley Edge Drive');
insert into customer values (9999914,4355470141,'Clem Spino','6 Transport Trail');
insert into customer values (9999915,8646549733,'Clayson Berrigan','9875 Springs Way');
insert into customer values (9999916,5667267557,'Hansiain Stigger','37 Basil Hill');
insert into customer values (9999917,2379241567,'Ibrahim Goding','241 Pond Place');
insert into customer values (9999918,3013434956,'Harris Saller','8774 Norway Maple Hill');
insert into customer values (9999919,7757365180,'Olivette Vakhrushev','5 Paget Park');
insert into customer values (9999920,9594796563,'Tades Zaniolo','0729 Messerschmidt Center');
insert into customer values (9999921,3209080882,'Ilyssa Braz','018 Derek Junction');
insert into customer values (9999922,3421657450,'Hermon Caplen','8936 Wayridge Court');
insert into customer values (9999923,4323338858,'Llewellyn Faro','50813 Menomonie Alley');
insert into customer values (9999924,8611908388,'Avram Rosenthaler','87 Veith Alley');
insert into customer values (9999925,2415899453,'Britte Kas','9 Blackbird Avenue');
insert into customer values (9999926,3856771318,'Cornell Jermy','2823 Artisan Way');
insert into customer values (9999927,6958672178,'Danika Biskupski','510 Grover Trail');
insert into customer values (9999928,9652959722,'Chilton Ridge','587 Service Circle');
insert into customer values (9999929,5946500687,'Philomena Pardy','71419 Dryden Circle');

-- insert into reservation values(999,802694,'fullsize_gas',5772223,'2019-11-15','00:00:00','2019-11-18','00:00:00','Midtown','Burnaby');
insert into reservation values(9999990,285834,'economy_electric',9999990,'2019-11-25','12:00:00','2019-12-12','12:00:00','Downtown','Vancouver');
insert into reservation values(9999991,401853,'economy_gas',9999991,'2019-11-25','12:00:00','2019-12-01','12:00:00','Downtown','Vancouver');
insert into reservation values(9999992,395267,'economy_hybrid',9999992,'2019-11-25','15:00:00','2019-11-30','15:00:00','Downtown','Vancouver');
insert into reservation values(9999993,977841,'compact_electric',9999993,'2019-11-25','12:00:00','2019-11-30','12:00:00','Downtown','Vancouver');
insert into reservation values(9999994,323642,'compact_gas',9999994,'2019-11-27','12:00:00','2019-11-30','8:00:00','Downtown','Vancouver');
insert into reservation values(9999995,134772,'compact_hybrid',9999995,'2019-11-27','12:00:00','2019-11-30','8:00:00','Downtown','Vancouver');
insert into reservation values(9999996,485830,'midsize_electric',9999996,'2019-11-27','12:00:00','2019-11-30','12:00:00','Downtown','Vancouver');
insert into reservation values(9999997,294121,'midsize_gas',9999997,'2019-11-27','8:00:00','2019-12-05','12:00:00','Downtown','Vancouver');
insert into reservation values(9999998,195921,'midsize_hybrid',9999998,'2019-11-28','16:00:00','2019-12-02','12:00:00','Downtown','Vancouver');
insert into reservation values(9999999,701740,'standard_electric',9999999,'2019-11-23','12:00:00','2019-11-29','12:00:00','Downtown','Vancouver');
insert into reservation values(9999910,575370,'standard_gas',9999910,'2019-11-27','16:00:00','2019-11-29','8:00:00','Downtown','Vancouver');
insert into reservation values(9999911,610034,'standard_hybrid',9999911,'2019-11-27','16:00:00','2019-11-29','8:00:00','Downtown','Vancouver');
insert into reservation values(9999912,549587,'fullsize_electric',9999912,'2019-11-27','16:00:00','2019-11-29','8:00:00','Downtown','Vancouver');
insert into reservation values(9999913,385674,'fullsize_gas',9999913,'2019-11-28','16:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999914,715498,'fullsize_hybrid',9999914,'2019-11-28','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999915,500207,'suv_electric',9999915,'2019-11-28','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999916,686376,'suv_gas',9999916,'2019-12-02','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999917,801741,'suv_hybrid',9999917,'2019-12-02','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999918,603872,'truck_electric',9999918,'2019-12-02','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');
insert into reservation values(9999919,621265,'truck_gas',9999918,'2019-12-02','8:00:00','2019-12-12','8:00:00','Downtown','Vancouver');

insert into rental values(8888880,285834,9999990,'2019-11-20','12:00:00','2019-12-12','12:00:00',80000,'Simonette Oleszkiewicz',9962483844913970,'2025-09-10',9999990,'Downtown','Vancouver','active');
insert into rental values(8888881,401853,9999991,'2019-11-21','12:00:00','2019-12-01','12:00:00',22000,'Judah Rippen',1553608499537700,'2025-09-10',9999991,'Downtown','Vancouver','active');
insert into rental values(8888882,395267,9999992,'2019-11-25','15:00:00','2019-11-30','15:00:00',35500,'Ephraim Anthon',1122277332356220,'2025-09-10',9999992,'Downtown','Vancouver','active');
insert into rental values(8888883,977841,9999993,'2019-11-25','12:00:00','2019-11-30','12:00:00',35500,'Gavrielle Belfit',2414390029457650,'2025-09-10',9999993,'Downtown','Vancouver','active');
insert into rental values(8888884,323642,9999994,'2019-11-27','12:00:00','2019-11-30','8:00:00',35500,'Vanni Audsley',4983242103882110,'2025-09-10',9999994,'Downtown','Vancouver','complete');
insert into rental values(8888885,134772,9999995,'2019-11-27','12:00:00','2019-11-30','8:00:00',200000,'Jeniece Napolione',4237462063451900,'2025-09-10',9999995,'Downtown','Vancouver','complete');
insert into rental values(8888886,485830,9999996,'2019-11-27','12:00:00','2019-11-30','12:00:00',200000,'Gerry Skedgell',5636912791405050,'2025-09-10',9999996,'Downtown','Vancouver','complete');
insert into rental values(8888887,294121,9999997,'2019-11-27','8:00:00','2019-12-05','12:00:00',200000,'Jarred Saintpierre',4922915908269540,'2025-09-10',9999997,'Downtown','Vancouver','active');
insert into rental values(8888888,195921,9999998,'2019-11-28','16:00:00','2019-12-02','12:00:00',200000,'Cherry Fulks',4781637900904780,'2025-09-10',9999998,'Downtown','Vancouver','active');
insert into rental values(8888889,701740,9999999,'2019-11-23','12:00:00','2019-11-29','12:00:00',150000,'Johnnie Jerwood',6664990725230690,'2025-09-10',9999999,'Downtown','Vancouver','complete');

insert into rental values(8888801,752963,9999910,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888802,696700,9999911,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888803,744097,9999912,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888804,195875,9999913,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888805,976051,9999914,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888806,365757,9999915,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888807,136841,9999916,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888808,303804,9999917,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888809,150743,9999918,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888810,949941,9999919,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');
insert into rental values(8888811,636018,9999920,'2019-11-22','12:00:00','2019-11-30','12:00:00',150000,'John Smith',4520000088880000,'2025-02-02',null,'Midtown','Burnaby','active');


insert into vehicle_return values(8888884,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',323642,200.99);
insert into vehicle_return values(8888881,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',401853,300.99);
insert into vehicle_return values(8888882,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',395267,420.99);
insert into vehicle_return values(8888883,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',977841,230.99);
insert into vehicle_return values(8888887,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',294121,150.99);
insert into vehicle_return values(8888885,'2019-11-22','12:00:00',35550,true,50,'Downtown','Vancouver',134772,100.99);
insert into vehicle_return values(8888886,'2019-11-30','12:00:00',35550,true,50,'Downtown','Vancouver',485830,250.99);