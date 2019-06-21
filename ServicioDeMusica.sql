create table artista(
	id serial primary key,
	nombre text not null,
	apellido text not null,
	nacionalidad text not null,
	descripcion text default 'Artista Musical'
);

create table album(
	id serial primary key,
	nombre text not null,
	fecha_de_lanzamiento date not null,
	duracion integer not null default 0,
	sello text not null,
	genero text not null,
	artista_asociado integer references artista(id) on delete restrict on update cascade
);
create table cancion(
	id serial primary key,
	nombre text not null,
	duracion integer not null,
	num_de_reproducciones integer not null default 0,
	explicito boolean default null,
	album_asociado integer references album(id) on delete restrict on update cascade
);
create type tipo_sexo as enum ('M','F');
create table usuario(
	id serial primary key,
	nombre text UNIQUE not null,
	correo text UNIQUE not null,
	contrasena text not null,
	pais text default null,
	sexo tipo_sexo not null
);


create table usuario_escucha_cancion(
	id serial primary key,
	usuario_asociado int references usuario(id) on delete restrict on update cascade,
	cancion_asociada int references cancion(id) on delete restrict on update cascade
);

create type ty_playlist as enum('Publica','Privada');
create table playlist(
	id serial primary key,
	nombre text not null,
	fecha_creacion TIMESTAMP DEFAULT now(),--se setea default la fecha actual del sistema
	tipo ty_playlist not null default 'Publica',
	usuario_asociado integer references usuario(id) on delete restrict on update cascade

);

create table anadir_cancion_playlist(
	id serial primary key,
	playlist_asociada integer references playlist(id) on delete restrict on update cascade,
	usuario_asociado integer references usuario(id) on delete restrict on update cascade,
	cancion_asociada integer references cancion(id) on delete restrict on update cascade
);
create type ty_tarjeta as enum('Visa','Mastercard');
create table tarjeta(
	numero_tarjeta bigint primary key,
	tipo_tarjeta ty_tarjeta not null,
	codigo_seguridad integer not null UNIQUE,
	fecha_vencimiento date not null
);

create table usuario_free(
	id_usuario integer primary key references usuario(id) on delete restrict on update cascade
);
create table usuario_premium(
	id_usuario integer primary key references usuario(id) on delete restrict on update cascade,
	fecha_renovacion date not null,
	tarjeta_asociada bigint references tarjeta(numero_tarjeta) on delete restrict on update cascade
);

create table pago(
	id serial primary key,
	fecha TIMESTAMP DEFAULT now(),--se setea default la fecha actual del sistema
	total_pago integer not null,
	usuario_asociado integer references usuario(id) on delete restrict on update cascade
);

-- triggers y procedures
--procedimiento almacenado para insertar pago.
create function insertarpago(total_pago integer,usuario_asociado integer)returns void as
$$
begin
 insert into pago(total_pago,usuario_asociado) values(total_pago,usuario_asociado);
end;
$$
LANGUAGE plpgsql;

--procedimiento almacenado para insertar tarjeta de pago.
create function insertartarjeta(numero_tarjeta bigint,tipo ty_tarjeta,codigo_seguridad integer, fecha_vencimiento integer)returns void as
$$
begin
	insert into tarjeta values(numero_tarjeta,tipo,codigo_seguridad,fecha_vencimiento);
end;
$$
LANGUAGE plpgsql;


--procedimiento almacenado para insertar a la tabla cuando un usuario añade una cancion a una playlist.
create function insertaranadircancionplaylist(playlist_asociada integer,usuario_id integer,cancion_asociada integer) returns void as
$$
declare 
id_premium integer;
begin
	execute format('select usuario_premium.id_usuario from usuario_premium where usuario_premium.id_usuario = usuario_id;')
	into id_premium;
	if(id_premium=null) then
		RAISE NOTICE 'No es premium, no puede agregar canciones a  una playlist';
	else
		insert into anadir_cancion_playlist(playlist_asociada,usuario_id,cancion_asociada) values(playlist_asociada,usuario_id,cancion_asociada);
	end if;
end;
$$
LANGUAGE plpgsql;

--procedimiento almacenado para insertar playlist.
create function insertarplaylist(nombre text,tipo text,usuario_asociado integer)returns void as
$$
declare 
id_premium integer;
begin
	execute format('select id_usuario from usuario_premium where id_usuario = usuario_asociado')
	into id_premium;
	IF(id_premium=null) then
		RAISE NOTICE 'Solo usuarios premium pueden crear playlist, cambiate! ';
	 
	ELSE
		IF(tipo='Publica') then
			insert into playlist(nombre,tipo,usuario_asociado) values(nombre,'Publica',usuario_asociado);
		ELSEIF(tipo='Privada') then
			insert into playlist(nombre,tipo,usuario_asociado) values(nombre,'Privada',usuario_asociado);
		ELSE
			insert into playlist(nombre,usuario_asociado) values(nombre,usuario_asociado);
		end IF;
	END IF;
end;
$$
LANGUAGE plpgsql;


--proceso almacenado para insertar un usuario que escucha una canción.
create function insertarUsuarioEscuchaCancion(usuario_asociado integer,cancion_asociada integer)returns void as
$$
begin
	insert into usuario_escucha_cancion(usuario_asociado,cancion_asociada) values(usuario_asociado,cancion_asociada);
end;
$$
LANGUAGE plpgsql;


--proceso almacenado para insertar un Artista
create function insertarArtista(nombre text,apellido text,nacionalidad text,descripcion text) returns void as
$$
begin
	IF(descripcion='') then
		insert into artista(nombre,apellido,nacionalidad) values(nombre,apellido,nacionalidad);
	ELSE
		insert into artista(nombre,apellido,nacionalidad,descripcion) values(nombre,apellido,nacionalidad,descripcion);
	end IF;
end;
$$
LANGUAGE plpgsql;

--Proceso almacenado para insertar un Album.
create function insertarAlbum(nombre text,fecha_de_lanzamiento date,duracion integer,sello text,
	genero text,artista_asociado integer)returns void as 
$$
begin
	insert into album(nombre,fecha_de_lanzamiento,duracion,sello,genero,artista_asociado) 
		values(nombre,fecha_de_lanzamiento,duracion,sello,genero,artista_asociado);
end;
$$
LANGUAGE plpgsql;

--Proceso almacenado para insertar una canción.
create function insertarcancion(nombre text,duracion integer,explicito boolean,
	album_asociado integer)returns void as
$$
begin
	insert into cancion(nombre,duracion,explicito,album_asociado) values(nombre,duracion,explicito,album_asociado);
end;
$$
LANGUAGE plpgsql;


--Proceso almacenado para insertar un usuario.
create function insertarusuario(nombre text,correo text,contrasena text,pais text,sexo tipo_sexo,tipo text, tarjeta_numero bigint)returns void as
$$
declare
id_usuario integer;
begin
	
	insert into usuario(nombre,correo,contrasena,pais,sexo) values(nombre,correo,contrasena,pais,sexo);	
	execute format('select usuario.id from usuario where usuario.nombre = nombre;')
	into id_usuario;
	IF (tipo='Premium') then
		insert into usuario_premium(id_usuario,fecha_renovacion, tarjeta_asociada) values(id_usuario, (select current_date + interval '1 month'),tarjeta_numero);
	else
		insert into usuario_free values(id_usuario);
	end if;	
end;
$$
LANGUAGE plpgsql;



--trigger y procedure para cambiar la duracion del album cuando se ingresa una cancion.
create function PA_insertar() RETURNs TRIGGER AS
$$
begin 
	update album set duracion = (duracion + new.duracion) Where new.album_asociado = album.id;
	RETURN new;
end
$$
LANGUAGE plpgsql;

create trigger insertar
	after insert
	on cancion
	For each row
	execute procedure PA_insertar();

--trigger y procedure para actualizar la duracion de un album.
create function PA_actualizar_duracion() returns trigger as 
$$
begin
	update album set duracion = (album.duracion - old.duracion) where old.album_asociado = album.id;
	update album set duracion = (album.duracion + new.duracion) where new.album_asociado = album.id;
	return new;
end
$$
LANGUAGE plpgsql;

create trigger actualizar_duracion
	after update
	on cancion
	for each row
	execute procedure PA_actualizar_duracion();


--trigger y procedure para actualizar duracion de album cuando se borra una cancion de él.
create function PA_borrar_duracion()
	Returns trigger AS
	$$
	begin
		update album set duracion = (album.duracion - old.duracion) where old.album_asociado = album.id;
		return new;
	end
	$$
LANGUAGE plpgsql;

create trigger borrar_duracion
	after delete
	on cancion
	for each row
	execute procedure PA_borrar_duracion();



create function PA_aumentar_reproduccion()
	returns trigger as
	$$
	begin 
		update cancion set num_de_reproducciones = (num_de_reproducciones + 1) where new.cancion_asociada = cancion.id;
		return new;
	end
	$$
LANGUAGE plpgsql;
--trigger para aumentar el numero de reproducciones cuando se un usuario escucha la cancion
-- osea cuando se añade un dato a la tabla usuario_escucha_cancion y la clave foranea es de la canción.
create trigger tr_aumentar_n_reproduccion
	after insert
	on usuario_escucha_cancion
	for each row
	execute procedure PA_aumentar_reproduccion();

