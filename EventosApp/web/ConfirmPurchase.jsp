<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        response.sendRedirect("Login.jsp?error=You must log in first.");
    } else {
        DataBaseHelper dt = new DataBaseHelper();

        if (dt.setPurchase(userID)) {
            response.sendRedirect("userIndex.jsp?success=1");
        } else {
            response.sendRedirect("Login.jsp?error=Failed to add task.");
        }
        dt.Close();
    }
%>