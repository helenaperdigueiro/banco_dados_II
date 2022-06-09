SELECT COUNT(idVideo) AS qtdVideos
FROM video
WHERE video.privado = 1;

SELECT nome, titulo
FROM usuario
INNER JOIN video
ON idUsuario = usuario_idUsuario;

SELECT nome, count(titulo) AS qtdVideos
FROM usuario
INNER JOIN video
ON idUsuario = usuario_idUsuario
GROUP BY nome
ORDER BY qtdVideos DESC;

SELECT pais.nome, count(usuario.nome) AS qtdUsuarios
FROM usuario
INNER JOIN pais
ON idPais = Pais_idPais
GROUP BY pais.nome
ORDER BY qtdUsuarios DESC;

SELECT usuario.nome, count(reacao.Tiporeacao_idTiporeacao) AS qtdReacoes
FROM usuario
INNER JOIN reacao
ON idUsuario = usuario_idUsuario
GROUP BY usuario.nome
ORDER BY qtdReacoes DESC;