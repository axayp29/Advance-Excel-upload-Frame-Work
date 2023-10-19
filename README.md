Advance Excel Upload FrameWork

Functionality :- 

1. Excel Column Datatype validation. You can Specify the Column Type in the Array.
   Like If you have 4 field in Excel
    1. NUMERIC
    2. STRING
    3. BOOLEAN
    4. STRING
   In Additions If cell is blank and Datatype not validate then it's return not valid.

2. Specify The Custom validation
    Like if 
     1. Date and Time formate Then validate formate is valid or not
     2. If Column have a Employee code then Check employee code is exist or not.
     3. If Shift Code if employee and Shift code not matched then non validate.
     Other You can Specify Based on you requirement.

3. In The specify location we store the excel file if directory is not found then create automatically.
4. In the DB saved uploaded file,uploaded file location,uploaded time and uploaded by and other field. also store md5hashCode for proof purpose.
5. Used Datatable in front-end each row editable if row is validate then row green otherwise row in red. also delete row Functionality.
6. For what reason row is not validate show error message when user can click on info-button.
7. After changing the row user can validate the data again.
8. Validate and non-validate count on front-end.
