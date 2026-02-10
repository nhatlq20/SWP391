<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <div class="sidebar-wrapper">
        <div class="sidebar-menu">
            <a href="profile" class="sidebar-item">
                <i class="fas fa-user"></i> Thông tin của tôi
            </a>
            <a href="orders" class="sidebar-item">
                <i class="fas fa-box"></i> Đơn hàng của tôi
            </a>
            <a href="cart" class="sidebar-item active">
                <i class="fas fa-shopping-cart"></i> Giỏ hàng của tôi
            </a>
            <a href="reviews" class="sidebar-item">
                <i class="fas fa-comment-dots"></i> Đánh giá của tôi
            </a>
        </div>
        <div class="sidebar-footer">
            <a href="logout" class="sidebar-item sidebar-logout">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>