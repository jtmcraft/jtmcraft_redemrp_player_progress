create table jtmcraft_progress_combat
(
    recorded_timestamp int(11)       not null default unix_timestamp(),
    citizenid          varchar(10)   not null,
    game_hours         int           not null,
    game_minutes       int           not null,
    game_seconds       int           not null,
    scoped_in          int           not null default 0,
    on_horse           int           not null default 0,
    execution          int           not null default 0,
    distance           decimal(7, 2) not null,
    head_shot          int           not null default 0,
    hat_shot           int           not null default 0,
    weapon_type        varchar(25)   not null default 'unknown',
    weapon_hash        int           not null,
    ammo_hash          int           not null
) charset = utf8;
