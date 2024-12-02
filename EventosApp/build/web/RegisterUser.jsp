<%@page import="database.DataBaseHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<%
    String txtname = request.getParameter("txtname");
    String txtemail = request.getParameter("txtemail");
    String txtpwd = request.getParameter("txtpwd");
    String txtpwd2 = request.getParameter("txtpwd2");
    String path;

    if (txtpwd.equals(txtpwd2)) {
        DataBaseHelper dt = new DataBaseHelper();

        if (!dt.validateEmail(txtemail)) {

            if (dt.registerUser(txtname, txtemail, txtpwd)) {
                path = "/Login.jsp?msg=User has been registered";
            } else {
                path = "/Login.jsp?error=Unhandled error";
            }

        } else {
            path = "/Login.jsp?error=Email already exists";
        }

    } else {
        path = "/Login.jsp?error=Password must be the same";
    }
    RequestDispatcher dispatcher = request.getRequestDispatcher(path);
    dispatcher.forward(request, response);
%>
