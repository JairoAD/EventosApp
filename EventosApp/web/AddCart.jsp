<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        response.sendRedirect("Login.jsp?error=You must log in first.");
    } else {
        int eventID = Integer.parseInt(request.getParameter("id"));
        int tickets = Integer.parseInt(request.getParameter("cantidadEntradas"));
        DataBaseHelper dt = new DataBaseHelper();

        if (dt.addCart(userID, eventID, tickets)) {
            response.sendRedirect("userIndex.jsp?success=2");
        } else {
            response.sendRedirect("Login.jsp?error=Failed to add task.");
        }
        dt.Close();
    }
%>