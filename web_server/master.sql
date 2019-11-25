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

insert into vehicle values (111111,'Toyota','Prius',2015,'blue',80000,'available','economy_electric','Downtown','Vancouver');
insert into vehicle values (111112,'Kia','Niro',2016,'white',22000,'available','economy_gas','Downtown','Vancouver');
insert into vehicle values (111113,'Toyota','Prius',2016,'blue',35500,'available','economy_hybrid','Downtown','Vancouver');
insert into vehicle values (111114,'Kia','Forte',2016,'purple',35500,'available','compact_electric','Downtown','Vancouver');
insert into vehicle values (111115,'Honda','Civic',2016,'red',35500,'available','compact_gas','Downtown','Vancouver');
insert into vehicle values (111116,'Honda','Civic',2010,'red',200000,'available','compact_hybrid','Downtown','Vancouver');
insert into vehicle values (111117,'Nissan','Sentra',2010,'blue',200000,'available','midsize_electric','Downtown','Vancouver');
insert into vehicle values (111118,'Ford','Focus',2010,'blue',200000,'available','midsize_gas','Downtown','Vancouver');
insert into vehicle values (111119,'Ford','Focus',2010,'blue',200000,'available','midsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111120,'Toyota','Corolla',2012,'blue',150000,'available','standard_electric','Downtown','Vancouver');
insert into vehicle values (111121,'Toyota','Corolla',2014,'blue',100000,'available','standard_gas','Downtown','Vancouver');
insert into vehicle values (111122,'Toyota','Corolla',2015,'blue',68000,'available','standard_hybrid','Downtown','Vancouver');
insert into vehicle values (111123,'Ford','Fusion',2015,'white',73000,'available','fullsize_electric','Downtown','Vancouver');
insert into vehicle values (111124,'Nissan','Altima',2015,'black',59000,'available','fullsize_gas','Downtown','Vancouver');
insert into vehicle values (111125,'Nissan','Altima',2015,'brick orange',33000,'available','fullsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111126,'Toyota','Rav4',2015,'white',80000,'available','suv_electric','Downtown','Vancouver');
insert into vehicle values (111127,'Ford','Edge',2015,'yellow',15000,'available','suv_gas','Downtown','Vancouver');
insert into vehicle values (111128,'Ford','Edge',2015,'brown',56500,'available','suv_hybrid','Downtown','Vancouver');
insert into vehicle values (111129,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_electric','Downtown','Vancouver');
insert into vehicle values (111130,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_gas','Downtown','Vancouver');
insert into vehicle values (111131,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_hybrid','Downtown','Vancouver');
insert into vehicle values (111132,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_electric','Midtown','Vancouver');
insert into vehicle values (111133,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_gas','Midtown','Vancouver');
insert into vehicle values (111134,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_hybrid','Midtown','Vancouver');
insert into vehicle values (111135,'Hyundai','Elantra',2019,'metallic grey',12500,'available','compact_electric','Midtown','Vancouver');
insert into vehicle values (111136,'Hyundai','Veloster',2019,'metallic grey',11500,'available','compact_gas','Midtown','Vancouver');
insert into vehicle values (111137,'Volkswagen ','GTI',2019,'metallic grey',18000,'available','compact_hybrid','Midtown','Vancouver');
insert into vehicle values (111138,'Toyota','Corolla',2019,'red',5000,'available','midsize_electric','Midtown','Vancouver');
insert into vehicle values (111139,'Ford','Focus',2019,'red',7800,'available','midsize_gas','Midtown','Vancouver');
insert into vehicle values (111140,'Ford','Focus',2011,'red',64500,'available','midsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111141,'Toyota','Corolla',2011,'red',146000,'available','standard_electric','Midtown','Vancouver');
insert into vehicle values (111142,'Toyota','Corolla',2011,'red',150000,'available','standard_gas','Midtown','Vancouver');
insert into vehicle values (111143,'Toyota','Corolla',2011,'red',150000,'available','standard_hybrid','Midtown','Vancouver');
insert into vehicle values (111144,'Chevrolet','Impala',2011,'red',150000,'available','fullsize_electric','Midtown','Vancouver');
insert into vehicle values (111145,'Ford','Taurus',2011,'green marble',150000,'available','fullsize_gas','Midtown','Vancouver');
insert into vehicle values (111146,'Nissan','Altima',2011,'purple',135000,'available','fullsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111147,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_electric','Midtown','Vancouver');
insert into vehicle values (111148,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_gas','Midtown','Vancouver');
insert into vehicle values (111149,'Chevrolet','Tahoe',2013,'black',135000,'available','suv_hybrid','Midtown','Vancouver');
insert into vehicle values (111150,'Nissan','Frontier',2013,'black',67000,'available','truck_electric','Midtown','Vancouver');
insert into vehicle values (111151,'Ford','F150',2013,'black',48000,'available','truck_gas','Midtown','Vancouver');
insert into vehicle values (111152,'Ford','F150',2013,'black',48500,'available','truck_hybrid','Midtown','Vancouver');
insert into vehicle values (111153,'Chevrolet','Aveo',2013,'black',99000,'available','economy_electric','Downtown','Burnaby');
insert into vehicle values (111154,'Chevrolet','Aveo',2013,'black',34000,'available','economy_gas','Downtown','Burnaby');
insert into vehicle values (111155,'Chevrolet','Aveo',2019,'black',20000,'available','economy_hybrid','Downtown','Burnaby');
insert into vehicle values (111156,'Kia','Forte',2019,'white',50000,'available','compact_electric','Downtown','Burnaby');
insert into vehicle values (111157,'Honda','Civic',2017,'white',35000,'available','compact_gas','Downtown','Burnaby');
insert into vehicle values (111158,'Mazda','Mazda3',2017,'white',35000,'available','compact_hybrid','Downtown','Burnaby');
insert into vehicle values (111159,'Dodge','Avenger',2017,'white',35000,'available','midsize_electric','Downtown','Burnaby');
insert into vehicle values (111160,'Dodge','Avenger',2017,'white',35000,'available','midsize_gas','Downtown','Burnaby');
insert into vehicle values (111161,'Dodge','Avenger',2017,'white',35000,'available','midsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111162,'Toyota','Corolla',2017,'blue',35000,'available','standard_electric','Downtown','Burnaby');
insert into vehicle values (111163,'Toyota','Corolla',2010,'blue',100000,'available','standard_gas','Downtown','Burnaby');
insert into vehicle values (111164,'Toyota','Corolla',2010,'blue',100000,'available','standard_hybrid','Downtown','Burnaby');
insert into vehicle values (111165,'Nissan','Armada',2010,'blue',100000,'available','fullsize_electric','Downtown','Burnaby');
insert into vehicle values (111166,'Nissan','Armada',2010,'blue',100000,'available','fullsize_gas','Downtown','Burnaby');
insert into vehicle values (111167,'Nissan','Armada',2010,'blue',100000,'available','fullsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111168,'Ford','Escape',2012,'blue',100000,'available','suv_electric','Downtown','Burnaby');
insert into vehicle values (111169,'Toyota','Rav4',2012,'yellow',100000,'available','suv_gas','Downtown','Burnaby');
insert into vehicle values (111170,'Nissan','Armada',2018,'pink',40000,'available','suv_hybrid','Downtown','Burnaby');
insert into vehicle values (111171,'Ford','F150',2012,'ochre',140000,'available','truck_electric','Downtown','Burnaby');
insert into vehicle values (111172,'Nissan','Frontier',2012,'violet',140000,'available','truck_gas','Downtown','Burnaby');
insert into vehicle values (111173,'Nissan','Frontier',2012,'black',140000,'available','truck_hybrid','Downtown','Burnaby');
insert into vehicle values (111174,'Hyundai','Accent',2013,'black',140000,'available','economy_electric','Midtown','Burnaby');
insert into vehicle values (111175,'Hyundai','Accent',2013,'black',80000,'available','economy_gas','Midtown','Burnaby');
insert into vehicle values (111176,'Hyundai','Accent',2013,'black',90000,'available','economy_hybrid','Midtown','Burnaby');
insert into vehicle values (111177,'Mazda','Mazda3',2013,'black',400000,'available','compact_electric','Midtown','Burnaby');
insert into vehicle values (111178,'Kia','Forte',2013,'black',120000,'available','compact_gas','Midtown','Burnaby');
insert into vehicle values (111179,'Chevrolet','Cobalt',2013,'black',120000,'available','compact_hybrid','Midtown','Burnaby');
insert into vehicle values (111180,'Toyota','Corolla',2016,'black',50000,'available','midsize_electric','Midtown','Burnaby');
insert into vehicle values (111181,'Dodge','Avenger',2015,'black',70000,'available','midsize_gas','Midtown','Burnaby');
insert into vehicle values (111182,'Ford','Focus',2010,'black',200000,'available','midsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111183,'Toyota','Corolla',2011,'black',200000,'available','standard_electric','Midtown','Burnaby');
insert into vehicle values (111184,'Toyota','Corolla',2017,'black',40000,'available','standard_gas','Midtown','Burnaby');
insert into vehicle values (111185,'Toyota','Corolla',2017,'black',45000,'available','standard_hybrid','Midtown','Burnaby');
insert into vehicle values (111186,'Ford','Fusion',2017,'black',45000,'available','fullsize_electric','Midtown','Burnaby');
insert into vehicle values (111187,'Dodge','Charger',2017,'green',45000,'available','fullsize_gas','Midtown','Burnaby');
insert into vehicle values (111188,'Chevrolet','Impala',2017,'blue',45000,'available','fullsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111189,'Toyota','Rav4',2017,'blue',45000,'available','suv_electric','Midtown','Burnaby');
insert into vehicle values (111190,'Toyota','Rav5',2017,'blue',45000,'available','suv_gas','Midtown','Burnaby');
insert into vehicle values (111191,'Toyota','Rav6',2017,'blue',45000,'available','suv_hybrid','Midtown','Burnaby');
insert into vehicle values (111192,'Nissan','Frontier',2017,'blue',45000,'available','truck_electric','Midtown','Burnaby');
insert into vehicle values (111193,'Nissan','Frontier',2010,'brown',180000,'available','truck_gas','Midtown','Burnaby');
insert into vehicle values (111194,'Nissan','Frontier',2010,'brown',180000,'available','truck_hybrid','Midtown','Burnaby');
insert into vehicle values (111195,'Chevrolet','Spark',2010,'brown',180000,'available','economy_electric','Downtown','Surrey');
insert into vehicle values (111196,'Hyundai','Accent',2010,'brown',180000,'available','economy_gas','Downtown','Surrey');
insert into vehicle values (111197,'Hyundai','Accent',2010,'brown',180000,'available','economy_hybrid','Downtown','Surrey');
insert into vehicle values (111198,'Hyundai','Veloster',2010,'red',180000,'available','compact_electric','Downtown','Surrey');
insert into vehicle values (111199,'Ford','Focus',2010,'red',180000,'available','compact_gas','Downtown','Surrey');
insert into vehicle values (111200,'Hyundai','Elantra',2010,'red',180000,'available','compact_hybrid','Downtown','Surrey');
insert into vehicle values (111201,'Toyota','Corolla',2010,'grey',180000,'available','midsize_electric','Downtown','Surrey');
insert into vehicle values (111202,'Toyota','Corolla',2010,'grey',180000,'available','midsize_gas','Downtown','Surrey');
insert into vehicle values (111203,'Toyota','Corolla',2010,'blue',180000,'available','midsize_hybrid','Downtown','Surrey');
insert into vehicle values (111204,'Toyota','Corolla',2012,'white',75000,'available','standard_electric','Downtown','Surrey');
insert into vehicle values (111205,'Toyota','Corolla',2012,'black',75000,'available','standard_gas','Downtown','Surrey');
insert into vehicle values (111206,'Toyota','Corolla',2012,'white',75000,'available','standard_hybrid','Downtown','Surrey');
insert into vehicle values (111207,'Ford','Taurus',2012,'white',85000,'available','fullsize_electric','Downtown','Surrey');
insert into vehicle values (111208,'Ford','Taurus',2012,'red',85000,'available','fullsize_gas','Downtown','Surrey');
insert into vehicle values (111209,'Ford','Taurus',2012,'pink',45000,'available','fullsize_hybrid','Downtown','Surrey');
insert into vehicle values (111210,'Ford','Edge',2012,'baby blue',55000,'available','suv_electric','Downtown','Surrey');
insert into vehicle values (111211,'Ford','Edge',2012,'silver',90000,'available','suv_gas','Downtown','Surrey');
insert into vehicle values (111212,'Ford','Edge',2012,'silver',90000,'available','suv_hybrid','Downtown','Surrey');
insert into vehicle values (111213,'Nissan','Frontier',2012,'silver',90000,'available','truck_electric','Downtown','Surrey');
insert into vehicle values (111214,'Nissan','Frontier',2018,'silver',15000,'available','truck_gas','Downtown','Surrey');
insert into vehicle values (111215,'Nissan','Frontier',2018,'silver',40000,'available','truck_hybrid','Downtown','Surrey');
insert into vehicle values (111216,'Chevrolet','Aveo',2018,'silver',40000,'available','economy_electric','Midtown','Surrey');
insert into vehicle values (111217,'Chevrolet','Aveo',2018,'light brown',25000,'available','economy_gas','Midtown','Surrey');
insert into vehicle values (111218,'Chevrolet','Aveo',2018,'bright red',10000,'available','economy_hybrid','Midtown','Surrey');
insert into vehicle values (111219,'Hyundai','Elantra',2018,'gold',18000,'available','compact_electric','Midtown','Surrey');
insert into vehicle values (111220,'Volkswagen ','GTI',2018,'white',18000,'available','compact_gas','Midtown','Surrey');
insert into vehicle values (111221,'Subaru ','Impreza',2018,'white',18000,'available','compact_hybrid','Midtown','Surrey');
insert into vehicle values (111222,'Dodge','Avenger',2018,'white',18000,'available','midsize_electric','Midtown','Surrey');
insert into vehicle values (111223,'Dodge','Avenger',2018,'white',18000,'available','midsize_gas','Midtown','Surrey');
insert into vehicle values (111224,'Dodge','Avenger',2018,'white',18000,'available','midsize_hybrid','Midtown','Surrey');
insert into vehicle values (111225,'Toyota','Corolla',2018,'white',18000,'available','standard_electric','Midtown','Surrey');
insert into vehicle values (111226,'Toyota','Corolla',2019,'white',10000,'available','standard_gas','Midtown','Surrey');
insert into vehicle values (111227,'Toyota','Corolla',2010,'white',150000,'available','standard_hybrid','Midtown','Surrey');
insert into vehicle values (111228,'Dodge','Charger',2010,'black',160000,'available','fullsize_electric','Midtown','Surrey');
insert into vehicle values (111229,'Dodge','Charger',2010,'black',130000,'available','fullsize_gas','Midtown','Surrey');
insert into vehicle values (111230,'Dodge','Charger',2010,'black',120000,'available','fullsize_hybrid','Midtown','Surrey');
insert into vehicle values (111231,'Jeep','Cherokee',2010,'black',150000,'available','suv_electric','Midtown','Surrey');
insert into vehicle values (111232,'Jeep','Cherokee',2010,'black',150000,'available','suv_gas','Midtown','Surrey');
insert into vehicle values (111233,'Jeep','Cherokee',2010,'dark grey',150000,'available','suv_hybrid','Midtown','Surrey');
insert into vehicle values (111234,'Nissan','Frontier',2010,'red',150000,'available','truck_electric','Midtown','Surrey');
insert into vehicle values (111235,'Nissan','Frontier',2010,'black',150000,'available','truck_gas','Midtown','Surrey');
insert into vehicle values (111236,'Nissan','Frontier',2010,'black',150000,'available','truck_hybrid','Midtown','Surrey');
insert into vehicle values (111237,'Toyota','Prius',2015,'blue',80000,'available','economy_electric','Downtown','Vancouver');
insert into vehicle values (111238,'Kia','Niro',2016,'white',22000,'available','economy_gas','Downtown','Vancouver');
insert into vehicle values (111239,'Toyota','Prius',2016,'blue',35500,'available','economy_hybrid','Downtown','Vancouver');
insert into vehicle values (111240,'Kia','Forte',2016,'purple',35500,'available','compact_electric','Downtown','Vancouver');
insert into vehicle values (111241,'Honda','Civic',2016,'red',35500,'available','compact_gas','Downtown','Vancouver');
insert into vehicle values (111242,'Honda','Civic',2010,'red',200000,'available','compact_hybrid','Downtown','Vancouver');
insert into vehicle values (111243,'Nissan','Sentra',2010,'blue',200000,'available','midsize_electric','Downtown','Vancouver');
insert into vehicle values (111244,'Ford','Focus',2010,'blue',200000,'available','midsize_gas','Downtown','Vancouver');
insert into vehicle values (111245,'Ford','Focus',2010,'blue',200000,'available','midsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111246,'Toyota','Corolla',2012,'blue',150000,'available','standard_electric','Downtown','Vancouver');
insert into vehicle values (111247,'Toyota','Corolla',2014,'blue',100000,'available','standard_gas','Downtown','Vancouver');
insert into vehicle values (111248,'Toyota','Corolla',2015,'blue',68000,'available','standard_hybrid','Downtown','Vancouver');
insert into vehicle values (111249,'Ford','Fusion',2015,'white',73000,'available','fullsize_electric','Downtown','Vancouver');
insert into vehicle values (111250,'Nissan','Altima',2015,'black',59000,'available','fullsize_gas','Downtown','Vancouver');
insert into vehicle values (111251,'Nissan','Altima',2015,'brick orange',33000,'available','fullsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111252,'Toyota','Rav4',2015,'white',80000,'available','suv_electric','Downtown','Vancouver');
insert into vehicle values (111253,'Ford','Edge',2015,'yellow',15000,'available','suv_gas','Downtown','Vancouver');
insert into vehicle values (111254,'Ford','Edge',2015,'brown',56500,'available','suv_hybrid','Downtown','Vancouver');
insert into vehicle values (111255,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_electric','Downtown','Vancouver');
insert into vehicle values (111256,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_gas','Downtown','Vancouver');
insert into vehicle values (111257,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_hybrid','Downtown','Vancouver');
insert into vehicle values (111258,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_electric','Midtown','Vancouver');
insert into vehicle values (111259,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_gas','Midtown','Vancouver');
insert into vehicle values (111260,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_hybrid','Midtown','Vancouver');
insert into vehicle values (111261,'Hyundai','Elantra',2019,'metallic grey',12500,'available','compact_electric','Midtown','Vancouver');
insert into vehicle values (111262,'Hyundai','Veloster',2019,'metallic grey',11500,'available','compact_gas','Midtown','Vancouver');
insert into vehicle values (111263,'Volkswagen ','GTI',2019,'metallic grey',18000,'available','compact_hybrid','Midtown','Vancouver');
insert into vehicle values (111264,'Toyota','Corolla',2019,'red',5000,'available','midsize_electric','Midtown','Vancouver');
insert into vehicle values (111265,'Ford','Focus',2019,'red',7800,'available','midsize_gas','Midtown','Vancouver');
insert into vehicle values (111266,'Ford','Focus',2011,'red',64500,'available','midsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111267,'Toyota','Corolla',2011,'red',146000,'available','standard_electric','Midtown','Vancouver');
insert into vehicle values (111268,'Toyota','Corolla',2011,'red',150000,'available','standard_gas','Midtown','Vancouver');
insert into vehicle values (111269,'Toyota','Corolla',2011,'red',150000,'available','standard_hybrid','Midtown','Vancouver');
insert into vehicle values (111270,'Chevrolet','Impala',2011,'red',150000,'available','fullsize_electric','Midtown','Vancouver');
insert into vehicle values (111271,'Ford','Taurus',2011,'green marble',150000,'available','fullsize_gas','Midtown','Vancouver');
insert into vehicle values (111272,'Nissan','Altima',2011,'purple',135000,'available','fullsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111273,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_electric','Midtown','Vancouver');
insert into vehicle values (111274,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_gas','Midtown','Vancouver');
insert into vehicle values (111275,'Chevrolet','Tahoe',2013,'black',135000,'available','suv_hybrid','Midtown','Vancouver');
insert into vehicle values (111276,'Nissan','Frontier',2013,'black',67000,'available','truck_electric','Midtown','Vancouver');
insert into vehicle values (111277,'Ford','F150',2013,'black',48000,'available','truck_gas','Midtown','Vancouver');
insert into vehicle values (111278,'Ford','F150',2013,'black',48500,'available','truck_hybrid','Midtown','Vancouver');
insert into vehicle values (111279,'Chevrolet','Aveo',2013,'black',99000,'available','economy_electric','Downtown','Burnaby');
insert into vehicle values (111280,'Chevrolet','Aveo',2013,'black',34000,'available','economy_gas','Downtown','Burnaby');
insert into vehicle values (111281,'Chevrolet','Aveo',2019,'black',20000,'available','economy_hybrid','Downtown','Burnaby');
insert into vehicle values (111282,'Kia','Forte',2019,'white',50000,'available','compact_electric','Downtown','Burnaby');
insert into vehicle values (111283,'Honda','Civic',2017,'white',35000,'available','compact_gas','Downtown','Burnaby');
insert into vehicle values (111284,'Mazda','Mazda3',2017,'white',35000,'available','compact_hybrid','Downtown','Burnaby');
insert into vehicle values (111285,'Dodge','Avenger',2017,'white',35000,'available','midsize_electric','Downtown','Burnaby');
insert into vehicle values (111286,'Dodge','Avenger',2017,'white',35000,'available','midsize_gas','Downtown','Burnaby');
insert into vehicle values (111287,'Dodge','Avenger',2017,'white',35000,'available','midsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111288,'Toyota','Corolla',2017,'blue',35000,'available','standard_electric','Downtown','Burnaby');
insert into vehicle values (111289,'Toyota','Corolla',2010,'blue',100000,'available','standard_gas','Downtown','Burnaby');
insert into vehicle values (111290,'Toyota','Corolla',2010,'blue',100000,'available','standard_hybrid','Downtown','Burnaby');
insert into vehicle values (111291,'Nissan','Armada',2010,'blue',100000,'available','fullsize_electric','Downtown','Burnaby');
insert into vehicle values (111292,'Nissan','Armada',2010,'blue',100000,'available','fullsize_gas','Downtown','Burnaby');
insert into vehicle values (111293,'Nissan','Armada',2010,'blue',100000,'available','fullsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111294,'Ford','Escape',2012,'blue',100000,'available','suv_electric','Downtown','Burnaby');
insert into vehicle values (111295,'Toyota','Rav4',2012,'yellow',100000,'available','suv_gas','Downtown','Burnaby');
insert into vehicle values (111296,'Nissan','Armada',2018,'pink',40000,'available','suv_hybrid','Downtown','Burnaby');
insert into vehicle values (111297,'Ford','F150',2012,'ochre',140000,'available','truck_electric','Downtown','Burnaby');
insert into vehicle values (111298,'Nissan','Frontier',2012,'violet',140000,'available','truck_gas','Downtown','Burnaby');
insert into vehicle values (111299,'Nissan','Frontier',2012,'black',140000,'available','truck_hybrid','Downtown','Burnaby');
insert into vehicle values (111300,'Hyundai','Accent',2013,'black',140000,'available','economy_electric','Midtown','Burnaby');
insert into vehicle values (111301,'Hyundai','Accent',2013,'black',80000,'available','economy_gas','Midtown','Burnaby');
insert into vehicle values (111302,'Hyundai','Accent',2013,'black',90000,'available','economy_hybrid','Midtown','Burnaby');
insert into vehicle values (111303,'Mazda','Mazda3',2013,'black',400000,'available','compact_electric','Midtown','Burnaby');
insert into vehicle values (111304,'Kia','Forte',2013,'black',120000,'available','compact_gas','Midtown','Burnaby');
insert into vehicle values (111305,'Chevrolet','Cobalt',2013,'black',120000,'available','compact_hybrid','Midtown','Burnaby');
insert into vehicle values (111306,'Toyota','Corolla',2016,'black',50000,'available','midsize_electric','Midtown','Burnaby');
insert into vehicle values (111307,'Dodge','Avenger',2015,'black',70000,'available','midsize_gas','Midtown','Burnaby');
insert into vehicle values (111308,'Ford','Focus',2010,'black',200000,'available','midsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111309,'Toyota','Corolla',2011,'black',200000,'available','standard_electric','Midtown','Burnaby');
insert into vehicle values (111310,'Toyota','Corolla',2017,'black',40000,'available','standard_gas','Midtown','Burnaby');
insert into vehicle values (111311,'Toyota','Corolla',2017,'black',45000,'available','standard_hybrid','Midtown','Burnaby');
insert into vehicle values (111312,'Ford','Fusion',2017,'black',45000,'available','fullsize_electric','Midtown','Burnaby');
insert into vehicle values (111313,'Dodge','Charger',2017,'green',45000,'available','fullsize_gas','Midtown','Burnaby');
insert into vehicle values (111314,'Chevrolet','Impala',2017,'blue',45000,'available','fullsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111315,'Toyota','Rav4',2017,'blue',45000,'available','suv_electric','Midtown','Burnaby');
insert into vehicle values (111316,'Toyota','Rav5',2017,'blue',45000,'available','suv_gas','Midtown','Burnaby');
insert into vehicle values (111317,'Toyota','Rav6',2017,'blue',45000,'available','suv_hybrid','Midtown','Burnaby');
insert into vehicle values (111318,'Nissan','Frontier',2017,'blue',45000,'available','truck_electric','Midtown','Burnaby');
insert into vehicle values (111319,'Nissan','Frontier',2010,'brown',180000,'available','truck_gas','Midtown','Burnaby');
insert into vehicle values (111320,'Nissan','Frontier',2010,'brown',180000,'available','truck_hybrid','Midtown','Burnaby');
insert into vehicle values (111321,'Chevrolet','Spark',2010,'brown',180000,'available','economy_electric','Downtown','Surrey');
insert into vehicle values (111322,'Hyundai','Accent',2010,'brown',180000,'available','economy_gas','Downtown','Surrey');
insert into vehicle values (111323,'Hyundai','Accent',2010,'brown',180000,'available','economy_hybrid','Downtown','Surrey');
insert into vehicle values (111324,'Hyundai','Veloster',2010,'red',180000,'available','compact_electric','Downtown','Surrey');
insert into vehicle values (111325,'Ford','Focus',2010,'red',180000,'available','compact_gas','Downtown','Surrey');
insert into vehicle values (111326,'Hyundai','Elantra',2010,'red',180000,'available','compact_hybrid','Downtown','Surrey');
insert into vehicle values (111327,'Toyota','Corolla',2010,'grey',180000,'available','midsize_electric','Downtown','Surrey');
insert into vehicle values (111328,'Toyota','Corolla',2010,'grey',180000,'available','midsize_gas','Downtown','Surrey');
insert into vehicle values (111329,'Toyota','Corolla',2010,'blue',180000,'available','midsize_hybrid','Downtown','Surrey');
insert into vehicle values (111330,'Toyota','Corolla',2012,'white',75000,'available','standard_electric','Downtown','Surrey');
insert into vehicle values (111331,'Toyota','Corolla',2012,'black',75000,'available','standard_gas','Downtown','Surrey');
insert into vehicle values (111332,'Toyota','Corolla',2012,'white',75000,'available','standard_hybrid','Downtown','Surrey');
insert into vehicle values (111333,'Ford','Taurus',2012,'white',85000,'available','fullsize_electric','Downtown','Surrey');
insert into vehicle values (111334,'Ford','Taurus',2012,'red',85000,'available','fullsize_gas','Downtown','Surrey');
insert into vehicle values (111335,'Ford','Taurus',2012,'pink',45000,'available','fullsize_hybrid','Downtown','Surrey');
insert into vehicle values (111336,'Ford','Edge',2012,'baby blue',55000,'available','suv_electric','Downtown','Surrey');
insert into vehicle values (111337,'Ford','Edge',2012,'silver',90000,'available','suv_gas','Downtown','Surrey');
insert into vehicle values (111338,'Ford','Edge',2012,'silver',90000,'available','suv_hybrid','Downtown','Surrey');
insert into vehicle values (111339,'Nissan','Frontier',2012,'silver',90000,'available','truck_electric','Downtown','Surrey');
insert into vehicle values (111340,'Nissan','Frontier',2018,'silver',15000,'available','truck_gas','Downtown','Surrey');
insert into vehicle values (111341,'Nissan','Frontier',2018,'silver',40000,'available','truck_hybrid','Downtown','Surrey');
insert into vehicle values (111342,'Chevrolet','Aveo',2018,'silver',40000,'available','economy_electric','Midtown','Surrey');
insert into vehicle values (111343,'Chevrolet','Aveo',2018,'light brown',25000,'available','economy_gas','Midtown','Surrey');
insert into vehicle values (111344,'Chevrolet','Aveo',2018,'bright red',10000,'available','economy_hybrid','Midtown','Surrey');
insert into vehicle values (111345,'Hyundai','Elantra',2018,'gold',18000,'available','compact_electric','Midtown','Surrey');
insert into vehicle values (111346,'Volkswagen ','GTI',2018,'white',18000,'available','compact_gas','Midtown','Surrey');
insert into vehicle values (111347,'Subaru ','Impreza',2018,'white',18000,'available','compact_hybrid','Midtown','Surrey');
insert into vehicle values (111348,'Dodge','Avenger',2018,'white',18000,'available','midsize_electric','Midtown','Surrey');
insert into vehicle values (111349,'Dodge','Avenger',2018,'white',18000,'available','midsize_gas','Midtown','Surrey');
insert into vehicle values (111350,'Dodge','Avenger',2018,'white',18000,'available','midsize_hybrid','Midtown','Surrey');
insert into vehicle values (111351,'Toyota','Corolla',2018,'white',18000,'available','standard_electric','Midtown','Surrey');
insert into vehicle values (111352,'Toyota','Corolla',2019,'white',10000,'available','standard_gas','Midtown','Surrey');
insert into vehicle values (111353,'Toyota','Corolla',2010,'white',150000,'available','standard_hybrid','Midtown','Surrey');
insert into vehicle values (111354,'Dodge','Charger',2010,'black',160000,'available','fullsize_electric','Midtown','Surrey');
insert into vehicle values (111355,'Dodge','Charger',2010,'black',130000,'available','fullsize_gas','Midtown','Surrey');
insert into vehicle values (111356,'Dodge','Charger',2010,'black',120000,'available','fullsize_hybrid','Midtown','Surrey');
insert into vehicle values (111357,'Jeep','Cherokee',2010,'black',150000,'available','suv_electric','Midtown','Surrey');
insert into vehicle values (111358,'Jeep','Cherokee',2010,'black',150000,'available','suv_gas','Midtown','Surrey');
insert into vehicle values (111359,'Jeep','Cherokee',2010,'dark grey',150000,'available','suv_hybrid','Midtown','Surrey');
insert into vehicle values (111360,'Nissan','Frontier',2010,'red',150000,'available','truck_electric','Midtown','Surrey');
insert into vehicle values (111361,'Nissan','Frontier',2010,'black',150000,'available','truck_gas','Midtown','Surrey');
insert into vehicle values (111362,'Nissan','Frontier',2010,'black',150000,'available','truck_hybrid','Midtown','Surrey');
insert into vehicle values (111363,'Toyota','Prius',2015,'blue',80000,'available','economy_electric','Downtown','Vancouver');
insert into vehicle values (111364,'Kia','Niro',2016,'white',22000,'available','economy_gas','Downtown','Vancouver');
insert into vehicle values (111365,'Toyota','Prius',2016,'blue',35500,'available','economy_hybrid','Downtown','Vancouver');
insert into vehicle values (111366,'Kia','Forte',2016,'purple',35500,'available','compact_electric','Downtown','Vancouver');
insert into vehicle values (111367,'Honda','Civic',2016,'red',35500,'available','compact_gas','Downtown','Vancouver');
insert into vehicle values (111368,'Honda','Civic',2010,'red',200000,'available','compact_hybrid','Downtown','Vancouver');
insert into vehicle values (111369,'Nissan','Sentra',2010,'blue',200000,'available','midsize_electric','Downtown','Vancouver');
insert into vehicle values (111370,'Ford','Focus',2010,'blue',200000,'available','midsize_gas','Downtown','Vancouver');
insert into vehicle values (111371,'Ford','Focus',2010,'blue',200000,'available','midsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111372,'Toyota','Corolla',2012,'blue',150000,'available','standard_electric','Downtown','Vancouver');
insert into vehicle values (111373,'Toyota','Corolla',2014,'blue',100000,'available','standard_gas','Downtown','Vancouver');
insert into vehicle values (111374,'Toyota','Corolla',2015,'blue',68000,'available','standard_hybrid','Downtown','Vancouver');
insert into vehicle values (111375,'Ford','Fusion',2015,'white',73000,'available','fullsize_electric','Downtown','Vancouver');
insert into vehicle values (111376,'Nissan','Altima',2015,'black',59000,'available','fullsize_gas','Downtown','Vancouver');
insert into vehicle values (111377,'Nissan','Altima',2015,'brick orange',33000,'available','fullsize_hybrid','Downtown','Vancouver');
insert into vehicle values (111378,'Toyota','Rav4',2015,'white',80000,'available','suv_electric','Downtown','Vancouver');
insert into vehicle values (111379,'Ford','Edge',2015,'yellow',15000,'available','suv_gas','Downtown','Vancouver');
insert into vehicle values (111380,'Ford','Edge',2015,'brown',56500,'available','suv_hybrid','Downtown','Vancouver');
insert into vehicle values (111381,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_electric','Downtown','Vancouver');
insert into vehicle values (111382,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_gas','Downtown','Vancouver');
insert into vehicle values (111383,'Nissan','Frontier',2015,'metallic grey',75000,'available','truck_hybrid','Downtown','Vancouver');
insert into vehicle values (111384,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_electric','Midtown','Vancouver');
insert into vehicle values (111385,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_gas','Midtown','Vancouver');
insert into vehicle values (111386,'Chevrolet','Aveo',2015,'metallic grey',75000,'available','economy_hybrid','Midtown','Vancouver');
insert into vehicle values (111387,'Hyundai','Elantra',2019,'metallic grey',12500,'available','compact_electric','Midtown','Vancouver');
insert into vehicle values (111388,'Hyundai','Veloster',2019,'metallic grey',11500,'available','compact_gas','Midtown','Vancouver');
insert into vehicle values (111389,'Volkswagen ','GTI',2019,'metallic grey',18000,'available','compact_hybrid','Midtown','Vancouver');
insert into vehicle values (111390,'Toyota','Corolla',2019,'red',5000,'available','midsize_electric','Midtown','Vancouver');
insert into vehicle values (111391,'Ford','Focus',2019,'red',7800,'available','midsize_gas','Midtown','Vancouver');
insert into vehicle values (111392,'Ford','Focus',2011,'red',64500,'available','midsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111393,'Toyota','Corolla',2011,'red',146000,'available','standard_electric','Midtown','Vancouver');
insert into vehicle values (111394,'Toyota','Corolla',2011,'red',150000,'available','standard_gas','Midtown','Vancouver');
insert into vehicle values (111395,'Toyota','Corolla',2011,'red',150000,'available','standard_hybrid','Midtown','Vancouver');
insert into vehicle values (111396,'Chevrolet','Impala',2011,'red',150000,'available','fullsize_electric','Midtown','Vancouver');
insert into vehicle values (111397,'Ford','Taurus',2011,'green marble',150000,'available','fullsize_gas','Midtown','Vancouver');
insert into vehicle values (111398,'Nissan','Altima',2011,'purple',135000,'available','fullsize_hybrid','Midtown','Vancouver');
insert into vehicle values (111399,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_electric','Midtown','Vancouver');
insert into vehicle values (111400,'Chevrolet','Tahoe',2013,'grey',135000,'available','suv_gas','Midtown','Vancouver');
insert into vehicle values (111401,'Chevrolet','Tahoe',2013,'black',135000,'available','suv_hybrid','Midtown','Vancouver');
insert into vehicle values (111402,'Nissan','Frontier',2013,'black',67000,'available','truck_electric','Midtown','Vancouver');
insert into vehicle values (111403,'Ford','F150',2013,'black',48000,'available','truck_gas','Midtown','Vancouver');
insert into vehicle values (111404,'Ford','F150',2013,'black',48500,'available','truck_hybrid','Midtown','Vancouver');
insert into vehicle values (111405,'Chevrolet','Aveo',2013,'black',99000,'available','economy_electric','Downtown','Burnaby');
insert into vehicle values (111406,'Chevrolet','Aveo',2013,'black',34000,'available','economy_gas','Downtown','Burnaby');
insert into vehicle values (111407,'Chevrolet','Aveo',2019,'black',20000,'available','economy_hybrid','Downtown','Burnaby');
insert into vehicle values (111408,'Kia','Forte',2019,'white',50000,'available','compact_electric','Downtown','Burnaby');
insert into vehicle values (111409,'Honda','Civic',2017,'white',35000,'available','compact_gas','Downtown','Burnaby');
insert into vehicle values (111410,'Mazda','Mazda3',2017,'white',35000,'available','compact_hybrid','Downtown','Burnaby');
insert into vehicle values (111411,'Dodge','Avenger',2017,'white',35000,'available','midsize_electric','Downtown','Burnaby');
insert into vehicle values (111412,'Dodge','Avenger',2017,'white',35000,'available','midsize_gas','Downtown','Burnaby');
insert into vehicle values (111413,'Dodge','Avenger',2017,'white',35000,'available','midsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111414,'Toyota','Corolla',2017,'blue',35000,'available','standard_electric','Downtown','Burnaby');
insert into vehicle values (111415,'Toyota','Corolla',2010,'blue',100000,'available','standard_gas','Downtown','Burnaby');
insert into vehicle values (111416,'Toyota','Corolla',2010,'blue',100000,'available','standard_hybrid','Downtown','Burnaby');
insert into vehicle values (111417,'Nissan','Armada',2010,'blue',100000,'available','fullsize_electric','Downtown','Burnaby');
insert into vehicle values (111418,'Nissan','Armada',2010,'blue',100000,'available','fullsize_gas','Downtown','Burnaby');
insert into vehicle values (111419,'Nissan','Armada',2010,'blue',100000,'available','fullsize_hybrid','Downtown','Burnaby');
insert into vehicle values (111420,'Ford','Escape',2012,'blue',100000,'available','suv_electric','Downtown','Burnaby');
insert into vehicle values (111421,'Toyota','Rav4',2012,'yellow',100000,'available','suv_gas','Downtown','Burnaby');
insert into vehicle values (111422,'Nissan','Armada',2018,'pink',40000,'available','suv_hybrid','Downtown','Burnaby');
insert into vehicle values (111423,'Ford','F150',2012,'ochre',140000,'available','truck_electric','Downtown','Burnaby');
insert into vehicle values (111424,'Nissan','Frontier',2012,'violet',140000,'available','truck_gas','Downtown','Burnaby');
insert into vehicle values (111425,'Nissan','Frontier',2012,'black',140000,'available','truck_hybrid','Downtown','Burnaby');
insert into vehicle values (111426,'Hyundai','Accent',2013,'black',140000,'available','economy_electric','Midtown','Burnaby');
insert into vehicle values (111427,'Hyundai','Accent',2013,'black',80000,'available','economy_gas','Midtown','Burnaby');
insert into vehicle values (111428,'Hyundai','Accent',2013,'black',90000,'available','economy_hybrid','Midtown','Burnaby');
insert into vehicle values (111429,'Mazda','Mazda3',2013,'black',400000,'available','compact_electric','Midtown','Burnaby');
insert into vehicle values (111430,'Kia','Forte',2013,'black',120000,'available','compact_gas','Midtown','Burnaby');
insert into vehicle values (111431,'Chevrolet','Cobalt',2013,'black',120000,'available','compact_hybrid','Midtown','Burnaby');
insert into vehicle values (111432,'Toyota','Corolla',2016,'black',50000,'available','midsize_electric','Midtown','Burnaby');
insert into vehicle values (111433,'Dodge','Avenger',2015,'black',70000,'available','midsize_gas','Midtown','Burnaby');
insert into vehicle values (111434,'Ford','Focus',2010,'black',200000,'available','midsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111435,'Toyota','Corolla',2011,'black',200000,'available','standard_electric','Midtown','Burnaby');
insert into vehicle values (111436,'Toyota','Corolla',2017,'black',40000,'available','standard_gas','Midtown','Burnaby');
insert into vehicle values (111437,'Toyota','Corolla',2017,'black',45000,'available','standard_hybrid','Midtown','Burnaby');
insert into vehicle values (111438,'Ford','Fusion',2017,'black',45000,'available','fullsize_electric','Midtown','Burnaby');
insert into vehicle values (111439,'Dodge','Charger',2017,'green',45000,'available','fullsize_gas','Midtown','Burnaby');
insert into vehicle values (111440,'Chevrolet','Impala',2017,'blue',45000,'available','fullsize_hybrid','Midtown','Burnaby');
insert into vehicle values (111441,'Toyota','Rav4',2017,'blue',45000,'available','suv_electric','Midtown','Burnaby');
insert into vehicle values (111442,'Toyota','Rav5',2017,'blue',45000,'available','suv_gas','Midtown','Burnaby');
insert into vehicle values (111443,'Toyota','Rav6',2017,'blue',45000,'available','suv_hybrid','Midtown','Burnaby');
insert into vehicle values (111444,'Nissan','Frontier',2017,'blue',45000,'available','truck_electric','Midtown','Burnaby');
insert into vehicle values (111445,'Nissan','Frontier',2010,'brown',180000,'available','truck_gas','Midtown','Burnaby');
insert into vehicle values (111446,'Nissan','Frontier',2010,'brown',180000,'available','truck_hybrid','Midtown','Burnaby');
insert into vehicle values (111447,'Chevrolet','Spark',2010,'brown',180000,'available','economy_electric','Downtown','Surrey');
insert into vehicle values (111448,'Hyundai','Accent',2010,'brown',180000,'available','economy_gas','Downtown','Surrey');
insert into vehicle values (111449,'Hyundai','Accent',2010,'brown',180000,'available','economy_hybrid','Downtown','Surrey');
insert into vehicle values (111450,'Hyundai','Veloster',2010,'red',180000,'available','compact_electric','Downtown','Surrey');
insert into vehicle values (111451,'Ford','Focus',2010,'red',180000,'available','compact_gas','Downtown','Surrey');
insert into vehicle values (111452,'Hyundai','Elantra',2010,'red',180000,'available','compact_hybrid','Downtown','Surrey');
insert into vehicle values (111453,'Toyota','Corolla',2010,'grey',180000,'available','midsize_electric','Downtown','Surrey');
insert into vehicle values (111454,'Toyota','Corolla',2010,'grey',180000,'available','midsize_gas','Downtown','Surrey');
insert into vehicle values (111455,'Toyota','Corolla',2010,'blue',180000,'available','midsize_hybrid','Downtown','Surrey');
insert into vehicle values (111456,'Toyota','Corolla',2012,'white',75000,'available','standard_electric','Downtown','Surrey');
insert into vehicle values (111457,'Toyota','Corolla',2012,'black',75000,'available','standard_gas','Downtown','Surrey');
insert into vehicle values (111458,'Toyota','Corolla',2012,'white',75000,'available','standard_hybrid','Downtown','Surrey');
insert into vehicle values (111459,'Ford','Taurus',2012,'white',85000,'available','fullsize_electric','Downtown','Surrey');
insert into vehicle values (111460,'Ford','Taurus',2012,'red',85000,'available','fullsize_gas','Downtown','Surrey');
insert into vehicle values (111461,'Ford','Taurus',2012,'pink',45000,'available','fullsize_hybrid','Downtown','Surrey');
insert into vehicle values (111462,'Ford','Edge',2012,'baby blue',55000,'available','suv_electric','Downtown','Surrey');
insert into vehicle values (111463,'Ford','Edge',2012,'silver',90000,'available','suv_gas','Downtown','Surrey');
insert into vehicle values (111464,'Ford','Edge',2012,'silver',90000,'available','suv_hybrid','Downtown','Surrey');
insert into vehicle values (111465,'Nissan','Frontier',2012,'silver',90000,'available','truck_electric','Downtown','Surrey');
insert into vehicle values (111466,'Nissan','Frontier',2018,'silver',15000,'available','truck_gas','Downtown','Surrey');
insert into vehicle values (111467,'Nissan','Frontier',2018,'silver',40000,'available','truck_hybrid','Downtown','Surrey');
insert into vehicle values (111468,'Chevrolet','Aveo',2018,'silver',40000,'available','economy_electric','Midtown','Surrey');
insert into vehicle values (111469,'Chevrolet','Aveo',2018,'light brown',25000,'available','economy_gas','Midtown','Surrey');
insert into vehicle values (111470,'Chevrolet','Aveo',2018,'bright red',10000,'available','economy_hybrid','Midtown','Surrey');
insert into vehicle values (111471,'Hyundai','Elantra',2018,'gold',18000,'available','compact_electric','Midtown','Surrey');
insert into vehicle values (111472,'Volkswagen ','GTI',2018,'white',18000,'available','compact_gas','Midtown','Surrey');
insert into vehicle values (111473,'Subaru ','Impreza',2018,'white',18000,'available','compact_hybrid','Midtown','Surrey');
insert into vehicle values (111474,'Dodge','Avenger',2018,'white',18000,'available','midsize_electric','Midtown','Surrey');
insert into vehicle values (111475,'Dodge','Avenger',2018,'white',18000,'available','midsize_gas','Midtown','Surrey');
insert into vehicle values (111476,'Dodge','Avenger',2018,'white',18000,'available','midsize_hybrid','Midtown','Surrey');
insert into vehicle values (111477,'Toyota','Corolla',2018,'white',18000,'available','standard_electric','Midtown','Surrey');
insert into vehicle values (111478,'Toyota','Corolla',2019,'white',10000,'available','standard_gas','Midtown','Surrey');
insert into vehicle values (111479,'Toyota','Corolla',2010,'white',150000,'available','standard_hybrid','Midtown','Surrey');
insert into vehicle values (111480,'Dodge','Charger',2010,'black',160000,'available','fullsize_electric','Midtown','Surrey');
insert into vehicle values (111481,'Dodge','Charger',2010,'black',130000,'available','fullsize_gas','Midtown','Surrey');
insert into vehicle values (111482,'Dodge','Charger',2010,'black',120000,'available','fullsize_hybrid','Midtown','Surrey');
insert into vehicle values (111483,'Jeep','Cherokee',2010,'black',150000,'available','suv_electric','Midtown','Surrey');
insert into vehicle values (111484,'Jeep','Cherokee',2010,'black',150000,'available','suv_gas','Midtown','Surrey');
insert into vehicle values (111485,'Jeep','Cherokee',2010,'dark grey',150000,'available','suv_hybrid','Midtown','Surrey');
insert into vehicle values (111486,'Nissan','Frontier',2010,'red',150000,'available','truck_electric','Midtown','Surrey');
insert into vehicle values (111487,'Nissan','Frontier',2010,'black',150000,'available','truck_gas','Midtown','Surrey');
insert into vehicle values (111488,'Nissan','Frontier',2010,'black',150000,'available','truck_hybrid','Midtown','Surrey');

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
insert into customer values (9999930,9594796563,'Kaylan Lucero','0728 Messerschmidt Center');
insert into customer values (9999931,3209080882,'Harriette Kennedy','024 Derek Junction');
insert into customer values (9999932,3421657450,'Rea Keller','8939 Wayridge Boulevard');
insert into customer values (9999933,4323338858,'Dante Mcphee','50818 Menomonie Alley');
insert into customer values (9999934,8611908388,'Inayah Britton','832 Veith Alley');
insert into customer values (9999935,2415899453,'Letitia Ventura','76 Bluejay Avenue');
insert into customer values (9999936,3856771318,'Braydon Welsh','4537 Artisan Way');
insert into customer values (9999937,6958672178,'Robert Skinner','640 Grover Trail');
insert into customer values (9999938,9652959722,'Toni Rigby','237 Service Circle');
insert into customer values (9999939,5946500687,'Carla Hooper','71362 Dryden Circle');
insert into customer values (9999940,1211420847,'Shanae Brown','462 David Road');
insert into customer values (9999941,4059058071,'Jamel Wharton','431 Yukon Crossing');
insert into customer values (9999942,4783456807,'Fahmida Whiteley','34 Delfino Plaza');
insert into customer values (9999943,9273666685,'Joe Thomson','485 Rainbow Road');
insert into customer values (9999944,4355470141,'Shanice Bailey','637 Luigi Mansion');
insert into customer values (9999945,8646549733,'Shiv Hogan','1800 Pompano Drive');
insert into customer values (9999946,5667267557,'Emir Hess','1835 Blackwater Hill');
insert into customer values (9999947,2379241567,'Dominika Whittington','921 Armadillo Place');
insert into customer values (9999948,3013434956,'Roscoe Snider','8674 Pikachu Palace');
insert into customer values (9999949,7757365180,'Raveena Ross','428 Napoleon Park');

insert into reservation values (7777770,111119,'economy_electric',9999990,'2019-11-23','12:00:00','2019-12-12','12:00:00','Downtown','Vancouver');
insert into reservation values (7777771,111130,'economy_gas',9999991,'2019-11-25','12:00:00','2019-12-01','4:00:00','Midtown','Vancouver');
insert into reservation values (7777772,111141,'economy_hybrid',9999992,'2019-11-25','15:00:00','2019-11-30','15:00:00','Downtown','Surrey');
insert into reservation values (7777773,111152,'compact_electric',9999993,'2019-11-25','12:00:00','2019-11-30','12:00:00','Downtown','Burnaby');
insert into reservation values (7777774,111163,'compact_gas',9999994,'2019-11-27','12:00:00','2019-11-30','8:00:00','Midtown','Vancouver');
insert into reservation values (7777775,111174,'compact_hybrid',9999995,'2019-11-27','12:00:00','2019-11-30','8:00:00','Midtown','Burnaby');
insert into reservation values (7777776,111185,'midsize_electric',9999996,'2019-11-27','17:00:00','2019-11-30','12:00:00','Midtown','Surrey');
insert into reservation values (7777777,111196,'midsize_gas',9999997,'2019-11-27','8:00:00','2019-12-05','11:00:00','Downtown','Surrey');
insert into reservation values (7777778,111207,'midsize_hybrid',9999998,'2019-11-28','16:00:00','2019-12-02','12:00:00','Downtown','Vancouver');
insert into reservation values (7777779,111218,'standard_electric',9999999,'2019-11-23','12:00:00','2019-11-28','13:00:00','Midtown','Surrey');
insert into reservation values (7777780,111229,'standard_gas',9999910,'2019-11-27','6:00:00','2019-11-29','8:00:00','Downtown','Burnaby');
insert into reservation values (7777781,111240,'standard_hybrid',9999911,'2019-11-27','16:00:00','2019-11-30','8:00:00','Midtown','Burnaby');
insert into reservation values (7777782,111251,'fullsize_electric',9999912,'2019-11-26','16:00:00','2019-11-29','8:00:00','Downtown','Vancouver');
insert into reservation values (7777783,111262,'fullsize_gas',9999913,'2019-11-28','16:00:00','2019-12-12','17:00:00','Downtown','Surrey');
insert into reservation values (7777784,111273,'fullsize_hybrid',9999914,'2019-11-28','23:00:00','2019-12-12','15:00:00','Midtown','Burnaby');
insert into reservation values (7777785,111284,'suv_electric',9999915,'2019-11-29','15:00:00','2019-12-12','8:00:00','Midtown','Vancouver');
insert into reservation values (7777786,111295,'suv_gas',9999916,'2019-12-02','5:00:00','2019-12-10','8:00:00','Downtown','Burnaby');
insert into reservation values (7777787,111306,'suv_hybrid',9999917,'2019-12-02','8:00:00','2019-12-11','8:00:00','Midtown','Surrey');
insert into reservation values (7777788,111317,'truck_electric',9999918,'2019-12-02','13:00:00','2019-12-12','18:00:00','Downtown','Burnaby');
insert into reservation values (7777789,111328,'truck_gas',9999918,'2019-12-02','18:00:00','2019-12-12','8:00:00','Midtown','Vancouver');


insert into rental values (8888880,111111,9999990,'2019-11-24','12:00:00','2019-12-15','12:00:00',187119,'Simonette Oleszkiewicz',5879950000000000,'2025-09-10',7777770,'Downtown','Vancouver','active');
insert into rental values (8888881,111118,9999991,'2019-11-24','12:00:00','2019-12-15','12:00:00',271758,'Judah Rippen',2909860000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888882,111125,9999992,'2019-11-24','12:00:00','2019-12-15','12:00:00',54090,'Ephraim Anthon',9911210000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888883,111132,9999993,'2019-11-24','12:00:00','2019-12-15','12:00:00',203764,'Gavrielle Belfit',9134670000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888884,111139,9999994,'2019-11-24','12:00:00','2019-12-15','12:00:00',118733,'Vanni Audsley',4515140000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888885,111146,9999995,'2019-11-24','12:00:00','2019-12-15','12:00:00',161640,'Jeniece Napolione',1945890000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888886,111153,9999996,'2019-11-24','12:00:00','2019-12-15','12:00:00',206477,'Gerry Skedgell',4239140000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888887,111160,9999997,'2019-11-24','12:00:00','2019-12-15','12:00:00',53464,'Jarred Saintpierre',2238830000000000,'2025-09-10',null,'Downtown','Vancouver','active');
insert into rental values (8888888,111167,9999998,'2019-11-24','12:00:00','2019-12-15','12:00:00',203715,'Cherry Fulks',2359420000000000,'2025-09-10',7777771,'Downtown','Burnaby','active');
insert into rental values (8888889,111174,9999999,'2019-11-24','12:00:00','2019-12-15','12:00:00',66804,'Johnnie Jerwood',7546930000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888890,111181,9999910,'2019-11-24','12:00:00','2019-12-15','12:00:00',138331,'Renado De Brett',5744960000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888891,111188,9999911,'2019-11-24','12:00:00','2019-12-15','12:00:00',96095,'Fern Bartalini',8019900000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888892,111195,9999912,'2019-11-24','12:00:00','2019-12-15','12:00:00',246945,'Renado Fowlds',5410320000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888893,111202,9999913,'2019-11-24','12:00:00','2019-12-15','12:00:00',126998,'Rivi Tyres',3449810000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888894,111209,9999914,'2019-11-24','12:00:00','2019-12-15','12:00:00',21488,'Clem Spino',1171050000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888895,111216,9999915,'2019-11-24','12:00:00','2019-12-15','12:00:00',90772,'Clayson Berrigan',6603530000000000,'2025-09-10',null,'Downtown','Burnaby','active');
insert into rental values (8888896,111223,9999916,'2019-11-24','12:00:00','2019-12-15','12:00:00',285736,'Hansiain Stigger',7936760000000000,'2025-09-10',7777772,'Downtown','Surrey','active');
insert into rental values (8888897,111230,9999917,'2019-11-24','12:00:00','2019-12-15','12:00:00',182645,'Ibrahim Goding',1934160000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888898,111237,9999918,'2019-11-24','12:00:00','2019-12-15','12:00:00',121427,'Harris Saller',7412000000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888899,111244,9999919,'2019-11-24','12:00:00','2019-12-15','12:00:00',92460,'Olivette Vakhrushev',9993580000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888900,111251,9999920,'2019-11-24','12:00:00','2019-12-15','12:00:00',275987,'Tades Zaniolo',5289880000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888901,111258,9999921,'2019-11-24','12:00:00','2019-12-15','12:00:00',260230,'Ilyssa Braz',8711080000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888902,111265,9999922,'2019-11-24','12:00:00','2019-12-15','12:00:00',140136,'Hermon Caplen',7757110000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888903,111272,9999923,'2019-11-24','12:00:00','2019-12-15','12:00:00',133736,'Llewellyn Faro',9568270000000000,'2025-09-10',null,'Downtown','Surrey','active');
insert into rental values (8888904,111279,9999924,'2019-11-24','12:00:00','2019-12-15','12:00:00',8496,'Avram Rosenthaler',9096860000000000,'2025-09-10',7777773,'Midtown','Vancouver','active');
insert into rental values (8888905,111286,9999925,'2019-11-24','12:00:00','2019-12-15','12:00:00',119310,'Britte Kas',1836560000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888906,111293,9999926,'2019-11-24','12:00:00','2019-12-15','12:00:00',195278,'Cornell Jermy',2964830000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888907,111300,9999927,'2019-11-24','12:00:00','2019-12-15','12:00:00',222597,'Danika Biskupski',4418140000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888908,111307,9999928,'2019-11-24','12:00:00','2019-12-15','12:00:00',168076,'Chilton Ridge',9230490000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888909,111314,9999929,'2019-11-24','12:00:00','2019-12-15','12:00:00',292935,'Philomena Pardy',3433940000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888910,111321,9999930,'2019-11-24','12:00:00','2019-12-15','12:00:00',76675,'Kaylan Lucero',5104660000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888911,111328,9999931,'2019-11-24','12:00:00','2019-12-15','12:00:00',84213,'Harriette Kennedy',3407330000000000,'2025-09-10',null,'Midtown','Vancouver','active');
insert into rental values (8888912,111335,9999932,'2019-11-24','12:00:00','2019-12-15','12:00:00',32336,'Rea Keller',2328270000000000,'2025-09-10',7777774,'Midtown','Burnaby','active');
insert into rental values (8888913,111342,9999933,'2019-11-24','12:00:00','2019-12-15','12:00:00',117528,'Dante Mcphee',5878970000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888914,111349,9999934,'2019-11-24','12:00:00','2019-12-15','12:00:00',91404,'Inayah Britton',4078240000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888915,111356,9999935,'2019-11-24','12:00:00','2019-12-15','12:00:00',104561,'Letitia Ventura',3148950000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888916,111363,9999936,'2019-11-24','12:00:00','2019-12-15','12:00:00',107595,'Braydon Welsh',8858840000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888917,111370,9999937,'2019-11-24','12:00:00','2019-12-15','12:00:00',107090,'Robert Skinner',1969290000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888918,111377,9999938,'2019-11-24','12:00:00','2019-12-15','12:00:00',113455,'Toni Rigby',5010260000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888919,111384,9999939,'2019-11-24','12:00:00','2019-12-15','12:00:00',233616,'Carla Hooper',6875340000000000,'2025-09-10',null,'Midtown','Burnaby','active');
insert into rental values (8888920,111391,9999940,'2019-11-24','12:00:00','2019-12-15','12:00:00',12727,'Shanae Brown',7094410000000000,'2025-09-10',7777775,'Midtown','Surrey','active');
insert into rental values (8888921,111398,9999941,'2019-11-24','12:00:00','2019-12-15','12:00:00',173574,'Jamel Wharton',5102160000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888922,111405,9999942,'2019-11-24','12:00:00','2019-12-15','12:00:00',266895,'Fahmida Whiteley',1628570000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888923,111412,9999943,'2019-11-24','12:00:00','2019-12-15','12:00:00',196730,'Joe Thomson',7700980000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888924,111419,9999944,'2019-11-24','12:00:00','2019-12-15','12:00:00',153094,'Shanice Bailey',7585510000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888925,111426,9999945,'2019-11-24','12:00:00','2019-12-15','12:00:00',142103,'Shiv Hogan',2489370000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888926,111433,9999946,'2019-11-24','12:00:00','2019-12-15','12:00:00',211029,'Emir Hess',7141110000000000,'2025-09-10',null,'Midtown','Surrey','active');
insert into rental values (8888927,111440,9999947,'2019-11-24','12:00:00','2019-12-15','12:00:00',13129,'Dominika Whittington',6138030000000000,'2025-09-10',null,'Midtown','Surrey','active');


insert into vehicle_return values (8888880,'2019-11-24','22:00:00',187169,true,50,'Downtown','Vancouver',111111,294.99);
insert into vehicle_return values (8888881,'2019-11-24','22:00:00',271808,true,50,'Downtown','Vancouver',111118,198.99);
insert into vehicle_return values (8888882,'2019-11-24','22:00:00',54140,true,50,'Downtown','Vancouver',111125,117.99);
insert into vehicle_return values (8888883,'2019-11-24','22:00:00',203814,true,50,'Downtown','Vancouver',111132,369.99);
insert into vehicle_return values (8888884,'2019-11-24','22:00:00',118783,true,50,'Downtown','Vancouver',111139,377.99);
insert into vehicle_return values (8888888,'2019-11-24','22:00:00',203765,true,50,'Downtown','Burnaby',111167,116.99);
insert into vehicle_return values (8888889,'2019-11-24','22:00:00',66854,true,50,'Downtown','Burnaby',111174,484.99);
insert into vehicle_return values (8888890,'2019-11-24','22:00:00',138381,true,50,'Downtown','Burnaby',111181,114.99);
insert into vehicle_return values (8888891,'2019-11-24','22:00:00',96145,true,50,'Downtown','Burnaby',111188,342.99);
insert into vehicle_return values (8888892,'2019-11-24','22:00:00',246995,true,50,'Downtown','Burnaby',111195,405.99);
insert into vehicle_return values (8888896,'2019-11-24','22:00:00',285786,true,50,'Downtown','Surrey',111223,365.99);
insert into vehicle_return values (8888897,'2019-11-24','22:00:00',182695,true,50,'Downtown','Surrey',111230,302.99);
insert into vehicle_return values (8888898,'2019-11-24','22:00:00',121477,true,50,'Downtown','Surrey',111237,470.99);
insert into vehicle_return values (8888899,'2019-11-24','22:00:00',92510,true,50,'Downtown','Surrey',111244,151.99);
insert into vehicle_return values (8888900,'2019-11-24','22:00:00',276037,true,50,'Downtown','Surrey',111251,165.99);
insert into vehicle_return values (8888904,'2019-11-24','22:00:00',8546,true,50,'Midtown','Vancouver',111279,178.99);
insert into vehicle_return values (8888905,'2019-11-24','22:00:00',119360,true,50,'Midtown','Vancouver',111286,412.99);
insert into vehicle_return values (8888906,'2019-11-24','22:00:00',195328,true,50,'Midtown','Vancouver',111293,122.99);
insert into vehicle_return values (8888907,'2019-11-24','22:00:00',222647,true,50,'Midtown','Vancouver',111300,461.99);
insert into vehicle_return values (8888908,'2019-11-24','22:00:00',168126,true,50,'Midtown','Vancouver',111307,438.99);
insert into vehicle_return values (8888912,'2019-11-24','22:00:00',32386,true,50,'Midtown','Burnaby',111335,113.99);
insert into vehicle_return values (8888913,'2019-11-24','22:00:00',117578,true,50,'Midtown','Burnaby',111342,447.99);
insert into vehicle_return values (8888914,'2019-11-24','22:00:00',91454,true,50,'Midtown','Burnaby',111349,112.99);
insert into vehicle_return values (8888915,'2019-11-24','22:00:00',104611,true,50,'Midtown','Burnaby',111356,341.99);
insert into vehicle_return values (8888916,'2019-11-24','22:00:00',107645,true,50,'Midtown','Burnaby',111363,196.99);
insert into vehicle_return values (8888920,'2019-11-24','22:00:00',12777,true,50,'Midtown','Surrey',111391,342.99);
insert into vehicle_return values (8888921,'2019-11-24','22:00:00',173624,true,50,'Midtown','Surrey',111398,405.99);
insert into vehicle_return values (8888922,'2019-11-24','22:00:00',266945,true,50,'Midtown','Surrey',111405,365.99);
insert into vehicle_return values (8888923,'2019-11-24','22:00:00',196780,true,50,'Midtown','Surrey',111412,302.99);
insert into vehicle_return values (8888924,'2019-11-24','22:00:00',153144,true,50,'Midtown','Surrey',111419,470.99);
