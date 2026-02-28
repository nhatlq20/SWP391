<%-- Document : login Created on : Feb 14, 2026, 7:52:37 AM Author : anltc --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                            <img src="${pageContext.request.contextPath}/assets/img/logo1.png" alt="Logo Icon"
                                class="icon-logo">
                            <img src="${pageContext.request.contextPath}/assets/img/logo2.png" alt="Logo Text"
                                class="text-logo">
                        </div>

                        <p class="login-title">Đăng nhập vào tài khoản của bạn</p>

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
                                        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" novalidate>
                                            <div id="clientLoginError"
                                                style="display: none; background-color: #ffe6e6; border-left: 4px solid #ff4444; padding: 12px; margin-bottom: 20px; border-radius: 4px; color: #cc0000; font-size: 14px;">
                                            </div>
                                            <!-- Email Field -->
                                            <div class="form-group">
                                                <label for="email">Địa chỉ email</label>
                                                <div class="input-wrapper">
                                                    <input type="email" id="email" name="email"
                                                        placeholder="Nhập email của bạn" value="${email}" required
                                                        maxlength="254" autocomplete="username" inputmode="email">
                                                    <img src="${pageContext.request.contextPath}/assets/img/email.png"
                                                        alt="Email Icon" class="input-icon">
                                                </div>
                                            </div>

                                            <!-- Password Field -->
                                            <div class="form-group">
                                                <label for="password">Mật Khẩu</label>
                                                <div class="input-wrapper password-wrapper">
                                                    <input type="password" id="password" name="password" class="password-input"
                                                        placeholder="Nhập mật khẩu của bạn" required minlength="8" maxlength="16"
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

                                            <!-- Divider -->
                                            <div class="divider">Hoặc</div>

                                            <!-- Register Link -->
                                            <div class="register-link">
                                                <a href="${pageContext.request.contextPath}/register">Đăng kí ngay</a>
                                            </div>

                                            <!-- Google Login Button -->
                                            <button type="button" class="btn-google" onclick="loginWithGoogle()">
                                                <svg class="google-icon" viewBox="0 0 24 24">
                                                    <path class="google-blue"
                                                        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                                                    <path class="google-green"
                                                        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                                                    <path class="google-yellow"
                                                        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
                                                    <path class="google-red"
                                                        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
                                                </svg>
                                                Đăng nhập với Google
                                            </button>
                                        </form>
                    </div>
                </div>

                <script>
                    function loginWithGoogle() {
                        var clientId = "314105560833-79r5neb6b7fciaqfql64ib168vifbm2t.apps.googleusercontent.com";
                        var redirectUri = "http://localhost:8080/pharmacy/login";
                        var scope = "email profile";
                        var authUrl = "https://accounts.google.com/o/oauth2/auth?scope=" + encodeURIComponent(scope) + "&client_id=" + clientId + "&redirect_uri=" + encodeURIComponent(redirectUri) + "&response_type=code";
                        
                        window.location.href = authUrl;
                    }

                    const passwordInput = document.getElementById("password");
                    const togglePasswordButton = document.getElementById("togglePassword");
                    const loginForm = document.getElementById("loginForm");
                    const emailInput = document.getElementById("email");
                    const clientLoginError = document.getElementById("clientLoginError");

                    function showClientError(message) {
                        clientLoginError.textContent = message;
                        clientLoginError.style.display = "block";
                    }

                    function hideClientError() {
                        clientLoginError.textContent = "";
                        clientLoginError.style.display = "none";
                    }

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

                    if (loginForm) {
                        loginForm.addEventListener("submit", function (event) {
                            hideClientError();

                            const normalizedEmail = emailInput.value.trim().toLowerCase();
                            const normalizedPassword = passwordInput.value.trim();
                            const emailRegex = /^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*@(gmail\.com|yahoo\.com|fucantho|fucantho\.edu\.vn)$/;

                            emailInput.value = normalizedEmail;

                            if (!normalizedEmail || !normalizedPassword) {
                                event.preventDefault();
                                showClientError("Vui lòng nhập đầy đủ email và mật khẩu!");
                                return;
                            }

                            if (normalizedEmail.length > 254 || !emailRegex.test(normalizedEmail)) {
                                event.preventDefault();
                                showClientError("Email chỉ được dùng đuôi: @gmail.com, @yahoo.com, @fucantho hoặc @fucantho.edu.vn");
                                return;
                            }

                            if (passwordInput.value.length < 8 || passwordInput.value.length > 16) {
                                event.preventDefault();
                                showClientError("Mật khẩu phải từ 8 đến 16 ký tự!");
                            }
                        });

                        emailInput.addEventListener("input", hideClientError);
                        passwordInput.addEventListener("input", hideClientError);
                    }
                </script>
            </body>

            </html>