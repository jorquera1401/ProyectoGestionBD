create function eliminarCancionPlaylist(nombre text,id_cancion_en_playlist integer)returns void as
$$
declare 
id_usuario integer;
id_premium integer;
id_playlist_dueño integer;
id_playlist_de_cancion integer;
begin
	execute format('select usuario.id from usuario where usuario.nombre = nombre;')
	into id_usuario;
	execute format('select usuario_premium.id_usuario from usuario_premium where usuario_premium.id_usuario = id_usuario;')
	into id_premium;

	if(id_premium=null) then
		RAISE NOTICE 'No es premium, no puede eliminar una playlist';
	else
		execute format('select anadir_cancion_playlist.playlist_asociada from anadir_cancion_playlist where anadir_cancion_playlist.id =id_cancion_en_playlist;')
		into id_playlist_de_cancion;
		execute format('select playlist.id from playlist where playlist.usuario_asociado = id_premium and playlist.id = id_playlist_de_cancion;')
		into id_playlist_dueño;
		if(id_playlist_dueño=null)then
			RAISE NOTICE 'Solo el creador de la playlist puede eliminar canciones';
		else
			delete from anadir_cancion_playlist where anadir_cancion_playlist.id = id_cancion_en_playlist;
		end if;
	end if;
end;
$$
LANGUAGE plpgsql;