<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forgot-password.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        /* Modern UI & Position Fix for Reset Password */
        .forgot-password-container {
            margin-left: 280px !important;
            margin-top: 110px !important;
            padding: 40px !important;
            background-color: #f1f5f9 !important;
            min-height: calc(100vh - 110px) !important;
            width: calc(100% - 280px) !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
        }

        .forgot-password-card {
            background: white !important;
            border-radius: 20px !important;
            padding: 40px !important;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05) !important;
            border: 1px solid #e2e8f0 !important;
            max-width: 450px !important;
            width: 100% !important;
            text-align: center !important;
        }

        .forgot-icon img {
            width: 80px !important;
            height: 80px !important;
            margin-bottom: 20px !important;
        }

        .forgot-password-card h2 {
            color: #4F81E1 !important;
            font-size: 28px !important;
            font-weight: 700 !important;
            margin-bottom: 10px !important;
        }

        .subtitle {
            color: #64748b !important;
            font-size: 15px !important;
            margin-bottom: 30px !important;
        }

        .form-group-forgot label {
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            font-size: 14px !important;
            font-weight: 600 !important;
            color: #1e293b !important;
            margin-bottom: 10px !important;
            text-align: left !important;
        }

        .form-group-forgot label i {
            color: #4B9AFF !important;
        }

        .input-wrapper {
            background-color: #f8fafc !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 12px !important;
            transition: all 0.2s ease !important;
        }

        .input-wrapper:focus-within {
            border-color: #4B9AFF !important;
            background-color: white !important;
        }

        .input-wrapper input {
            background: transparent !important;
            border: none !important;
            padding: 14px 15px !important;
            font-size: 15px !important;
            color: #475569 !important;
            width: 100% !important;
            outline: none !important;
        }

        .submit-btn-forgot {
            background: #4B81E1 !important;
            color: white !important;
            border: none !important;
            border-radius: 12px !important;
            padding: 15px !important;
            font-weight: 600 !important;
            width: 100% !important;
            margin-top: 25px !important;
            cursor: pointer !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 10px !important;
            transition: all 0.2s ease !important;
            box-shadow: 0 4px 10px rgba(75, 129, 225, 0.2) !important;
        }

        .submit-btn-forgot:hover {
            background: #3a6dc9 !important;
            transform: translateY(-1px) !important;
        }

        @media (max-width: 1024px) {
            .forgot-password-container {
                margin-left: 280px !important; /* Keep sidebar clearance */
                padding: 20px !important;
            }
        }
    </style>
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

                <form action="${pageContext.request.contextPath}/reset-password" method="post">
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
</body>
</html>
