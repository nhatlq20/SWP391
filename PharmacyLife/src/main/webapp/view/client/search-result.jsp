<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kết quả tìm kiếm - PharmacyLife</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="<c:url value='/assets/css/header.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/home-page.css'/>" rel="stylesheet">
                    <link href="<c:url value='/assets/css/search-result.css' />" rel="stylesheet">
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <div class="main-content">
                            <div class="container">
                                <!-- Search header -->
                                <c:if test="${not empty keyword}">
                                    <div class="search-header rounded p-4 mb-4">
                                        <h2><i class="fas fa-search me-2"></i>Kết quả tìm kiếm cho:
                                            <span class="keyword-highlight">"
                                                <c:out value='${keyword}' />"
                                            </span>
                                        </h2>
                                    </div>
                                </c:if>

                                <!-- Search results -->
                                <c:choose>
                                    <c:when test="${not empty medicines}">
                                        <div class="row g-3">
                                            <c:forEach var="medicine" items="${medicines}">
                                                <div class="col-6 col-md-4 col-lg-3">
                                                    <div class="card h-100 medicine-card">
                                                        <c:choose>
                                                            <c:when test="${not empty medicine.imageUrl}">
                                                                <c:set var="imageUrlTrimmed"
                                                                    value="${fn:trim(medicine.imageUrl)}" />
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
                                                                <a href="${pageContext.request.contextPath}/medicine/detail?id=${medicine.medicineId}">
                                                                    <img src="${imgSrc}" alt="${medicine.medicineName}"
                                                                        class="card-img-top img-fluid"
                                                                        onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                                    alt="${medicine.medicineName}"
                                                                    class="medicine-card-image card-img-top">
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="card-body d-flex flex-column">
                                                            <h5 class="card-title text-truncate medicine-name">
                                                                <a href="${pageContext.request.contextPath}/medicine/detail?id=${medicine.medicineId}" style="color:inherit; text-decoration:none;">
                                                                    <c:out value='${medicine.medicineName}' />
                                                                </a>
                                                            </h5>
                                                            <div class="mt-auto">
                                                                <div class="mb-2">
                                                                    <span class="fw-bold text-primary medicine-price">
                                                                        <fmt:formatNumber
                                                                            value="${medicine.sellingPrice}"
                                                                            type="number" groupingUsed="true" />₫
                                                                    </span><span class="text-muted small medicine-unit">
                                                                        /
                                                                        <c:out value='${medicine.unit}' />
                                                                    </span>
                                                                </div>
                                                                <c:set var="userRoleForCart"
                                                                    value="${fn:toLowerCase(fn:trim(sessionScope.roleName))}" />
                                                                <c:if
                                                                    test="${userRoleForCart ne 'admin' and userRoleForCart ne 'staff'}">
                                                                    <button
                                                                        class="btn btn-primary w-100 add-to-cart-btn"
                                                                        onclick="addToCartAjax(this, '${medicine.medicineId}')">
                                                                        Thêm vào giỏ hàng
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty keyword}">
                                            <div class="empty-state">
                                                <i class="fas fa-capsules"></i>
                                                <h4>Không tìm thấy sản phẩm nào</h4>
                                                <p>Không có kết quả cho"
                                                    <c:out value='${keyword}' />". Hãy thử tìm kiếm với từ khóa khác.
                                                </p>
                                                <a href="${pageContext.request.contextPath}/home"
                                                    class="btn btn-primary">
                                                    <i class="fas fa-home mb-2 mt-2"></i>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>

                        <%@ include file="../common/footer.jsp" %>

                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function addToCartAjax(btn, medicineId) {
                                    // Animation: fly image to cart
                                    const card = btn.closest('.medicine-card');
                                    const img = card.querySelector('img');
                                    const cartIcon = document.querySelector('.cart-btn i.fas.fa-shopping-cart');
                                    if (img && cartIcon) {
                                        const imgRect = img.getBoundingClientRect();
                                        const cartRect = cartIcon.getBoundingClientRect();
                                        const flyImg = img.cloneNode(true);
                                        flyImg.classList.add('fly-item');
                                        document.body.appendChild(flyImg);
                                        flyImg.style.left = imgRect.left + 'px';
                                        flyImg.style.top = imgRect.top + 'px';
                                        flyImg.style.width = imgRect.width + 'px';
                                        flyImg.style.height = imgRect.height + 'px';
                                        setTimeout(() => {
                                            flyImg.style.left = cartRect.left + (cartRect.width/2 - imgRect.width/4) + 'px';
                                            flyImg.style.top = cartRect.top + (cartRect.height/2 - imgRect.height/4) + 'px';
                                            flyImg.style.width = imgRect.width/2 + 'px';
                                            flyImg.style.height = imgRect.height/2 + 'px';
                                            flyImg.style.opacity = '0.5';
                                        }, 10);
                                        setTimeout(() => {
                                            flyImg.remove();
                                            cartIcon.classList.add('cart-pop');
                                            setTimeout(()=>cartIcon.classList.remove('cart-pop'), 350);
                                        }, 850);
                                    }
                                    const isLoggedIn = '<c:out value="${sessionScope.userId != null}"/>' === 'true';
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
                                                if (typeof updateHeaderCartCount === 'function') {
                                                    updateHeaderCartCount(data.cartCount);
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
                
                            </script>
                </body>

                </html>