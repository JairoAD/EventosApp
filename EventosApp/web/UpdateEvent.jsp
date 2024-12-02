<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String path;

    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        path = "/Login.jsp?error=You must log in first.";
    } else {
        int eventID = Integer.parseInt(request.getParameter("eventID"));
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        String fecha = request.getParameter("fecha");
        String imagenUrl = request.getParameter("imagenUrl");
        int cantidadEntradas = Integer.parseInt(request.getParameter("cantidadEntradas"));
        double precioEntrada = Double.parseDouble(request.getParameter("precioEntrada"));

        DataBaseHelper dt = new DataBaseHelper();

        if (dt.updateEvent(eventID, titulo, descripcion, fecha, cantidadEntradas, precioEntrada, imagenUrl)) {
            path = "/adminIndex.jsp?success=Event updated successfully.";
        } else {
            path = "/editEvent.jsp?id=" + eventID + "&error=Failed to update the event.";
        }
        dt.Close();
    }

    RequestDispatcher dispatcher = request.getRequestDispatcher(path);
    dispatcher.forward(request, response);
%>
