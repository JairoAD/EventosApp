package database;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DataBaseHelper {

    Connection conn;

    public void Close() {
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(DataBaseHelper.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public DataBaseHelper() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/eventosDB?useUnicode=true&characterEncoding=UTF-8", "root", "Admin$1234");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DataBaseHelper.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public int validateLogin(String txtEmail, String txtPwd) throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT * FROM eventosDB.Usuarios WHERE email = '" + txtEmail + "' AND contrasena = '" + txtPwd + "'";
        ResultSet resultset = statement.executeQuery(sql);
        int id;
        if (resultset.next()) {
            id = resultset.getInt("id");
            return id;
        } else {
            return 0;
        }
    }

    public boolean registerUser(String name, String email, String password) throws SQLException {
        try {
            Statement statement = conn.createStatement();
            String sql = "INSERT INTO Usuarios (nombre, email, contrasena, esAdmin) VALUES ('"
                    + name + "', '"
                    + email + "', '"
                    + password + "', FALSE);";
            statement.executeUpdate(sql);
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean validateEmail(String txtEmail) throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT * FROM eventosDB.Usuarios WHERE email = '" + txtEmail + "'";
        ResultSet resultset = statement.executeQuery(sql);
        while (resultset.next()) {
            return true;
        }
        return false;
    }

    public ResultSet getUser(int userID) throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT "
                + "u.name, "
                + "u.email "
                + "FROM eventosDB.Usuarios u "
                + "WHERE u.id = " + userID + ";";

        return statement.executeQuery(sql);
    }

    public boolean registerEvent(String title, String description, String date, int ticketCount, double ticketPrice, String imagenUrl) throws SQLException {
        try {
            Statement statement = conn.createStatement();

            String sql = "INSERT INTO Eventos (titulo, descripcion, fecha, cantidadEntradas, precioEntrada, idAdministrador, imagenUrl) VALUES ('"
                    + title + "', '"
                    + description + "', '"
                    + date + "', "
                    + ticketCount + ", "
                    + ticketPrice + ", "
                    + "1, '"
                    + imagenUrl + "');";

            statement.executeUpdate(sql);

            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean setPurchase(int userID) {
        ResultSet rsCarrito = null;

        try {
            conn.setAutoCommit(false);

            String queryCarrito = "SELECT idEvento, cantidad FROM Carrito WHERE idUsuario = ?";
            PreparedStatement stmtCarrito = conn.prepareStatement(queryCarrito);
            stmtCarrito.setInt(1, userID);
            rsCarrito = stmtCarrito.executeQuery();

            while (rsCarrito.next()) {
                int eventID = rsCarrito.getInt("idEvento");
                int tickets = rsCarrito.getInt("cantidad");

                String queryEvento = "SELECT cantidadEntradas FROM Eventos WHERE id = ?";
                PreparedStatement stmtEvento = conn.prepareStatement(queryEvento);
                stmtEvento.setInt(1, eventID);
                ResultSet rsEvento = stmtEvento.executeQuery();

                if (rsEvento.next()) {
                    int cantidadDisponibles = rsEvento.getInt("cantidadEntradas");

                    if (cantidadDisponibles >= tickets) {
                        String insertCompra = "INSERT INTO Compras (idUsuario, idEvento, cantidad) VALUES (?, ?, ?)";
                        PreparedStatement stmtInsert = conn.prepareStatement(insertCompra);
                        stmtInsert.setInt(1, userID);
                        stmtInsert.setInt(2, eventID);
                        stmtInsert.setInt(3, tickets);
                        stmtInsert.executeUpdate();

                        String updateEvento = "UPDATE Eventos SET cantidadEntradas = cantidadEntradas - ? WHERE id = ?";
                        PreparedStatement stmtUpdate = conn.prepareStatement(updateEvento);
                        stmtUpdate.setInt(1, tickets);
                        stmtUpdate.setInt(2, eventID);
                        stmtUpdate.executeUpdate();

                        stmtInsert.close();
                        stmtUpdate.close();
                    } else {
                        conn.rollback();
                        throw new SQLException("No hay suficientes entradas disponibles para el evento con ID: " + eventID);
                    }
                } else {
                    conn.rollback();
                    throw new SQLException("Evento con ID " + eventID + " no encontrado.");
                }

                rsEvento.close();
                stmtEvento.close();
            }

            String deleteCarrito = "DELETE FROM Carrito WHERE idUsuario = ?";
            PreparedStatement stmtDelete = conn.prepareStatement(deleteCarrito);
            stmtDelete.setInt(1, userID);
            stmtDelete.executeUpdate();
            stmtDelete.close();

            conn.commit();

            return true;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rsCarrito != null) {
                    rsCarrito.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean addCart(int userID, int eventID, int tickets) {
        ResultSet rsEvento = null;
        ResultSet rsCarrito = null;

        try {
            String queryEvento = "SELECT cantidadEntradas FROM Eventos WHERE id = " + eventID;
            rsEvento = conn.createStatement().executeQuery(queryEvento);

            int cantidadDisponiblesEvento = 0;

            if (rsEvento.next()) {
                cantidadDisponiblesEvento = rsEvento.getInt("cantidadEntradas");
            } else {
                return false;
            }

            String queryCarrito = "SELECT cantidad FROM Carrito WHERE idEvento = " + eventID + " AND idUsuario = " + userID;
            rsCarrito = conn.createStatement().executeQuery(queryCarrito);

            int cantidadCarrito = 0;
            if (rsCarrito.next()) {
                cantidadCarrito = rsCarrito.getInt("cantidad");
            }

            int totalEntradasSolicitadas = cantidadCarrito + tickets;
            if (totalEntradasSolicitadas > (cantidadDisponiblesEvento + cantidadCarrito)) {
                return false;
            }

            if (cantidadCarrito > 0) {
                String updateCarrito = "UPDATE Carrito SET cantidad = cantidad + " + tickets
                        + " WHERE idEvento = " + eventID + " AND idUsuario = " + userID;
                conn.createStatement().executeUpdate(updateCarrito);
            } else {
                String insertCarrito = "INSERT INTO Carrito (idUsuario, idEvento, cantidad) VALUES ("
                        + userID + ", " + eventID + ", " + tickets + ")";
                conn.createStatement().executeUpdate(insertCarrito);
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rsEvento != null) {
                    rsEvento.close();
                }
                if (rsCarrito != null) {
                    rsCarrito.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateCart(int userID, int eventID, int newQuantity) {
        PreparedStatement stmtSelectCarrito = null;
        PreparedStatement stmtSelectEvento = null;
        PreparedStatement stmtUpdateCarrito = null;
        ResultSet rsCarrito = null;
        ResultSet rsEvento = null;

        try {
            String queryCarrito = "SELECT cantidad FROM Carrito WHERE idUsuario = ? AND idEvento = ?";
            stmtSelectCarrito = conn.prepareStatement(queryCarrito);
            stmtSelectCarrito.setInt(1, userID);
            stmtSelectCarrito.setInt(2, eventID);
            rsCarrito = stmtSelectCarrito.executeQuery();

            if (rsCarrito.next()) {
                int oldQuantity = rsCarrito.getInt("cantidad");

                String queryEvento = "SELECT cantidadEntradas FROM Eventos WHERE id = ?";
                stmtSelectEvento = conn.prepareStatement(queryEvento);
                stmtSelectEvento.setInt(1, eventID);
                rsEvento = stmtSelectEvento.executeQuery();

                if (rsEvento.next()) {
                    int availableTickets = rsEvento.getInt("cantidadEntradas");

                    int difference = newQuantity - oldQuantity;

                    if (difference > 0 && availableTickets < difference) {
                        throw new SQLException("No hay suficientes entradas disponibles.");
                    }

                    String updateCarrito = "UPDATE Carrito SET cantidad = ? WHERE idUsuario = ? AND idEvento = ?";
                    stmtUpdateCarrito = conn.prepareStatement(updateCarrito);
                    stmtUpdateCarrito.setInt(1, newQuantity);
                    stmtUpdateCarrito.setInt(2, userID);
                    stmtUpdateCarrito.setInt(3, eventID);
                    stmtUpdateCarrito.executeUpdate();

                    return true;
                } else {
                    throw new SQLException("No se encontraron entradas disponibles para el evento.");
                }
            } else {
                throw new SQLException("No se encontraron registros en el carrito para el usuario y evento especificados.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rsCarrito != null) {
                    rsCarrito.close();
                }
                if (rsEvento != null) {
                    rsEvento.close();
                }
                if (stmtSelectCarrito != null) {
                    stmtSelectCarrito.close();
                }
                if (stmtSelectEvento != null) {
                    stmtSelectEvento.close();
                }
                if (stmtUpdateCarrito != null) {
                    stmtUpdateCarrito.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateEvent(int eventID, String titulo, String descripcion, String fecha, int cantidadEntradas, double precioEntrada, String imagenUrl) throws SQLException {
        try {
            Statement statement = conn.createStatement();
            String sql = "UPDATE Eventos SET "
                    + "titulo = '" + titulo + "', "
                    + "descripcion = '" + descripcion + "', "
                    + "fecha = '" + fecha + "', "
                    + "cantidadEntradas = " + cantidadEntradas + ", "
                    + "precioEntrada = " + precioEntrada + ", "
                    + "imagenUrl = '" + imagenUrl + "' "
                    + "WHERE id = " + eventID + ";";

            int rowsUpdated = statement.executeUpdate(sql);
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean deleteEvent(int eventID) throws SQLException {
        try {
            Statement statement = conn.createStatement();
            String sql = "DELETE FROM Eventos WHERE id = " + eventID + ";";

            int rowsDeleted = statement.executeUpdate(sql);
            return rowsDeleted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean deleteCartItem(int cartItemId, int userId) throws SQLException {
        try {
            Statement statement = conn.createStatement();
            String sql = "DELETE FROM Carrito WHERE id = " + cartItemId + " AND idUsuario = " + userId + ";";

            int rowsDeleted = statement.executeUpdate(sql);
            return rowsDeleted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public ResultSet getAllEvents() throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT e.id, e.titulo, e.descripcion, e.fecha, e.cantidadEntradas, e.precioEntrada, e.imagenUrl "
                + "FROM Eventos e "
                + "ORDER BY e.fecha DESC;";

        ResultSet resultset = statement.executeQuery(sql);
        return resultset;
    }

    public ResultSet cart(int userID) throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT e.id, e.titulo, e.descripcion, e.fecha, e.precioEntrada, SUM(c.cantidad) AS totalEntradas "
                + "FROM Eventos e "
                + "JOIN Compras c ON e.id = c.idEvento "
                + "WHERE c.idUsuario = " + userID
                + " GROUP BY e.id, e.titulo, e.descripcion, e.fecha, e.precioEntrada";

        ResultSet resultset = statement.executeQuery(sql);
        return resultset;
    }

    public ResultSet getEvent(int id) throws SQLException {
        Statement statement = conn.createStatement();
        String sql = "SELECT id, titulo, descripcion, fecha, cantidadEntradas, precioEntrada, imagenUrl FROM Eventos WHERE id = " + id;
        ResultSet resultset = statement.executeQuery(sql);
        return resultset;
    }

    public ResultSet getCartItems(int userID) throws SQLException {
        String sql = "SELECT e.id, e.titulo, e.descripcion, c.cantidad AS totalEntradas, e.fecha, e.precioEntrada, e.imagenUrl, c.id As cartID "
                + "FROM Carrito c "
                + "JOIN Eventos e ON c.idEvento = e.id "
                + "WHERE c.idUsuario = " + userID;

        Statement statement = conn.createStatement();
        return statement.executeQuery(sql);
    }

    public ResultSet getCartItemsForEvent(int userID, int eventID) {
        ResultSet rs = null;
        try {
            String query = "SELECT cantidad FROM Carrito WHERE idUsuario = " + userID + " AND idEvento = " + eventID;
            rs = conn.createStatement().executeQuery(query);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rs;
    }
}
