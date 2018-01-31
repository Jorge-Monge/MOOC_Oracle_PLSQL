**** ASSIGNMENT 1
Create an anonymous block that calculates the Provident Fund contribution amount
for the faculty whose faculty_id = 105.

SET SERVEROUTPUT ON

DECLARE
v_basic_percent NUMBER(2) := 45;
v_pf_percent NUMBER(2) := 12;
v_firstname ad_faculty_details.first_name%TYPE;
v_salary ad_faculty_details.salary%TYPE;
BEGIN
SELECT first_name, salary
INTO v_firstname, v_salary
FROM ad_faculty_details
WHERE faculty_id = 105;
DBMS_OUTPUT.PUT_LINE(v_firstname || '''s gross salary is: ' || v_salary);
DBMS_OUTPUT.PUT_LINE(v_firstname || '''s base salary is: ' || v_salary*v_basic_percent/100);
DBMS_OUTPUT.PUT_LINE(v_firstname || '''s PF contribution is: ' || v_salary*(v_basic_percent/100)*(v_pf_percent/100));
END;
/

**** ASSIGNMENT 2
Create a PL/SQL block that selects the maximum department ID in the 'ad_departments' table and displays it.

SET SERVEROUTPUT ON

DECLARE
v_max_deptID ad_departments.department_id%TYPE;
BEGIN
SELECT MAX(department_id)
INTO v_max_deptID
FROM ad_departments;
DBMS_OUTPUT.PUT_LINE('Maximum department ID is: ' || v_max_deptID);
END;
/

**** ASSIGNMENT 3
Create a PL/SQL block that inserts a new record in the 'ad_departments' table with the following values:
Department ID: Current maximum department ID + 10
Department name: Education
HOD: null

Print the following in the output:
- Value of the maximum department id.
- Number of rows inserted in the ad_departments table
- New department record that is inserted

SET SERVEROUTPUT ON

DECLARE
v_max_deptID ad_departments.department_id%TYPE;
v_inserted_rec ad_departments%ROWTYPE;
BEGIN
SELECT MAX(department_id)
INTO v_max_deptID
FROM ad_departments;
DBMS_OUTPUT.PUT_LINE('Maximum department ID is currently: ' || v_max_deptID);

INSERT INTO ad_departments (department_id, department_name, hod)
VALUES ((SELECT MAX(department_id) + 10 FROM ad_departments), 'Education', null);
DBMS_OUTPUT.PUT_LINE('Number of rows inserted: ' || SQL%ROWCOUNT);

END;
/


**** ASSIGNMENT 4

SET SERVEROUTPUT ON

DECLARE
v_max_deptID ad_departments.department_id%TYPE;

BEGIN
SELECT MAX(department_id)
INTO v_max_deptID
FROM ad_departments;

UPDATE ad_departments
SET hod = 'JEN YAM'
WHERE department_id = v_max_deptID;

END;
/



**** ASSIGNMENT 5

CREATE TABLE messages (results VARCHAR2(80));

BEGIN
FOR i IN 1..10 LOOP
	INSERT INTO messages(results)
	VALUES (TO_CHAR(i));
END LOOP;
END;


**** ASSIGNMENT 6

CREATE TABLE results AS
SELECT a.first_name, b.exam_id, c.course_name, b.marks
FROM ad_student_details a, ad_exam_results b, ad_course_details c
WHERE a.student_id = b.student_id
AND c.course_id = b.course_id;

ALTER TABLE results ADD stars VARCHAR2(50);

Create a PL/SQL block that inserts an asterisk in the 'stars' column for every 20 marks scored in an exam 
by the student whose first name is JACK.

SET SERVEROUTPUT ON

DECLARE
v_asterisks results.stars%TYPE;
CURSOR C1 IS SELECT first_name, marks, FLOOR(marks/20) AS stars FROM results;
BEGIN

FOR i IN C1
LOOP
    v_asterisks := '';
    IF i.stars = 1 THEN
        v_asterisks := '*';
    ELSIF i.stars >1 THEN
        FOR s IN 1..i.stars LOOP
            v_asterisks := v_asterisks || '*';  
        END LOOP;  
    END IF;
    UPDATE results
    SET stars = v_asterisks
    WHERE first_name = i.first_name
    AND marks = i.marks
    AND first_name = 'JACK';
    
END LOOP;
END;
