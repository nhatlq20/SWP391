<%-- 
    Document   : login
    Created on : Feb 14, 2026, 7:52:37 AM
    Author     : anltc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Pharmacy Life</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
    </head>
    <body>
        <div class="login-container">
            <!-- Left Side - Image -->
            <div class="login-left">
                <img src="${pageContext.request.contextPath}/assets/img/login.png" alt="Login Illustration">
            </div>

            <!-- Right Side - Form -->
            <div class="login-right">
                <!-- Logo -->
                <div class="login-logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logo1.png" alt="Logo Icon" class="icon-logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logo2.png" alt="Logo Text" class="text-logo">
                </div>

                <p class="login-title">Đăng nhập vào tài khoản của bạn</p>

                <!-- Success Message -->
                <% if (request.getAttribute("successMessage") != null) { %>
                <div style="background-color: #e6f7e6; border-left: 4px solid #44cc44; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
                    <p style="color: #00aa00; margin: 0; font-size: 14px;">
                        <%= request.getAttribute("successMessage") %>
                    </p>
                </div>
                <% } %>

                <!-- Error Message -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="background-color: #ffe6e6; border-left: 4px solid #ff4444; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
                    <p style="color: #cc0000; margin: 0; font-size: 14px;">
                        <%= request.getAttribute("errorMessage") %>
                    </p>
                </div>
                <% } %>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/Login" method="post">
                    <!-- Email Field -->
                    <div class="form-group">
                        <label for="email">Địa chỉ email</label>
                        <div class="input-wrapper">
                            <input type="email" id="email" name="email" placeholder="Nhập email của bạn" 
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                            <img src="${pageContext.request.contextPath}/assets/img/email.png" alt="Email Icon" class="input-icon">
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password">Mật Khẩu</label>
                        <div class="input-wrapper">
                            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu của bạn" required>
                            <img src="${pageContext.request.contextPath}/assets/img/Lock.png" alt="Password Icon" class="input-icon">
                        </div>
                    </div>

                    <!-- Forgot Password -->
                    <div class="forgot-password">
                        <a href="#">Quên mật khẩu?</a>
                    </div>

                    <!-- Login Button -->
                    <button type="submit" class="btn-login">Đăng nhập</button>

                    <!-- Divider -->
                    <div class="divider">Hoặc</div>

                    <!-- Register Link -->
                    <div class="register-link">
                        <a href="${pageContext.request.contextPath}/register">Đăng kí ngay</a>
                    </div>

                    <!-- Google Login Button -->
                    <button type="button" class="btn-google" onclick="loginWithGoogle()">
                        <svg class="google-icon" viewBox="0 0 24 24">
                            <path class="google-blue" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                            <path class="google-green" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                            <path class="google-yellow" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                            <path class="google-red" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                        </svg>
                        Đăng nhập với Google
                    </button>
                </form>
            </div>
        </div>

        <script>
            function loginWithGoogle() {
                // Implement Google login functionality here
                alert('Google login functionality will be implemented');
            }
        </script>
    </body>
</html>
