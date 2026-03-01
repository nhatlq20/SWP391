<%-- Document : register Created on : Feb 14, 2026 Author : anltc --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                                    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
                                        <div id="clientRegisterError" class="error-message" style="display: none;">
                                            <p id="clientRegisterErrorText"></p>
                                        </div>
                                        <!-- Full Name Field -->
                                        <div class="form-group">
                                            <label for="fullName">Họ và tên của bạn</label>
                                            <div class="input-wrapper">
                                                <input type="text" id="fullName" name="fullName"
                                                    placeholder="Nhập họ và tên của bạn"
                                                    value="${fn:escapeXml(fullName)}" required maxlength="100"
                                                    autocomplete="name">
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
                                                    value="${fn:escapeXml(phone)}" required maxlength="15"
                                                    autocomplete="tel" inputmode="numeric">
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
                                                    value="${fn:escapeXml(email)}" required maxlength="254"
                                                    autocomplete="username" inputmode="email">
                                                <img src="${pageContext.request.contextPath}/assets/img/emaillogin.png"
                                                    alt="Email Icon" class="input-icon">
                                            </div>
                                        </div>

                                        <!-- Password Field -->
                                        <div class="form-group">
                                            <label for="password">Mật khẩu</label>
                                            <div class="input-wrapper password-wrapper">
                                                <input type="password" id="password" name="password" class="password-input"
                                                    placeholder="Nhập mật khẩu của bạn" required minlength="8" maxlength="16"
                                                    autocomplete="new-password">
                                                <img src="${pageContext.request.contextPath}/assets/img/pass.png"
                                                    alt="Password Icon" class="input-icon">
                                                <button type="button" class="password-toggle"
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

                                        <!-- Confirm Password Field -->
                                        <div class="form-group">
                                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                                            <div class="input-wrapper password-wrapper">
                                                <input type="password" id="confirmPassword" name="confirmPassword" class="password-input"
                                                    placeholder="Nhập lại mật khẩu của bạn" required minlength="8" maxlength="16"
                                                    autocomplete="new-password">
                                                <img src="${pageContext.request.contextPath}/assets/img/pass.png"
                                                    alt="Password Icon" class="input-icon">
                                                <button type="button" class="password-toggle"
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

            <script>
                const registerForm = document.getElementById("registerForm");
                const fullNameInput = document.getElementById("fullName");
                const phoneInput = document.getElementById("phone");
                const emailInput = document.getElementById("email");
                const passwordInput = document.getElementById("password");
                const confirmPasswordInput = document.getElementById("confirmPassword");
                const clientRegisterError = document.getElementById("clientRegisterError");
                const clientRegisterErrorText = document.getElementById("clientRegisterErrorText");

                function showRegisterError(message) {
                    clientRegisterErrorText.textContent = message;
                    clientRegisterError.style.display = "block";
                }

                function hideRegisterError() {
                    clientRegisterErrorText.textContent = "";
                    clientRegisterError.style.display = "none";
                }

                function normalizeName(value) {
                    return value.trim().replace(/\s+/g, " ");
                }

                function normalizePhone(value) {
                    let normalized = value.trim().replace(/[\s.-]/g, "");
                    if (normalized.startsWith("+84") && normalized.length === 12) {
                        normalized = "0" + normalized.substring(3);
                    } else if (normalized.startsWith("84") && normalized.length === 11) {
                        normalized = "0" + normalized.substring(2);
                    }
                    return normalized;
                }

                const passwordWrappers = document.querySelectorAll(".password-wrapper");

                passwordWrappers.forEach(function (wrapper) {
                    const passwordInput = wrapper.querySelector(".password-input");
                    const togglePasswordButton = wrapper.querySelector(".password-toggle");

                    if (!passwordInput || !togglePasswordButton) {
                        return;
                    }

                    function hidePasswordToggle() {
                        togglePasswordButton.classList.remove("visible");
                        passwordInput.type = "password";
                        togglePasswordButton.setAttribute("aria-pressed", "false");
                    }

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
                });

                if (registerForm) {
                    registerForm.addEventListener("submit", function (event) {
                        hideRegisterError();

                        const normalizedFullName = normalizeName(fullNameInput.value);
                        const normalizedPhone = normalizePhone(phoneInput.value);
                        const normalizedEmail = emailInput.value.trim().toLowerCase();
                        const passwordValue = passwordInput.value;
                        const confirmPasswordValue = confirmPasswordInput.value;

                        const fullNameRegex = /^[\p{L}][\p{L}\s'.-]{1,99}$/u;
                        const emailRegex = /^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*@(gmail\.com|yahoo\.com|fucantho|fucantho\.edu\.vn)$/;
                        const phoneRegex = /^0(3|5|7|8|9)\d{8}$/;

                        fullNameInput.value = normalizedFullName;
                        phoneInput.value = normalizedPhone;
                        emailInput.value = normalizedEmail;

                        if (!normalizedFullName || !normalizedPhone || !normalizedEmail || !passwordValue || !confirmPasswordValue) {
                            event.preventDefault();
                            showRegisterError("Vui lòng nhập đầy đủ thông tin!");
                            return;
                        }

                        if (!fullNameRegex.test(normalizedFullName)) {
                            event.preventDefault();
                            showRegisterError("Họ tên không hợp lệ!");
                            return;
                        }

                        if (normalizedEmail.length > 254 || !emailRegex.test(normalizedEmail)) {
                            event.preventDefault();
                            showRegisterError("Email chỉ được dùng đuôi: @gmail.com, @yahoo.com, @fucantho hoặc @fucantho.edu.vn");
                            return;
                        }

                        if (!phoneRegex.test(normalizedPhone)) {
                            event.preventDefault();
                            showRegisterError("Số điện thoại không hợp lệ!");
                            return;
                        }

                        if (passwordValue.length < 8 || passwordValue.length > 16) {
                            event.preventDefault();
                            showRegisterError("Mật khẩu phải từ 8 đến 16 ký tự!");
                            return;
                        }

                        if (passwordValue !== confirmPasswordValue) {
                            event.preventDefault();
                            showRegisterError("Mật khẩu xác nhận không khớp!");
                        }
                    });

                    [fullNameInput, phoneInput, emailInput, passwordInput, confirmPasswordInput].forEach(function (input) {
                        input.addEventListener("input", hideRegisterError);
                    });
                }
            </script>
        </body>

        </html>