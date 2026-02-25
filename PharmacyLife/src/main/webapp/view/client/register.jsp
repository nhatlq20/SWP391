<%-- Document : register Created on : Feb 14, 2026 Author : anltc --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng ký - Pharmacy Life</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
        </head>

        <body>
            <div class="register-container">
                <!-- Left Side - Image -->
                <div class="register-left">
                    <img src="${pageContext.request.contextPath}/assets/img/login.png" alt="Register Illustration">
                </div>

                <!-- Right Side - Form -->
                <div class="register-right">
                    <!-- Logo -->
                    <div class="register-logo">
                        <img src="${pageContext.request.contextPath}/assets/img/logo1.png" alt="Logo Icon"
                            class="icon-logo">
                        <img src="${pageContext.request.contextPath}/assets/img/logo2.png" alt="Logo Text"
                            class="text-logo">
                    </div>

                    <p class="register-title">Đăng kí tài khoản của bạn</p>

                    <!-- Error Message -->
                    <% if (request.getAttribute("errorMessage") !=null) { %>
                        <div class="error-message">
                            <p>
                                <%= request.getAttribute("errorMessage") %>
                            </p>
                        </div>
                        <% } %>

                            <!-- Success Message -->
                            <% if (request.getAttribute("successMessage") !=null) { %>
                                <div class="success-message">
                                    <p>
                                        <%= request.getAttribute("successMessage") %>
                                    </p>
                                </div>
                                <% } %>

                                    <!-- Register Form -->
                                    <form action="${pageContext.request.contextPath}/register" method="post">
                                        <!-- Full Name Field -->
                                        <div class="form-group">
                                            <label for="fullName">Họ và tên của bạn</label>
                                            <div class="input-wrapper">
                                                <input type="text" id="fullName" name="fullName"
                                                    placeholder="Nhập họ và tên của bạn"
                                                    value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>" required>
                                                <img src="${pageContext.request.contextPath}/assets/img/emaillogin.png"
                                                    alt="Name Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Phone Field -->
                                        <div class="form-group">
                                            <label for="phone">Số điện thoại</label>
                                            <div class="input-wrapper">
                                                <input type="tel" id="phone" name="phone"
                                                    placeholder="Nhập số điện thoại của bạn"
                                                    value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
                                                <img src="${pageContext.request.contextPath}/assets/img/phonereg.png"
                                                    alt="Phone Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Email Field -->
                                        <div class="form-group">
                                            <label for="email">Địa chỉ email</label>
                                            <div class="input-wrapper">
                                                <input type="email" id="email" name="email"
                                                    placeholder="Nhập email của bạn"
                                                    value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                                                <img src="${pageContext.request.contextPath}/assets/img/emaillogin.png"
                                                    alt="Email Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Password Field -->
                                        <div class="form-group">
                                            <label for="password">Mật khẩu</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="password" name="password"
                                                    placeholder="Nhập mật khẩu của bạn" required>
                                                <img src="${pageContext.request.contextPath}/assets/img/pass.png"
                                                    alt="Password Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Confirm Password Field -->
                                        <div class="form-group">
                                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="confirmPassword" name="confirmPassword"
                                                    placeholder="Nhập lại mật khẩu của bạn" required>
                                                <img src="${pageContext.request.contextPath}/assets/img/pass.png"
                                                    alt="Password Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Register Button -->
                                        <button type="submit" class="btn-register">Đăng kí</button>

                                        <!-- Divider -->
                                        <div class="divider">Hoặc</div>

                                        <!-- Login Link -->
                                        <div class="login-link">
                                            Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng
                                                nhập ngay</a>
                                        </div>
                                    </form>
                </div>
            </div>
        </body>

        </html>