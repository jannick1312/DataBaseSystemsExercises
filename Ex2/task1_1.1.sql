CREATE TRIGGER BlockTitleChange
BEFORE UPDATE OF Title ON Lecture
REFERENCING OLD AS lOld NEW AS lNew
WHEN (lNew.Title != lOld.Title AND
  EXISTS (SELECT 1
    FROM Exercise e
    WHERE e.LectureTitle = lOld.Title))
(ROLLBACK WORK);
