CREATE TABLE Exercise (
	ExID          INT PRIMARY KEY,
	No            INT,
	Semester      VARCHAR(255),
	LectureTitle  VARCHAR(255),
  	FOREIGN KEY (LectureTitle) REFERENCES Lecture (Title)
->	ON UPDATE RESTRICT
);
