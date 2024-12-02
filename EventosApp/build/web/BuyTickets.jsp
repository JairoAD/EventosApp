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
            .completed {
                background-color: #d4edda;
                border-color: #c3e6cb;
            }

        </style>
        <title>Compra de Entradas</title>
        <script>
            function calcularTotal(precio) {
                console.log(precio);
                const cantidad = document.getElementById("cantidadEntradas").value;
                const total = cantidad * precio;
                document.getElementById("totalPrecio").innerText = '$' + total;
            }
        </script>
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

            int eventID = Integer.parseInt(request.getParameter("id"));

            ResultSet resultset = ds.getEvent(eventID);
            //ResultSet resultsUser = ds.getUser(userID);
            //resultsUser.next();

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
                <%                    while (resultset.next()) {
                        String titulo = resultset.getString("titulo");
                        String descripcion = resultset.getString("descripcion");
                        String fecha = resultset.getString("fecha");
                        int cantidadEntradas = resultset.getInt("cantidadEntradas");
                        double precioEntrada = resultset.getDouble("precioEntrada");
                %>
                <div class="container mt-5">
                    <div class="card shadow-lg">
                        <div class="card-header cardTitle text-white text-center">
                            <h1 class="mb-0"><%= titulo%></h1>
                        </div>
                        <div class="card-body">
                            <form action="AddCart.jsp">
                                <div class="row">
                                    <div class="col-md-6">
                                        <img src="<%= resultset.getString("imagenUrl")%>" class="img-fluid rounded shadow-sm" alt="Imagen del Concierto">
                                    </div>
                                    <div class="col-md-6">
                                        <h2 class="text-dark">Descripción:</h2>
                                        <p class="fs-5"><%= descripcion%></p>
                                        <h3 class="text-dark">Fecha: <span class="text-muted"><%= fecha%></span></h3>
                                        <h3 class="text-dark">Precio por entrada: <span class="text-success">$<%= precioEntrada%></span></h3>
                                        <div class="mt-4">
                                            <label for="cantidadEntradas" class="form-label fs-5">Cantidad de Entradas:</label>
                                            <input type="number" class="form-control" id="cantidadEntradas" name="cantidadEntradas" min="1" max="<%= cantidadEntradas%>" value="1" oninput="calcularTotal(<%= precioEntrada%>)">
                                        </div>
                                        <div class="mt-3">
                                            <h3>Total: <span id="totalPrecio" class="text-success">$<%= precioEntrada%></span></h3>
                                        </div>
                                        <input type="hidden" name="id" value="<%= eventID%>">
                                        <button type="submit" id="primaryBtn" class="btn mt-4 w-100">Añadir al carrito</button>

                                    </div>
                                </div>
                            </form>
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</body>
</html>
