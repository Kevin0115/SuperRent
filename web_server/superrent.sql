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
    conf_no integer not null primary key,
    -- I added this to be able to reference which vehicles are reserved
    vlicense integer not null,
    vtname varchar(20) not null,
    dlicense integer not null,
    from_date date not null,
    from_time time not null,
    to_date date not null,
    to_time time not null,
    foreign key (vlicense) references vehicle,
    foreign key (vtname) references vehicle_type,
    foreign key (dlicense) references customer
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
    conf_no integer,
    foreign key (vlicense) references vehicle,
    foreign key (dlicense) references customer,
    foreign key (conf_no) references reservation
    -- foreign key (from_date, from_time, to_date, to_time) references time_period
);

create table vehicle_return (
    rid integer not null primary key,
    return_date date not null,
    return_time time not null,
    odometer integer not null,
    fulltank boolean not null,
    tank_value integer not null,
    foreign key (rid) references rental
);