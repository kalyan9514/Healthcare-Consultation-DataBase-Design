-- Creating Database for our Team4

CREATE DATABASE TEAM4_MEDICAL_CONSULT
USE TEAM4_MEDICAL_CONSULT

-- Created Schema MED for our tables 
CREATE SCHEMA MED;

USE TEAM4_MEDICAL_CONSULT;


CREATE TABLE MED.PatientDetails
(
	PatientID INT IDENTITY(100, 1) NOT NULL  PRIMARY KEY,
	FirstName VARCHAR(45) NOT NULL,
	LastName VARCHAR(45) NOT NULL,
	Birthday Date,
	Age AS DATEDIFF(hour, Birthday, GETDATE()) / 8766,
	Gender VARCHAR(45) NOT NULL CHECK (Gender IN ('Male', 'Female')),
	PatientPhoneNum VARCHAR(20) NOT NULL,
)

CREATE TABLE MED.Department
(
	DepartmentID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	DepartmentName VARCHAR(45) NOT NULL,
	DepartmentDescription VARCHAR(MAX) NOT NULL
)

CREATE TABLE MED.Doctor
(
	DoctorID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	DepartmentID INT NOT NULL REFERENCES MED.Department(DepartmentID),
	FirstName VARCHAR(45) NOT NULL,
	LastName VARCHAR(45) NOT NULL,
	Birthday Date,
	Age AS DATEDIFF(hour, Birthday, GETDATE()) / 8766,
	Gender VARCHAR(45) NOT NULL CHECK (Gender IN ('Male', 'Female')),
	DoctorPhoneNum VARCHAR(20) NOT NULL,
	Specialization VARCHAR(100) NOT NULL,
	LicenseNumber VARCHAR(100) NOT NULL,
	DoctorAddress VARCHAR(100) NOT NULL,
	DoctorTitle VARCHAR(45) NOT NULL,
	Rating DECIMAL(5, 2);
)

CREATE TABLE MED.Symptom
(
	SymptomID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	SymptomName VARCHAR(45) NOT NULL,
	SymptomDescription VARCHAR(MAX) NOT NULL
)

CREATE TABLE MED.SymptomSpecialtyDoctor
(
	SymptomID INT NOT NULL REFERENCES MED.Symptom(SymptomID),
	DoctorID INT NOT NULL REFERENCES MED.Doctor(DoctorID),
	CONSTRAINT PK_DoctorSymptomSpecialty PRIMARY KEY CLUSTERED (SymptomID, DoctorID)
)

CREATE TABLE MED.ConsultationRoom
(
	ConsultationRoomID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	RoomLink VARCHAR(60) NOT NULL
)


CREATE TABLE MED.DoctorAppointmentSchedule
(
	ScheduleID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	DoctorID INT NOT NULL REFERENCES MED.Doctor(DoctorID),
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL,
	CONSTRAINT CHECK_DS CHECK (StartTime < EndTime)
)

CREATE TABLE MED.PatientBooking
(
	BookingID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	ScheduleID INT NOT NULL REFERENCES MED.DoctorAppointmentSchedule(ScheduleID),
	PatientID INT NOT NULL REFERENCES MED.PatientDetails(PatientID),
	ConsultationRoomID INT NOT NULL REFERENCES MED.ConsultationRoom(ConsultationRoomID)
)

CREATE TABLE MED.PrescriptionDetails
(
	PrescriptionID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	DoctorComments VARCHAR(MAX) NOT NULL,
	PrescribingDoctor VARCHAR(100) NOT NULL,
	MedicationName  VARCHAR(100) NOT NULL,
	Dosage VARCHAR(100) NOT NULL,
	DosageFrequency VARCHAR(100) NOT NULL,
	DosageGuidance VARCHAR(100) NOT NULL,
)

CREATE TABLE MED.CaseRecord
(
	CaseID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	BookingID INT NOT NULL REFERENCES MED.PatientBooking(BookingID),
	PrescriptionID INT NOT NULL REFERENCES MED.PrescriptionDetails(PrescriptionID),
	[Result] VARCHAR(MAX) NOT NULL,
	Advice VARCHAR(MAX) NOT NULL
)

CREATE TABLE MED.PatientFeedback
(
	FeedbackID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	CaseID INT NOT NULL REFERENCES MED.CaseRecord(CaseID),
	Content VARCHAR(MAX) NOT NULL,
	Feedback VARCHAR(45) NOT NULL CHECK (Feedback IN ('Positive', 'Negative'))
)

CREATE TABLE MED.MedicationOrder
(
	DrugOrderID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	PrescriptionID INT NOT NULL REFERENCES MED.PrescriptionDetails(PrescriptionID),
	OrderDate DATETIME NOT NULL,
	TotalPrice MONEY NOT NULL,
)

CREATE TABLE MED.DrugDetails
(
	DrugID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
	DrugName VARCHAR(45) NOT NULL,
	Company VARCHAR(45) NOT NULL,
	UnitPrice MONEY NOT NULL
)

CREATE TABLE MED.PrescribedDrug
(
	DrugID INT NOT NULL REFERENCES MED.DrugDetails(DrugID),
	PrescriptionID INT NOT NULL REFERENCES MED.PrescriptionDetails(PrescriptionID),
	CONSTRAINT PK_DrugPrescripted PRIMARY KEY CLUSTERED (DrugID, PrescriptionID),
	Quantity INT NOT NULL
)


---- Inserted records into the tables

INSERT INTO MED.PatientDetails (FirstName, LastName, Birthday, Gender, PatientPhoneNum) VALUES
('Michael', 'Johnson', '1980-01-01', 'Male', '555-0001'),
('Laura', 'Williams', '1981-02-01', 'Female', '555-0002'),
('David', 'Martinez', '1982-03-01', 'Female', '555-0003'),
('Emma', 'Taylor', '1983-04-01', 'Male', '555-0004'),
('Jacob', 'Brown', '1984-05-01', 'Male', '555-0005'),
('Olivia', 'Garcia', '1985-06-01', 'Female', '555-0006'),
('William', 'Anderson', '1986-07-01', 'Male', '555-0007'),
('Sophia', 'Miller', '1987-08-01', 'Female', '555-0008'),
('Alexander', 'Wilson', '1988-09-01', 'Male', '555-0009'),
('Emily', 'Moore', '1989-10-01', 'Female', '555-0010');


INSERT INTO MED.Department (DepartmentName, DepartmentDescription) VALUES
('Cardiology', 'Deals with conditions and diseases of the heart.'),
('Neurology', 'Focuses on disorders of the nervous system.'),
('Orthopedics', 'Concerned with conditions involving the musculoskeletal system.'),
('Pediatrics', 'Specializes in the care of infants, children, and adolescents.'),
('Dermatology', 'Deals with the skin, nails, hair, and their diseases.'),
('Psychiatry', 'Focused on the diagnosis, treatment, and prevention of mental, emotional, and behavioral disorders.'),
('Oncology', 'Concerned with the study and treatment of tumors.'),
('Radiology', 'Focuses on using medical imaging to diagnose and treat diseases.'),
('Gastroenterology', 'Deals with the diseases of the digestive system.'),
('Endocrinology', 'Concerned with the endocrine system and hormones.');

INSERT INTO MED.Doctor (DepartmentID, FirstName, LastName, Birthday, Gender, DoctorPhoneNum, Specialization, LicenseNumber, DoctorAddress, DoctorTitle) VALUES
(100, 'John', 'Doe', '1970-01-01', 'Male', '555-1001', 'Cardiology', 'LIC001', '123 Main St', 'Dr.'),
(101, 'Jane', 'Smith', '1975-02-01', 'Female', '555-1002', 'Neurology', 'LIC002', '124 Main St', 'Dr.'),
(102, 'Alice', 'Brown', '1980-03-01', 'Female', '555-1003', 'Orthopedics', 'LIC003', '125 Main St', 'Dr.'),
(103, 'Bob', 'Clark', '1978-04-01', 'Male', '555-1004', 'Pediatrics', 'LIC004', '126 Main St', 'Dr.'),
(104, 'Charlie', 'Davis', '1982-05-01', 'Male', '555-1005', 'Dermatology', 'LIC005', '127 Main St', 'Dr.'),
(105, 'Diana', 'Evans', '1976-06-01', 'Female', '555-1006', 'Psychiatry', 'LIC006', '128 Main St', 'Dr.'),
(106, 'Ethan', 'Frank', '1981-07-01', 'Male', '555-1007', 'Oncology', 'LIC007', '129 Main St', 'Dr.'),
(107, 'Grace', 'Hill', '1983-08-01', 'Female', '555-1008', 'Radiology', 'LIC008', '130 Main St', 'Dr.'),
(108, 'Henry', 'Iris', '1977-09-01', 'Male', '555-1009', 'Gastroenterology', 'LIC009', '131 Main St', 'Dr.'),
(109, 'Isla', 'Jones', '1985-10-01', 'Female', '555-1010', 'Endocrinology', 'LIC010', '132 Main St', 'Dr.');


INSERT INTO MED.Symptom (SymptomName, SymptomDescription) VALUES
('Chest Pain', 'A potential indicator of cardiac issues, often investigated in cardiology.'),
('Headaches', 'Can be associated with various neurological conditions.'),
('Joint Pain', 'Commonly addressed in orthopedics, relating to bones and joints.'),
('Fever in Children', 'A common symptom in pediatrics, often requiring careful evaluation.'),
('Skin Rash', 'Dermatology often deals with rashes and other skin anomalies.'),
('Mood Swings', 'Can indicate psychological conditions, relevant to psychiatry.'),
('Unexplained Lumps', 'Potentially indicative of tumors, a primary concern in oncology.'),
('Abdominal Pain', 'A symptom often investigated with medical imaging in radiology.'),
('Stomach Upset', 'Related to gastroenterology, focusing on digestive system health.'),
('Fatigue', 'Can be related to hormonal imbalances, relevant to endocrinology.');

INSERT INTO MED.SymptomSpecialtyDoctor (SymptomID, DoctorID) VALUES
(100, 100),
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(106, 106),
(107, 107),
(108, 108),
(109, 109);

INSERT INTO MED.ConsultationRoom (RoomLink) VALUES
('http://room101.com'),
('http://room102.com'),
('http://room103.com'),
('http://room104.com'),
('http://room105.com'),
('http://room106.com'),
('http://room107.com'),
('http://room108.com'),
('http://room109.com'),
('http://room110.com');

INSERT INTO MED.DoctorAppointmentSchedule (DoctorID, StartTime, EndTime) VALUES
(100, '2023-04-12 09:00:00', '2023-04-12 10:00:00'),
(101, '2023-04-12 10:00:00', '2023-04-12 11:00:00'),
(102, '2023-04-13 09:00:00', '2023-04-13 10:00:00'),
(103, '2023-04-13 10:00:00', '2023-04-13 11:00:00'),
(104, '2023-04-14 09:00:00', '2023-04-14 10:00:00'),
(105, '2023-04-14 10:00:00', '2023-04-14 11:00:00'),
(106, '2023-04-15 09:00:00', '2023-04-15 10:00:00'),
(107, '2023-04-15 10:00:00', '2023-04-15 11:00:00'),
(108, '2023-04-16 09:00:00', '2023-04-16 10:00:00'),
(109, '2023-04-16 10:00:00', '2023-04-16 11:00:00');

INSERT INTO MED.PatientBooking (ScheduleID, PatientID, ConsultationRoomID) VALUES
(100, 100, 100),
(101, 101, 101),
(102, 102, 102),
(103, 103, 103),
(104, 104, 104),
(105, 105, 105),
(106, 106, 106),
(107, 107, 107),
(108, 108, 108),
(109, 109, 109);

INSERT INTO MED.PrescriptionDetails (DoctorComments, PrescribingDoctor, MedicationName, Dosage, DosageFrequency, DosageGuidance) VALUES
('For cardiovascular health', 'John Doe', 'Beta Blocker', '50 mg', 'Once a day', 'Take in the morning'),
('Neurological support', 'Jane Smith', 'Anticonvulsant', '100 mg', 'Twice a day', 'Take with meals'),
('Orthopedic care', 'Alice Brown', 'Calcium', '500 mg', 'Twice a day', 'Take after meals'),
('Pediatric fever reducer', 'Bob Clark', 'Ibuprofen', '200 mg', 'Every 6 hours', 'Take with food'),
('Dermatological cream', 'Charlie Davis', 'Hydrocortisone', 'Apply topically', 'Twice a day', 'Apply to affected area'),
('Psychiatric medication', 'Diana Evans', 'Antidepressant', '20 mg', 'Once a day', 'Take before bedtime'),
('Cancer treatment', 'Ethan Frank', 'Chemotherapy agent', 'Varies', 'Per cycle', 'Administered at hospital'),
('Radiological dye', 'Grace Hill', 'Contrast medium', 'Varies', 'Before procedure', 'Follow radiologist instructions'),
('Gastrointestinal relief', 'Henry Iris', 'Proton Pump Inhibitor', '40 mg', 'Once a day', 'Take before eating'),
('Endocrine system stabilizer', 'Isla Jones', 'Insulin', 'Varies', 'As needed', 'Inject subcutaneously');

INSERT INTO MED.CaseRecord (BookingID, PrescriptionID, [Result], Advice) VALUES
(100, 100, 'Treatment was effective', 'Continue medication and follow-up in 2 weeks'),
(101, 101, 'Symptoms improved', 'Adjust dosage as per the response'),
(102, 102, 'Condition stabilized', 'Schedule next appointment in 1 month'),
(103, 103, 'Patient responded well to treatment', 'Maintain current medication and monitor'),
(104, 104, 'Significant improvement observed', 'Repeat prescription and reassess in 3 weeks'),
(105, 105, 'Condition under control', 'Continue treatment and evaluate in 1 month'),
(106, 106, 'Positive response to medication', 'Maintain dosage, follow-up in 2 weeks'),
(107, 107, 'Treatment successful', 'No further action required, discharge patient'),
(108, 108, 'Stable after intervention', 'Recommend lifestyle changes and regular monitoring'),
(109, 109, 'Recovery on track', 'Continue current regimen, check-up in 1 month');

INSERT INTO MED.PatientFeedback (CaseID, Content, Feedback) VALUES
(100, 'The treatment was well-explained and effective. Feeling much better now.', 'Positive'),
(101, 'Noticed no significant improvement. The new dosage seems not to be working.', 'Negative'),
(102, 'Happy with the care provided. The condition has stabilized significantly.', 'Positive'),
(103, 'Not satisfied with the treatment outcome. The staff was also not helpful.', 'Negative'),
(104, 'The medication worked well. No side effects experienced.', 'Positive'),
(105, 'Not Feeling better. The instructions were not clear.', 'Negative'),
(106, 'Treatment was successful. Appreciate the follow-up and care provided.', 'Positive'),
(107, 'Cannot Fully recover. No timely and effective treatment.', 'Negative'),
(108, 'The lifestyle recommendations were really helpful. Feeling much more stable.', 'Positive'),
(109, 'The regular check-ups and monitoring have been not good.', 'Negative');


INSERT INTO MED.MedicationOrder (PrescriptionID, OrderDate, TotalPrice) VALUES
(100, '2023-04-15 10:00:00', 200.00),
(101, '2023-04-16 11:00:00', 150.00),
(102, '2023-04-17 09:30:00', 180.00),
(103, '2023-04-18 14:45:00', 220.00),
(104, '2023-04-19 16:00:00', 75.00),
(105, '2023-04-20 10:15:00', 90.00),
(106, '2023-04-21 11:20:00', 200.00),
(107, '2023-04-22 13:00:00', 300.00),
(108, '2023-04-23 15:30:00', 85.00),
(109, '2023-04-24 09:45:00', 60.00);

INSERT INTO MED.DrugDetails (DrugName, Company, UnitPrice) VALUES
('Acetaminophen', 'PharmaCo', 10.00),
('Ibuprofen', 'BestMed', 20.00),
('Amoxicillin', 'GenericPharm', 15.00),
('Ciprofloxacin', 'PharmaCo', 25.00),
('Atorvastatin', 'BestMed', 30.00),
('Metformin', 'GenericPharm', 8.00),
('Lisinopril', 'PharmaCo', 22.00),
('Amlodipine', 'BestMed', 18.00),
('Simvastatin', 'GenericPharm', 27.00),
('Losartan', 'PharmaCo', 16.00);

INSERT INTO MED.PrescribedDrug (DrugID, PrescriptionID, Quantity) VALUES
(100, 100, 2),
(101, 101, 1),
(102, 102, 3),
(103, 103, 1),
(104, 104, 2),
(105, 105, 4),
(106, 106, 1),
(107, 107, 2),
(108, 108, 3),
(109, 109, 1);


---- 2 Views


---- First View
   
/*
 * The MED.BookingDetailsView provides a concise summary of patient appointments, 
 * including the booking ID, patient's first and last names, doctor's first and last names, 
 * consultation room link, and appointment start and end times. 
 * This view is instrumental in managing and organizing appointment scheduling within the 
 * medical facility.
 */
   
CREATE VIEW MED.BookingDetailsView AS
SELECT
    PB.BookingID,
    P.FirstName AS PatientFirstName,
    P.LastName AS PatientLastName,
    D.FirstName AS DoctorFirstName,
    D.LastName AS DoctorLastName,
    CR.RoomLink,
    DS.StartTime,
    DS.EndTime
FROM
    MED.PatientDetails P
JOIN
    MED.PatientBooking PB ON P.PatientID = PB.PatientID
JOIN
    MED.ConsultationRoom CR ON PB.ConsultationRoomID = CR.ConsultationRoomID
JOIN
    MED.DoctorAppointmentSchedule DS ON PB.ScheduleID = DS.ScheduleID
JOIN
    MED.Doctor D ON DS.DoctorID = D.DoctorID;
   

--- select statement for the view
   
SELECT * FROM MED.BookingDetailsView




---- Second View
/*
 The ComprehensivePatientHistoryView summarizes a patient's medical journey, 
 including doctor consultations, prescribed medications, diagnoses, and patient feedback. 
 It combines information such as patient details, doctor appointments, prescription details,
 and symptom descriptions into a single comprehensive overview.
 */

CREATE VIEW MED.ComprehensivePatientHistoryView AS
SELECT 
    pd.PatientID,
    pd.FirstName + ' ' + pd.LastName AS PatientName,
    pd.Birthday,
    pd.Age,
    pd.Gender,
    pd.PatientPhoneNum,
    d.FirstName + ' ' + d.LastName AS DoctorName,
    d.Specialization,
    d.LicenseNumber,
    d.DoctorPhoneNum,
    d.DoctorAddress,
    dept.DepartmentName,
    s.SymptomName,
    s.SymptomDescription,
    cr.RoomLink,
    das.StartTime,
    das.EndTime,
    presc.MedicationName,
    presc.Dosage,
    presc.DosageFrequency,
    presc.DosageGuidance,
    presc.DoctorComments AS PrescriptionComments,
    crd.[Result] AS DiagnosisResult,
    crd.Advice,
    pfb.Content AS PatientFeedback
FROM 
    MED.PatientDetails pd
INNER JOIN 
    MED.PatientBooking pb ON pd.PatientID = pb.PatientID
INNER JOIN 
    MED.DoctorAppointmentSchedule das ON pb.ScheduleID = das.ScheduleID
INNER JOIN 
    MED.Doctor d ON das.DoctorID = d.DoctorID
INNER JOIN 
    MED.Department dept ON d.DepartmentID = dept.DepartmentID
INNER JOIN 
    MED.ConsultationRoom cr ON pb.ConsultationRoomID = cr.ConsultationRoomID
INNER JOIN 
    MED.CaseRecord crd ON pb.BookingID = crd.BookingID
INNER JOIN 
    MED.PrescriptionDetails presc ON crd.PrescriptionID = presc.PrescriptionID
LEFT JOIN 
    MED.PatientFeedback pfb ON crd.CaseID = pfb.CaseID
LEFT JOIN 
    MED.SymptomSpecialtyDoctor ssd ON d.DoctorID = ssd.DoctorID
LEFT JOIN 
    MED.Symptom s ON ssd.SymptomID = s.SymptomID;
   

--- select statement for the view
   
SELECT * FROM MED.ComprehensivePatientHistoryView

   

   
-- Table-level CHECK Constraints based on a function

/*
Step 1: Create a User-Defined Function

This function ensure that the age of any doctor is at least 18. 
*/


CREATE FUNCTION MED.CheckAgeValidity(@Birthday DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SET @Age = DATEDIFF(YEAR, @Birthday, GETDATE());
    
    IF @Age >= 18
        RETURN 1;
    RETURN 0;
END;

/*
Step 2:  Table with a CHECK Constraint
We have applied this function check on doctor table to make sure that age of doctor is at least 18
*/

ALTER TABLE MED.Doctor
ADD CONSTRAINT chk_AgeValidity CHECK (MED.CheckAgeValidity(Birthday) = 1);


---- Checking if this constraint is working or not

/* This query will fail because the person's age is not 18, and it will not insert the record into the table. 
 * The person's age in the doctor table is calculated based on their birthdate. 
 * The birthdate provided is in the year 2023. */

INSERT INTO MED.Doctor (DepartmentID, FirstName, LastName, Birthday, Gender, DoctorPhoneNum, Specialization, LicenseNumber, DoctorAddress, DoctorTitle) VALUES
(109, 'ABC', 'XYZ', '2023-10-01', 'Female', '555-1010', 'Endocrinology', 'LIC010', '132 Main St', 'Dr.')




-- Computed Columns based on a function

/*
 * The MED.GetDoctorRating4 function calculates the rating for a doctor based on the number of 
 * positive and negative feedback entries they receive. By leveraging this function, 
 * healthcare facilities can dynamically assess and monitor the quality of care provided by doctors, 
 * aiding in continuous improvement efforts.
 */


CREATE FUNCTION MED.GetDoctorRating5 (@DoctorID INT)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @Rating DECIMAL(5, 2);

    -- Count positive feedback
    DECLARE @PositiveCount INT;
    SELECT @PositiveCount = COUNT(*) 
    FROM MED.PatientFeedback pf
    INNER JOIN MED.CaseRecord crd ON pf.CaseID = crd.CaseID
    INNER JOIN MED.PatientBooking pb ON crd.BookingID = pb.BookingID
    INNER JOIN MED.DoctorAppointmentSchedule das ON pb.ScheduleID = das.ScheduleID
    INNER JOIN MED.Doctor d ON das.DoctorID = d.DoctorID
    WHERE pf.Feedback = 'Positive' AND d.DoctorID = @DoctorID;

    -- Count negative feedback
    DECLARE @NegativeCount INT;
    SELECT @NegativeCount = COUNT(*) 
    FROM MED.PatientFeedback pf
    INNER JOIN MED.CaseRecord crd ON pf.CaseID = crd.CaseID
    INNER JOIN MED.PatientBooking pb ON crd.BookingID = pb.BookingID
    INNER JOIN MED.DoctorAppointmentSchedule das ON pb.ScheduleID = das.ScheduleID
    INNER JOIN MED.Doctor d ON das.DoctorID = d.DoctorID
    WHERE pf.Feedback = 'Negative' AND d.DoctorID = @DoctorID;

    -- Calculate rating based on feedback counts
    IF (@PositiveCount + @NegativeCount) = 0
        SET @Rating = 0;
    ELSE IF (@PositiveCount + @NegativeCount) <= 5
        SET @Rating = 3.5;
    ELSE IF (@PositiveCount + @NegativeCount) <= 10
        SET @Rating = 4.0;
    ELSE
        SET @Rating = 4.5;

    RETURN @Rating;
END;


/* The "Rating" column in the doctor entity is a calculated column 
 determined by the "getdoctorrating5" function. */

UPDATE MED.Doctor
SET Rating = MED.GetDoctorRating5(DoctorID);


SELECT * from MED.Doctor




