<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth-verify.css">
</head>
<body>
    <div class="container">
        <img src="${pageContext.request.contextPath}/assets/img/key.png" alt="Quên mật khẩu" class="icon">
        
        <h2>Quên mật khẩu</h2>
        <p class="subtitle">Nhập email của bạn để nhận mã xác thực OTP khôi phục mật khẩu.</p>
        
        <c:if test="${not empty successMessage}">
            <div class="success-msg">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="error-msg">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="form-group">
                <label>
                    <i class="fas fa-envelope"></i> Địa chỉ Email
                </label>
                <div class="input-wrapper">
                    <input type="email" name="email" value="${email}" placeholder="example@gmail.com" required>
                </div>
            </div>
            <button type="submit" class="submit-btn">
                Gửi mã xác thực
            </button>
        </form>
        
        <div class="back-link">
            Nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>