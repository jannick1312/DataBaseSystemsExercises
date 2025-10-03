-- Exercise 3b
SELECT D.Name, COUNT(A.Patient_ID) AS Total_Patients
FROM Doctor D
JOIN Appointment A ON D.Doctor_ID = A.Doctor_ID
GROUP BY D.Name;
