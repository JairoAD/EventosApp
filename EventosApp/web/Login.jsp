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
        </style>
        <title>Eventos CR</title>
    </head>
    <body>
        <%
            session = request.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            String error = request.getParameter("error");
            String msg = request.getParameter("msg");
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

        <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Register</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="RegisterUser.jsp">
                            <div class="mb-3">
                                <label for="txtname" class="form-label">Name</label>
                                <input type="text" class="form-control" id="txtname" name="txtname">                            
                            </div>
                            <div class="mb-3">
                                <label for="txtemail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="txtemail" name="txtemail">                            
                            </div>
                            <div class="mb-3">
                                <label for="txtpwd" class="form-label">Password</label>
                                <input type="password" class="form-control" id="txtpwd" name="txtpwd">
                            </div>
                            <div class="mb-3">
                                <label for="txtpwd2" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="txtpwd2" name="txtpwd2">
                            </div>       
                            <button type="submit" id="primaryBtn" class="btn btn-primary">Register</button>
                            <% if (error != null) {%>
                            <div class="footer">
                                <div class="alert alert-danger">
                                    <label class><%=error%></label>
                                </div>   
                            </div>                    
                            <% }%>
                            <% if (msg != null) {%>
                            <div class="footer">
                                <div class="alert alert-info">
                                    <label class><%=msg%></label>
                                </div>   
                            </div>                    
                            <% }%>
                        </form>        
                    </div>                    
                </div>
            </div>
        </div> 

        <div class="container d-flex justify-content-center align-items-center vh-100">
            <div class="card" style="width: 18rem;">
                <div class="card-header navbar navbar-expand-lg navbar-dark" >
                    <a class="navbar-brand">Login</a>
                </div>
                <div class="card-body">
                    <form action="ValidateLogin.jsp">
                        <div class="mb-3">
                            <label for="txtemail" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="txtemail" name="txtemail" value="usuario1@eventos.com">                            
                        </div>
                        <div class="mb-3">
                            <label for="txtpwd" class="form-label">Password</label>
                            <input type="password" class="form-control" id="txtpwd" name="txtpwd" value="usuario123">
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="exampleCheck1">
                            <label class="form-check-label" for="exampleCheck1">Check me out</label>
                        </div>
                        <div class="d-flex justify-content-between mt-3">
                            <button type="submit" id="primaryBtn" class="btn me-2">Login</button>
                            <button type="button" id="secondaryBtn" class="btn ms-2" data-bs-toggle="modal" data-bs-target="#registerModal">Register</button>
                        </div>
                    </form>                         
                </div>
            </div>
        </div>

        <footer class='text-white text-center text-lg-start mt-auto footer'>
            <div class='text-center p-3' style='background-color: #586e7d; margin-top: 200px'>
                © 2024 Eventos CR | All rights reserved.
            </div>
        </footer>
    </body>
</html>
