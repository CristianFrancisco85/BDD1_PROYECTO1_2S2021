SELECT DISTINCT
(SELECT COUNT(*) FROM Actor) AS ACTORES,
(SELECT COUNT(*) FROM Categoria) AS CATEGORIAS,
(SELECT COUNT(*) FROM Ciudad) AS CIUDADES,
(SELECT COUNT(*) FROM Clasificacion) AS CLASIFICACIONES,
(SELECT COUNT(*) FROM Cliente) AS CLIENTES,
(SELECT COUNT(*) FROM Direccion) AS DIRECCIONES,
(SELECT COUNT(*) FROM Empleado) AS EMPLEADOS,
(SELECT COUNT(*) FROM Inventario) AS INVENTARIO,
(SELECT COUNT(*) FROM Idioma) AS IDIOMAS,
(SELECT COUNT(*) FROM Pais) AS PAISES,
(SELECT COUNT(*) FROM Pelicula) AS PELICULAS,
(SELECT COUNT(*) FROM Actor_Pelicula) AS ACTOR_PELICULA,
(SELECT COUNT(*) FROM Categoria_Pelicula) AS CATEGORIA_PELICULA,
(SELECT COUNT(*) FROM Renta) AS RENTAS,
(SELECT COUNT(*) FROM Tienda) AS TIENDAS FROM TEMPORAL; 

