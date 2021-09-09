-- ******************************************************************
-- Reporte 1
-- ****************************************************************** 

SELECT Titulo FROM Pelicula 
INNER JOIN INVENTARIO ON Inventario.idPelicula = Pelicula.idPelicula
WHERE Titulo = 'SUGAR WONKA';

-- ******************************************************************
-- Reporte 2
-- ****************************************************************** 

SELECT Nombre,Apellido,SUM(Total) AS Total FROM Cliente
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
GROUP BY Nombre,Apellido
HAVING COUNT(*)>40;

-- ******************************************************************
-- Reporte 3
-- ****************************************************************** 

SELECT Nombre,Apellido,Titulo FROM Cliente
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
INNER JOIN Inventario ON Inventario.idInventario = Renta.idInventario
INNER JOIN Pelicula ON Pelicula.idPelicula=Inventario.idPelicula
WHERE Renta.FechaRetorno IS NULL OR Renta.FechaRetorno > Renta.FechaRenta+Pelicula.diasRentables;  

-- ******************************************************************
-- Reporte 4
-- ****************************************************************** 

SELECT Nombre||' '||Apellido AS FullName FROM Actor
WHERE UPPER(Apellido) LIKE '%SON%';

-- ******************************************************************
-- Reporte 5
-- ****************************************************************** 

SELECT Apellido,COUNT(*) FROM Actor
WHERE Nombre IN 
    (SELECT Nombre FROM Actor
    GROUP BY Nombre
    HAVING COUNT(*)>=2)
GROUP BY Apellido;

-- ******************************************************************
-- Reporte 6
-- ****************************************************************** 

SELECT Nombre,Apellido FROM Actor
INNER JOIN Actor_Pelicula ON  Actor_Pelicula.idActor = Actor.idActor
INNER JOIN Pelicula ON Pelicula.idPelicula = Actor_Pelicula.idPelicula
WHERE LOWER(Pelicula.Descripcion) LIKE '%shark%' OR LOWER(Pelicula.Descripcion) LIKE '%crocodile%'
GROUP BY Nombre,Apellido
ORDER BY Apellido ASC;

-- ******************************************************************
-- Reporte 7
-- ****************************************************************** 

SELECT Nombre,COUNT(*) FROM Categoria
INNER JOIN Categoria_Pelicula ON  Categoria_Pelicula.idcategoria = Categoria.idCategoria
GROUP BY Nombre
HAVING COUNT(*)>=55 AND COUNT(*)<=65
ORDER BY COUNT(*) DESC;

-- ******************************************************************
-- Reporte 8
-- ****************************************************************** 

SELECT ROUND(AVG(multa-costo),2) AS Promedio,categoria.nombre FROM Pelicula
INNER JOIN Categoria_Pelicula ON Categoria_Pelicula.idPelicula = Pelicula.idPelicula
INNER JOIN Categoria ON Categoria.idCategoria = Categoria_Pelicula.idCategoria
GROUP BY categoria.nombre
HAVING ROUND(AVG(multa-costo),2)>=17;

-- ******************************************************************
-- Reporte 9
-- ****************************************************************** 
SELECT Titulo,Nombre,Apellido FROM Actor 
INNER JOIN Actor_Pelicula ON Actor_Pelicula.idActor = Actor.idActor
INNER JOIN Pelicula ON Pelicula.idPelicula = Actor_Pelicula.idPelicula
WHERE 
(SELECT COUNT(*) FROM Actor_Pelicula 
WHERE Actor_Pelicula.idPelicula!=Pelicula.idPelicula AND Actor_Pelicula.idActor = Actor.idActor)>=2;

-- ******************************************************************
-- Reporte 10
-- ******************************************************************

SELECT Nombre || ' ' || Apellido
FROM (
    SELECT Nombre,Apellido  FROM ACTOR
    WHERE Nombre = 'Matthew'
    AND Nombre || ' ' || Apellido <> 'Matthew Johansson'
    UNION
    SELECT Nombre,Apellido FROM CLIENTE
    WHERE Nombre = 'Matthew'
    AND Nombre || ' ' || Apellido <> 'Matthew Johansson'
);

-- ******************************************************************
-- Reporte 11
-- ****************************************************************** 

SELECT 
  cliente.nombre, 
  cliente.apellido, 
  pais.nombre AS Nombre_Pais, 
  (
    SELECT 
      Count(*) 
    FROM 
      renta 
    WHERE 
      renta.idcliente = cliente.idcliente
  ) * 100 / (
    SELECT 
      Count(*) 
    FROM 
      renta 
      inner join cliente ON cliente.idcliente = renta.idcliente 
      inner join direccion ON direccion.iddireccion = cliente.iddireccion 
      inner join ciudad ON ciudad.idciudad = direccion.idciudad 
      inner join pais ON pais.idpais = ciudad.idpais
      WHERE pais.nombre = (
        SELECT 
          pais.nombre 
        FROM 
          cliente 
          inner join direccion ON direccion.iddireccion = cliente.iddireccion 
          inner join ciudad ON ciudad.idciudad = direccion.idciudad 
          inner join pais ON pais.idpais = ciudad.idpais 
        WHERE 
          idcliente = (
            SELECT 
              idcliente 
            FROM 
              (
                SELECT 
                  Count(*) AS Conteo, 
                  idcliente 
                FROM 
                  renta 
                GROUP BY 
                  idcliente
              ) 
            WHERE 
              conteo = (
                SELECT 
                  Max(conteo) 
                FROM 
                  (
                    SELECT 
                      Count(*) AS Conteo, 
                      idcliente 
                    FROM 
                      renta 
                    GROUP BY 
                      idcliente
                  )
              )
          )
      )
  ) AS Porcentaje 
FROM 
  cliente 
  inner join direccion ON direccion.iddireccion = cliente.iddireccion 
  inner join ciudad ON ciudad.idciudad = direccion.idciudad 
  inner join pais ON pais.idpais = ciudad.idpais 
WHERE 
  idcliente = (
    SELECT 
      idcliente 
    FROM 
      (
        SELECT 
          Count(*) AS Conteo, 
          idcliente 
        FROM 
          renta 
        GROUP BY 
          idcliente
      ) 
    WHERE 
      conteo = (
        SELECT 
          Max(conteo) 
        FROM 
          (
            SELECT 
              Count(*) AS Conteo, 
              idcliente 
            FROM 
              renta 
            GROUP BY 
              idcliente
          )
      )
  );

-- ******************************************************************
-- Reporte 12 - Omitido :)
-- ****************************************************************** 

-- ******************************************************************
-- Reporte 13
-- ****************************************************************** 

SELECT Cliente.Nombre,Cliente.Apellido,Pais.Nombre AS Pais,(SELECT COUNT(*) FROM Renta WHERE idCliente = Cliente.idCliente) AS Conteo FROM Cliente
INNER JOIN Direccion ON Direccion.idDireccion = Cliente.idDireccion
INNER JOIN Ciudad ON Ciudad.idCiudad = DIreccion.idCiudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais 
WHERE (Pais.Nombre,(SELECT COUNT(*) FROM Renta WHERE idCliente = Cliente.idCliente)) IN
(SELECT NombrePais,MAX(Conteo) AS MaxConteo FROM (
    SELECT COUNT(*) AS Conteo,Pais.Nombre AS NombrePais FROM Renta 
    INNER JOIN Cliente ON Cliente.idCliente = Renta.idCliente
    INNER JOIN Direccion ON Direccion.idDireccion = Cliente.idDireccion
    INNER JOIN Ciudad ON Ciudad.idCiudad = Direccion.idCiudad
    INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
    GROUP BY Cliente.Nombre,Cliente.Apellido,Pais.Nombre
)
GROUP BY NombrePais)
ORDER BY Conteo DESC;

-- ******************************************************************
-- Reporte 14
-- ****************************************************************** 

SELECT NombrePais,NombreCiudad FROM 
(
SELECT Pais.Nombre AS NombrePais,Ciudad.Nombre AS NombreCiudad,COUNT(*) AS Conteo FROM Ciudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
INNER JOIN Inventario ON Inventario.idInventario = Renta.idInventario
INNER JOIN Pelicula ON Pelicula.idPelicula = Inventario.idPelicula
INNER JOIN Categoria_Pelicula ON Categoria_Pelicula.idPelicula = Pelicula.idPelicula
INNER JOIN Categoria ON Categoria.idCategoria = Categoria_Pelicula.idCategoria
WHERE Categoria.Nombre = 'Horror'
GROUP BY Pais.Nombre,Ciudad.Nombre
)
WHERE (NombreCiudad,Conteo) IN 
(
SELECT NombreCiudad,MAX(Conteo) FROM (
SELECT COUNT(*) AS Conteo,Ciudad.Nombre AS NombreCiudad,Categoria.Nombre AS NombreCategoria FROM Ciudad
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
INNER JOIN Inventario ON Inventario.idInventario = Renta.idInventario
INNER JOIN Pelicula ON Pelicula.idPelicula = Inventario.idPelicula
INNER JOIN Categoria_Pelicula ON Categoria_Pelicula.idPelicula = Pelicula.idPelicula
INNER JOIN Categoria ON Categoria.idCategoria = Categoria_Pelicula.idCategoria
GROUP BY Ciudad.Nombre,Categoria.Nombre)
GROUP BY NombreCiudad
);

-- ******************************************************************
-- Reporte 15
-- ****************************************************************** 

SELECT Pais.Nombre AS NombrePais,Ciudad.Nombre AS NombreCiudad,ROUND(COUNT(*)/
(SELECT Conteo FROM(
SELECT COUNT(*) AS Conteo, Pais.Nombre AS NombrePais FROM Pais
INNER JOIN Ciudad ON Ciudad.idPais = Pais.idPais
GROUP BY Pais.Nombre) WHERE NombrePais = Pais.Nombre) 
,2)AS Conteo FROM Ciudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
GROUP BY Pais.Nombre,Ciudad.Nombre;

-- ******************************************************************
-- Reporte 16
-- ****************************************************************** 

SELECT Pais.Nombre AS NombrePais,ROUND(COUNT(*)*100/
(
SELECT Conteo FROM (
SELECT Pais.Nombre AS NombrePais,COUNT(*) AS Conteo FROM Ciudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
INNER JOIN Inventario ON Inventario.idInventario = Renta.idInventario
INNER JOIN Pelicula ON Pelicula.idPelicula = Inventario.idPelicula
INNER JOIN Categoria_Pelicula ON Categoria_Pelicula.idPelicula = Pelicula.idPelicula
INNER JOIN Categoria ON Categoria.idCategoria = Categoria_Pelicula.idCategoria
GROUP BY Pais.Nombre) WHERE NombrePais = Pais.Nombre 
),2) AS Porcentaje FROM Ciudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
INNER JOIN Inventario ON Inventario.idInventario = Renta.idInventario
INNER JOIN Pelicula ON Pelicula.idPelicula = Inventario.idPelicula
INNER JOIN Categoria_Pelicula ON Categoria_Pelicula.idPelicula = Pelicula.idPelicula
INNER JOIN Categoria ON Categoria.idCategoria = Categoria_Pelicula.idCategoria
WHERE Categoria.Nombre='Sports'
GROUP BY Pais.Nombre;


-- ******************************************************************
-- Reporte 17
-- ****************************************************************** 


SELECT NombreCiudad,Conteo FROM 
(SELECT Ciudad.Nombre AS NombreCiudad,COUNT(*)Conteo FROM Ciudad
INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
WHERE Pais.Nombre = 'United States'
GROUP BY Ciudad.Nombre)
WHERE Conteo >
(
SELECT COUNT(*)Conteo FROM Ciudad
INNER JOIN Direccion ON Direccion.idCiudad = Ciudad.idCiudad
INNER JOIN Cliente ON Cliente.idDireccion = Direccion.idDIreccion
INNER JOIN Renta ON Renta.idCliente= Cliente.idCliente
WHERE Ciudad.Nombre = 'Dayton'
)

-- ******************************************************************
-- Reporte 18
-- ****************************************************************** 



-- ******************************************************************
-- Reporte 19
-- ****************************************************************** 



-- ******************************************************************
-- Reporte 20
-- ****************************************************************** 

