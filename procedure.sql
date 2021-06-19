CREATE OR REPLACE  PROCEDURE SP_LIST_EMP_X_DPTO
	(
	dept_id IN hr.employees.DEPARTMENT_ID%TYPE
	)
	IS
	v_name HR.employees.FIRST_NAME%TYPE;
    v_surname HR.employees.LAST_NAME%TYPE;
    v_salary HR.employees.SALARY%TYPE;
    v_date HR.employees.HIRE_DATE%TYPE;
    v_dept HR.departments.DEPARTMENT_NAME%TYPE;
    v_city HR.locations.CITY%TYPE;
	BEGIN
	  for cur in (select employee_id from HR.EMPLOYEES  where department_Id = dept_id) loop
        SELECT e.FIRST_NAME,e.LAST_NAME,e.SALARY,e.HIRE_DATE,d.DEPARTMENT_NAME,l.CITY
        INTO v_name, v_surname, v_salary, v_date, v_dept, v_city
		FROM EMPLOYEES e join  DEPARTMENTS d on (e.DEPARTMENT_ID = d.DEPARTMENT_ID) join LOCATIONS l on (d.LOCATION_ID = l.LOCATION_ID)
		WHERE employee_id = cur.employee_id;
		DBMS_OUTPUT.PUT_LINE('First Name '|| v_name);
        DBMS_OUTPUT.PUT_LINE('Last Name '|| v_surname);
        DBMS_OUTPUT.PUT_LINE('Salary '|| v_salary);
        DBMS_OUTPUT.PUT_LINE('Hire Date '|| v_date);
        DBMS_OUTPUT.PUT_LINE('Department Name '|| v_dept);
        DBMS_OUTPUT.PUT_LINE('City '|| v_city);
	  end loop;
	end;
    
EXECUTE SP_LIST_EMP_X_DPTO (90);

