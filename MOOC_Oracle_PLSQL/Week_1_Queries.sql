ORACLE USERS IN SQL DEVELOPER:
Do not connect with the SYSDBA user. Connect with
these instead:
user   password
ora1	ora1
ora2	ora2
ora3	ora3
ora4	ora4

-- Enabling the server output in Oracle SQL Developer:
SET SERVEROUTPUT ON

BEGIN
	DBMS_OUTPUT.PUT_LINE('Hello World!');
END;

-- VARIABLES
Their names must start with a letter. Can include letter, numbers,
'$', '_' and '#' signs. Cannot be longer than 30 characters.

DECLARE
	-- Declare variables, assigning types and initial value.
	v_empid NUMBER(6) NOT NULL := 100;
	v_fname VARCHAR(20);

BEGIN
	v_empid := 110; --':='' is the assignment operator.
	v_fname := get_firstname(v_empid);
END;

-- Variable syntax:
identifier [CONSTANT] datatype [NOT NULL][:= | DEFAULT expr]

SET SERVEROUTPUT ON
DECLARE
v_myName VARCHAR(20);
BEGIN
DBMS_OUTPUT.PUT_LINE('My name is: ' || v_myName);
v_myName := 'John';
DBMS_OUTPUT.PUT_LINE('My name is: ' || v_myName);
END;

VARIABLE CLASSIFICATION:
PL/SQL Variables vs. Non-PL/SQL Variables

https://www.youtube.com/redirect?q=https%3A%2F%2Fdocs.oracle.com%2Fdatabase%2F122%2FLNPLS%2Fplsql-data-types.htm%23LNPLS003&redir_token=Le_THFioC_VPp40EaZjHfbo-afl8MTUxNjMzOTg0OUAxNTE2MjUzNDQ5&v=rkjeZajD2Zs&event=video_description

SCALAR VARIABLES
Hold a single value, and have no internal components.
They subclassify in:
	- Numbers (DOUBLE PRECISION, INTEGER, etc.)
	- Strings (CHAR, STRING, VARCHAR, etc.)
	- BOOLEAN
	- Time (DATE, TIMESTAMP)

EXAMPLES OF SCALAR VARIABLE DECLARATION:
DECLARE
v_emp_job VARCHAR2(9);
v_count_loop BINARY_INTEGER := 0;
v_dept_total_sal NUMBER(9,2) := 0;
v_orderdate DATE := SYSDATE + 7;
c_tax_rate CONSTANT NUMBER(3,2) := 8.25;
v_valid BOOLEAN NOT NULL := TRUE;
BEGIN

%TYPE Attributes
%TYPE attribute is used to declare a variable according to another previouly declared variable
or database column.
By using the %TYPE attribute, PL/SQL determines the data type and size of the variable
when the block is compiled.
Examples:
-- Definition of variable taking its datatype from a table column:
v_emp_lname employees.last_name%TYPE;
-- Definition of variable taking its datatype from previously declared variable:
v_balance NUMBER(7,2);
v_min_balance v_balance%TYPE := 1000;

REFERENCE Variables
https://www.youtube.com/redirect?q=https%3A%2F%2Fwww.oracle.com%2Fpls%2Ftopic%2Flookup%3Fctx%3Ddb122%26id%3DLNPLS00605&redir_token=Le_THFioC_VPp40EaZjHfbo-afl8MTUxNjMzOTg0OUAxNTE2MjUzNDQ5&v=rkjeZajD2Zs&event=video_description
Reference data types hold values, called pointers, which
point to a storage location.

Large OBject (LOB) Variables
CLOB Character LOB For instance, to store books.
BLOB Binary LOB For instance, to store images
BFILE For instance, to store large binary files (e.g. movies)
	BFILES are not stored inside the DB, only a POINTER to the data is stored.

COMPOSITE DATA TYPES
Contain internal elements that you can treat as individual variables.
They are available by using PL/SQL collection and record variables.

VARIABLE NAMING CONVENTIONS FOR THE MOOC COURSE
Variable v_variableName
Constant c_constantName
Subprogram parameter p_parameterName
Bind (host) variable b_bindName
Cursor cur_cursorName
Record rec_recordName
Type type_typeName
Exception e_exceptionName
File handle f_fileHandlename

BIND VARIABLES or HOST VARIABLES
Bind variables are not created in the DECLARE block.
Bind variables are created in the environment, and not
in the declarative section of a PL/SQL block.
VARIABLE b_emp_salary NUMBER
BEGIN
SELECT salary
INTO :b_emp_salary
FROM employees
WHERE employee_id = 178;
END;

PRINT b_emp_salary;

BIND variables are scoped to the environment in which they are executed. That means
that they are available even after the PL/SQL block has run.

BIND variables are preceded by a colon (:)

VARIABLE b_emp_salary NUMBER
SET AUTOPRINT ON /* Prints the system-modified block to the output */

DECLARE
    v_empno NUMBER(6) := &empno; /* The ampersand before the name of the variable
                                    causes the system to prompt the user for the
                                    value of the variable */
BEGIN
    SELECT salary
    INTO :b_emp_salary
    FROM employees
    WHERE employee_id = v_empno;
END;
/

PRINT b_emp_salary;


*** PL/SQL LEXICAL UNITS ***

IDENTIFIERS
https://www.youtube.com/redirect?redir_token=WHHIvxoIf7rNPBJT9IV1z4FfWJh8MTUxNjQyNjMxNkAxNTE2MzM5OTE2&q=https%3A%2F%2Fwww.oracle.com%2Fpls%2Ftopic%2Flookup%3Fctx%3Ddb122%26id%3DLNPLS99973&v=SgsAglyTVC4&event=video_description
Names given to PL/SQL objects (e.g. variables)

DELIMITERS
https://www.youtube.com/redirect?redir_token=WHHIvxoIf7rNPBJT9IV1z4FfWJh8MTUxNjQyNjMxNkAxNTE2MzM5OTE2&q=https%3A%2F%2Fwww.oracle.com%2Fpls%2Ftopic%2Flookup%3Fctx%3Ddb122%26id%3DLNPLS189&v=SgsAglyTVC4&event=video_description
Simple or compound symbols with special meaning in PL/SQL.
For instance, semi-colon, '--' to start comments,
|| to concatenate strings
Examples of compound symbols: /* <comment> */, := (assignment operator)

LITERALS
Any value that is assigned to a variable. Subclassified in Character Literals,
Numeric Literals, and Boolean literals.

COMMENTS

*** EXAMPLE OF SEQUENCE ***
SET SERVEROUTPUT ON
DECLARE
v_new_empid NUMBER;
BEGIN
v_new_empid := employees_seq.NEXTVAL;
DBMS_OUTPUT.PUT_LINE('The new employee ID is: ' || v_new_empid);
END;
/

CONCEPT OF IMPLICIT DATATYPE CONVERSIONS VS. EXPLICIT DATATYPE CONVERSIONS


METHODS FOR EXPLICIT DATATYPE CONVERSIONS:
TO_CHAR(), TO_DATE(), TO_NUMBER()
v_dateofjoining DATE := TO_DATE('February 02, 2000', 'Month DD, YYY')

QUALIFYING A DECLARE BLOCK SO THAT WE CAN REFER TO THEIR SPECIFIC VARIABLES
(Maybe from inside an inner block with a variable of the same name)

BEGIN
	<< outer >> DECLARE
	v_father_name VARCHAR2(20) := 'Jorge';
	BEGIN
		DECLARE
			v_father_name VARCHAR(20) := 'Pedro';
		BEGIN
			DBMS_OUTPUT.PUT_LINE('Name of the father: ' || outer.v_father_name);
		END;
		DBMS_OUTPUT.PUT_LINE('Name of the father: ' || v_father_name);
	END;
END outer;
/

