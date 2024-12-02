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
                    <a href="adminIndex.jsp"><i class="fa-solid fa-house"></i></a>
                    <a href="Login.jsp"><i class="fa-solid fa-right-from-bracket"></i></a>
                </div>
            </div>
        </nav>

        <div class="register">
            <div class="registerTitle">
                <h1>Registrar Evento</h1>
            </div>
            <form action="AddEvent.jsp" method="post" class="registerForm">
                <div>
                    <label for="titulo">Título del Evento</label>
                    <input type="text" id="titulo" name="titulo" placeholder="Ingresa el título del evento" required maxlength="150">
                </div>
                <div>
                    <label for="descripcion">Descripción</label>
                    <textarea id="descripcion" name="descripcion" rows="4" placeholder="Describe el evento" required></textarea>
                </div>
                <div>
                    <label for="fecha">Fecha</label>
                    <input type="date" id="fecha" name="fecha" required>
                </div>
                <div>
                    <label for="cantidadEntradas">Cantidad de Entradas</label>
                    <input type="number" id="cantidadEntradas" name="cantidadEntradas" placeholder="Número de entradas disponibles" required min="1">
                </div>
                <div>
                    <label for="precioEntrada">Precio por Entrada</label>
                    <input type="number" id="precioEntrada" name="precioEntrada" placeholder="Precio de cada entrada" required step="0.01" min="0">
                </div>
                <div>
                    <label for="imagenUrl">URL de la Imagen</label>
                    <input type="url" id="imagenUrl" name="imagenUrl" placeholder="https://example.com/imagen.jpg" required>
                </div>
                <div class="registerButtons">
                    <button type="submit">Registrar Evento</button>
                    <button type="reset">Limpiar</button>
                </div>
            </form>
        </div>
        <main class='container mt-5'>
            <div class="row">
                <%
                    while (resultset.next()) {
                        String titulo = resultset.getString("titulo");
                        String descripcion = resultset.getString("descripcion");
                        String fecha = resultset.getString("fecha");
                        int cantidadEntradas = resultset.getInt("cantidadEntradas");
                        double precioEntrada = resultset.getDouble("precioEntrada");
                        int eventID = resultset.getInt("id");
                        String imagenUrl = resultset.getString("imagenUrl");

                        ResultSet rsCart = ds.getCartItemsForEvent(userID, eventID);
                        int cartTickets = 0;
                        if (rsCart.next()) {
                            cartTickets = rsCart.getInt("cantidad");
                        }

                %>
                <div class="col-md-4 mb-3 cards" style="margin: 0 auto;">
                    <div class="card" style="width: 18rem;">
                        <img 
                            src="<%= resultset.getString("imagenUrl")%>" 
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
                                <strong>Precio:</strong> $<%= precioEntrada%>
                            </p>
                            <div class="eventButtons">
                                <button class="btn" id="secondaryBtn" data-bs-toggle="modal" data-bs-target="#editEventModal<%= eventID%>">
                                    Editar
                                    <button type="button" class="btn" id="primaryBtn" 
                                            onclick="window.location.href = 'DeleteEvent.jsp?id=<%= eventID%>'">
                                        Eliminar Evento
                                    </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="editEventModal<%= eventID%>" tabindex="-1" aria-labelledby="editEventModalLabel<%= eventID%>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="UpdateEvent.jsp">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editEventModalLabel<%= eventID%>">Editar Evento</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="eventID" value="<%= eventID%>">
                                    <div class="mb-3">
                                        <label for="titulo<%= eventID%>" class="form-label">Título del Evento</label>
                                        <input type="text" class="form-control" id="titulo<%= eventID%>" name="titulo" value="<%= titulo%>" required maxlength="150">
                                    </div>
                                    <div class="mb-3">
                                        <label for="descripcion<%= eventID%>" class="form-label">Descripción</label>
                                        <textarea class="form-control" id="descripcion<%= eventID%>" name="descripcion" rows="4" required><%= descripcion%></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="fecha<%= eventID%>" class="form-label">Fecha</label>
                                        <input type="date" class="form-control" id="fecha<%= eventID%>" name="fecha" value="<%= fecha%>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="cantidadEntradas<%= eventID%>" class="form-label">Cantidad de Entradas</label>
                                        <input type="number" class="form-control" id="cantidadEntradas<%= eventID%>" name="cantidadEntradas" value="<%= cantidadEntradas%>" required min="1">
                                    </div>
                                    <div class="mb-3">
                                        <label for="precioEntrada<%= eventID%>" class="form-label">Precio por Entrada</label>
                                        <input type="number" class="form-control" id="precioEntrada<%= eventID%>" name="precioEntrada" value="<%= precioEntrada%>" required step="0.01" min="0">
                                    </div>
                                    <div class="mb-3">
                                        <label for="imagenUrl<%= eventID%>" class="form-label">URL de la Imagen</label>
                                        <input type="text" class="form-control" id="imagenUrl<%= eventID%>" name="imagenUrl" value="<%= imagenUrl%>" required maxlength="255">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" id="secondaryBtn" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-primary" id="primaryBtn">Guardar Cambios</button>
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
        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('success') && urlParams.get('success') === '1') {
                    alert('¡Evento creado con éxito');
                } else if (urlParams.has('success') && urlParams.get('success') === '2') {
                    alert('¡Evento eliminado con éxito!');
                } 
            };
        </script>
    </body>
</body>
</html>
