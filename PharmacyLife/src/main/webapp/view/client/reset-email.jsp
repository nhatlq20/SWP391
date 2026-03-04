<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập email mới - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth-verify.css">
</head>
<body>
    <div class="container">
        <img src="${pageContext.request.contextPath}/assets/img/veriEmail.png" alt="Email" class="icon">
        
        <h2>Thay đổi Email</h2>
        <p class="subtitle">Vui lòng nhập địa chỉ email mới của bạn.</p>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" style="color: #dc3545; background-color: #f8d7da; border-color: #f5c6cb; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/change-email" method="post">
            <input type="hidden" name="action" value="submit-new-email">
            <div class="form-group">
                <label>
                    <i class="fas fa-envelope"></i> Email mới
                </label>
                <div class="input-wrapper">
                    <input type="email" name="newEmail" placeholder="Nhập email mới của bạn" required style="width: 100%; padding: 10px; margin-top: 5px; border-radius: 5px; border: 1px solid #ddd;">
                </div>
            </div>
            <button type="submit" class="submit-btn" style="margin-top: 20px; width: 100%; padding: 10px; background-color: #4F81E1; color: white; border: none; border-radius: 5px; cursor: pointer;">
                Tiếp tục
            </button>
        </form>
        
        <div class="back-link" style="margin-top: 15px; text-align: center;">
            <a href="${pageContext.request.contextPath}/profile" style="color: #4F81E1; text-decoration: none;"> Quay lại hồ sơ</a>
        </div>
    </div>
</body>
</html>
