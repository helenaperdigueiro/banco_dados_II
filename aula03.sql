-- 01
SELECT p.nome AS Pais
FROM pais p
WHERE p.nome
LIKE '%a%'
ORDER BY p.nome;

-- 02
SELECT u.*, p.nome AS Pais, a.nome AS Avatar
FROM usuario u
INNER JOIN avatar a
ON Avatar_idAvatar = a.idAvatar
INNER JOIN pais p
ON Pais_idPais = p.idPais;


-- 03
SELECT u.nome AS Nome, COUNT(p.idPlaylist) AS qtoPlaylist
FROM usuario u
INNER JOIN playlist p
ON u.idUsuario = p.usuario_idUsuario
GROUP BY u.nome;

-- 04
SELECT c.nome AS Canal
FROM canal c
WHERE c.dataCriacao
BETWEEN DATE ('2021-04-01') AND DATE ('2021-06-01');

-- 05
SELECT u.nome AS Nome, p.nome AS Pais, v.titulo AS Video, GROUP_CONCAT(DISTINCT h.nome SEPARATOR ", ") AS Tag
FROM usuario u
INNER JOIN pais p
ON u.Pais_idPais = p.idPais
INNER JOIN video v
ON u.idUsuario = v.usuario_idUsuario
INNER JOIN video_hashtag vh
ON v.idVideo = vh.video_idVideo
INNER JOIN hashtag h
ON vh.hashtag_idHashtag = h.idHashtag
GROUP BY v.titulo
ORDER BY v.duracao
LIMIT 5;

-- 06
SELECT p.nome AS Playlist, u.nome AS Usuario, a.nome AS Avatar, COUNT(pv.video_idVideo) AS qtdVideos
FROM playlist p
INNER JOIN playlist_video pv
ON p.idPlaylist = pv.Playlist_idPlaylist
INNER JOIN usuario u
ON p.usuario_idUsuario = u.idUsuario
INNER JOIN avatar a
ON u.Avatar_idAvatar = a.idAvatar
GROUP BY p.nome
HAVING (COUNT(pv.video_idVideo) < 3);

-- 07 (fizemos errado, mas nao quisemos apagar!)
INSERT INTO usuario (nome, email, senha, dataNascimento, codigoPostal, Pais_idPais, Avatar_idAvatar)
VALUES ('Carolina', 'ca_haka@gmail.com', 'cahakas', '1989-08-28 00:00:00', 12345678, 25, 3);

-- 07 (agora sim o certo)
INSERT INTO avatar (nome, urlimagem)
VALUES ('Avocado', 'https://images.pexels.com/photos/2228553/pexels-photo-2228553.jpeg');

UPDATE usuario
SET usuario.Avatar_idAvatar = 87
WHERE usuario.email = 'ca_haka@gmail.com';

-- 08
SELECT p.nome AS Pais, a.nome AS Avatar, COUNT(a.idAvatar) AS qtdUsos
FROM usuario u
INNER JOIN pais p
ON u.Pais_idPais = p.idPais
INNER JOIN avatar a
ON u.Avatar_idAvatar = a.idAvatar
GROUP BY a.nome
ORDER BY p.nome;

-- 09
INSERT INTO usuario (nome, email, senha, dataNascimento, codigoPostal, Pais_idPais, Avatar_idAvatar)
VALUES ('Roberto Rodriguez', 'rrodriguez@dhtube.com', 'rr1254', '1975-11-01 00:00:00', 1429, 9, 85);

-- 10
SELECT v.titulo AS Video, GROUP_CONCAT(DISTINCT h.nome SEPARATOR ", ") AS Tag
FROM video v
INNER JOIN video_hashtag vh
ON v.idVideo = vh.video_idVideo
INNER JOIN hashtag h
ON vh.hashtag_idHashtag = h.idHashtag
WHERE CHAR_LENGTH(h.nome) < 10
GROUP BY v.titulo;











