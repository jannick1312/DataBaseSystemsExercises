CREATE PROCEDURE checkAllBalances (consistent OUT VARCHAR2)
IS
	inconsistent BOOLEAN := FALSE;
	CURSOR c IS SELECT customer_id FROM Customer;
BEGIN
	FOR record IN c LOOP
		IF check_balance(record.customer_id) = 
					'Inconsistent' THEN
			inconsistent := TRUE;
		END IF;
  	END LOOP;

	IF inconsistent THEN
		consistent := 'Inconsistent';
	ELSE
		consistent := 'Consistent';
	END IF;
END;
