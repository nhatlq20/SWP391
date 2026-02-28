<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - Pharmacy Life</title>
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
                <h2>Xác thực OTP</h2>
                <p class="subtitle">Nhập mã OTP</p>
                
                <c:if test="${not empty successMessage}">
                    <div style="color: green; margin-bottom: 10px;">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div style="color: red; margin-bottom: 10px;">${errorMessage}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                    <div class="form-group-forgot">
                        <label>
                            <i class="fas fa-lock"></i>
                            Mã OTP
                        </label>
                        <div class="input-wrapper">
                            <input type="text" name="otp" placeholder="Nhập mã OTP" required>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn-forgot">
                        Xác nhận
                    </button>
                </form>
                
                <div class="back-to-login">
                    Hết hạn? <a href="${pageContext.request.contextPath}/forgot-password">Gửi lại mã</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
