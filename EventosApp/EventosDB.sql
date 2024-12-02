CREATE DATABASE eventosDB;
USE eventosDB;

CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    esAdmin BOOLEAN DEFAULT FALSE
);

CREATE TABLE Eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha DATE NOT NULL,
    cantidadEntradas INT NOT NULL,
    precioEntrada DECIMAL(10, 2) NOT NULL,
    idAdministrador INT,
    FOREIGN KEY (idAdministrador) REFERENCES Usuarios(id) ON DELETE CASCADE
);

CREATE TABLE Compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT,
    idEvento INT,
    cantidad INT NOT NULL,
    fechaCompra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (idEvento) REFERENCES Eventos(id) ON DELETE CASCADE
);

CREATE TABLE Carrito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT,
    idEvento INT,
    cantidad INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (idEvento) REFERENCES Eventos(id) ON DELETE CASCADE
);