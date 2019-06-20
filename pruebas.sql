select insertarartista('JOHN', 'LENNON', 'UK', 'SOLISTA');
select insertaralbum('Imagine', '1980-01-23', 0, 'virgin', 'rock', 1);
select insertarcancion('real love', 120, false,1);
select insertarcancion('twist and shout', 130, false,1);
select insertarcancion('revolution', 180, false,1);

select insertartarjeta(5544332211,'Visa', 222,'2025-01-01');
select insertarusuario('miguel', 'jorquera1401@aol.co.uk','1234', 'chile', 'masculino', 'Premium',5544332211);
select insertarusuario('javier', 'jaliaga@aol.co.uk','1234', 'chile', 'masculino', 'Free',0);

select * from tarjeta;