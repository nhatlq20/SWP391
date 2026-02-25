<%@ page pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <c:set var="cartCount" value="0" />
                <c:if test="${not empty sessionScope.cart.items}">
                    <c:forEach var="item" items="${sessionScope.cart.items}">
                        <c:set var="cartCount" value="${cartCount + item.quantity}" />
                    </c:forEach>
                </c:if>


                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/header.css">
                <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">

                <style>
                    .fly-item {
                        position: fixed;
                        z-index: 10000;
                        width: 50px;
                        height: 50px;
                        border-radius: 50%;
                        object-fit: cover;
                        pointer-events: none;
                        transition: all 0.8s cubic-bezier(0.42, 0, 0.58, 1);
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                    }

                    @keyframes cartPop {
                        0% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.3);
                        }

                        100% {
                            transform: scale(1);
                        }
                    }

                    .cart-pop {
                        animation: cartPop 0.3s ease-out;
                    }
                </style>


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

                    <div class="search-section">
                        <form action="${pageContext.request.contextPath}/search" method="GET" style="width: 100%;">
                            <input type="text" class="search-bar" placeholder="Tìm tên thuốc, bệnh lý,..." name="q"
                                id="searchInput">
                        </form>
                    </div>

                    <!-- Navigation Section -->
                    <div class="nav-section">
                        <% if (session.getAttribute("loggedInUser") !=null) { %>
                            <div class="user-menu">
                                <a class="user-trigger" href="${pageContext.request.contextPath}/profile">
                                    <span class="avatar"><i class="fas fa-user"></i></span>
                                    <span class="name">${sessionScope.userName}</span>
                                    <i class="fas fa-chevron-down caret ms-1" style="font-size: 0.8rem;"></i>
                                </a>
                                <div class="user-dropdown">
                                    <a class="user-item" href="${pageContext.request.contextPath}/profile">Thông tin cá
                                        nhân</a>
                                    <c:if test="${sessionScope.userType eq 'customer'}">
                                        <a class="user-item" href="${pageContext.request.contextPath}/reviews">Đánh giá của
                                            tôi</a>
                                    </c:if>
                                    <a class="user-item" href="${pageContext.request.contextPath}/order-list">Xem đơn
                                        hàng</a>
                                    <% String roleName=(String) session.getAttribute("roleName"); if
                                        ("Admin".equalsIgnoreCase(roleName)) { %>
                                        <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                        <a class="user-item" href="${pageContext.request.contextPath}/order">Quản lí đơn
                                            hàng</a>
                                        <a class="user-item" href="${pageContext.request.contextPath}/product">Quản lí
                                            sản phẩm</a>
                                        <a class="user-item" href="${pageContext.request.contextPath}/staff">Quản lí
                                            khách hàng</a>
                                        <a class="user-item"
                                            href="${pageContext.request.contextPath}/admin/imports">Quản lí
                                            nhập thuốc</a>
                                        <a class="user-item" href="${pageContext.request.contextPath}/manage-staff">Quản
                                            lí nhân viên</a>
                                        <% } else if ("Staff".equalsIgnoreCase(roleName)) { %>
                                            <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                            <a class="user-item" href="${pageContext.request.contextPath}/order">Quản lí
                                                đơn hàng</a>
                                            <a class="user-item" href="${pageContext.request.contextPath}/product">Quản
                                                lí sản phẩm</a>
                                            <% } %>
                                                <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/logout-page">Đăng xuất</a>
                                </div>
                            </div>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/login" class="login-btn">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Tài khoản</span>
                                </a>
                                <% } %>

                                    <!-- Cart Dropdown -->
                                    <div class="cart-wrapper">
                                        <a href="${pageContext.request.contextPath}/cart" class="cart-btn"
                                            style="text-decoration: none;">
                                            <i class="fas fa-shopping-cart"></i><span class="cart-badge" id="cartCount">
                                                <c:out value="${cartCount != null ? cartCount : 0}" />
                                            </span>
                                        </a>
                                        <!-- Dropdown -->
                                        <div class="cart-dropdown shadow-sm" id="cartDropdown">
                                            <div class="cart-header fw-semibold px-3 py-2 border-bottom">Giỏ hàng</div>
                                            <div class="cart-items" id="miniCartItems">
                                                <c:choose>
                                                    <c:when
                                                        test="${empty sessionScope.cart.items or fn:length(sessionScope.cart.items) == 0}">
                                                        <div class="text-center text-muted py-3 small">Giỏ hàng trống
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="it" items="${sessionScope.cart.items}">
                                                            <div
                                                                class="cart-item d-flex align-items-center p-2 border-bottom">
                                                                <div class="cart-img-wrapper">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty it.medicine.imageUrl}">
                                                                            <c:set var="imageUrlTrimmed"
                                                                                value="${fn:trim(it.medicine.imageUrl)}" />
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
                                                                                <c:otherwise>
                                                                                    <c:set var="imgSrc"
                                                                                        value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                            <img src="<c:out value='${imgSrc}'/>"
                                                                                alt="${it.medicine.medicineName}"
                                                                                class="cart-img"
                                                                                onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                                                alt="No image" class="cart-img">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="flex-grow-1 ms-2" style="min-width: 0;">
                                                                    <div class="cart-name text-truncate"
                                                                        title="${it.medicine.medicineName}">
                                                                        ${it.medicine.medicineName}
                                                                    </div>
                                                                    <div class="cart-price text-primary fw-semibold">
                                                                        <fmt:formatNumber value="${it.price}"
                                                                            type="number" groupingUsed="true" />₫
                                                                        <small
                                                                            class="text-muted">x${it.quantity}</small>
                                                                    </div>
                                                                </div>
                                                                <a href="${pageContext.request.contextPath}/cart?action=remove&id=${it.medicine.medicineId}"
                                                                    class="text-danger small ms-2">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
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
                <script>
                    function animateFlyToCart(imgElement) {
                        if (!imgElement) return;

                        const cartBtn = document.querySelector('.cart-btn');
                        if (!cartBtn) return;

                        const imgRect = imgElement.getBoundingClientRect();
                        const cartRect = cartBtn.getBoundingClientRect();

                        const flyer = document.createElement('img');
                        flyer.src = imgElement.src;
                        flyer.className = 'fly-item';
                        flyer.style.top = imgRect.top + 'px';
                        flyer.style.left = imgRect.left + 'px';
                        flyer.style.width = imgRect.width + 'px';
                        flyer.style.height = imgRect.height + 'px';

                        document.body.appendChild(flyer);

                        setTimeout(() => {
                            flyer.style.top = (cartRect.top + 10) + 'px';
                            flyer.style.left = (cartRect.left + 10) + 'px';
                            flyer.style.width = '20px';
                            flyer.style.height = '20px';
                            flyer.style.opacity = '0.5';
                        }, 50);

                        flyer.addEventListener('transitionend', () => {
                            flyer.remove();
                            // Trigger pop animation on cart button
                            cartBtn.classList.add('cart-pop');
                            setTimeout(() => cartBtn.classList.remove('cart-pop'), 300);
                        });
                    }

                    function updateHeaderCartCount(newCount) {
                        let badge = document.getElementById('cartCount');
                        if (badge) {
                            badge.textContent = newCount;
                        }
                    }
                </script>