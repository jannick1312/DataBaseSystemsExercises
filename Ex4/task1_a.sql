CREATE FUNCTION checkBalance (cid IN NUMBER)
RETURN VARCHAR2
IS
	balanceCalculated NUMBER(10,2);
	balanceSaved NUMBER(10,2);
BEGIN
	SELECT SUM(amount)
	INTO balanceCalculated
	FROM BankTransaction
	WHERE customer_id = cid;
	SELECT balance
	INTO balanceSaved
	FROM Customer
	WHERE customer_id = cid;

	IF balanceCalculated = balanceSaved THEN
		RETURN 'Consistent';
	ELSE
		RETURN 'Inconsistent';
	END IF;
END;
