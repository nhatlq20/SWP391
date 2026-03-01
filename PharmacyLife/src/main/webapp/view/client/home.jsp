<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PharmacyLife - Trang chủ</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<c:url value='/assets/css/header.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/home.css'/>" rel="stylesheet">
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <!-- 🔹 Banner quảng cáo dưới thanh danh mục -->
                        <section class="main-banner">
                            <!-- Banner bên trái (slider) -->
                            <div id="mainBannerCarousel" class="carousel slide banner-left" data-bs-ride="carousel"
                                data-bs-interval="4000">
                                <div class="carousel-inner">
                                    <div class="carousel-item active">
                                        <img src="<c:url value='/assets/img/banner-left-1.png'/>" alt="Banner 1"
                                            class="banner-img">
                                    </div>
                                    <div class="carousel-item">
                                        <img src="<c:url value='/assets/img/banner-left-2.png'/>" alt="Banner 2"
                                            class="banner-img">
                                    </div>
                                    <div class="carousel-item">
                                        <img src="<c:url value='/assets/img/banner-left-3.png'/>" alt="Banner 3"
                                            class="banner-img">
                                    </div>
                                </div>

                                <!-- Nút điều hướng -->
                                <button class="carousel-control-prev" type="button" data-bs-target="#mainBannerCarousel"
                                    data-bs-slide="prev">
                                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                    <span class="visually-hidden">Previous</span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#mainBannerCarousel"
                                    data-bs-slide="next">
                                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                    <span class="visually-hidden">Next</span>
                                </button>
                            </div>

                            <div class="banner-right">
                                <div class="banner-small">
                                    <img src="<c:url value='/assets/img/banner-top.png'/>" alt="Banner nhỏ trên"
                                        class="banner-img">
                                </div>
                                <div class="banner-small">
                                    <img src="<c:url value='/assets/img/banner-bot.png'/>" alt="Banner nhỏ dưới"
                                        class="banner-img">
                                </div>
                            </div>
                        </section>

                        <!-- Main Content -->
                        <div class="main-content container">
                            <section class="categories-section mb-5">
                                <h2 class="section-title text-center mb-4">Danh Mục Sản Phẩm</h2>
                                <div class="categories-grid">
                                    <c:forEach var="c" items="${listCategory}" varStatus="loop">
                                        <div class="category-card"
                                            onclick="window.location.href='${pageContext.request.contextPath}/search?categoryId=${c.categoryId}'">
                                            <div class="category-img-wrapper">
                                                <img src="<c:url value='/assets/img/category/${loop.index + 1}.png'/>"
                                                    alt="<c:out value='${c.categoryName}'/>" class="category-image"
                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/category/default.png';">
                                            </div>
                                            <div class="category-info">
                                                <div class="category-name">
                                                    <c:out value="${c.categoryName}" />
                                                </div>
                                                <div class="category-count">${c.medicineCount} sản phẩm</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>

                            <!-- 🔹 Best Seller Section -->
                            <section class="bestseller-section border-top">
                                <div class="container py-5">
                                    <div class="text-center mb-5">
                                        <h2 class="section-title mb-2">
                                            <i class="fas fa-crown text-warning me-2"></i>Sản Phẩm Bán Chạy
                                        </h2>
                                        <p class="text-muted">Khám phá những sản phẩm được tin dùng nhiều nhất</p>
                                    </div>

                                    <div class="bestseller-grid">
                                        <c:if test="${not empty bestSellers}">
                                            <c:forEach var="m" items="${bestSellers}" varStatus="vs">
                                                <div class="bestseller-premium-card">
                                                    <div class="card-img-wrapper cursor-pointer"
                                                        onclick="window.location.href = '${pageContext.request.contextPath}/medicine/detail?id=${m.medicineId}'">
                                                        <c:choose>
                                                            <c:when test="${not empty m.imageUrl}">
                                                                <c:set var="url" value="${fn:trim(m.imageUrl)}" />
                                                                <c:choose>
                                                                    <c:when test="${fn:startsWith(url, 'http')}">
                                                                        <c:set var="imgSrc" value="${url}" />
                                                                    </c:when>
                                                                    <c:when test="${fn:startsWith(url, '/')}">
                                                                        <c:set var="imgSrc"
                                                                            value="${pageContext.request.contextPath}${url}" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:set var="imgSrc"
                                                                            value="${pageContext.request.contextPath}/assets/img/${url}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <img src="${imgSrc}" alt="${m.medicineName}"
                                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                                    alt="No image">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="card-info-wrapper">
                                                        <h4 class="premium-card-name mb-2 cursor-pointer"
                                                            title="${m.medicineName}"
                                                            onclick="window.location.href = '${pageContext.request.contextPath}/medicine/detail?id=${m.medicineId}'">
                                                            ${m.medicineName}
                                                        </h4>
                                                        <div class="premium-card-price mb-2">
                                                            <fmt:formatNumber value="${m.sellingPrice}" type="number"
                                                                groupingUsed="true" />₫
                                                            <span class="price-unit">/ ${m.unit}</span>
                                                        </div>
                                                        <button onclick="addToCartAjax(this, '${m.medicineId}')"
                                                            class="btn-buy-premium">
                                                            Chọn mua
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                </div>
                            </section>
                        </div>

                        <%@ include file="../common/footer.jsp" %>
                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function addToCartAjax(btn, medicineId) {
                                    const isLoggedIn = ${ sessionScope.userId != null ? 'true' : 'false'
                                };
                                const userRole = '${sessionScope.roleName != null ? sessionScope.roleName : ""}';
                                const role = userRole.toLowerCase();

                                if (!isLoggedIn) {
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                    return;
                                }

                                if (role === 'admin' || role === 'staff') {
                                    alert('Tài khoản Admin và Staff không thể mua hàng. Vui lòng đăng nhập với tài khoản khách hàng.');
                                    return;
                                }

                                const card = btn.closest('.bestseller-premium-card');
                                const img = card ? card.querySelector('.card-img-wrapper img') : null;

                                const formData = new URLSearchParams();
                                formData.append('action', 'add');
                                formData.append('id', medicineId);
                                formData.append('quantity', 1);

                                fetch('${pageContext.request.contextPath}/cart', {
                                    method: 'POST',
                                    headers: {
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: formData
                                })
                                    .then(response => {
                                        if (response.headers.get('content-type')?.includes('application/json')) {
                                            return response.json();
                                        } else {
                                            window.location.href = '${pageContext.request.contextPath}/login';
                                            throw new Error('Redirected');
                                        }
                                    })
                                    .then(data => {
                                        if (data.success) {
                                            if (typeof animateFlyToCart === 'function' && img) {
                                                animateFlyToCart(img);
                                            }
                                            if (typeof updateHeaderCartCount === 'function') {
                                                setTimeout(() => updateHeaderCartCount(data.cartCount), 800);
                                            }
                                        }
                                    })
                                    .catch(error => {
                                        if (error.message !== 'Redirected') {
                                            console.error('Error adding to cart:', error);
                                        }
                                    });
        }
                            </script>
                </body>

                </html>