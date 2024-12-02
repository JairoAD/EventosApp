<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        response.sendRedirect("Login.jsp?error=You must log in first.");
    } else {
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String fecha = request.getParameter("fecha");
        String url = request.getParameter("imagenUrl");
        int cantidadEntradas = Integer.parseInt(request.getParameter("cantidadEntradas"));
        double precioEntrada = Double.parseDouble(request.getParameter("precioEntrada"));

        DataBaseHelper dt = new DataBaseHelper();

        if (dt.registerEvent(titulo, descripcion, fecha, cantidadEntradas, precioEntrada, url)) {
            response.sendRedirect("adminIndex.jsp?success=1");
        } else {
            response.sendRedirect("adminIndex.jsp?error=Failed to register the event.");
        }
    }
%>
