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
                    <button class="btn-cancel" onclick="window.history.back()">
                        Đóng
                    </button>
                    <button class="btn-logout" onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                        Đăng xuất
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
