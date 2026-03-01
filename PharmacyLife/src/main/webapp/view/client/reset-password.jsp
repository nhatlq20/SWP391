<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
</head>
<body>
    <%@ include file="/view/common/header.jsp" %>
    <div style="display: flex;">
        <%@ include file="/view/common/sidebar.jsp" %>
        <div class="forgot-password-container">
            <div class="forgot-password-card">
                <div class="forgot-icon">
                    <img src="${pageContext.request.contextPath}/assets/img/key.png" alt="Key">
                </div>
                <h2>Đặt lại mật khẩu</h2>
                <p class="subtitle">Nhập mật khẩu mới cho tài khoản của bạn</p>
                
                <c:if test="${not empty errorMessage}">
                    <div style="color: red; margin-bottom: 10px;">${errorMessage}</div>
                </c:if>

                <div id="clientResetError" style="color: red; margin-bottom: 10px; display: none;"></div>

                <form id="resetPasswordForm" action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>
                    <div class="form-group-forgot">
                        <label>
                            <i class="fas fa-lock"></i>
                            Mật khẩu mới
                        </label>
                        <div class="input-wrapper">
                            <input type="password" name="password" placeholder="Nhập mật khẩu mới" required>
                        </div>
                    </div>
                    <div class="form-group-forgot">
                        <label>
                            <i class="fas fa-check-circle"></i>
                            Xác nhận mật khẩu
                        </label>
                        <div class="input-wrapper">
                            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn-forgot">
                        Đổi mật khẩu
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const resetPasswordForm = document.getElementById("resetPasswordForm");
        const passwordInput = resetPasswordForm ? resetPasswordForm.querySelector('input[name="password"]') : null;
        const confirmPasswordInput = resetPasswordForm ? resetPasswordForm.querySelector('input[name="confirmPassword"]') : null;
        const clientResetError = document.getElementById("clientResetError");

        function showResetError(message) {
            if (!clientResetError) {
                return;
            }
            clientResetError.textContent = message;
            clientResetError.style.display = "block";
        }

        function hideResetError() {
            if (!clientResetError) {
                return;
            }
            clientResetError.textContent = "";
            clientResetError.style.display = "none";
        }

        if (resetPasswordForm) {
            resetPasswordForm.addEventListener("submit", function (event) {
                hideResetError();

                const passwordValue = passwordInput ? passwordInput.value : "";
                const confirmValue = confirmPasswordInput ? confirmPasswordInput.value : "";

                if (passwordValue.length < 8 || passwordValue.length > 16) {
                    event.preventDefault();
                    showResetError("mật khẩu phải có độ dài từ 8 đến 16 kí tự");
                    return;
                }

                if (confirmValue.length < 8 || confirmValue.length > 16) {
                    event.preventDefault();
                    showResetError("mật khẩu phải có độ dài từ 8 đến 16 kí tự");
                    return;
                }

                if (passwordValue !== confirmValue) {
                    event.preventDefault();
                    showResetError("Mật khẩu xác nhận không khớp.");
                }
            });

            if (passwordInput) {
                passwordInput.addEventListener("input", hideResetError);
            }
            if (confirmPasswordInput) {
                confirmPasswordInput.addEventListener("input", hideResetError);
            }
        }
    </script>
</body>
</html>
