set serveroutput on;
create table store_data(
loaded_sysmbol varchar2(50),
rownumbr number,
colmn_number char
);
--drop table store_data;

DECLARE
  pos NUMBER;
BEGIN
  SELECT count(*) INTO pos FROM user_tables 
    WHERE TABLE_NAME = 'Tic_Tac_Toe';
  IF pos = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE Tic_Tac_Toe(
      row_ID NUMBER,
      c CHAR,
      d char,
      f char
    )';
 END IF;
  exception
  when others then
  if sqlcode = -955 then
  dbms_output.put_line('Table already Exists');
  end if;
END;
/


CREATE OR REPLACE FUNCTION numToColName(numbr IN NUMBER)
RETURN CHAR
IS
BEGIN
  IF numbr=1 THEN
    RETURN 'c';
  ELSIF numbr=2 THEN
    RETURN 'd';
  ELSIF numbr=3 THEN
    RETURN 'f';
  ELSE 
    RETURN '_';
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE display_game AS
BEGIN
  dbms_output.enable(10000);
  dbms_output.put_line(' ');
  --dbms_output.put_line('     '|| c || ' ' || d || ' '  || f);
  FOR x in (SELECT * FROM Tic_Tac_Toe ORDER BY row_ID) LOOP
    dbms_output.put_line('    '|| x.c|| ' ' || x.d || ' '  || x.f);
  END LOOP; 
  
  dbms_output.put_line(' ');
 
END;

/



create or replace package silly_p as
  v number:=0;
   X number:=0;
   y number:=0;
   s number:=0;
     function check_first return number;
     
   function reset_variable_X return number;
   function reset_variable_v return number;
 function show_v return number;
 function show_X return number;
 Function increment_v return number;
 Function increment_X return number;

end;
/

create or replace package body silly_p as
function show_v return number as   
begin
if v!=0 then

       return v;
       else
       v:=v+1;
       return v;
       end if;
     end show_v;
function show_X return number as   
begin
      if X!=0 then

       return X;
       else
       X:=X+1;
       return X;
       end if;
     end show_X;
     Function increment_X
    return Number
    as
     begin
        X := X+1;
        return X;
  end increment_X;
    Function increment_v
    return Number
    as
     begin
        v := v+1;
        return v;
  end increment_v;
  function reset_variable_X return number
  as
  begin
  v:=0;
  X:=0;
 
  return X;
  end reset_variable_X;
  function reset_variable_v return number
  as
  begin
  v:=0;
  X:=0;
 
  return v;
  end reset_variable_v;
  
function check_first return number
as
begin
  s:=s+1;
  return s;
  dbms_output.put_line('s value is  ='||s); 
 
  end;

  
  end silly_p;
   /

CREATE OR REPLACE FUNCTION count_symbol(symbol IN varchar2)
RETURN number
IS
BEGIN
  RETURN ('SELECT COUNT(*) FROM store_data WHERE loaded_sysmbol= ' || symbol);

 -- RETURN ('SELECT '|| numcol ||' FROM Tic_Tac_Toe WHERE row_ID=' || yvalue);
END;
/


Create or Replace Procedure PlayGame(Symbol IN char, Column_Num IN Number, Row_Num IN Number) AS
selected_position Tic_Tac_Toe.c%type;
colm Char;
Nxt_Symbol char;
X_count number;
O_count number;
total_count char;

total_count1 char;

first_count number;
wrong_turn exception;
First_Turn exception;
temp1 varchar2(200);
temp2 varchar2(200);
BEGIN
--SELECT Symbol INTO New_Symbol FROM DUAL;
SELECT Row_Num INTO x_count FROM DUAL;
SELECT numToColName(Column_Num) INTO colm FROM DUAL;
 
 --first_count:= silly_p.check_first;
   --dbms_output.put_line( 'First Count is ='||first_count); 

  -- dbms_output.put_line('X count Count is ='||total_count);  
 --IF Symbol='O' THEN
--if (first_count ='1')then
-- raise First_Turn;
-- end if;
-- end if;
  IF Symbol='X' THEN
     Nxt_Symbol:='O';

--mp1:= (SELECT count (*) FROM store_data WHERE loaded_sysmbol= 'X') ;
  O_count :=silly_p.show_X;
   X_count := silly_p.increment_v;
 
  --dbms_output.put_line('X value='||X_count||'V value='|| O_count|| 'First Count is ='||temp1);  

     ELSE
      Nxt_Symbol:='X';
    
    X_count := silly_p.show_v ;
         O_count := silly_p.increment_X;
     
        -- dbms_output.put_line('X value='||X_count||'V value='|| O_count|| 'First Count is ='||total_count1);  
        
     END IF;
      
         
if not  X_count <= O_count  then
raise wrong_turn;
end if;
 
 EXECUTE IMMEDIATE ('SELECT ' || colm || ' FROM Tic_Tac_Toe WHERE row_ID=' || Row_Num) INTO selected_position;

  IF selected_position='_' THEN
    EXECUTE IMMEDIATE ('UPDATE Tic_Tac_Toe SET ' || colm || '=''' || Symbol || ''' WHERE row_ID=' || Row_Num);
    dbms_output.put_line('play excetued at'||'colmn = ' || colm|| 'Row_Num ='||Row_Num||' with Symbol= '|| Symbol);
      --EXECUTE IMMEDIATE ('insert into Store_data'||' values('colm', 'x_count', 'New_Symbol')');
       insert into store_data(
       
loaded_sysmbol,
rownumbr,
colmn_number
)
values
(
Symbol,
Row_Num,
colm


);
     IF Symbol='X' THEN
     Nxt_Symbol:='O';
     
     ELSE
      Nxt_Symbol:='X';
     END IF;
    display_game();
    --New_Symbol:= Symbol;
    dbms_output.put_line('Player ' || Nxt_Symbol || ' turn : EXECUTE play(''' || Nxt_Symbol || ''', ColumnPos, RowPos);');
   
   ELSE
    dbms_output.enable(10000);
    dbms_output.put_line('You cannot play this square, it is already played');
   
   END IF;
  
        
  exception
  when wrong_turn then 
  total_count:=silly_p.reset_variable_X;
  total_count1:=silly_p.reset_variable_v;
  dbms_output.put_line('You cannot play this turn, it is nxt players turn');
  when First_Turn then
    dbms_output.put_line('test turn tO NEXT');


 
END PlayGame;
/



CREATE OR REPLACE PROCEDURE reset_game AS
newval number;
newval1 number;
ii NUMBER;
BEGIN

  DELETE FROM Tic_Tac_Toe;
  FOR ii in 1..3 LOOP
    INSERT INTO Tic_Tac_Toe VALUES (ii,'_','_','_');
    dbms_output.put_line('ii='|| ii);
  END LOOP; 
  dbms_output.enable(10000);
  display_game();
  newval:=silly_p.reset_variable_X;
  newval1:=silly_p.reset_variable_v;
  dbms_output.put_line('The game is ready to play : EXECUTE play(''X'', x, y);');
  
END;
/


CREATE OR REPLACE PROCEDURE winner(symbol IN VARCHAR2) AS
BEGIN
  dbms_output.enable(10000);
  display_game();
  
  dbms_output.put_line('The player ' || symbol || ' Won !!'); 
  dbms_output.put_line('---------------------------------------');
  dbms_output.put_line('Launch of''a new game...');
  reset_game();

END;
/


CREATE OR REPLACE FUNCTION wincol_request(numcol IN VARCHAR2, symbol IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
  RETURN ('SELECT COUNT(*) FROM Tic_Tac_Toe WHERE ' || numcol || ' = '''|| symbol ||''' AND ' || numcol || ' != ''_''');
END;
/
-- fonction de creation de requetes de colone
-- column query creation function
CREATE OR REPLACE FUNCTION wincross_request(numcol IN VARCHAR2, yvalue IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
  RETURN ('SELECT '|| numcol ||' FROM Tic_Tac_Toe WHERE row_ID=' || yvalue);
END;
/
-- fonction de test des colones
-- column test function
CREATE OR REPLACE FUNCTION wincol(numcol IN VARCHAR2)
RETURN CHAR
IS
  numbrwin NUMBER;
  avr VARCHAR2(100);
BEGIN
  SELECT wincol_request(numcol, 'X') into avr FROM DUAL;
  EXECUTE IMMEDIATE avr INTO numbrwin;
  IF numbrwin=3 THEN
    RETURN 'X';
  ELSIF numbrwin=0 THEN
    SELECT wincol_request(numcol, 'O') into avr FROM DUAL;
    EXECUTE IMMEDIATE avr INTO numbrwin;
    IF numbrwin=3 THEN
      RETURN 'O';
    END IF;
  END IF;
  RETURN '_';
END;
/
-- fonction de test des diagonales
-- diagonal test function
CREATE OR REPLACE FUNCTION wincross(tmp IN CHAR, colnumbr IN NUMBER, Row_Num IN NUMBER)
RETURN CHAR
IS
  tmpvar CHAR;
  tmpxvar CHAR;
  avr VARCHAR2(56);
BEGIN
  SELECT wincross_request(numToColName(colnumbr), Row_Num) INTO avr FROM DUAL;
  IF tmp IS NULL THEN
    EXECUTE IMMEDIATE (avr) INTO tmpxvar;
  ELSIF NOT tmp = '_' THEN
    EXECUTE IMMEDIATE (avr) INTO tmpvar;
    IF NOT tmp = tmpvar THEN
      tmpxvar := '_';
    END IF;
  ELSE
    tmpxvar := '_';
  END IF;
  RETURN tmpxvar;
END;
/

CREATE OR REPLACE TRIGGER iswinner
AFTER UPDATE ON Tic_Tac_Toe
DECLARE
  CURSOR cr_row IS 
    SELECT * FROM Tic_Tac_Toe ORDER BY row_ID; 
  crlv Number;
  tmpvar CHAR;
  tmpx1 CHAR;
  tmpx2 CHAR;
  r VARCHAR2(100);
BEGIN
  FOR crlv IN cr_row LOOP
    -- test des lignes
    -- line test
    IF crlv.c = crlv.d AND crlv.d = crlv.f AND NOT crlv.c='_' THEN
      winner(crlv.c);
      EXIT;
    END IF;
    -- test des colones
    -- colon test
    SELECT wincol(numToColName(crlv.row_ID)) INTO tmpvar FROM DUAL;
    IF NOT tmpvar = '_' THEN
      winner(tmpvar);
      EXIT;
    END IF;
    -- test des diagonales
    -- diagonal test
    SELECT wincross(tmpx1, crlv.row_ID, crlv.row_ID) INTO tmpx1 FROM dual;
    SELECT wincross(tmpx2, 4-crlv.row_ID, crlv.row_ID) INTO tmpx2 FROM dual;
  END LOOP;
  IF NOT tmpx1 = '_' THEN
    winner(tmpx1);
  END IF;
  IF NOT tmpx2 = '_' THEN
    winner(tmpx2);
  END IF;
END;
/



select * from store_data;
truncate table store_data;


EXECUTE reset_game;
EXECUTE PlayGame('X', 2, 2);
EXECUTE PlayGame('0', 1, 1);
EXECUTE PlayGame('X', 1, 3);


EXECUTE PlayGame('X', 3, 2);
