CREATE TABLE Lecture (
	Title              VARCHAR(255) PRIMARY KEY,
	CreditPoints       INTEGER,
	SemesterWeekHours  INTEGER,
	LecturerID         INTEGER,
->	FOREIGN KEY (LecturerID) REFERENCES Lecturer (LecturerID)
);