<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay đổi mật khẩu - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/change-password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        /* Responsive & Anti-overlap overrides */
        .change-password-container {
            margin-left: 280px !important;
            margin-top: 110px !important;
            padding: 30px 50px !important;
            background-color: #f1f5f9 !important;
            min-height: calc(100vh - 110px) !important;
            width: calc(100% - 280px) !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important; /* Centered as requested */
            justify-content: flex-start !important;
        }

        .change-password-modal {
            background: white !important;
            border-radius: 20px !important;
            padding: 35px 50px !important;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05) !important;
            border: 2px solid #4B9AFF !important; /* Blue border to match profile */
            max-width: 500px !important;
            width: 100% !important;
            margin-top: 20px !important;
        }

        .password-title-top {
            font-size: 28px !important;
            font-weight: 700 !important;
            color: #1e293b !important;
            margin-bottom: 10px !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
            width: 100% !important; /* Occupy full width to allow left alignment if needed */
            max-width: 500px !important; /* Match the modal width for perfect alignment */
            text-align: left !important;
        }

        .password-title-top i {
            color: #4B9AFF !important;
        }

        .modal-header {
            display: none !important; /* Move title outside like profile */
        }

        .password-form {
            gap: 15px !important;
        }

        .form-group label {
            font-size: 14px !important;
            font-weight: 500 !important;
            color: #1e293b !important;
            margin-bottom: 6px !important;
        }

        .form-group input {
            background-color: #f3f6f9 !important;
            border: none !important;
            border-radius: 10px !important;
            padding: 12px 18px !important;
            font-size: 14px !important;
            color: #475569 !important;
        }

        .form-group input:focus {
            background-color: #ffffff !important;
            box-shadow: 0 0 0 2px rgba(75, 154, 255, 0.2) !important;
        }

        .submit-btn {
            background: #628ce6 !important; /* Matching blue/lavender */
            border-radius: 30px !important;
            padding: 12px !important;
            font-weight: 600 !important;
            margin-top: 15px !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1) !important;
        }

        .submit-btn:hover {
            opacity: 0.9 !important;
            transform: translateY(-1px) !important;
        }

        @media (max-width: 1024px) {
            .change-password-container {
                margin-left: 280px !important;
                padding: 20px !important;
            }
        }
    </style>
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
