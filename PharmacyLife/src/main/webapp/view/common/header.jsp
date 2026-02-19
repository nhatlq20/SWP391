<%@ page pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/header.css">
                <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">


                <header class="header">

                    <!-- Logo Section -->
                    <div class="logo-section">
                        <a href="${pageContext.request.contextPath}/home" class="logo-link">
                            <div class="logo-wrapper">
                                <span class="logo-top">NHÀ THUỐC</span>
                                <span class="logo-main">PHARMACY LIFE</span>
                            </div>
                        </a>
                    </div>

                    <!-- Search Section -->
                    <div class="search-section">
                        <form action="${pageContext.request.contextPath}/search" method="GET" style="width: 100%;">
                            <input type="text" class="search-bar" placeholder="Tìm tên thuốc, bệnh lý,..." name="q"
                                id="searchInput">
                        </form>
                    </div>

                    <!-- Navigation Section -->
                    <div class="nav-section">
                        <% if (session.getAttribute("user") !=null) { %>
                            <div class="user-menu">
                                <a class="user-trigger" href="${pageContext.request.contextPath}/profile">
                                    <span class="avatar"><i class="fas fa-user"></i></span>
                                    <span class="name">${sessionScope.user.fullName}</span>
                                </a>
                                <div class="user-dropdown">
                                    <a class="user-item" href="${pageContext.request.contextPath}/profile">Thông tin cá
                                        nhân</a>
                                    <a class="user-item" href="${pageContext.request.contextPath}/my-reviews">Đánh giá của tôi</a>
                                    <a class="user-item" href="${pageContext.request.contextPath}/my-orders">Xem đơn
                                        hàng</a>
                                    <% if ("admin".equalsIgnoreCase((String)session.getAttribute("roleName"))) { %>
                                        <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                        <a class="user-item" href="${pageContext.request.contextPath}/order">Quản lí đơn
                                            hàng</a>
                                        <a class="user-item" href="${pageContext.request.contextPath}/product">Quản lí
                                            sản phẩm</a>
                                        <a class="user-item" href="${pageContext.request.contextPath}/staff">Quản lí
                                            khách hàng</a>
                                        <% } %>
                                            <a class="user-item"
                                                href="${pageContext.request.contextPath}/auth?action=logout">Đăng
                                                xuất</a>
                                </div>
                            </div>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/auth" class="login-btn">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Tài khoản</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/my-reviews?customerId=2" class="login-btn">
                                    <i class="fas fa-star"></i>
                                    <span>Đánh giá của tôi</span>
                                </a>
                                <% } %>

                                    <!-- Cart Dropdown -->
                                    <div class="cart-wrapper">
                                        <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
                                            <i class="fas fa-shopping-cart">
                                                <c:if test="${cartCount > 0}">
                                                    <span class="cart-badge">${cartCount}</span>
                                                </c:if>
                                            </i>
                                        </a>
                                        <!-- Dropdown -->
                                        <div class="cart-dropdown shadow-sm" id="cartDropdown">
                                            <div class="dropdown-cart-header fw-semibold px-3 py-2 border-bottom">Giỏ
                                                hàng</div>
                                            <div class="cart-items" id="miniCartItems">
                                                <c:choose>
                                                    <c:when test="${empty cartItems}">
                                                        <div class="text-center text-muted py-3 small">Giỏ hàng trống
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="it" items="${cartItems}">
                                                            <div
                                                                class="cart-item d-flex align-items-center p-2 border-bottom">
                                                                <c:choose>
                                                                    <c:when test="${not empty it.imageUrl}">
                                                                        <c:set var="imageUrlTrimmed"
                                                                            value="${fn:trim(it.imageUrl)}" />
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                                <c:set var="imgSrc"
                                                                                    value="${imageUrlTrimmed}" />
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                                <c:set var="imgSrc"
                                                                                    value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${fn:startsWith(imageUrlTrimmed, 'assets/img')}">
                                                                                        <c:set var="imgSrc"
                                                                                            value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <c:set var="imgSrc"
                                                                                            value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:set var="imgSrc"
                                                                                    value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <img src="<c:out value='${imgSrc}'/>"
                                                                            alt="${it.medicineName}"
                                                                            class="cart-img me-2"
                                                                            onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                                            alt="${it.medicineName}"
                                                                            class="cart-img me-2">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <div class="flex-grow-1" style="min-width: 0;">
                                                                    <div class="cart-name text-truncate">
                                                                        ${it.medicineName}</div>
                                                                    <div class="cart-price text-primary fw-semibold">
                                                                        <fmt:formatNumber value="${it.price}"
                                                                            type="number" groupingUsed="true" />₫
                                                                        <small
                                                                            class="text-muted">x${it.quantity}</small>
                                                                    </div>
                                                                </div>
                                                                <a href="cart?action=remove&id=${it.medicineID}"
                                                                    class="text-danger small ms-2"><i
                                                                        class="fas fa-trash"></i></a>
                                                            </div>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="cart-footer text-center p-2">
                                                <a href="cart" class="btn btn-primary btn-sm px-3">Xem giỏ hàng</a>
                                            </div>
                                        </div>
                                    </div>
                    </div>
                </header>
                <script src="${pageContext.request.contextPath}/assets/js/header.js"></script>

