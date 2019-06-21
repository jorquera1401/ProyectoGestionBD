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


