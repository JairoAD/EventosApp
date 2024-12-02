<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;

    if (userID == null) {
        response.sendRedirect("Login.jsp?error=You must log in first.");
    } else {
        DataBaseHelper dt = new DataBaseHelper();
        int cartItemID = Integer.parseInt(request.getParameter("id"));

        if (dt.deleteCartItem(cartItemID, userID)) {
            response.sendRedirect("userIndex.jsp?success=3");
        } else {
            response.sendRedirect("userIndex.jsp?error=Failed to delete the event.");
        }
    }
%>