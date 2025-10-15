CREATE ASSERTION no_more_than_10_credits
	CHECK (NOT EXISTS (
		SELECT * FROM Lecture 
		WHERE CreditPoints > 10))
	NOT DEFERRABLE;
