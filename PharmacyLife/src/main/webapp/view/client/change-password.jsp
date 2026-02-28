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

                <form action="${pageContext.request.contextPath}/change-password" method="post" class="password-form">
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <input type="password" name="currentPassword" placeholder="Nhập mật khẩu hiện tại của bạn" required>
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới của bạn" required minlength="6">
                    </div>

                    <div class="form-group">
                        <label>Nhập lại mật khẩu mới</label>
                        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới của bạn" required minlength="6">
                    </div>

                    <button type="submit" class="submit-btn">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
