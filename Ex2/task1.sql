CREATE TABLE Lecturer (
	LecturerID INT PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Title VARCHAR(50)
);

CREATE TABLE Lecture (
	Title VARCHAR(50) PRIMARY KEY,
	CreditPoints INT,
	SemesterWeekHours INT,
	FOREIGN KEY (LecturerID) REFERENCES Lecturer(LecturerID)
);

CREATE TABLE Exercise (
	ExerciseID INT PRIMARY KEY,
	No INT,
	Semester VARCHAR(50),
	FOREIGN KEY (LectureTitle) REFERENCES Lecture(Title)
);

CREATE TABLE Author (
	AuthorID INT PRIMARY KEY,
	LastName VARCHAR(50),
	FirstName VARCHAR(50),
	Title VARCHAR(50)
);

CREATE TABLE Task (
	TaskID INT PRIMARY KEY,
	Points INT,
	Difficulty INT,
	Text TEXT,
	FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE consists_of(
	FOREIGN KEY (SuperTaskID) REFERENCES Task(TaskID),
	FOREIGN KEY (SubTaskID) REFERENCES Task(TaskID),
	Sequence INT,

	PRIMARY KEY (SuperTaskID, SubTaskID)
);

CREATE TRIGGER dont_alter_lecture_name_if_exercise_exist
	BEFORE UPDATE OF Title ON Lecture
	REFERENCING OLD AS lOld
	WHEN EXISTS (SELECT * FROM Exercise 
		WHERE LectureTitle = lOld.Title)
	(ROLLBACK WORK);

CREATE ASSERTION no_lecture_more_than_10_credits
	CHECK (NOT EXISTS (
		SELECT * FROM Lecture 
		WHERE CreditPoints > 10))
	NOT DEFERRABLE;

CREATE TRIGGER not_same_author
	BEFORE INSERT ON Author
	REFERENCING NEW AS aNew
	FOR EACH ROW
	WHEN EXISTS (SELECT * FROM Author 
		WHERE LastName = aNew.LastName
		AND FirstName = aNew.FirstName
		AND Title = aNew.Title)
	(ROLLBACK WORK);