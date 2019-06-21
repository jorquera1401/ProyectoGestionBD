create function eliminarCancionPlaylist(nombre text,id_cancion_en_playlist integer)returns void as
$$
declare 
id_usuario integer;
id_premium integer;
begin
	execute format('select usuario.id from usuario where usuario.nombre = nombre;')
	into id_usuario;
	execute format('select usuario_premium.id_usuario from usuario_premium where usuario_premium.id_usuario = id_usuario;')
	into id_premium;
	if(id_premium=null) then
		RAISE NOTICE 'No es premium, no puede eliminar una playlist';
	else
		delete from anadir_cancion_playlist where anadir_cancion_playlist.id = id_cancion_en_playlist and anadir_cancion_playlist.usuario_asociado = id_premium; 
	end if;
end;
$$
LANGUAGE plpgsql;