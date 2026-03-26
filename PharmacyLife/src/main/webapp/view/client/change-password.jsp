<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay đổi mật khẩu - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>
    <%@ include file="/view/common/header.jsp" %>
    
    <div style="display: flex;">
        <%@ include file="/view/common/sidebar.jsp" %>
        
        <div class="change-password-container">
            <h1 class="password-title-top">
                <i class="fas fa-key"></i>
                Thay đổi mật khẩu
            </h1>
            <div class="change-password-modal">
                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${errorMessage}</span>
                </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/change-password" method="post" class="password-form" id="changePasswordForm" novalidate>
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <div class="input-wrapper password-wrapper">
                            <input type="password" name="currentPassword" id="currentPassword" class="password-input" placeholder="Nhập mật khẩu hiện tại của bạn" required>
                            <button type="button" class="password-toggle" aria-label="Hiển thị mật khẩu" aria-pressed="false">
                                <span class="eye-icon eye-closed" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 20C7 20 2.73 16.89 1 12c.68-1.94 1.79-3.65 3.2-5" />
                                        <path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c5 0 9.27 3.11 11 8a11.83 11.83 0 0 1-4.29 5.94" />
                                        <path d="M14.12 14.12A3 3 0 1 1 9.88 9.88" />
                                        <path d="M1 1l22 22" />
                                    </svg>
                                </span>
                                <span class="eye-icon eye-open" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <div class="input-wrapper password-wrapper">
                            <input type="password" name="newPassword" id="newPassword" class="password-input" placeholder="Nhập mật khẩu mới của bạn" required>
                            <button type="button" class="password-toggle" aria-label="Hiển thị mật khẩu" aria-pressed="false">
                                <span class="eye-icon eye-closed" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 20C7 20 2.73 16.89 1 12c.68-1.94 1.79-3.65 3.2-5" />
                                        <path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c5 0 9.27 3.11 11 8a11.83 11.83 0 0 1-4.29 5.94" />
                                        <path d="M14.12 14.12A3 3 0 1 1 9.88 9.88" />
                                        <path d="M1 1l22 22" />
                                    </svg>
                                </span>
                                <span class="eye-icon eye-open" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Nhập lại mật khẩu mới</label>
                        <div class="input-wrapper password-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="password-input" placeholder="Nhập lại mật khẩu mới của bạn" required>
                            <button type="button" class="password-toggle" aria-label="Hiển thị mật khẩu" aria-pressed="false">
                                <span class="eye-icon eye-closed" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 20C7 20 2.73 16.89 1 12c.68-1.94 1.79-3.65 3.2-5" />
                                        <path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c5 0 9.27 3.11 11 8a11.83 11.83 0 0 1-4.29 5.94" />
                                        <path d="M14.12 14.12A3 3 0 1 1 9.88 9.88" />
                                        <path d="M1 1l22 22" />
                                    </svg>
                                </span>
                                <span class="eye-icon eye-open" aria-hidden="true">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div id="passwordError" class="alert alert-error" style="display: none; margin-bottom: 20px; align-items: center; gap: 8px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span id="errorText"></span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/profile" class="btn-back-sync" style="padding: 6px 12px !important; font-size: 13px !important; min-height: auto !important; flex: 0 0 auto; white-space: nowrap;">
                            <i class="fas fa-chevron-left" style="font-size: 11px;"></i> Trở lại
                        </a>
                        <button type="submit" class="submit-btn" style="width: auto !important; max-width: fit-content !important; margin-bottom: 0; padding: 6px 15px !important; font-size: 13px !important; min-height: auto !important; border-radius: 10px !important; flex: 0 0 auto; white-space: nowrap;">Cập nhật mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const form = document.getElementById('changePasswordForm');
        const currentPassword = document.getElementById('currentPassword');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const errorDiv = document.getElementById('passwordError');
        const errorText = document.getElementById('errorText');

        function showError(message) {
            errorText.innerText = message;
            errorDiv.style.display = 'flex';
        }

        function hideError() {
            errorDiv.style.display = 'none';
        }

        form.addEventListener('submit', function(e) {
            hideError();

            if (!currentPassword.value) {
                e.preventDefault();
                showError("Vui lòng nhập mật khẩu hiện tại");
                return;
            }

            if (newPassword.value.length < 8 || newPassword.value.length > 16) {
                e.preventDefault();
                showError("Mật khẩu mới phải từ 8 đến 16 ký tự");
                return;
            }

            if (currentPassword.value === newPassword.value) {
                e.preventDefault();
                showError("Mật khẩu mới không được trùng với mật khẩu cũ");
                return;
            }

            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                showError("Mật khẩu xác nhận không khớp");
                return;
            }
        });

        [currentPassword, newPassword, confirmPassword].forEach(input => {
            input.addEventListener('input', hideError);
        });

        // Toggle password visibility
        document.querySelectorAll('.password-toggle').forEach(button => {
            const input = button.parentElement.querySelector('input');
            
            button.addEventListener('click', () => {
                const isPressed = button.getAttribute('aria-pressed') === 'true';
                button.setAttribute('aria-pressed', !isPressed);
                input.type = isPressed ? 'password' : 'text';
            });
        });
    </script>
</body>
</html>
