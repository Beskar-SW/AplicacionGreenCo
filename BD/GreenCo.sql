Create database GreenCo_gps;
use GreenCo_gps;
 
create table Categorias(
   idCategoria int not null auto_increment,
   nomCategoria char (64) not null unique,
   primary key(idCategoria)
);
 

CREATE TABLE Productos (
    idProducto INT NOT NULL AUTO_INCREMENT,
    nomProd char(64),
    precio float,
    descripcion varchar(128),
    rutaFotoProducto varchar(2048) UNIQUE,
    idCategoria int,
    existencia int,
    PRIMARY KEY (IdProducto),
    foreign key (idCategoria) references Categorias (idCategoria)
);
 

create table Tags(
   idTag int not null auto_increment,
   idCategoria int not null,
   nomTag char(16) not null unique,
   primary key (idTag),
   foreign key (idCategoria) references Categorias (idCategoria)
);
 
create table TagsProds(
   idProducto int not null ,
   idTag int not null,
   primary key(idProducto, idTag),
   foreign key (idProducto) references Productos (idProducto),
   foreign key (idTag) references Tags (idTag)
);
 

CREATE TABLE Estados (
    idEstado INT NOT NULL AUTO_INCREMENT,
    nomEstado CHAR(64) NOT NULL unique,
    PRIMARY KEY (idEstado)
);
 
create table Municipios(
   idMunicipio int not null auto_increment,
   idEstado int not null,
   nomMunicipio char(128),
   primary key(idMunicipio, idEstado),
   foreign key (idEstado) references Estados (idEstado)   
);
 
create table Asentamiento(
   idAsentamiento int not null auto_increment,
   idMunicipio int not null,
   nomAsentamiento char(128),
   primary key(idAsentamiento, idMunicipio),
   foreign key (idMunicipio) references Municipios (idMunicipio)   
);
 
CREATE TABLE Colonia (
    idColonia INT NOT NULL AUTO_INCREMENT,
    idAsentamiento INT NOT NULL,
    nomColonia CHAR(128) NOT NULL,
    PRIMARY KEY (idColonia , idAsentamiento),
    FOREIGN KEY (idAsentamiento)
        REFERENCES Asentamiento (idAsentamiento)
);
 
CREATE TABLE Calles (
    idCalle INT NOT NULL AUTO_INCREMENT,
    idColonia int,
    nomCalle CHAR(128) NOT NULL,
    PRIMARY KEY (idCalle, idColonia),
    foreign key (idColonia) references Colonias (idColonia)
);
 
/*
Ejemplo Json:
 
{
"edificio": "2",
"piso": "2",
"lote": "3",
"Entre calle 1": "tlacoapan",
"Entre calle 2": "temoaya",
"tipoDeVivienda": {
"condominio": "False",
"vivienda": "True",
"residencial": "False",
"fraccionamiento": "False"
}
}
 
*/
 
CREATE TABLE Usuario(
    idUsuario INT NOT NULL AUTO_INCREMENT,
    nickname char(64) not null unique,
    nomUsuario char(64) not null,
    apellidos char(128),
    fechaNacimiento DATE,
    rutaFotoUsuario VARCHAR(2048),
    idCalle int,
    num char(8),
    correo varchar(255),
    contraseña char(16),
    productor boolean Default False,
    codigoPostal char(12),
    datosExtraDireccion json,    
    PRIMARY KEY (idUsuario, codigoPostal),
    FOREIGN KEY (idCalle)
        REFERENCES Calles (idCalle)
);
 

create table FormasDeContacto(
   idContacto int, 
   formaDeContacto char(128),
   tipoContacto char(4) comment "Tel, Cel, Mail, Twit, Face...",
   primary key (idContacto, formaDeContacto),
   foreign key (idContacto) references Clientes (idCliente)
);
 
create table DatosFacturacion(   
   idDatosFacturacion int auto_increment,
   idCliente int,
   RFC char (13),
   razonSocial char (512),
   datosDelCliente bool comment "Utiliza los datos de direccion del cliente",
   idCalle int,
   num varchar(16),
   datosExtraDireccion json,       
   primary key (idDatosFacturacion),
   key(idCliente,RFC),
   foreign key (idCliente) references Usuarios (idUsuario)
);
 
create table TagsUsuarios(
   idUsuario int not null ,
   idTag int not null,
   primary key(idUsuario, idTag),
   foreign key (idUsuario)references Usuarios(idUsuario),
   foreign key (idTag) references Tags (idTag)
);
 

CREATE TABLE Carrito(
    idCarrito INT NOT NULL AUTO_INCREMENT,
    idCliente int,
    idDatosFacturacion int,
    fechaVenta DATETIME,
    -- impuesto FLOAT, viola la quinta FN
    -- Total FLOAT comment "Por la fluctuación de precios",
    estadoVenta char(5) comment "retenido, en revisión, incompleta, en progreso, pagado, cancelado, enviando, denegado, entregado",
    formaDePago char(5) comment "credito, debito, trans, deposito",    
    PRIMARY KEY (idCarrito, idCliente),    
    foreign key (idDatosFacturacion) references DatosFacturacion (idDatosFacturacion),
    FOREIGN KEY (idCliente) REFERENCES Usuarios(idUsuario)
);
 
create table ProductosEnElCarrito(
   idProducto int,
   idCarrito int,
   costoVenta float,
   cantidad float,
   descuento float comment "porcentaje de descuento",
   primary key(idProducto, idCarrito),
   foreign key (idProducto) references Productos (idProducto),
   foreign key (idCarrito) references Carrito(idCarrito)
);
 

create table TagsCarrito(
   idCarrito int not null ,
   idTag int not null,
   primary key(idCarrito, idTag),
   foreign key (idCarrito) references Carritos (idCarrito),
   foreign key (idTag) references Tags (idTag)
);
 
 

CREATE TABLE RolesDeUsuarios(
    idRol int auto_increment,
    rolUsuario char(5) comment "usuario, vendMin, tienda, admin, superadmin",    
    PRIMARY KEY (idRol)
);
 
create table UsuariosRoles(
   idRol int not null,
   idUsuario int not null,
   primary key (idRol, idUsuario),
   foreign key (idRol) references RolesDeUsuarios (idRol),
   foreign key (idUsuario) references Usuarios (idUsuario)
);
 
CREATE TABLE EstadoEnvios (
    IdState INT NOT NULL,
    IdUser INT NOT NULL,
    UserDirection varchar(300),
    UserPhone varchar(30),
    IdVentaFk varchar(30),
    State varchar(10) NOT NULL DEFAULT 'PROGRESS',
    FOREIGN KEY (IdUser) REFERENCES Usuarios(IdUsuario),
    FOREIGN KEY (UserDirection) REFERENCES Usuarios(Direccion),
    FOREIGN KEY (UserPhone) REFERENCES Usuarios(Telefono),
    FOREIGN KEY (IdVentaFk) REFERENCES Ventas(IdVenta)
);
 
CREATE TABLE Facturacion (
    IdFactura INT NOT NULL AUTO_INCREMENT,
    Fecha DATE,
    Concepto varchar(30),
    IdCliente INT,
    NombreCliente varchar(50),
    ApellidoCliente varchar(50),
    PRIMARY KEY (Id_factura),
    FOREIGN KEY (IdCliente) REFERENCES Usuarios(IdUsuario),
    FOREIGN KEY (NombreCliente) REFERENCES Usuarios(Nombre),
    FOREIGN KEY (ApellidoCliente) REFERENCES Usuarios(Apellido)
);
 
CREATE TABLE Disponibilidad (
    IdDisponibilidad INT NOT NULL AUTO_INCREMENT,
    Ciudad varchar(30),
    Locales INT(30),
    PRIMARY KEY (Ciudad)
);
 

/*24/Feb*/
 
/*
CREATE TABLE UsuarioVendedor(
idUsuarioVendedor int not null,
    rfcVendedor char(13),
    idProducto int not null,
    Primary Key(idClienteVendedor),
    Foreign Key (idUsuarioVendedor) references Usuario(idUsuario),    
    Foreign Key(idProducto) references Productos(idProducto)
);
 
CREATE TABLE UsuarioUsuario(
    idVentaP2P int auto increment,
    idClienteVendedor int not null,
    idClienteComprador int not null,
      idVenta int not null,
    Primary Key (idVentaPToP,idClienteVendedor) key (idClienteComprador),
    Foreign Key (idClienteVendedor) references      UsuarioVendedor(idUsuarioVendedor),
    Foreign Key (idClienteComprador) references Usuario(idUsuario),
    Foreign Key (idVenta) references Ventas(idVenta)
);
 
CREATE TABLE Empresa( 
    idEmpresa int not null,
    empNombre char(250),
    idCalle int not null,
    empRFC char(13),
    empGiro char(25)
    empTipo char ()
    Primary Key (idEmpresa, empNombre),
);
 
Create table articulos (
    idArt int not null,
    IdTipo int not null,
    IdClienteVendedor int not null,
    nomArt  char(64),
    precioArt boolean,
    disponibilidad char(5) comment “Disponible, Agotado”,
    cantArt int(10),
    Primary key (idArt, idTipo),
    Foreign key (idClienteVendedor) references UsuarioVendedor(idUsuarioVendedor)
);
 
describe usuarios;
/*31/marzo vistas*/
create view usuarios_registro as select ID_Usuario,
NombreUser,Apellido from usuarios where Direccion is null;
 
create view carrito_prod_guard as select cantidad 
from ProductosEnElCarrito as ProdC inner join productos
as P on ProdC.idProducto= P.idProducto inner join carrito 
as C on ProdC.idCarrito= C.idCarrito where cantidad=10;
 
create view prod_org_mariscos as select nombrePro, precio
from productos where precio > 50; 
*/