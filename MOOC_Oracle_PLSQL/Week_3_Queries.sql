COMPOSITE DATA TYPES:
- PL/SQL RECORDS
- COLLECTIONS

*** PL/SQL RECORDS ***

SET SERVEROUTPUT ON;
DECLARE
-- Define a new record type, named rec_emp
TYPE rec_emp IS RECORD
(
v_first_name employees.first_name%TYPE,
v_last_name employees.last_name%TYPE,
v_job_id employees.job_id%TYPE,
v_sal employees.salary%TYPE
);
v_emprec rec_emp;

BEGIN
SELECT first_name,
last_name,
job_id,
salary
INTO v_emprec
FROM employees
WHERE employee_id = 100;
DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emprec.v_first_name || ' ' || v_emprec.v_last_name || chr(10) ||
                     'Job ID: ' || v_emprec.v_job_id || chr(10) ||
                     'Salary: ' || v_emprec.v_sal);
END;



SET SERVEROUTPUT ON;
DECLARE
v_emp_id employees.employee_id%TYPE := 150;
v_new_jobid employees.job_id%TYPE := 'SA_MAN';
v_new_salary employees.salary%TYPE := 10500;
v_remp_rec employees%ROWTYPE;

BEGIN

-- All the attributes can be "dumped" into a ROWTYPE variable:
SELECT * INTO v_remp_rec FROM employees WHERE employee_id = v_emp_id;
DBMS_OUTPUT.PUT_LINE('****Before Promotion****');
DBMS_OUTPUT.PUT_LINE('Employee name: ' || v_remp_rec.first_name || ' ' || v_remp_rec.last_name || chr(10) ||
                     'Job ID: ' || v_remp_rec.job_id || chr(10) ||
                     'Salary: ' || v_remp_rec.salary);
                     
-- Update promotion details into the Employees table.
-- Note how we can overwrite the ROW attributes.
v_remp_rec.job_id := 'SA_MAN';
v_remp_rec.salary := v_new_salary;

UPDATE employees SET ROW = v_remp_rec WHERE employee_id = v_emp_id;

-- All the attributes can be "dumped" into a ROWTYPE variable:
SELECT * INTO v_remp_rec FROM employees WHERE employee_id = v_emp_id;
DBMS_OUTPUT.PUT_LINE('****After Promotion****');
DBMS_OUTPUT.PUT_LINE('Employee name: ' || v_remp_rec.first_name || ' ' || v_remp_rec.last_name || chr(10) ||
                     'Job ID: ' || v_remp_rec.job_id || chr(10) ||
                     'Salary: ' || v_remp_rec.salary);
END;

*** ARRAYS, A TYPE OF PL/SQL COLLECTION ***
COMPOSITE DATA TYPES: PL/SQL RECORDS AND COLLECTIONS

COLLECTIONS can be:
	- Associative arrays
	- Nested tables
	- VARRAYs

Elements within a collection are gotten by its INDEX: variable_name(index)

*** ASSOCIATIVE ARRAYS ***
It consists of only 2 columns, the first one for the index (key) and the second one containing values.
It would be like a Python dictionary where the keys were integers or strings and the values were either SCALAR
or RECORD types.

SET SERVEROUTPUT ON

DECLARE
-- Define the associative array. It will have
-- a value column, whose type is obtained from the employees.salary column
-- and a key column of type integer.
TYPE expense_table_type IS TABLE OF
employees.salary%TYPE INDEX BY PLS_INTEGER;
v_expense_list expense_table_type;
v_array_idx NUMBER;
BEGIN
-- Keys do not need to be sequential, and can be positive or negative
v_expense_list(10) := 100000;
v_expense_list(20) := 25000;
v_expense_list(30) := 85999;

v_array_idx := v_expense_list.first;
WHILE (v_array_idx IS NOT NULL)LOOP
DBMS_OUTPUT.PUT_LINE('Key: ' || v_array_idx || chr(10) || 'Value: ' || v_expense_list(v_array_idx));
v_array_idx := v_expense_list.next(v_array_idx);
END LOOP;

END;
/

*** NESTED TABLES ***

SET SERVEROUTPUT ON
-- *** NESTED TABLES ***
-- They would be equivalent to a Python list.
DECLARE
TYPE email_table_type IS TABLE OF VARCHAR2(50);
emails email_table_type := email_table_type('SKING', 'NKOCHAR', 'LDEHAAN', 'AHUNOLD');
BEGIN
-- Editing an element:
emails(4) := 'jordimonk@yahoo.com';
-- Adding an element to the end of the nested table:
emails.EXTEND;
emails(emails.LAST) := 'canadianmonk@gmail.com';
FOR i IN emails.FIRST..emails.LAST LOOP
DBMS_OUTPUT.PUT_LINE('Key: ' || i || ' Value: ' || emails(i));
END LOOP;
END;
/

*** VARRAYS ***

SET SERVEROUTPUT ON
-- *** VARRAYS ***
-- They would be equivalent to a Python list with a FIXED number of elements.
DECLARE
TYPE email_table_type IS VARRAY(5) OF VARCHAR2(50);
emails email_table_type := email_table_type('SKING', 'NKOCHAR', 'LDEHAAN', 'AHUNOLD', 'canada@gmail.com');
BEGIN
-- Editing an element:
emails(5) := 'jordimonk@yahoo.com';
FOR i IN emails.FIRST..emails.LAST LOOP
DBMS_OUTPUT.PUT_LINE('Key: ' || i || ' Value: ' || emails(i));
END LOOP;
END;
/

PL/SQL RECORDS are used to store related but dissimilar data as a logical unit (A ROW), whereas
COLLECTIONS are used to store similar data as a single unit.

Use RECORDS when you want to store values of different data types that are logically related.
use COLLECTIONS when you want to store values of the same data type.


*** EXPLICIT CURSORS ***

A cursor is a pointer to a private memory area, using which we can read each record details in a
PL/SQL program without firing multiple SELECT queries.
An implicit cursor closes automatically after executing the statement associated with it, whereas
the programmer has to explicitly open and close the explicit cursor before and after processing
the records respectively.

STEPS TO DECLARE AND USE EXPLICIT CURSORS
** DECLARE
** OPEN 
** FETCH. Loads the current row into variables, and the cursor advances.
	It has to be executed in a loop, until the current row is null.
** CLOSE. Release the active set from the private memory area.

SET SERVEROUTPUT ON
-- *** EXPLICIT CURSORS ***
DECLARE
v_emp_id employees.employee_id%TYPE := 0;
v_bonus NUMBER(8,2) := 0;
v_salary employees.salary%TYPE;
v_hire_date employees.hire_date%TYPE;
CURSOR c_emp_cursor IS
SELECT employee_id, salary, hire_date FROM employees;
BEGIN
OPEN c_emp_cursor;
LOOP
FETCH c_emp_cursor INTO v_emp_id, v_salary, v_hire_date;
EXIT WHEN c_emp_cursor%NOTFOUND;
v_bonus :=
CASE
WHEN ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) = 10 THEN
v_salary * 0.5
WHEN ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) >= 5 AND ROUND((MONTHS_BETWEEN(SYSDATE, v_hire_date)/12), 0) < 10 THEN
v_salary * 0.25
ELSE
v_salary * 0.1
END; -- CASE ends.
DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ' gets a bonus amount of ' || v_bonus);
END LOOP;
-- Releases the private memory area allocated for the cursor.
CLOSE c_emp_cursor;

END;
/

