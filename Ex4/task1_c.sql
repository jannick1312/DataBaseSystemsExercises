CREATE PROCEDURE checkReceive (
	cid			IN NUMBER,
	amount			IN NUMBER(10,2),
	description		IN VARCHAR2)
IS
	customerExists		NUMBER;
	customerNotExists 	EXCEPTION;
	maxTransaction		BankTransaction.transaction_id%TYPE;
BEGIN
	SELECT COUNT(*)
	INTO customerExists
	FROM Customer
	WHERE customer_id = cid;
	
	IF customerExists = 0 THEN RAISE customerNotExists;
	END IF;

	UPDATE Customer
	SET balance = balance + amount
	WHERE customer_id = cid;
	
	SELECT MAX(transaction_id)
	INTO maxTransaction
	FROM BankTransaction;

	INSERT INTO BankTransaction
	VALUES (maxTransaction + 1, cid, SYSDATE, 
						amount, description);
	COMMIT;

EXCEPTION
	WHEN customerNotExists THEN
		ROLLBACK;
	WHEN OTHERS THEN
		ROLLBACK;
END;