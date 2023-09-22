CREATE TABLE VaccineType( 
id VARCHAR(255) PRIMARY KEY, 
name VARCHAR(255) NOT NULL, 
doses INTEGER NOT NULL, 
tempmin INTEGER not null, 
tempmax INTEGER not null 
); 
 
 
CREATE TABLE Manufacturer( 
id VARCHAR(255) PRIMARY KEY, 
country VARCHAR(255) NOT NULL, 
phone VARCHAR(255) NOT NULL, 
vaccine VARCHAR(255) REFERENCES VaccineType(id) NOT NULL 
); 
 
CREATE TABLE VaccinationStations( 
name VARCHAR(255) PRIMARY KEY, 
address VARCHAR(255) NOT NULL, 
phone VARCHAR(255) NOT NULL 
); 
 
CREATE TABLE VaccineBatch( 
batchid VARCHAR(255) PRIMARY KEY, 
amount INTEGER NOT NULL, 
type VARCHAR(255) REFERENCES VaccineType(id) NOT NULL, 
manufacturer VARCHAR(255) REFERENCES Manufacturer(id) NOT NULL, 
manufdate DATE not null, 
expiration DATE not null, 
location VARCHAR(255) references VaccinationStations(name) not null 
); 
 
 
CREATE TABLE TransportationLog( 
batchid VARCHAR(255) references VaccineBatch(batchid) NOT NULL, 
arrival VARCHAR(255) references VaccinationStations(name) NOT NULL, 
departure VARCHAR(255) references VaccinationStations(name) NOT NULL, 
datearr DATE not null, 
datedep DATE not null, 
PRIMARY KEY (batchID, departure,dateDep) 
); 
 
create TABLE StaffMembers( 
socialsecuritynumber VARCHAR(255) PRIMARY KEY, 
name VARCHAR(255) NOT NULL, 
dateofbirth DATE NOT NULL, 
phone VARCHAR(255) NOT NULL, 
role VARCHAR(255) not null, 
vaccinationstatus BOOLEAN not null, 
hospital VARCHAR(255) references VaccinationStations(name) not null 
); 
 
CREATE TABLE Shifts( 
station VARCHAR(255) references VaccinationStations(name) not NULL, 
weekday VARCHAR(255) NOT NULL, 
worker VARCHAR(255) references StaffMembers(socialsecuritynumber) NOT NULL, 
PRIMARY KEY (worker, weekday) 
); 
 
CREATE TABLE Vaccinations( 
date DATE NOT NULL, 
batchid VARCHAR(255) references VaccineBatch(batchid) NOT NULL, 
location VARCHAR(255) references VaccinationStations(name) NOT NULL,
PRIMARY KEY(date,location)
); 
 
CREATE TABLE Patients( 
ssno VARCHAR(255) PRIMARY KEY, 
name VARCHAR(255) NOT NULL, 
dateofbirth DATE NOT NULL, 
gender VARCHAR(1) NOT NULL 
); 
 
CREATE TABLE VaccinePatients( 
date DATE not null, 
location VARCHAR(255) references VaccinationStations(name) NOT NULL, 
patientssno VARCHAR(255) references Patients(ssno) NOT NULL, 
PRIMARY KEY (date, patientssno) 
); 
 
CREATE TABLE Symptoms( 
name VARCHAR(255) PRIMARY KEY, 
criticality BOOLEAN NOT NULL 
);

CREATE TABLE Diagnosis( 
date DATE NOT NULL, 
symptom VARCHAR(255) references Symptoms(name) NOT NULL, 
patient VARCHAR(255) references Patients(ssno) NOT null, 
PRIMARY KEY (date, patient,symptom) 
);