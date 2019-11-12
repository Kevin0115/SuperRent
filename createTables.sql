drop table license;
drop table exam;
drop table branch;
drop table driver;

create table branch ( 
	branch_id integer not null PRIMARY KEY,
	branch_name varchar(20) not null,
	branch_addr varchar(50),
	branch_city varchar(20) not null,
	branch_phone integer 
);

create table driver (
	driver_sin integer not null PRIMARY KEY,
	driver_name varchar(20) not null,
	driver_addr varchar(50) not null,
	driver_city varchar(20) not null,
	driver_birthdate date not null,
	driver_phone integer
);

create table license ( 
	license_no BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	driver_sin integer not null,
	license_type char not null,
	license_class integer,
	license_expiry date not null,
	issue_date date not null,
	branch_id integer not null,
	foreign key (driver_sin) references driver,
	foreign key (branch_id) references branch
);

create table exam (
	driver_sin integer not null,
	branch_id integer not null,
	exam_date date not null,
	exam_type char not null,
	exam_score integer,
	PRIMARY KEY (driver_sin, branch_id, exam_date),
	foreign key (driver_sin) references driver,
	foreign key (branch_id) references branch
);

insert into branch values (1, 'Main', '1234 Main St.', 'Vancouver', 5551234);
insert into branch values (2, 'Richmond', '23 No.3 Road', 'Richmond', 5552331);
insert into branch values (3, 'West Creek', '251 Creek Rd.', 'Sechelt', 5552511);
insert into branch values (4, 'Blenheim', '1342 W. 22 Ave.', 'Burnaby', 5551342);

insert into driver values (111111111, 'Bob Smith', '111 E. 11 St.', 'Vancouver', TO_DATE('01-JAN-1995', 'DD-MON-YYYY'), 5551111);
insert into driver values (222222222, 'Candace Walters', '222 E. 22 St.', 'Burnaby', TO_DATE('02-FEB-1996', 'DD-MON-YYYY'), 5552222);
insert into driver values (333333333, 'Kara Rops', '333 W. 33 Ave.', 'Richmond', TO_DATE('03-MAR-1990', 'DD-MON-YYYY'), 5553333);
insert into driver values (444444444, 'Alex Mark', '444 E. 4 Ave.', 'Vancouver', TO_DATE('04-APR-1994', 'DD-MON-YYYY'), 5554444);

insert into exam values (111111111, 2, TO_DATE('02-DEC-2007', 'DD-MON-YYYY'), 'L', 97);
insert into exam values (222222222, 3, TO_DATE('09-MAY-2006', 'DD-MON-YYYY'), 'L', 25);
insert into exam values (222222222, 4, TO_DATE('10-JUN-2006', 'DD-MON-YYYY'), 'L', 51);
insert into exam values (111111111, 2, TO_DATE('25-MAY-2007', 'DD-MON-YYYY'), 'D', 79);
insert into exam values (333333333, 2, TO_DATE('27-JUN-2007', 'DD-MON-YYYY'), 'L', 49);
insert into exam values (222222222, 4, TO_DATE('29-AUG-2006', 'DD-MON-YYYY'), 'D', 81);
insert into exam values (333333333, 1, TO_DATE('07-JUL-2007', 'DD-MON-YYYY'), 'L', 45);
insert into exam values (444444444, 1, TO_DATE('27-JUL-2007', 'DD-MON-YYYY'), 'L', 71);
insert into exam values (444444444, 2, TO_DATE('30-AUG-2007', 'DD-MON-YYYY'), 'D', 65);
insert into exam values (333333333, 2, TO_DATE('27-JUL-2007', 'DD-MON-YYYY'), 'L', 61);

insert into license(driver_sin, license_type, license_class, license_expiry, issue_date, branch_id) values (111111111, 'D', 5, TO_DATE('25-MAY-2009', 'DD-MON-YYYY'), TO_DATE('25-MAY-2007', 'DD-MON-YYYY'), 2);
insert into license(driver_sin, license_type, license_class, license_expiry, issue_date, branch_id) values (222222222, 'D', 5, TO_DATE('29-AUG-2008', 'DD-MON-YYYY'), TO_DATE('29-AUG-2006', 'DD-MON-YYYY'), 4);
insert into license(driver_sin, license_type, license_class, license_expiry, issue_date, branch_id) values (333333333, 'L', 7, TO_DATE('27-DEC-2007', 'DD-MON-YYYY'), TO_DATE('27-JUN-2007', 'DD-MON-YYYY'), 2);
insert into license(driver_sin, license_type, license_class, license_expiry, issue_date, branch_id) values (444444444, 'D', 5, TO_DATE('30-AUG-2009', 'DD-MON-YYYY'), TO_DATE('30-AUG-2007', 'DD-MON-YYYY'), 2);

commit;
