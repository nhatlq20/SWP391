<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
            <div class="sidebar-wrapper">
                <div class="sidebar-menu">
                    <c:set var="uri" value="${pageContext.request.requestURI}" />

                    <a href="profile" class="sidebar-item ${fn:contains(uri, 'profile') ? 'active' : ''}">
                        <i class="fas fa-user"></i> Thông tin của tôi
                    </a>

                    <a href="order-list"
                        class="sidebar-item ${fn:contains(uri, 'order-list') || fn:contains(uri, 'order-detail') ? 'active' : ''}">
                        <i class="fas fa-box"></i> Đơn hàng của tôi
                    </a>

                    <a href="cart"
                        class="sidebar-item ${fn:contains(uri, 'cart') || fn:contains(uri, 'checkout') ? 'active' : ''}">
                        <i class="fas fa-shopping-cart"></i> Giỏ hàng của tôi
                    </a>

                    <a href="reviews" class="sidebar-item ${fn:contains(uri, 'reviews') ? 'active' : ''}">
                        <i class="fas fa-comment-dots"></i> Đánh giá của tôi
                    </a>
                </div>
                <div class="sidebar-footer">
                    <a href="logout" class="sidebar-item sidebar-logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </div>