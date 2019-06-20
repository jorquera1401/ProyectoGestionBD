select insertarartista('JOHN', 'LENNON', 'UK', 'SOLISTA');
select insertaralbum('Imagine', '1980-01-23', 0, 'virgin', 'rock', 1);
select insertarcancion('real love', 120, false,1);
select insertarcancion('twist and shout', 130, false,1);
select insertarcancion('revolution', 180, false,1);

select insertartarjeta(5542,'Visa', 1234,'2025-01-01');
select insertarusuario('Miguel', 'jorquera111@aol.co.uk', 'conca','chile','M','Premium', 5542);
select insertarusuario('javier', 'jaliaga@aol.co.uk','1234', 'chile', 'M', 'Free',0);

select actualizar_usuario('javier','Javier1','reivaj_31@hotmail.com','4321','Chile','M');
