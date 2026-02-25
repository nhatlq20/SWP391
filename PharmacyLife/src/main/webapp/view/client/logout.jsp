<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng xuất - Pharmacy Life</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/logout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        /* Modern UI & Position Fix for Logout */
        .logout-container {
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

        .logout-modal {
            background: white !important;
            border-radius: 20px !important;
            padding: 40px !important;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05) !important;
            border: 1px solid #e2e8f0 !important;
            max-width: 450px !important;
            width: 100% !important;
            text-align: center !important;
        }

        .logout-icon img {
            width: 80px !important;
            height: 80px !important;
            margin-bottom: 20px !important;
        }

        .logout-modal h2 {
            color: #4F81E1 !important;
            font-size: 28px !important;
            font-weight: 700 !important;
            margin-bottom: 20px !important;
        }

        .logout-modal p {
            color: #64748b !important;
            font-size: 16px !important;
            margin-bottom: 30px !important;
        }

        .button-group {
            display: flex !important;
            gap: 15px !important;
            justify-content: center !important;
        }

        .btn {
            padding: 12px 30px !important;
            border-radius: 30px !important;
            font-weight: 600 !important;
            cursor: pointer !important;
            transition: all 0.2s ease !important;
            font-size: 15px !important;
            border: none !important;
            flex: 1 !important;
        }

        .btn-cancel {
            background-color: #94a3b8 !important; /* Xám đậm hơn để nổi bật chữ trắng */
            color: white !important;
        }

        .btn-cancel:hover {
            background-color: #64748b !important;
        }

        .btn-logout {
            background-color: #4B9AFF !important;
            color: white !important;
            box-shadow: 0 4px 10px rgba(75, 154, 255, 0.2) !important;
        }

        .btn-logout:hover {
            background-color: #3b8aec !important;
            transform: translateY(-1px) !important;
        }

        @media (max-width: 1024px) {
            .logout-container {
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
        
        <div class="logout-container">
            <div class="logout-modal">
                <div class="logout-icon">
                    <img src="${pageContext.request.contextPath}/assets/img/logout.png" alt="Logout">
                </div>
                
                <h2>Đăng xuất</h2>
                
                <p>Bạn có muốn đăng xuất hay không?</p>
                
                <div class="button-group">
                    <button class="btn btn-cancel" onclick="window.history.back()">
                        Đóng
                    </button>
                    <button class="btn btn-logout" onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                        Đăng xuất
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
