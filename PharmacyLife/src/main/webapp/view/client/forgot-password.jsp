<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quên mật khẩu - Pharmacy Life</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forgot-password.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
            <style>
                /* Anti-overlap & Position Fix */
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
                    border: 1px solid #e2e8f0 !important; /* Lighter border */
                    max-width: 450px !important;
                    width: 100% !important;
                    text-align: center !important;
                }

                .forgot-icon {
                    margin-bottom: 20px !important;
                }

                .forgot-icon img {
                    width: 80px !important; /* Larger as per screenshot */
                    height: 80px !important;
                }

                .forgot-password-card h2 {
                    color: #4F81E1 !important; /* Blue title as per screenshot */
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

                /* Fixed overlap issue with absolute override */
                .input-wrapper {
                    background-color: #f8fafc !important;
                    border: 1px solid #e2e8f0 !important;
                    border-radius: 12px !important;
                    display: flex !important;
                    align-items: center !important;
                    position: relative !important;
                }

                .input-icon {
                    position: static !important; /* REMOVE absolute positioning */
                    transform: none !important;
                    padding: 0 15px !important;
                    color: #333 !important;
                    font-size: 18px !important;
                    font-weight: 500 !important;
                }

                .input-wrapper input {
                    background: transparent !important;
                    border: none !important;
                    padding: 14px 10px !important;
                    font-size: 15px !important;
                    color: #475569 !important;
                    width: 100% !important;
                    outline: none !important;
                }

                .info-text {
                    display: flex !important;
                    align-items: center !important;
                    gap: 6px !important;
                    font-size: 13px !important;
                    color: #64748b !important;
                    margin-top: 10px !important;
                    text-align: left !important;
                }

                .info-text i {
                    color: #4B9AFF !important;
                }

                .submit-btn-forgot {
                    background: #4B81E1 !important; /* Matching blue button */
                    color: white !important;
                    border: none !important;
                    border-radius: 12px !important; /* Less rounded as per screenshot */
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

                .back-to-login {
                    margin-top: 25px !important;
                    font-size: 14px !important;
                    color: #1e293b !important;
                }

                .back-to-login a {
                    color: #4B9AFF !important;
                    text-decoration: none !important;
                    font-weight: 600 !important;
                }

                @media (max-width: 1024px) {
                    .forgot-password-container {
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