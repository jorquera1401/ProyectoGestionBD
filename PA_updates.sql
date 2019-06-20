create function actualizar_artista(id_artista int,nombre_art text,apellido_art text,nacionalidad_art text,descripcion_art text)returns void as 
$$
begin
	if(descripcion_art='') then
		update artista set nombre = nombre_art, apellido = apellido_art,
			nacionalidad = nacionalidad_art where artista.id = id_artista;
	else
		update artista set nombre = nombre_art, apellido = apellido_art,
			nacionalidad = nacionalidad_art,descripcion = descripcion_art 
			where artista.id = id_artista;
	end IF;
end;
$$
LANGUAGE plpgsql;

create function actualizar_album(id_album integer,nombre_al text,fecha_de_lanzamiento_al date,sello_al text,genero_al text,artista_asociado_al integer)returns void as
$$
begin
	update album set nombre = nombre_al, fecha_de_lanzamiento = fecha_de_lanzamiento_al,sello = sello_al ,genero = genero_al, artista_asociado = artista_asociado_al 
		where album.id = id_album;
end;
$$
LANGUAGE plpgsql;

create function actualizar_cancion(id_cancion integer,nombre_can text,duracion_can integer,explicito_can boolean,album_asociado_can integer)returns void as
$$
begin
 update cancion set nombre = nombre_Can,duracion = duracion_can,explicito = explicito_can, album_asociado = album_asociado_can  where cancion.id = id_cancion;                    
end;
$$
LANGUAGE plpgsql;

create function actualizar_usuario(nombre_antiguo text,nombre_nuevo text,correo_u text,contrasena_u text,pais_u text,sexo_u tipo_sexo) returns void as
$$
begin
	update usuario set nombre = nombre_nuevo, correo = correo_u, contrasena = contrasena_u,pais = pais_u,sexo = sexo_u where usuario.nombre = nombre_antiguo;
end;
$$
LANGUAGE plpgsql;


	