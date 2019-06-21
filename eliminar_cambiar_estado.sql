create function eliminarartista(id_artista integer)returns void as
$$
begin
	update artista set eliminado = true where artista.id = id_artista;
end;
$$
LANGUAGE plpgsql;

create function eliminaralbum(id_album integer)returns void as
$$
begin
	update album set eliminado = true where album.id = integer;
end;
$$
LANGUAGE plpgsql;

create function eliminarcancion(id_cancion integer)returns void as
$$
begin
	update cancion set eliminado = true where cancion.id = id_cancion;
end;
$$
LANGUAGE plpgsql;

create function eliminarplaylist(id_playlist integer)returns void as
$$
begin
	update playlist set eliminado = true where playlist.id = id_playlist;
end;
$$
LANGUAGE plpgsql;

create function eliminarusuario(nombre text)returns void as
$$
declare
id_usuario integer;
id_premium integer;
begin
	execute format('select usuario.id from usuario where usuario.nombre = nombre_usuario;')
	into id_usuario;
	execute format('select usuario_premium.id_usuario from usuario_premium where usuario_premium.id_usuario = id_usuario;')
	into id_premium;
	if(id_premium=null)then
		update usuario_premium set eliminado = true where usuario_premium.id_usuario = id_premium;
		update usuario set eliminado = true where usuario.id = id_usuario;
	else
		update usuario_free set eliminado = true where usuario_free.id_usuario = id_usuario;
		update usuario set eliminado = true where usuario.id = id_usuario;
	end if;			
end;
$$
LANGUAGE plpgsql;
