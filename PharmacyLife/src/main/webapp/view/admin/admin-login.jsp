<%-- Document : login Created on : Feb 14, 2026, 7:52:37 AM Author : anltc --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="utils.Constants" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng nhập Nội bộ - Pharmacy Life</title>
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
                            <img src="${pageContext.request.contextPath}/assets/img/logo1.png" alt="Logo Icon"
                                class="icon-logo">
                            <img src="${pageContext.request.contextPath}/assets/img/logo2.png" alt="Logo Text"
                                class="text-logo">
                        </div>

                        <p class="login-title">Đăng nhập Quản trị & Nhân viên</p>

                        <!-- Success Message -->
                        <% if (request.getAttribute("successMessage") !=null) { %>
                            <div
                                style="background-color: #e6f7e6; border-left: 4px solid #44cc44; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
                                <p style="color: #00aa00; margin: 0; font-size: 14px;">
                                    <%= request.getAttribute("successMessage") %>
                                </p>
                            </div>
                            <% } %>

                                <!-- Error Message -->
                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                    <div
                                        style="background-color: #ffe6e6; border-left: 4px solid #ff4444; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
                                        <p style="color: #cc0000; margin: 0; font-size: 14px;">
                                            <%= request.getAttribute("errorMessage") %>
                                        </p>
                                    </div>
                                    <% } %>

                                        <!-- Login Form -->
                                        <form id="loginForm" action="${pageContext.request.contextPath}/admin-staff/login" method="post" novalidate>
                                            <!-- Email Field -->
                                            <div class="form-group">
                                                <label for="email">Địa chỉ email</label>
                                                <div class="input-wrapper">
                                                    <input type="email" id="email" name="email"
                                                        placeholder="Nhập email nội bộ" value="${email}"
                                                        autocomplete="username" inputmode="email">
                                                    <img src="${pageContext.request.contextPath}/assets/img/mail.png"
                                                        alt="Email Icon" class="input-icon">
                                                </div>
                                            </div>

                                            <!-- Password Field -->
                                            <div class="form-group">
                                                <label for="password">Mật khẩu</label>
                                                <div class="input-wrapper password-wrapper">
                                                    <input type="password" id="password" name="password" class="password-input"
                                                        placeholder="Nhập mật khẩu của bạn"
                                                        autocomplete="current-password">
                                                    <img src="${pageContext.request.contextPath}/assets/img/Lock.png"
                                                        alt="Password Icon" class="input-icon">
                                                    <button type="button" id="togglePassword" class="password-toggle"
                                                        aria-label="Hiển thị mật khẩu" aria-pressed="false">
                                                        <span class="eye-icon eye-closed" aria-hidden="true">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M17.94 17.94A10.94 10.94 0 0 1 12 20C7 20 2.73 16.89 1 12c.68-1.94 1.79-3.65 3.2-5" />
                                                                <path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c5 0 9.27 3.11 11 8a11.83 11.83 0 0 1-4.29 5.94" />
                                                                <path d="M14.12 14.12A3 3 0 1 1 9.88 9.88" />
                                                                <path d="M1 1l22 22" />
                                                            </svg>
                                                        </span>
                                                        <span class="eye-icon eye-open" aria-hidden="true">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z" />
                                                                <circle cx="12" cy="12" r="3" />
                                                            </svg>
                                                        </span>
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Forgot Password -->
                                            <div class="forgot-password">
                                                <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                                            </div>

                                            <!-- Login Button -->
                                            <button type="submit" class="btn-login">Đăng nhập</button>
                                        </form>
                    </div>
                </div>

                <script>
                    const passwordInput = document.getElementById("password");
                    const togglePasswordButton = document.getElementById("togglePassword");

                    function hidePasswordToggle() {
                        togglePasswordButton.classList.remove("visible");
                        passwordInput.type = "password";
                        togglePasswordButton.setAttribute("aria-pressed", "false");
                    }

                    if (passwordInput && togglePasswordButton) {
                        passwordInput.addEventListener("focus", function () {
                            togglePasswordButton.classList.add("visible");
                        });

                        passwordInput.addEventListener("blur", function () {
                            setTimeout(function () {
                                if (document.activeElement !== togglePasswordButton) {
                                    hidePasswordToggle();
                                }
                            }, 0);
                        });

                        togglePasswordButton.addEventListener("mousedown", function (event) {
                            event.preventDefault();
                        });

                        togglePasswordButton.addEventListener("click", function () {
                            const showPassword = passwordInput.type === "password";
                            passwordInput.type = showPassword ? "text" : "password";
                            togglePasswordButton.setAttribute("aria-pressed", String(showPassword));
                        });
                    }
                </script>
            </body>

            </html>