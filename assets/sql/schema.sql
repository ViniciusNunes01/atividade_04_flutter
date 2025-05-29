
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT    UNIQUE NOT NULL,
  password TEXT NOT NULL
);

INSERT INTO users (email, password)
VALUES ('usuario@exemplo.com', 'senha123');

SELECT *
  FROM users
 WHERE email    = 'usuario@exemplo.com'
   AND password = 'senha123';

UPDATE users
   SET password = 'novaSenhaSegura'
 WHERE email = 'usuario@exemplo.com';
