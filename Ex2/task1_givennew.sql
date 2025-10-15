===== Entity =====
CREATE TABLE Lecturer (
	LecturerID  INT PRIMARY KEY,
	FirstName   VARCHAR(255),
	LastName    VARCHAR(255),
	Title       VARCHAR(255)
);

CREATE TABLE Lecture (
	Title              VARCHAR(255) PRIMARY KEY,
	CreditPoints       INT,
	SemesterWeekHours  INT,
	LecturerID         INT,
	FOREIGN KEY (LecturerID) REFERENCES Lecturer (LecturerID)
);

CREATE TABLE Exercise (
	ExID        INT PRIMARY KEY,
	No          INT,
	Semester    VARCHAR(255),
	LectureTitle VARCHAR(255),
	FOREIGN KEY (LectureTitle) REFERENCES Lecture (Title)
);

CREATE TABLE Author (
	AuthorID   INT PRIMARY KEY,
	LastName   VARCHAR(255),
	FirstName  VARCHAR(255),
	Title      VARCHAR(255)
);

CREATE TABLE Task (
	TaskID     INT PRIMARY KEY,
	Points     INT,
	Difficulty INT,
	Text       VARCHAR(65535), 
	AuthorID   INT,
	FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID)
);

===== Relationships =====
CREATE TABLE Contains (
	ExID      INT,
	TaskID    INT,
	PRIMARY KEY (ExID, TaskID),
	FOREIGN KEY (ExID)  REFERENCES Exercise (ExID),
	FOREIGN KEY (TaskID) REFERENCES Task (TaskID),
	Sequence  INT
);

CREATE TABLE Consists_of (
	SuperTaskID INT,
	SubTaskID   INT,
	PRIMARY KEY (SuperTaskID, SubTaskID),
	FOREIGN KEY (SuperTaskID) REFERENCES Task (TaskID),
	FOREIGN KEY (SubTaskID)   REFERENCES Task (TaskID),
	Sequence    INT
);

===== Integrity =====
CREATE ASSERTION contains_only_super_tasks
  CHECK ( NOT EXISTS (
    SELECT *
    FROM Contains c
    WHERE EXISTS (
      SELECT *
      FROM Consists_of co
      WHERE co.SubTaskID = c.TaskID
    )
  ) );

CREATE ASSERTION consists_of_non_recursive
  CHECK ( NOT EXISTS (
    SELECT *
    FROM Consists_of x
    WHERE EXISTS (
      SELECT *
      FROM Consists_of y
      WHERE y.SuperTaskID = x.SubTaskID
    )
  ) );
