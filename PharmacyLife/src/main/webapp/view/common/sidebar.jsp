<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
            <style>
                .sidebar-item {
                    white-space: nowrap !important;
                    display: flex !important;
                    align-items: center !important;
                    flex-wrap: nowrap !important;
                    overflow: hidden !important;
                }

                .sidebar-item i {
                    flex-shrink: 0 !important;
                    width: 20px !important;
                    margin-right: 12px !important;
                }
            </style>
            <div class="sidebar-wrapper">
                <div class="sidebar-menu">
                    <c:set var="uri" value="${pageContext.request.requestURI}" />

                    <c:set var="userRole" value="${fn:toLowerCase(fn:trim(sessionScope.roleName))}" />

                    <c:if test="${not empty sessionScope.loggedInUser}">
                        <a href="${pageContext.request.contextPath}/profile"
                            class="sidebar-item ${fn:contains(uri, 'profile') ? 'active' : ''}">
                            <i class="fas fa-user-circle"></i> <span>Thông tin cá nhân</span>
                        </a>
                    </c:if>

                    <!-- Section for Customer -->
                    <c:if test="${userRole eq 'customer'}">


                        <a href="${pageContext.request.contextPath}/order-list"
                            class="sidebar-item ${(fn:contains(uri, '/order-list') || fn:contains(uri, '/order-detail')) && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                            <i class="fas fa-box"></i> <span>Đơn hàng của tôi</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/cart"
                            class="sidebar-item ${(fn:contains(uri, 'cart') || fn:contains(uri, 'checkout')) && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                            <i class="fas fa-shopping-cart"></i> <span>Giỏ hàng của tôi</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/reviews"
                            class="sidebar-item ${fn:contains(uri, 'reviews') && !fn:contains(uri, 'dashboard') ? 'active' : ''}">
                            <i class="fas fa-comment-dots"></i> <span>Đánh giá của tôi</span>
                        </a>
                    </c:if>

                    <!-- Section for Staff and Admin -->
                    <c:if test="${userRole eq 'admin' || userRole eq 'staff'}">
                        <hr class="sidebar-divider">

                        <a href="${pageContext.request.contextPath}/admin/medicines-dashboard"
                            class="sidebar-item ${fn:contains(uri, 'medicine') || fn:contains(uri, 'medicines-dashboard') ? 'active' : ''}">
                            <i class="fas fa-pills"></i> <span>Quản lý thuốc</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/category?action=list"
                            class="sidebar-item ${fn:contains(uri, 'category') ? 'active' : ''}">
                            <i class="fas fa-th-list"></i> <span>Quản lý danh mục</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/orders-dashboard"
                            class="sidebar-item ${fn:contains(uri, 'order') && fn:contains(uri, 'dashboard') ? 'active' : ''}">
                            <i class="fas fa-shopping-bag"></i> <span>Quản lý đơn hàng</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/customers-dashboard"
                            class="sidebar-item ${fn:contains(uri, 'customer') && fn:contains(uri, 'dashboard') ? 'active' : ''}">
                            <i class="fas fa-users"></i> <span>Quản lý khách hàng</span>
                        </a>

                        <c:if test="${userRole eq 'admin'}">
                            <a href="${pageContext.request.contextPath}/admin/imports"
                                class="sidebar-item ${fn:contains(uri, 'imports') ? 'active' : ''}">
                                <i class="fas fa-file-import"></i> <span>Quản lý nhập thuốc</span>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/revenue"
                                class="sidebar-item ${fn:contains(uri, 'revenue') ? 'active' : ''}">
                                <i class="fas fa-chart-line"></i> <span>Quản lý doanh thu</span>
                            </a>

                            <a href="${pageContext.request.contextPath}/manage-staff"
                                class="sidebar-item ${fn:contains(uri, 'manage-staff') ? 'active' : ''}">
                                <i class="fas fa-user-shield"></i> <span>Quản lý nhân viên</span>
                            </a>
                        </c:if>
                    </c:if>
                </div>
                <div class="sidebar-footer">
                    <c:if test="${not empty sessionScope.loggedInUser}">
                        <a href="${pageContext.request.contextPath}/logout-page" class="sidebar-item sidebar-logout">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </c:if>
                </div>
            </div>