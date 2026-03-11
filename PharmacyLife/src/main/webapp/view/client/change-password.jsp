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
                        <input type="password" name="currentPassword" id="currentPassword" placeholder="Nhập mật khẩu hiện tại của bạn" required>
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" name="newPassword" id="newPassword" placeholder="Nhập mật khẩu mới của bạn" required>
                    </div>

                    <div class="form-group">
                        <label>Nhập lại mật khẩu mới</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới của bạn" required>
                    </div>

                    <div id="passwordError" class="alert alert-error" style="display: none; margin-bottom: 20px; align-items: center; gap: 8px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span id="errorText"></span>
                    </div>

                    <button type="submit" class="submit-btn">Lưu thay đổi</button>
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

            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                showError("Mật khẩu xác nhận không khớp");
                return;
            }
        });

        [currentPassword, newPassword, confirmPassword].forEach(input => {
            input.addEventListener('input', hideError);
        });
    </script>
</body>
</html>
