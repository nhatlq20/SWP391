<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <c:out value="${medicine.medicineName}" />
                    </title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assets/css/client-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assets/css/detail.css" rel="stylesheet">
                </head>

                <body>
                    <%@ include file="../common/header.jsp" %>

                        <div class="detail-wrapper">
                            <div class="detail-content">
                                <!-- Main Medicine Info -->
                                <div class="row g-5">
                                    <!-- Left: Medicine Image -->
                                    <div class="col-12 col-lg-5">
                                        <div class="medicine-image-section">
                                            <div class="medicine-image-box rounded-3 overflow-hidden">
                                                <c:choose>
                                                    <c:when test="${not empty medicine.imageUrl}">
                                                        <c:set var="imageUrlTrimmed"
                                                            value="${fn:trim(medicine.imageUrl)}" />
                                                        <c:choose>
                                                            <c:when
                                                                test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:when
                                                                test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="imgSrc"
                                                                    value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <img src="<c:out value='${imgSrc}'/>"
                                                            alt="<c:out value='${medicine.medicineName}'/>"
                                                            class="main-img zoom-img" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                            alt="<c:out value='${medicine.medicineName}'/>"
                                                            class="main-img zoom-img" />
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>
                                        </div>

                                        <!-- Review Section -->
                                        <div class="review-section">
                                            <h3 class="review-title">Đánh giá sản phẩm</h3>

                                            <!-- Review Stats -->
                                            <c:if test="${totalReviews > 0}">
                                                <div class="review-stats">
                                                    <div class="stats-left">
                                                        <div class="average-rating">
                                                            <span class="rating-number">${averageRating}</span>
                                                            <div class="rating-stars">
                                                                <c:forEach var="i" begin="1" end="5">
                                                                    <c:choose>
                                                                        <c:when test="${i <= averageRating}">
                                                                            <i class="fas fa-star"
                                                                                style="color: #FFD700;"></i>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="fas fa-star"
                                                                                style="color: #ddd;"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </div>
                                                            <p class="total-reviews">dựa trên
                                                                <strong>${totalReviews}</strong> đánh giá
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Reviews List -->
                                            <div class="reviews-list">
                                                <c:choose>
                                                    <c:when test="${empty reviews}">
                                                        <p class="no-reviews">Chưa có đánh giá nào cho sản phẩm này</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="review" items="${reviews}">
                                                            <div class="review-item">
                                                                <div class="review-thread">
                                                                    <div class="thread-main">
                                                                        <div class="thread-avatar customer-avatar">
                                                                            <c:out value="${fn:toUpperCase(fn:substring(fn:trim(review.customerName), 0, 1))}" />
                                                                        </div>
                                                                        <div class="thread-main-content">
                                                                            <div class="reviewer-name"><c:out value="${review.customerName}" /></div>
                                                                            <div class="review-score-line">
                                                                                <span class="score-number">${review.rating}</span>
                                                                                <i class="fas fa-star"></i>
                                                                                <span class="review-date">${review.createdAt}</span>
                                                                            </div>
                                                                            <p class="review-comment"><c:out value="${review.comment}" /></p>
                                                                        </div>
                                                                    </div>

                                                                    <c:if test="${not empty review.replyContent}">
                                                                        <div class="thread-reply-wrap">
                                                                            <div class="thread-reply-line"></div>
                                                                            <div class="thread-reply">
                                                                                <div class="thread-avatar staff-avatar">
                                                                                    <c:out value="${fn:toUpperCase(fn:substring(fn:trim(not empty review.replyStaffName ? review.replyStaffName : 'N'), 0, 1))}" />
                                                                                </div>
                                                                                <div class="thread-reply-content">
                                                                                    <div class="thread-reply-header">
                                                                                        <span class="reply-staff-name"><c:out value="${not empty review.replyStaffName ? review.replyStaffName : 'Nhân viên nhà thuốc'}" /></span>
                                                                                        <span class="reply-role-tag">Dược sĩ</span>
                                                                                    </div>
                                                                                    <div class="thread-reply-text"><c:out value="${review.replyContent}" /></div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${sessionScope.userType eq 'staff'}">
                                                                        <a class="btn btn-sm btn-primary mt-2"
                                                                           href="${pageContext.request.contextPath}/view-reviews?medicineId=${medicine.medicineId}&selectedReviewId=${review.reviewId}">
                                                                            ${not empty review.replyContent ? 'Chỉnh sửa phản hồi' : 'Trả lời'}
                                                                        </a>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>


                                    <!-- Right: Medicine Details -->
                                    <div class="col-12 col-lg-7 medicine-info-section">
                                        <!-- Title -->
                                        <h2>
                                            <c:out value='${medicine.medicineName}' />
                                        </h2>

                                        <!-- Price -->
                                        <div class="price-section">
                                            <span class="price-value">
                                                <c:choose>
                                                    <c:when
                                                        test="${medicine.sellingPrice != null && medicine.sellingPrice > 0}">
                                                        <fmt:formatNumber value="${medicine.sellingPrice}" type="number"
                                                            groupingUsed="true" />₫
                                                    </c:when>
                                                    <c:otherwise>Giá tham khảo</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="price-unit">/
                                                <c:out value='${medicine.unit}' />
                                            </span>
                                        </div>


                                        <!-- Quantity Selection -->
                                        <div class="mb-3 d-flex align-items-center gap-3">
                                            <label class="form-label text-muted mb-0">Chọn số lượng</label>
                                            <div class="input-group rounded-pill border"
                                                style="max-width: 130px; overflow: hidden;">
                                                <button type="button" class="btn btn-light px-3"
                                                    onclick="decreaseQty()">−</button>
                                                <input type="number" id="quantity" value="1" min="1"
                                                    class="form-control text-center border-0 shadow-none qty-input">
                                                <button type="button" class="btn btn-light px-3"
                                                    onclick="increaseQty()">+</button>
                                            </div>
                                        </div>

                                        <!-- Category -->
                                        <div class="category-section">
                                            <span class="category-label">Danh mục:</span>
                                            <span class="category-value">
                                                <c:out value='${medicine.category.categoryName}'
                                                    default='Chưa phân loại' />
                                            </span>
                                        </div>

                                        <!-- Description -->
                                        <div class="description-section">
                                            <span class="section-title">Mô tả ngắn:</span>
                                            <p class="section-content">
                                                <c:out value='${medicine.shortDescription}' />
                                            </p>
                                        </div>

                                        <!-- Action Buttons -->

                                        <div class="action-buttons">
                                            <form id="addToCartForm" action="${pageContext.request.contextPath}/cart"
                                                method="POST" style="display: none;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="id" value="${medicine.medicineId}">
                                                <input type="hidden" name="quantity" id="formQuantity" value="1">
                                            </form>

                                            <button class="btn-buy btn btn-primary"
                                                onclick="submitAddToCart()">Mua</button>
                                            <c:choose>
                                                <c:when test="${sessionScope.userType eq 'customer'}">
                                                    <a class="btn-rate btn btn-outline-warning"
                                                        href="${pageContext.request.contextPath}/create-review?medicineId=${medicine.medicineId}">
                                                        <i class="fas fa-star"></i> Đánh giá sản phẩm
                                                    </a>
                                                </c:when>
                                                <c:when test="${sessionScope.userType eq 'staff'}">
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="btn-rate btn btn-outline-warning"
                                                        href="${pageContext.request.contextPath}/login">
                                                        <i class="fas fa-star"></i> Đánh giá sản phẩm
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                                <script src="${pageContext.request.contextPath}/assets/js/detail.js"></script>
                                <script>
                                    function submitAddToCart() {
                                        const qty = document.getElementById('quantity').value;
                                        const mainImg = document.querySelector('.main-img');

                                        const formData = new URLSearchParams();
                                        formData.append('action', 'add');
                                        formData.append('id', '${medicine.medicineId}');
                                        formData.append('quantity', qty);

                                        fetch('${pageContext.request.contextPath}/cart', {
                                            method: 'POST',
                                            headers: { 'X-Requested-With': 'XMLHttpRequest' },
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
                                                    // Start fly animation
                                                    if (typeof animateFlyToCart === 'function') {
                                                        animateFlyToCart(mainImg);
                                                    }
                                                    // Update header count
                                                    if (typeof updateHeaderCartCount === 'function') {
                                                        setTimeout(() => updateHeaderCartCount(data.cartCount), 800);
                                                    }
                                                }
                                            })
                                            .catch(error => {
                                                if (error.message !== 'Redirected')
                                                    console.error(error);
                                            });
                                    }
                                </script>
                </body>

                </html>