
--cursor para ver informacion playlist 

create or replace function getPlpaylist(c_nombre text)
returns text as $$
declare 
    salida text default '';
    record record;
    cursor_playlist cursor(c_nombre text)
        for select p.nombre as nombrePlaylist , u.nombre as creador, c.nombre as nombreCancion, c.duracion as duracion
		,c.explicito as explicito,c.num_de_reproducciones as numeroReproducciones,a.nombre as nombreAlbum
		, a.fecha_de_lanzamiento as fechaLanzamiento,a.genero as genero,art.nombre as artista   
        from usuario as u, playlist as p, anadir_cancion_playlist as acp, cancion as c, 
		album as a, artista as art where p.usuario_asociado = u.id and p.id = acp.playlist_asociada
		and acp.cancion_asociada = c.id and c.album_asociado = a.id and a.artista_asociado = art.id;
begin
    open cursor_playlist(c_nombre);
    loop
        fetch cursor_playlist into record;
        exit when not found;

        if record.nombrePlaylist like c_nombre||'%' then
            salida :=salida || record.nombrePlaylist || ' creado por ' || record.creador ||
                    ' [titulo : '||record.nombreCancion ||' artista: '|| record.artista || ' album : ' || record.nombreAlbum ||
                    ' duracion : '||record.duracion || ' reproducciones: ' || record.reproducciones|| ']';
        end if;
    end loop;
    close cursor_playlist;
    return salida;
end;
$$
language plpgsql;