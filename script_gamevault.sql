
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS videojuegos;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS plataformas;
DROP TABLE IF EXISTS generos;


CREATE TABLE generos (
    id_genero   INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre      TEXT    NOT NULL UNIQUE
);


CREATE TABLE plataformas (
    id_plataforma INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre        TEXT    NOT NULL UNIQUE,
    fabricante    TEXT
);


CREATE TABLE videojuegos (
    id_videojuego       INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo              TEXT    NOT NULL UNIQUE,
    nombre              TEXT    NOT NULL,
    id_genero           INTEGER NOT NULL,
    id_plataforma       INTEGER NOT NULL,
    anio_lanzamiento    INTEGER CHECK (anio_lanzamiento BETWEEN 1970 AND 2100),
    desarrollador       TEXT,
    precio              REAL    NOT NULL DEFAULT 0 CHECK (precio >= 0),
    cantidad_total      INTEGER NOT NULL DEFAULT 0 CHECK (cantidad_total >= 0),
    cantidad_disponible INTEGER NOT NULL DEFAULT 0
        CHECK (cantidad_disponible >= 0 AND cantidad_disponible <= cantidad_total),
    FOREIGN KEY (id_genero)     REFERENCES generos(id_genero)         ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_plataforma) REFERENCES plataformas(id_plataforma) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE usuarios (
    id_usuario     INTEGER PRIMARY KEY AUTOINCREMENT,
    identificacion TEXT    NOT NULL UNIQUE,
    nombre         TEXT    NOT NULL,
    apellido       TEXT    NOT NULL,
    telefono       TEXT,
    correo         TEXT    UNIQUE
);


CREATE TABLE prestamos (
    id_prestamo               INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario                INTEGER NOT NULL,
    id_videojuego             INTEGER NOT NULL,
    fecha_prestamo            TEXT    NOT NULL,          -- formato AAAA-MM-DD
    fecha_devolucion_prevista TEXT    NOT NULL,
    fecha_devolucion_real     TEXT,                      -- NULL mientras no se devuelva
    estado                    TEXT    NOT NULL DEFAULT 'PRESTADO'
        CHECK (estado IN ('PRESTADO', 'DEVUELTO')),
    CHECK (fecha_devolucion_prevista >= fecha_prestamo),
    FOREIGN KEY (id_usuario)    REFERENCES usuarios(id_usuario)       ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_videojuego) REFERENCES videojuegos(id_videojuego) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_videojuegos_nombre ON videojuegos(nombre);
CREATE INDEX idx_prestamos_estado   ON prestamos(estado);


INSERT INTO generos (nombre) VALUES
    ('Acción'), ('Aventura'), ('Deportes'), ('Rol (RPG)'),
    ('Estrategia'), ('Carreras'), ('Disparos (Shooter)'), ('Plataformas');

INSERT INTO plataformas (nombre, fabricante) VALUES
    ('PlayStation 5',   'Sony'),
    ('Xbox Series X|S', 'Microsoft'),
    ('Nintendo Switch', 'Nintendo'),
    ('PC',              'Varios');

INSERT INTO videojuegos (codigo, nombre, id_genero, id_plataforma, anio_lanzamiento, desarrollador, precio, cantidad_total, cantidad_disponible) VALUES
    ('VJ-001', 'The Legend of Zelda: Tears of the Kingdom', 2, 3, 2023, 'Nintendo EPD',        259900, 3, 2),
    ('VJ-002', 'God of War Ragnarök',                       1, 1, 2022, 'Santa Monica Studio', 239900, 2, 1),
    ('VJ-003', 'EA Sports FC 25',                           3, 1, 2024, 'EA Vancouver',        279900, 4, 4),
    ('VJ-004', 'Forza Horizon 5',                           6, 2, 2021, 'Playground Games',    199900, 2, 2),
    ('VJ-005', 'Elden Ring',                                4, 4, 2022, 'FromSoftware',        189900, 2, 1),
    ('VJ-006', 'Super Mario Bros. Wonder',                  8, 3, 2023, 'Nintendo EPD',        249900, 3, 3),
    ('VJ-007', 'Halo Infinite',                             7, 2, 2021, '343 Industries',      149900, 1, 1),
    ('VJ-008', 'Age of Empires IV',                         5, 4, 2021, 'Relic Entertainment', 119900, 1, 1);

INSERT INTO usuarios (identificacion, nombre, apellido, telefono, correo) VALUES
    ('1098765432', 'Laura',  'Gómez',    '3001234567', 'laura.gomez@correo.com'),
    ('1095123456', 'Andrés', 'Pérez',    '3157654321', 'andres.perez@correo.com'),
    ('1102345678', 'Camila', 'Rodríguez','3209876543', 'camila.rodriguez@correo.com'),
    ('1091234567', 'Mateo',  'Suárez',   '3184561230', 'mateo.suarez@correo.com');


INSERT INTO prestamos (id_usuario, id_videojuego, fecha_prestamo, fecha_devolucion_prevista, fecha_devolucion_real, estado) VALUES
    (1, 1, '2026-10-10', '2026-10-24', NULL,         'PRESTADO'),
    (2, 2, '2026-10-12', '2026-10-26', NULL,         'PRESTADO'),
    (3, 5, '2026-10-15', '2026-10-29', NULL,         'PRESTADO'),
    (4, 3, '2026-09-20', '2026-10-04', '2026-10-02', 'DEVUELTO'),
    (1, 6, '2026-09-25', '2026-10-09', '2026-10-08', 'DEVUELTO');
