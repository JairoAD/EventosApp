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

            //int userID = (Integer) session.getAttribute("userID");
            DataBaseHelper ds = new DataBaseHelper();
            int userID = (Integer) session.getAttribute("userID");
            ResultSet resultset = ds.getAllEvents();
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
            <div class="eventsTitle">
                <h1>Eventos Disponibles</h1>
            </div>
            <div class="row">
                <%
                    while (resultset.next()) {
                        String titulo = resultset.getString("titulo");
                        String descripcion = resultset.getString("descripcion");
                        String fecha = resultset.getString("fecha");
                        int cantidadEntradas = resultset.getInt("cantidadEntradas");
                        double precioEntrada = resultset.getDouble("precioEntrada");
                        int eventID = resultset.getInt("id");
                        String img = resultset.getString("imagenUrl");

                        ResultSet rsCart = ds.getCartItemsForEvent(userID, eventID);
                        int cartTickets = 0;
                        if (rsCart.next()) {
                            cartTickets = rsCart.getInt("cantidad");
                        }

                %>
                <div class="col-md-4 mb-3">
                    <div class="card" style="width: 18rem;">
                        <img 
                            src="<%= img%>" 
                            class="card-img-top" 
                            alt="<%= titulo%>">
                        <div class="card-header cardTitle">
                            <h5 class="card-title mb-0"><%= titulo%></h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">
                                <strong>Descripción:</strong> <%= descripcion%><br>
                                <strong>Fecha:</strong> <%= fecha%><br>
                                <strong>Entradas disponibles:</strong> <%= cantidadEntradas%><br>
                                <strong>Entradas en Carrito: </strong> <%= cartTickets%><br>
                                <strong>Precio:</strong> $<%= precioEntrada%>
                            </p>
                            <button class="btn btn-success" id="primaryBtn" 
                                    onclick="window.location.href = 'BuyTickets.jsp?id=<%= resultset.getInt("id")%>'">
                                Comprar Entrada
                            </button>
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
        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('success') && urlParams.get('success') === '1') {
                    alert('¡Compra realizada con éxito!');
                } else if (urlParams.has('success') && urlParams.get('success') === '2') {
                    alert('¡Compra añadida al carrito!');
                } else if(urlParams.has('success') && urlParams.get('success') === '3'){
                    alert('Se ha eliminado el item del carrito');
                }
            };
        </script>
    </body>
</html>
