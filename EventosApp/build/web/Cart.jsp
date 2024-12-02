<%@page import="java.text.SimpleDateFormat"%>
<%@page import="database.DataBaseHelper"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/js/all.min.js"></script>
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap" rel="stylesheet">
        <style>
            html, body {
                height: 100%;
            }
            body {
                display: flex;
                flex-direction: column;
            }
            main {
                flex-grow: 1;
            }

        </style>
        <title>JSP Page</title>
    </head>
    <body>    
        <%
            String msg = request.getParameter("msg");
        %>
        <%
            if (session.getAttribute("userID") == null) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp?error=You must log in");
                dispatcher.forward(request, response);
            }

            int userID = (Integer) session.getAttribute("userID");
            DataBaseHelper ds = new DataBaseHelper();

            ResultSet resultset = ds.getCartItems(userID);
        %>

        <nav>
            <div class="navbar">
                <div>
                    <span>Eventos CR</span>
                </div>
                <div class="navbarLinks">
                    <a href="userIndex.jsp" title="Home"><i class="fa-solid fa-house"></i></a>
                    <a href="Cart.jsp" title="Carrito"><i class="fa-solid fa-shopping-cart"></i></a>
                    <a href="Login.jsp" title="Logout"><i class="fa-solid fa-right-from-bracket"></i></a>
                </div>
            </div>
        </nav>
        <main class='container mt-5'>
            <div class="row">
                <%
                    while (resultset.next()) {
                        String titulo = resultset.getString("titulo");
                        String descripcion = resultset.getString("descripcion");
                        String fecha = resultset.getString("fecha");
                        int totalEntradas = resultset.getInt("totalEntradas");
                        double precioEntrada = resultset.getDouble("precioEntrada");

                        double totalAPagar = 0.0;

                        double subtotal = precioEntrada * totalEntradas;

                        totalAPagar += subtotal;
                %>
                <div class="col-md-4 mb-3">
                    <div class="card" style="width: 18rem;">
                        <img 
                            src="<%= resultset.getString("imagenUrl")%>" 
                            class="card-img-top" 
                            alt="<%= titulo%>">
                        <div class="card-header cardTitle text-white">
                            <h5 class="card-title mb-0"><%= titulo%></h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">
                                <strong>Descripción: </strong> <%= descripcion%><br>
                                <strong>Fecha: </strong> <%= fecha%><br>
                                <strong>Entradas disponibles: </strong> <%= totalEntradas%><br>
                                <strong>Precio: </strong> $<%= precioEntrada%><br>
                                <strong>Total: </strong> $<%= totalAPagar%><br>
                            </p>
                            <div class="btn-container cartBtns">
                                <button id="secondaryBtn"
                                    class="btn btn-success" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#editTicketsModal<%= resultset.getInt("id")%>">
                                    Editar
                                </button>

                                <form action="ConfirmPurchase.jsp" method="POST" style="margin: 0;">
                                    <input type="hidden" name="userID" value="<%= userID%>">
                                    <input type="hidden" name="eventID" value="<%= resultset.getInt("id")%>">
                                    <input type="hidden" name="quantity" value="<%= resultset.getInt("totalEntradas")%>">
                                    <button type="submit" id="primaryBtn" class="btn btn-success">Comprar</button>
                                </form>

                                <button class="btn btn-danger" 
                                        onclick="window.location.href = 'DeleteCartItem.jsp?id=<%= resultset.getInt("cartID")%>&userID=<%= session.getAttribute("userID")%>'">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="editTicketsModal<%= resultset.getInt("id")%>" tabindex="-1" aria-labelledby="editTicketsModalLabel<%= resultset.getInt("id")%>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editTicketsModalLabel<%= resultset.getInt("id")%>">Editar Entradas</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form action="EditTickets.jsp">
                                    <input type="hidden" name="eventID" value="<%= resultset.getInt("id")%>">

                                    <div class="mb-3">
                                        <label for="eventName<%= resultset.getInt("id")%>" class="form-label">Nombre del Evento</label>
                                        <input type="text" class="form-control" id="eventName<%= resultset.getInt("id")%>" value="<%= titulo%>" readonly>
                                    </div>

                                    <div class="mb-3">
                                        <label for="currentTickets<%= resultset.getInt("id")%>" class="form-label">Entradas compradas</label>
                                        <input type="text" class="form-control" id="currentTickets<%= resultset.getInt("id")%>" value="<%= totalEntradas%>" readonly>
                                    </div>

                                    <div class="mb-3">
                                        <label for="newTickets<%= resultset.getInt("id")%>" class="form-label">Nueva Cantidad de Entradas</label>
                                        <input type="number" class="form-control" id="newTickets<%= resultset.getInt("id")%>" name="newTickets" min="1" required>
                                    </div>

                                    <button type="submit" class="btn btn-primary" id="primaryBtn">Actualizar</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <%}%>
            </div>
        </main>

        <footer class='text-white text-center text-lg-start mt-auto footer'>
            <div class='text-center p-3' style='background-color: #586e7d; margin-top: 200px'>
                © 2024 Eventos CR | All rights reserved.
            </div>
        </footer>

    </body>
</html>
