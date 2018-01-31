SELECT statements within a PL/SQL block must return one and only one row.
-- Associated errors:
NO_DATA_FOUND When not a single record was found.
TOO_MANY_ROWS When more than one row was returned.

DML STATEMENTS
UPDATE
INSERT
DELETE
MERGE: Selects rows from one table to update or insert into another table.

DECLARE
	v_min_sal NUMBER := 5000;
BEGIN
	INSERT INTO employees ( employee_id, first_name, last_name, email, hire_date, job_id, salary)
	VALUES (employee_seq.NEXTVAL, 'Ruth', 'Cores', 'RCORES', current_date, 'AD_ASST', v_min_sal + 4000);
END;


*** MERGE EXAMPLE ***

BEGIN
	MERGE INTO copy_emp c USING employees e ON (
		e.employee_id = c.employee_id
		) WHEN MATCHED THEN
			UPDATE
		SET c.first_name = e.first_name,
			c.last_name = e.last_name,
			c.email = e.email,
			c.phone_number = e.phone_number,
			c.hire_date = e.hire_date,
			c.job_id = e.job_id,
			c.salary = e.salary,
			c.commission_pct = e.commission_pct,
			c.manager_id = e.manager_id,
			c.department_id = e.department_id
		WHEN NOT MATCHED THEN INSERT VALUES (e.employee_id, e.first_name, e.last_name, e.email, e.phone_number,
											 e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id,
											 e.department_id);
END;
/

**** CONDITIONAL PROGRAMMING ****

OPERATORS IN PL/SQL

LOGICAL
ARITHMETIC
CONCATENATION
PARENTHESIS
The 4 operators above perform the same operations as in plan SQL.

DECLARE
	v_bonus NUMBER(8,2) NOT NULL := 0;
	v_service_period NUMBER NOT NULL :=3;
	v_salary NUMBER(8,2) := 11000;
BEGIN
	IF v_service_period = 10
	THEN
		-- This employee is with the organization since its inception.
		v_bonus := v_salary * 0.5;
		DBMS_OUTPUT.PUT_LINE('Bonus amount = ' || v_bonus);
	ELSE
		IF v_service_period < 10 AND v_service_period >= 5
		THEN
			-- This employee has a service period between 5 and 9 years.
			v_bonus := v_salary * 0.25;
			DBMS_OUTPUT.PUT_LINE('Bonus amount = ' || v_bonus);
		ELSE
			-- This employee has a service period of less than 5 years.
			v_bonus := v_salary * 0.1;
			DBMS_OUTPUT.PUT_LINE('Bonus amount = ' || v_bonus);
		END IF;
	END IF;
END;
/

*** ELSIF ***
IF condition1 THEN
ELSIF condition2 THEN
ELSIF condition3 THEN ...
ELSE
END IF;

*** CASE ***
CASE selector
WHEN expression1 THEN result1
WHEN expresion2 THEN result2
...
ELSE resultX
END;

...
BEGIN
v_bonus :=
	CASE
		WHEN v_service_period < 10 AND v_service_period >5 THEN
		v_salary * 0.25
		WHEN...
		ELSE
		v_salary * 0.1
	END;
END;


DECLARE
...
BEGIN

CASE v_service_period
 WHEN 10 THEN
 v_bonus := v_salary * 0.5;
 ...
 UPDATE x SET y WHERE z
 ELSE
 v_bonus := ...
 UPDATE x SET z WHERE whatever
 END CASE;

 END;

**** LOOPS ****

*** BASIC LOOP . Executes at least once. ***
DECLARE
v_emp_id copy_emp2.empl
...
LOOP
EXIT WHEN v_emp_count = 0;
END LOOP;

*** WHILE LOOP ***
BEGIN
...
WHILE v_emp_count > 0 LOOP
...
END LOOP;

*** FOR LOOP ***
BEGIN
...
FOR i IN 1..v_emp_count LOOP
-- If we want to reverse the loop:
FOR i IN REVERSE 1..v_emp_count LOOP
...
END LOOP;

** EXAMPLE OF A SIMPLE LOOP **

SET SERVEROUTPUT ON

DECLARE
v_emp_id employees.employee_id%TYPE := 0;
v_emp_count NUMBER NOT NULL := 0;
v_bonus NUMBER(8,2) := 0;
v_salary employees.salary%TYPE;
v_hire_date employees.hire_date%TYPE;

BEGIN
SELECT COUNT(*) INTO v_emp_count FROM employees;
LOOP
SELECT MIN(employee_id) INTO v_emp_id FROM employees WHERE employee_id > v_emp_id;
SELECT salary, hire_date INTO v_salary, v_hire_date FROM employees WHERE employee_id = v_emp_id;
v_bonus :=
CASE
WHEN ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) = 10
THEN v_salary * 0.5
WHEN ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) >= 5 AND ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) < 10
THEN v_salary * 0.25
ELSE
v_salary * 0.1
END; -- CASE ends.
DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ' gets a bonus amount of ' || v_bonus);
v_emp_count := v_emp_count -1;
EXIT WHEN v_emp_count = 0;
END LOOP;
END;


**** CURSORS ****
%FOUND If the cursor affects to at least one row. true or false
%NOTFOUND
%ROWCOUNT

-- The function below does NOT update the record.
-- It just sets the value to itself. That is why
-- the column name prevalesces over the variable name.
declare
department_name ad_departments.department_name%type := 'EDUCATION';
begin
update ad_departments
set department_name = department_name
where department_id=50;
end;

