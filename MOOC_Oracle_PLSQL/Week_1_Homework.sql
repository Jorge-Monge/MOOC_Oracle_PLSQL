ASSIGNMENT 1

Blocks a, c and d will execute with no errors.
Incorrect: a: DECLARE is needed!
Incorrect: c: There needs to be some code between the BEGIN and the END!

ASSIGNMENT 3 (variable names)

c: incorrect because it contains a single quotation mark ("today's_date")
d: incorrect because its length is > 30 chars.
f: incorrect because it does not start with a letter (#number)

ASSIGNMENT 4 (Identify invalid variable declarations)

a: PLS_INTEGER: valid oracle PL/SQL datatype (signed integer)
b: Declaration of CONSTANT must contain an initialization assignment (PRINTER_NAME constant VARCHAR2(10);)
c: String must be enclosed in single quotation marks.

ASSIGNMENT 7 (BIND variables)

SET SERVEROUTPUT ON
VARIABLE b_basic_percent NUMBER
VARIABLE b_pf_percent NUMBER
BEGIN
:b_basic_percent := 45;
:b_pf_percent := 12;
END;
/
PRINT b_basic_percent;
PRINT b_pf_percent;

