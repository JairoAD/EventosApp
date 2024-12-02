<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        response.sendRedirect("Login.jsp?error=You must log in first.");
    } else {
        int eventID = Integer.parseInt(request.getParameter("id"));
        DataBaseHelper dt = new DataBaseHelper();

        if (dt.deleteEvent(eventID)) {
            response.sendRedirect("adminIndex.jsp?success=2");
        } else {
            response.sendRedirect("adminIndex.jsp?error=Failed to delete the event.");
        }

        dt.Close();
    }
%>
