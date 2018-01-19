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