-- Exercise 3c
SELECT D.Name, COUNT(DISTINCT A.Patient_ID) AS Total_Patients
FROM Doctor D
JOIN Appointment A ON D.Doctor_ID = A.Doctor_ID
GROUP BY D.Name
HAVING COUNT(DISTINCT A.Patient_ID) > 10;
