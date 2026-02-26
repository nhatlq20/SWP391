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

                    /* Logout Modal Styles */
                    .logout-modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.4);
                        display: none;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        backdrop-filter: blur(2px);
                    }

                    .logout-modal {
                        background: #fff;
                        width: 90%;
                        max-width: 400px;
                        border-radius: 24px;
                        padding: 35px 30px;
                        text-align: center;
                        position: relative;
                        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
                    }

                    .logout-modal-icon {
                        width: 85px;
                        height: 85px;
                        margin: 0 auto 20px;
                        display: block;
                    }

                    .logout-modal-title {
                        font-size: 28px;
                        font-weight: 700;
                        color: #1a1a1a;
                        margin-bottom: 12px;
                        font-family: 'Inter', sans-serif;
                    }

                    .logout-modal-text {
                        font-size: 16px;
                        color: #4a4a4a;
                        margin-bottom: 30px;
                        font-family: 'Inter', sans-serif;
                    }

                    .logout-modal-actions {
                        display: flex;
                        gap: 15px;
                        justify-content: center;
                    }

                    .btn-logout-confirm {
                        background: #ff5a5f;
                        color: white !important;
                        border: none;
                        padding: 10px 30px;
                        border-radius: 30px;
                        font-weight: 600;
                        font-size: 16px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        min-width: 130px;
                        box-shadow: 0 4px 12px rgba(255, 90, 95, 0.3);
                        text-decoration: none;
                    }

                    .btn-logout-confirm:hover {
                        background: #e04a4e;
                        transform: translateY(-2px);
                        box-shadow: 0 6px 15px rgba(255, 90, 95, 0.4);
                    }

                    .btn-logout-close {
                        background: #4B9BFF;
                        color: white !important;
                        border: none;
                        padding: 10px 30px;
                        border-radius: 30px;
                        font-weight: 600;
                        font-size: 16px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        min-width: 130px;
                        box-shadow: 0 4px 12px rgba(75, 155, 255, 0.3);
                    }

                    .btn-logout-close:hover {
                        background: #3b82f6;
                        transform: translateY(-2px);
                        box-shadow: 0 6px 15px rgba(75, 155, 255, 0.4);
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
                            <input type="text" class="search-bar" placeholder="Tìm tên thuốc, bệnh lý,..."
                                name="keyword" id="searchInput">
                        </form>
                    </div>

                    <!-- Navigation Section -->
                    <div class="nav-section">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser}">
                                <div class="user-menu">
                                    <c:set var="userRole" value="${fn:toLowerCase(fn:trim(sessionScope.roleName))}" />
                                    <a class="user-trigger" href="${pageContext.request.contextPath}/profile">
                                        <span class="avatar"><i class="fas fa-user"></i></span>
                                        <span class="name">${sessionScope.userName}</span>
                                        <i class="fas fa-chevron-down caret ms-1" style="font-size: 0.8rem;"></i>
                                    </a>
                                    <div class="user-dropdown">
                                        <a class="user-item" href="${pageContext.request.contextPath}/profile">
                                            Thông tin cá nhân
                                        </a>

                                        <c:choose>
                                            <c:when test="${userRole eq 'customer'}">
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/order-list">
                                                    Đơn hàng của tôi
                                                </a>
                                                <a class="user-item" href="${pageContext.request.contextPath}/cart">
                                                    Giỏ hàng của tôi
                                                </a>
                                                <a class="user-item" href="${pageContext.request.contextPath}/reviews">
                                                    Đánh giá của tôi
                                                </a>
                                            </c:when>

                                            <c:when test="${userRole eq 'admin' || userRole eq 'staff'}">
                                                <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/admin/medicines-dashboard">
                                                    Quản lý thuốc
                                                </a>
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/category?action=list">
                                                    Quản lý danh mục
                                                </a>
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/admin/orders-dashboard">
                                                    Quản lý đơn hàng
                                                </a>
                                                <a class="user-item"
                                                    href="${pageContext.request.contextPath}/admin/customers-dashboard">
                                                    Quản lý khách hàng
                                                </a>

                                                <c:if test="${userRole eq 'admin'}">
                                                    <a class="user-item"
                                                        href="${pageContext.request.contextPath}/admin/imports">
                                                        Quản lý nhập thuốc
                                                    </a>
                                                    <a class="user-item"
                                                        href="${pageContext.request.contextPath}/admin/revenue">
                                                        Quản lý doanh thu
                                                    </a>
                                                    <a class="user-item"
                                                        href="${pageContext.request.contextPath}/admin/manage-staff">
                                                        Quản lý nhân viên
                                                    </a>
                                                </c:if>
                                            </c:when>
                                        </c:choose>

                                        <div style="border-top:1px solid #eef2f7; margin:6px 6px 8px;"></div>
                                        <a class="user-item" href="javascript:void(0);" onclick="openLogoutModal()">
                                            Đăng xuất
                                        </a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="login-btn">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Tài khoản</span>
                                </a>
                            </c:otherwise>
                        </c:choose>

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
                                                <div class="cart-item d-flex align-items-center p-2 border-bottom">
                                                    <div class="cart-img-wrapper">
                                                        <c:choose>
                                                            <c:when test="${not empty it.medicine.imageUrl}">
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
                                                                    alt="${it.medicine.medicineName}" class="cart-img"
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
                                                            <fmt:formatNumber value="${it.price}" type="number"
                                                                groupingUsed="true" />₫
                                                            <small class="text-muted">x${it.quantity}</small>
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

                <!-- Logout Modal -->
                <div id="logoutModal" class="logout-modal-overlay">
                    <div class="logout-modal">
                        <img src="${pageContext.request.contextPath}/assets/img/logout.png" alt="Logout Icon"
                            class="logout-modal-icon">
                        <h2 class="logout-modal-title">Đăng xuất</h2>
                        <p class="logout-modal-text">Bạn có muốn đăng xuất hay không ?</p>
                        <div class="logout-modal-actions">
                            <button class="btn-logout-close" onclick="closeLogoutModal()">Đóng</button>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-logout-confirm">Đăng xuất</a>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
                <script>
                    function openLogoutModal() {
                        document.getElementById('logoutModal').style.display = 'flex';
                        document.body.style.overflow = 'hidden';
                    }

                    function closeLogoutModal() {
                        document.getElementById('logoutModal').style.display = 'none';
                        document.body.style.overflow = 'auto';
                    }

                    // Smooth closing by clicking outside
                    window.onclick = function (event) {
                        const modal = document.getElementById('logoutModal');
                        if (event.target == modal) {
                            closeLogoutModal();
                        }
                    }

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