<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quên mật khẩu - Pharmacy Life</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/password.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">

        <body>
            <%@ include file="/view/common/header.jsp" %>

                <div style="display: flex;">
                    <%@ include file="/view/common/sidebar.jsp" %>

                        <div class="forgot-password-container">
                            <div class="forgot-password-card">
                                <div class="forgot-icon">
                                    <img src="${pageContext.request.contextPath}/assets/img/key.png" alt="Key">
                                </div>

                                <h2>Quên mật khẩu</h2>
                                <p class="subtitle">Nhập email để nhận mã OTP</p>

                                <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                                    <div class="form-group-forgot">
                                        <label>
                                            <i class="fas fa-envelope"></i>
                                            Email
                                        </label>
                                        <div class="input-wrapper">
                                            <span class="input-icon">@</span>
                                            <input type="email" name="email" placeholder="Nhập email của bạn" required>
                                        </div>
                                        <div class="info-text">
                                            <i class="fas fa-info-circle"></i>
                                            <span>Mã OTP sẽ được gửi đến email này</span>
                                        </div>
                                    </div>

                                    <button type="submit" class="submit-btn-forgot">
                                        <i class="fas fa-paper-plane"></i>
                                        Gửi mã OTP
                                    </button>
                                </form>

                                <div class="back-to-login">
                                    Nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                </div>
                            </div>
                        </div>
                </div>
        </body>

        </html>