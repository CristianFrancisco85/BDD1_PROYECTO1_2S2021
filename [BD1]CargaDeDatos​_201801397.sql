-- ******************************************************************
-- Carga de Paises
-- ******************************************************************

INSERT INTO Pais(Nombre)
    SELECT DISTINCT PAIS_CLIENTE FROM TEMPORAL
    WHERE PAIS_CLIENTE!='-' AND PAIS_CLIENTE NOT IN (SELECT Nombre FROM Pais);    

INSERT INTO Pais(Nombre)
    SELECT DISTINCT PAIS_EMPLEADO FROM TEMPORAL
    WHERE PAIS_EMPLEADO!='-' AND PAIS_EMPLEADO NOT IN (SELECT Nombre FROM Pais);

-- ******************************************************************
-- Carga de Ciudades
-- ******************************************************************

INSERT INTO Ciudad(idPais,Nombre)
    SELECT DISTINCT (SELECT idPais FROM PAIS WHERE Nombre = PAIS_CLIENTE),CIUDAD_CLIENTE FROM TEMPORAL
    WHERE CIUDAD_CLIENTE !='-' AND PAIS_CLIENTE!='-' 
    AND ((SELECT idPais FROM PAIS WHERE Nombre = PAIS_CLIENTE),CIUDAD_CLIENTE) NOT IN(SELECT idPais,Nombre FROM Ciudad);

INSERT INTO Ciudad(idPais,Nombre)
    SELECT DISTINCT (SELECT idPais FROM PAIS WHERE Nombre = PAIS_EMPLEADO),CIUDAD_EMPLEADO FROM TEMPORAL
    WHERE CIUDAD_EMPLEADO !='-' AND PAIS_EMPLEADO!='-' 
    AND ((SELECT idPais FROM PAIS WHERE Nombre = PAIS_EMPLEADO),CIUDAD_EMPLEADO) NOT IN(SELECT idPais,Nombre FROM Ciudad);

INSERT INTO Ciudad(idPais,Nombre)
    SELECT DISTINCT (SELECT idPais FROM PAIS WHERE Nombre = PAIS_TIENDA),CIUDAD_TIENDA FROM TEMPORAL
    WHERE CIUDAD_TIENDA !='-' AND PAIS_TIENDA!='-'
    AND ((SELECT idPais FROM PAIS WHERE Nombre = PAIS_TIENDA),CIUDAD_TIENDA) NOT IN(SELECT idPais,Nombre FROM Ciudad);

-- ******************************************************************
-- Carga de Direcciones
-- ******************************************************************

INSERT INTO Direccion(idCiudad,Direccion,CodigoPostal)
    SELECT DISTINCT 
    (SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_CLIENTE AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_CLIENTE)),DIRECCION_CLIENTE,CODIGO_POSTAL_CLIENTE  FROM TEMPORAL
    WHERE PAIS_CLIENTE!='-' AND CIUDAD_CLIENTE!='-' AND DIRECCION_CLIENTE!='-' AND CODIGO_POSTAL_CLIENTE!='-' 
    AND ((SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_CLIENTE AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_CLIENTE)),
    DIRECCION_CLIENTE,CODIGO_POSTAL_CLIENTE) NOT IN (SELECT idCiudad,DIreccion,CodigoPostal FROM DIRECCION);

INSERT INTO Direccion(idCiudad,Direccion)
    SELECT DISTINCT 
    (SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_EMPLEADO AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_EMPLEADO)),DIRECCION_EMPLEADO FROM TEMPORAL
    WHERE PAIS_EMPLEADO!='-' AND CIUDAD_EMPLEADO!='-' AND DIRECCION_EMPLEADO!='-'
    AND ((SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_EMPLEADO AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_EMPLEADO)),
    DIRECCION_EMPLEADO) NOT IN (SELECT idCiudad,Direccion FROM DIRECCION);

INSERT INTO Direccion(idCiudad,Direccion)
    SELECT DISTINCT 
    (SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_TIENDA AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_TIENDA)),DIRECCION_TIENDA FROM TEMPORAL
    WHERE PAIS_TIENDA!='-' AND CIUDAD_TIENDA!='-' AND DIRECCION_TIENDA!='-'
    AND ((SELECT idCiudad FROM Ciudad WHERE Nombre = CIUDAD_TIENDA AND idPais =(SELECT idPais FROM PAIS WHERE Nombre = PAIS_TIENDA)),
    DIRECCION_TIENDA) NOT IN (SELECT idCiudad,Direccion FROM DIRECCION);

-- ******************************************************************
-- Carga de Empleados
-- ****************************************************************** 

INSERT INTO Empleado(Nombre,Apellido,Email,Username,Password,iddireccion,Activo)
    SELECT DISTINCT 
    SubStr(NOMBRE_EMPLEADO, 0, InStr(NOMBRE_EMPLEADO, ' ')-1) as FName,
    SubStr(NOMBRE_EMPLEADO, InStr(NOMBRE_EMPLEADO, ' ')+1) as LName,
    CORREO_EMPLEADO,USUARIO_EMPLEADO,CONTRASENA_EMPLEADO,
    (SELECT idDireccion FROM Direccion WHERE Direccion=DIRECCION_EMPLEADO AND idCiudad=(SELECT idCiudad FROM Ciudad WHERE Nombre=CIUDAD_EMPLEADO)),
    REGEXP_REPLACE(REGEXP_REPLACE (EMPLEADO_ACTIVO, 'Si', '1'),'No','0') FROM TEMPORAL
    WHERE NOMBRE_EMPLEADO!='-';

-- ******************************************************************
-- Carga de Tiendas
-- ****************************************************************** 

INSERT INTO Tienda(Nombre,iddireccion,idJefe)
    SELECT DISTINCT NOMBRE_TIENDA,
    (SELECT idDireccion FROM Direccion WHERE Direccion=DIRECCION_TIENDA AND idCiudad=(SELECT idCiudad FROM Ciudad WHERE Nombre=CIUDAD_TIENDA)),
    (SELECT idEmpleado FROM Empleado WHERE Nombre||' '||Apellido=ENCARGADO_TIENDA) FROM TEMPORAL
    WHERE NOMBRE_TIENDA!='-';

-- ******************************************************************
-- Actualizacion Tienda Empleados
-- ******************************************************************

UPDATE EMPLEADO SET
    idTienda=(SELECT idTienda FROM Tienda WHERE Tienda.Nombre=(SELECT DISTINCT TIENDA_EMPLEADO FROM TEMPORAL WHERE NOMBRE_EMPLEADO=Empleado.Nombre||' '||Empleado.Apellido));


-- ******************************************************************
-- Carga de Clientes
-- ******************************************************************

INSERT INTO Cliente(Nombre,Apellido,Email,iddireccion,FechaRegistro,Activo,idvideotecafav)
    SELECT DISTINCT
    SubStr(NOMBRE_CLIENTE, 0, InStr(NOMBRE_CLIENTE, ' ')-1) as FName,
    SubStr(NOMBRE_CLIENTE, InStr(NOMBRE_CLIENTE, ' ')+1) as LName, 
    CORREO_CLIENTE,
    (SELECT idDireccion FROM Direccion 
     INNER JOIN Ciudad ON Ciudad.idCiudad = Direccion.idCiudad
     INNER JOIN Pais ON Pais.idPais = Ciudad.idPais
     WHERE Direccion=DIRECCION_CLIENTE AND Ciudad.Nombre=CIUDAD_CLIENTE AND Pais.Nombre=PAIS_CLIENTE ),
    FECHA_CREACION,
    REGEXP_REPLACE(REGEXP_REPLACE (CLIENTE_ACTIVO, 'Si', '1'),'No','0'),
    (SELECT idTienda FROM TIENDA WHERE Nombre=TIENDA_PREFERIDA) FROM TEMPORAL
    WHERE NOMBRE_CLIENTE!='-';

-- ******************************************************************
-- Carga de Categorias
-- ******************************************************************    

INSERT INTO Categoria(Nombre)
  SELECT DISTINCT CATEGORIA_PELICULA FROM Temporal WHERE CATEGORIA_PELICULA!='-';  

-- ******************************************************************
-- Carga de Actores
-- ******************************************************************   

INSERT INTO Actor(Nombre,Apellido)
  SELECT DISTINCT
  SubStr(ACTOR_PELICULA, 0, InStr(ACTOR_PELICULA, ' ')-1) as FName,
  SubStr(ACTOR_PELICULA, InStr(ACTOR_PELICULA, ' ')+1) as LName
  FROM Temporal WHERE ACTOR_PELICULA!='-' ; 

-- ******************************************************************
-- Carga de Clasificaciones
-- ******************************************************************   

INSERT INTO Clasificacion(Nombre)
  SELECT DISTINCT CLASIFICACION FROM Temporal WHERE CLASIFICACION!='-' ; 

-- ******************************************************************
-- Carga de Idiomas
-- ******************************************************************   

INSERT INTO Idioma(Nombre)
  SELECT DISTINCT LENGUAJE_PELICULA FROM Temporal WHERE LENGUAJE_PELICULA!='-' ; 

-- ******************************************************************
-- Carga de Peliculas
-- ******************************************************************  
INSERT INTO Pelicula(Titulo,Descripcion,"AÑO",Duracion,DiasRentables,Costo,Multa,idclasificacion)
  SELECT DISTINCT NOMBRE_PELICULA,DESCRIPCION_PELICULA,ANIO_LANZAMIENTO,DURACION,DIAS_RENTA,COSTO_RENTA,COSTO_POR_DANO,
  (SELECT idClasificacion FROM Clasificacion WHERE NOMBRE=CLASIFICACION)FROM Temporal 
  WHERE NOMBRE_PELICULA!='-' ; 

-- ******************************************************************
-- Carga de Inventario
-- ****************************************************************** 

INSERT INTO Inventario(idTienda,idPelicula,idIdioma,stock)
    SELECT DISTINCT
    (SELECT idTienda FROM Tienda WHERE Nombre=TIENDA_PELICULA),
    (SELECT idPelicula FROM Pelicula WHERE Titulo=NOMBRE_PELICULA),
    (SELECT idIdioma FROM Idioma WHERE Nombre=LENGUAJE_PELICULA),
    1 FROM Temporal 
    WHERE NOMBRE_PELICULA!='-' AND TIENDA_PELICULA!='-';

-- ******************************************************************
-- Carga de Actor_Pelicula
-- ****************************************************************** 

INSERT INTO Actor_Pelicula(idActor,idPelicula)
    SELECT DISTINCT 
    (SELECT idActor FROM Actor WHERE Nombre||' '||Apellido=ACTOR_PELICULA ),
    (SELECT idPelicula FROM Pelicula WHERE Titulo=NOMBRE_PELICULA)
    FROM TEMPORAL WHERE NOMBRE_PELICULA!='-' AND ACTOR_PELICULA!='-';

-- ******************************************************************
-- Carga de Categoria_Pelicula
-- ****************************************************************** 

INSERT INTO Categoria_Pelicula(idCategoria,idPelicula)
    SELECT DISTINCT 
    (SELECT idCategoria FROM Categoria WHERE Nombre=CATEGORIA_PELICULA ),
    (SELECT idPelicula FROM Pelicula WHERE Titulo=NOMBRE_PELICULA)
    FROM TEMPORAL WHERE NOMBRE_PELICULA!='-' AND CATEGORIA_PELICULA!='-';

-- ******************************************************************
-- Carga de Rentas
-- ****************************************************************** 

INSERT INTO Renta(idInventario,idCliente,FechaRenta,FechaRetorno,Total,FechaPago)
    SELECT DISTINCT 
    (SELECT idInventario FROM Inventario 
    INNER JOIN Pelicula ON Pelicula.idPelicula = Inventario.idPelicula
    INNER JOIN Tienda ON Tienda.idTienda = Inventario.idTienda
    INNER JOIN Idioma ON Idioma.idIdioma = Inventario.idIdioma
    WHERE Pelicula.Titulo=NOMBRE_PELICULA AND Tienda.Nombre = TIENDA_PELICULA  AND Idioma.Nombre=LENGUAJE_PELICULA )AS IDInventario,
    (SELECT idCliente FROM Cliente WHERE Nombre||' '||Apellido=NOMBRE_CLIENTE),
    FECHA_RENTA,REGEXP_REPLACE (FECHA_RETORNO, '-',null),MONTO_A_PAGAR,FECHA_PAGO
    FROM TEMPORAL WHERE NOMBRE_PELICULA!='-' AND TIENDA_PELICULA!='-' AND LENGUAJE_PELICULA!='-' AND FECHA_RENTA!='-';
    
