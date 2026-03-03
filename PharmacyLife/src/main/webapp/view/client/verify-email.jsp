<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực Email - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .verify-container {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }
        .verify-icon {
            width: 80px;
            height: 80px;
            margin-bottom: 20px;
        }
        h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 24px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .subtitle strong {
            color: #4F81E1;
        }
        .form-group {
            margin-bottom: 25px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #555;
        }
        .input-wrapper {
            position: relative;
        }
        .input-wrapper input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e4e8;
            border-radius: 8px;
            font-size: 24px;
            text-align: center;
            letter-spacing: 8px;
            font-weight: bold;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        .input-wrapper input:focus {
            outline: none;
            border-color: #4F81E1;
        }
        .submit-btn {
            width: 100%;
            padding: 14px;
            background: #4F81E1;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .submit-btn:hover {
            background: #3d6dc9;
        }
        .error-msg {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            border: 1px solid #f5c6cb;
        }
        .back-link {
            margin-top: 25px;
            font-size: 14px;
            color: #777;
        }
        .back-link a {
            color: #4F81E1;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="verify-container">
        <img src="${pageContext.request.contextPath}/assets/img/veriEmail.png" alt="Xác thực Email" class="verify-icon">
        
        <h2>Xác thực Email</h2>
        <p class="subtitle">Chúng tôi đã gửi mã OTP đến email:<br><strong>${email}</strong></p>
        
        <c:if test="${not empty successMessage}">
            <div style="background-color: #d1e7dd; color: #0f5132; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; border: 1px solid #badbcc;">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="error-msg">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/verify-email" method="post">
            <div class="form-group">
                <label>
                    <i class="fas fa-key"></i> Nhập mã xác thực (6 chữ số)
                </label>
                <div class="input-wrapper">
                    <input type="text" name="otp" placeholder="XXXXXX" maxlength="6" pattern="\d{6}" required autocomplete="off">
                </div>
            </div>
            <button type="submit" class="submit-btn">
                Xác nhận đăng ký
            </button>
        </form>

        <form action="${pageContext.request.contextPath}/verify-email" method="post" style="margin-top: 15px;">
            <input type="hidden" name="action" value="resend">
            <button type="submit" style="background: none; border: none; color: #4F81E1; font-weight: 600; cursor: pointer; text-decoration: underline; font-size: 14px;">
                Gửi lại mã OTP
            </button>
        </form>
        
        <div class="back-link">
            Không nhận được mã? <a href="${pageContext.request.contextPath}/register">Quay lại đăng ký</a>
        </div>
    </div>
</body>
</html>
