--actualiza la duracion del album cuando inserto cancion
create function pa_actualizar_duracion() returns trigger as 
$$
begin
    update album set duracion = (duracion+new.duracion)
    where new.album_asociado = album.id;
    return new;
end;
$$
language plpgsql;

create or replace trigger tg_insertar_cancion
    after insert 
    on cancion 
    for each row
    execute procedure pa_actualizar_duracion();