<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực mã OTP - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth-verify.css">
</head>
<body>
    <div class="container">
        <img src="${pageContext.request.contextPath}/assets/img/key.png" alt="Xác thực OTP" class="icon">
        
        <h2>Xác thực mã OTP</h2>
        <p class="subtitle">Vui lòng nhập mã OTP 6 số đã được gửi đến email của bạn.</p>
        
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

        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <div class="form-group">
                <label>
                    <i class="fas fa-key"></i> Nhập mã xác thực (6 chữ số)
                </label>
                <div class="input-wrapper">
                    <input type="text" name="otp" placeholder="" maxlength="6" pattern="\d{6}" required autocomplete="off">
                </div>
            </div>
            <button type="submit" class="submit-btn">
                Xác nhận
            </button>
        </form>
        
        <div class="back-link">
            Chưa nhận được mã? <a href="${pageContext.request.contextPath}/verify-otp?action=resend">Gửi lại mã</a>
        </div>
    </div>
</body>
</html>
