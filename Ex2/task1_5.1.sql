CREATE TRIGGER BlockDuplicateAuthor
BEFORE INSERT ON Author
REFERENCING NEW AS aNew
WHEN (EXISTS (SELECT 1
    FROM Author a
    WHERE a.FirstName = aNew.FirstName
      AND a.LastName = aNew.LastName
      AND a.Title = aNew.Title))
(ROLLBACK WORK);
