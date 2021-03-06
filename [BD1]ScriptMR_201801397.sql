DROP TABLE Pais CASCADE CONSTRAINTS;
CREATE TABLE Pais(
    idPais NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(idPais)
);

DROP TABLE Ciudad CASCADE CONSTRAINTS;
CREATE TABLE Ciudad (
    idCiudad NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    idPais NUMBER NOT NULL,
    PRIMARY KEY(idCiudad),
    FOREIGN KEY(idPais) REFERENCES Pais(idPais)
);

DROP TABLE Direccion CASCADE CONSTRAINTS;
CREATE TABLE Direccion (
    idDireccion NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Direccion VARCHAR(100) NOT NULL,
    Distrito VARCHAR(50),
    CodigoPostal NUMBER,
    idCiudad NUMBER NOT NULL,
    PRIMARY KEY(idDireccion),
    FOREIGN KEY (idCiudad) REFERENCES Ciudad(idCiudad)
);

DROP TABLE Empleado CASCADE CONSTRAINTS;
CREATE TABLE Empleado(
    idEmpleado NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    idDireccion NUMBER NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(200) NOT NULL,
    Activo NUMBER NOT NULL,
    idTienda NUMBER,
    PRIMARY KEY (idEmpleado),
    FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion),
    FOREIGN KEY (idTienda) REFERENCES Tienda(idTienda)
);

DROP TABLE Tienda CASCADE CONSTRAINTS;
CREATE TABLE Tienda(
    idTienda NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    idDireccion NUMBER NOT NULL,
    idJefe NUMBER NOT NULL,
    PRIMARY KEY(idTienda),
    FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion),
    FOREIGN KEY (idJefe) REFERENCES Empleado(idEmpleado)
);

DROP TABLE Bonos CASCADE CONSTRAINTS;
CREATE TABLE Bonos(
    idBono NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Fecha DATE NOT NULL,
    idEmpleado NUMBER NOT NULL,
    PRIMARY KEY(idBono),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

DROP TABLE Cliente CASCADE CONSTRAINTS;
CREATE TABLE Cliente(
    idCliente NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    idDireccion NUMBER NOT NULL,
    FechaRegistro DATE NOT NULL,
    Activo NUMBER NOT NULL,
    idVideotecaFav NUMBER,
    PRIMARY KEY(idCliente),
    FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion),
    FOREIGN KEY (idVideotecaFav) REFERENCES Tienda(idTienda)
);

DROP TABLE Actor CASCADE CONSTRAINTS;
CREATE TABLE Actor(
    idActor NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    PRIMARY KEY (idActor)
);

DROP TABLE Categoria CASCADE CONSTRAINTS;
CREATE TABLE Categoria(
    idCategoria NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (idCategoria)
);

DROP TABLE Clasificacion CASCADE CONSTRAINTS;
CREATE TABLE Clasificacion(
    idClasificacion NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(idClasificacion)
);

DROP TABLE Idioma CASCADE CONSTRAINTS;
CREATE TABLE Idioma(
    idIdioma NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (idIdioma)
);

DROP TABLE Pelicula CASCADE CONSTRAINTS;
CREATE TABLE Pelicula(
    idPelicula NUMBER GENERATED BY DEFAULT AS IDENTITY,
    Titulo VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    A?o NUMBER NOT NULL,
    Duracion NUMBER NOT NULL,
    DiasRentables NUMBER NOT NULL,
    Costo NUMBER NOT NULL,
    Multa NUMBER NOT NULL,
    idClasificacion NUMBER NOT NULL,
    PRIMARY KEY(idPelicula),
    FOREIGN KEY (idClasificacion) REFERENCES Clasificacion(idClasificacion)
);

DROP TABLE Inventario CASCADE CONSTRAINTS;
CREATE TABLE Inventario(
    idInventario NUMBER GENERATED BY DEFAULT AS IDENTITY,
    idTienda NUMBER NOT NULL,
    idPelicula NUMBER NOT NULL,
    idIdioma NUMBER NOT NULL,
    Stock NUMBER NOT NULL,
    PRIMARY KEY(idInventario),
    FOREIGN KEY (idTienda) REFERENCES Tienda(idTienda),
    FOREIGN KEY (idPelicula) REFERENCES Pelicula(idPelicula),
    FOREIGN KEY (idIdioma) REFERENCES Idioma(idIdioma)
);

DROP TABLE Actor_Pelicula CASCADE CONSTRAINTS;
CREATE TABLE Actor_Pelicula (
    idActor NUMBER NOT NULL,
    idPelicula NUMBER NOT NULL,
    FOREIGN KEY (idActor) REFERENCES Actor(idActor),
    FOREIGN KEY (idPelicula) REFERENCES Pelicula(idPelicula),
    PRIMARY KEY(idActor,idPelicula)
);

DROP TABLE Categoria_Pelicula CASCADE CONSTRAINTS;
CREATE TABLE Categoria_Pelicula (
    idCategoria NUMBER NOT NULL,
    idPelicula NUMBER NOT NULL,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
    FOREIGN KEY (idPelicula) REFERENCES Pelicula(idPelicula),
    PRIMARY KEY(idCategoria,idPelicula)
);

DROP TABLE Renta CASCADE CONSTRAINTS;
CREATE TABLE Renta(
    idRenta NUMBER GENERATED BY DEFAULT AS IDENTITY,
    idInventario NUMBER NOT NULL,
    idCliente NUMBER NOT NULL,
    FechaRenta TIMESTAMP(6) NOT NULL,
    FechaRetorno TIMESTAMP(6),
    FechaPago TIMESTAMP(6) NOT NULL,
    Total NUMBER NOT NULL,
    PRIMARY KEY(idRenta),
    FOREIGN KEY (idInventario) REFERENCES Inventario(idInventario),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);