SET SERVEROUTPUT ON
DECLARE
today DATE := SYSDATE;
tomorrow DATE := today + 1;
BEGIN
DBMS_OUTPUT.PUT_LINE('Hello World');
DBMS_OUTPUT.PUT_LINE('TODAY IS: ' || today);
DBMS_OUTPUT.PUT_LINE('TOMORROW WILL BE: ' || tomorrow);
END;