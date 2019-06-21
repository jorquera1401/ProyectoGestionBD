--se crea tabla log para registrar AUDITORIA A LA BASE DE DATOS
create table log(
	nombreTabla character varying,
	usuario character varying,
	consultaSQL character varying,
	SQLejecutado text,
	hora timestamp without time zone default NOW()
);
--SE ELIMINAN PRIVILEGIOS PARA LOS USUARIOS PUBLICOS DE LA BASE DE DATOS
--SOLO LOS ADMIN PUEDEN ADMINISTRAR ESTA TABLA
REVOKE ALL ON log from public;

--PROCEDIMIENTO ALMACENADO PARA ALMACENAR REGISTRO
create or replace function pa_registrarLog()
returns trigger as $$
begin
    insert into log(nombreTabla,usuario,consultaSQL,SQLejecutado)
	values (tg_table_name::text,session_user::text,
   	tg_op,current_query());
	return null;
end;
$$
language plpgsql;

--DISPARADORES PARA TODAS LAS TABLAS DE LA BASE DE DATOS
create trigger tg_registrar_log
after insert or update or delete on artista
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on anadir_cancion_playlist
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on album
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on cancion
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on pago
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on playlist
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on tarjeta
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on usuario
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on usuario_escucha_cancion
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on usuario_free
for each row execute procedure pa_registrarLog();

create trigger tg_registrar_log
after insert or update or delete on usuario_premium
for each row execute procedure pa_registrarLog();