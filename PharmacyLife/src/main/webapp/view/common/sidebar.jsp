<%@ page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/sidebar.css"
/>
<div class="sidebar-wrapper">
  <div class="sidebar-menu">
    <c:set var="uri" value="${pageContext.request.requestURI}" />

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
            <div class="sidebar-wrapper">
                <div class="sidebar-menu">
                    <c:set var="uri" value="${pageContext.request.requestURI}" />

                    <a href="${pageContext.request.contextPath}/profile"
                        class="sidebar-item ${fn:contains(uri, 'profile') && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-user"></i> Thông tin của tôi
                    </a>

                    <a href="${pageContext.request.contextPath}/order-list"
                        class="sidebar-item ${(fn:contains(uri, '/order-list') || fn:contains(uri, '/order-detail')) && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-box"></i> Đơn hàng của tôi
                    </a>

                    <a href="${pageContext.request.contextPath}/cart"
                        class="sidebar-item ${(fn:contains(uri, 'cart') || fn:contains(uri, 'checkout')) && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-shopping-cart"></i> Giỏ hàng của tôi
                    </a>

                    <a href="${pageContext.request.contextPath}/reviews"
                        class="sidebar-item ${fn:contains(uri, 'reviews') && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-comment-dots"></i> Đánh giá của tôi
                    </a>

                    <hr>
                    <div class="sidebar-heading text-muted small text-uppercase fw-bold mb-2 px-3">Quản Trị Viên</div>

                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                        class="sidebar-item ${fn:contains(uri, 'dashboard') && !fn:contains(uri, 'order') && !fn:contains(uri, 'customer') && !fn:contains(uri, 'product') && !fn:contains(uri, 'staff') ? 'active' : ''}">
                        <i class="fas fa-tachometer-alt"></i> Tổng quan
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/orders-dashboard"
                        class="sidebar-item ${fn:contains(uri, 'order') && fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-shopping-bag"></i> Quản lý đơn hàng
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/products-dashboard"
                        class="sidebar-item ${fn:contains(uri, 'product') && fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-pills"></i> Quản lý sản phẩm
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/customers-dashboard"
                        class="sidebar-item ${fn:contains(uri, 'customer') && fn:contains(uri, 'dashboard') ? 'active' : ''}">
                        <i class="fas fa-users"></i> Quản lý khách hàng
                    </a>

                    <c:if test="${sessionScope.roleName eq 'Admin'}">
                        <a href="${pageContext.request.contextPath}/Staffmanage"
                            class="sidebar-item ${fn:contains(uri, 'Staffmanage') ? 'active' : ''}">
                            <i class="fas fa-user-shield"></i> Quản lý nhân viên
                        </a>
                    </c:if>
                </div>
                <div class="sidebar-footer">
                    <a href="logout-page" class="sidebar-item sidebar-logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </div>
