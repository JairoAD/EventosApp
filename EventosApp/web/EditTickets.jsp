<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String path;
    DataBaseHelper dt = new DataBaseHelper();
    
    int userID = (Integer) session.getAttribute("userID");
    int eventID = Integer.parseInt(request.getParameter("eventID"));
    int newQuantity = Integer.parseInt(request.getParameter("newTickets"));

    if (dt.updateCart(userID, eventID, newQuantity)) {
        path = "/Cart.jsp";
    } else {
        path = "/Login.jsp?msg=Error updating the Movie";
    }

    dt.Close();
    RequestDispatcher dispatcher = request.getRequestDispatcher(path);
    dispatcher.forward(request, response);
%>
