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


                                            <!-- Review Stats và nút đánh giá sản phẩm nằm cùng khung, căn trái -->
                                            <c:if test="${totalReviews > 0}">
                                                <div class="review-stats position-relative"
                                                    style="padding-bottom: 16px;">
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
                                                        <!-- Nút đánh giá sản phẩm nằm dưới dòng chữ, căn trái -->
                                                        <!-- Không hiện gì nếu không đủ điều kiện, KHÔNG để comment trong c:choose -->
                                                        <div class="mt-3 text-end btn-danh-gia">
                                                            <c:choose>
                                                                <c:when test="${sessionScope.userType eq 'customer'}">
                                                                    <c:choose>
                                                                        <c:when test="${hasReviewed}">
                                                                            <a class="btn btn-primary" href="#"
                                                                                onclick="showReviewedToast(); return false;">
                                                                                <i class="fas fa-star"></i> Gửi đánh giá
                                                                            </a>
                                                                        </c:when>
                                                                        <c:when test="${canReview}">
                                                                            <a class="btn btn-primary"
                                                                                href="${pageContext.request.contextPath}/create-review?medicineId=${medicine.medicineId}">
                                                                                <i class="fas fa-star"></i> Gửi đánh giá
                                                                            </a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a class="btn btn-primary" href="#"
                                                                                onclick="showReviewToast(); return false;">
                                                                                <i class="fas fa-star"></i> Gửi đánh giá
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:when
                                                                    test="${sessionScope.userType eq 'admin' || sessionScope.userType eq 'staff'}">
                                                                    <button type="button" class="btn btn-primary">
                                                                        <i class="fas fa-star"></i> Gửi đánh giá
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${empty sessionScope.userType}">
                                                                    <a class="btn btn-primary"
                                                                        href="${pageContext.request.contextPath}/login">
                                                                        <i class="fas fa-star"></i> Gửi đánh giá
                                                                    </a>
                                                                </c:when>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Reviews List -->
                                            <div class="reviews-list">
                                                <c:choose>
                                                    <c:when test="${empty reviews}">
                                                        <div class="review-stats position-relative"
                                                            style="padding-bottom: 16px;">
                                                            <div class="stats-left">
                                                                <div class="average-rating">
                                                                    <span class="rating-number">0</span>
                                                                    <div class="rating-stars">
                                                                        <c:forEach var="i" begin="1" end="5">
                                                                            <i class="fas fa-star"
                                                                                style="color: #ddd;"></i>
                                                                        </c:forEach>
                                                                    </div>
                                                                    <p class="total-reviews">dựa trên <strong>0</strong>
                                                                        đánh giá</p>
                                                                </div>
                                                                <div class="mt-3 text-end btn-danh-gia">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${sessionScope.userType eq 'customer'}">
                                                                            <c:choose>
                                                                                <c:when test="${hasReviewed}">
                                                                                    <a class="btn btn-primary" href="#"
                                                                                        onclick="showReviewedToast(); return false;">
                                                                                        <i class="fas fa-star"></i> Gửi
                                                                                        đánh giá
                                                                                    </a>
                                                                                </c:when>
                                                                                <c:when test="${canReview}">
                                                                                    <a class="btn btn-primary"
                                                                                        href="${pageContext.request.contextPath}/create-review?medicineId=${medicine.medicineId}">
                                                                                        <i class="fas fa-star"></i> Gửi
                                                                                        đánh giá
                                                                                    </a>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <a class="btn btn-primary" href="#"
                                                                                        onclick="showReviewToast(); return false;">
                                                                                        <i class="fas fa-star"></i> Gửi
                                                                                        đánh giá
                                                                                    </a>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${sessionScope.userType eq 'admin' || sessionScope.userType eq 'staff'}">
                                                                            <button type="button"
                                                                                class="btn btn-primary">
                                                                                <i class="fas fa-star"></i> Gửi đánh giá
                                                                            </button>
                                                                        </c:when>
                                                                        <c:when test="${empty sessionScope.userType}">
                                                                            <a class="btn btn-primary"
                                                                                href="${pageContext.request.contextPath}/login">
                                                                                <i class="fas fa-star"></i> Gửi đánh giá
                                                                            </a>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <p class="no-reviews">Chưa có đánh giá nào cho sản phẩm này</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="review" items="${reviews}"
                                                            varStatus="reviewStatus">
                                                            <c:if test="${not reviewStatus.first}">
                                                                <hr class="comment-divider" />
                                                            </c:if>
                                                            <div class="review-item" id="review-${review.reviewId}">
                                                                <div class="review-thread">
                                                                    <div class="thread-main">
                                                                        <div class="thread-avatar customer-avatar">
                                                                            <c:out
                                                                                value="${fn:toUpperCase(fn:substring(fn:trim(review.customerName), 0, 1))}" />
                                                                        </div>
                                                                        <div class="thread-main-content">
                                                                            <div class="reviewer-name">
                                                                                <c:out value="${review.customerName}" />
                                                                            </div>
                                                                            <div class="review-score-line">
                                                                                <span
                                                                                    class="score-number">${review.rating}</span>
                                                                                <i class="fas fa-star"></i>
                                                                                <span
                                                                                    class="review-date">${review.createdAt}</span>
                                                                            </div>
                                                                            <div class="customer-comment-box">
                                                                                <p class="review-comment">
                                                                                    <c:out value="${review.comment}" />
                                                                                </p>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <c:if test="${not empty review.replyContent}">
                                                                        <div id="reply-list-${review.reviewId}">
                                                                            <c:forEach var="replyItem"
                                                                                items="${fn:split(review.replyContent, '@@BR@@')}">
                                                                                <c:if
                                                                                    test="${not empty fn:trim(replyItem)}">
                                                                                    <c:set var="replyLine"
                                                                                        value="${fn:trim(replyItem)}" />
                                                                                    <c:set var="separatorIndex"
                                                                                        value="${fn:indexOf(replyLine, ': ')}" />
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${separatorIndex gt 0}">
                                                                                            <c:set var="replyAuthorName"
                                                                                                value="${fn:substring(replyLine, 0, separatorIndex)}" />
                                                                                            <c:set var="replyBodyText"
                                                                                                value="${fn:substring(replyLine, separatorIndex + 2, fn:length(replyLine))}" />
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <c:set var="replyAuthorName"
                                                                                                value="${not empty review.replyStaffName ? review.replyStaffName : (review.replyBy lt 0 ? 'Khách hàng' : 'Nhân viên')}" />
                                                                                            <c:set var="replyBodyText"
                                                                                                value="${replyLine}" />
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <div
                                                                                        class="thread-reply-wrap custom-reply-style">
                                                                                        <div class="thread-reply-line">
                                                                                        </div>
                                                                                        <div class="thread-reply">
                                                                                            <div
                                                                                                class="thread-avatar staff-avatar reply-avatar">
                                                                                                <c:out
                                                                                                    value="${fn:toUpperCase(fn:substring(fn:trim(replyAuthorName), 0, 1))}" />
                                                                                            </div>
                                                                                            <div
                                                                                                class="thread-reply-content">
                                                                                                <span
                                                                                                    class="reply-staff-name reply-author">
                                                                                                    <c:out
                                                                                                        value="${replyAuthorName}" />
                                                                                                </span>
                                                                                                <span
                                                                                                    class="thread-reply-text reply-body">
                                                                                                    <c:out
                                                                                                        value="${replyBodyText}" />
                                                                                                </span>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${sessionScope.userType eq 'staff'}">
                                                                        <a class="btn btn-sm btn-primary mt-2"
                                                                            href="${pageContext.request.contextPath}/view-reviews?medicineId=${medicine.medicineId}&selectedReviewId=${review.reviewId}">
                                                                            ${not empty review.replyContent ? 'Trả lời'
                                                                            : 'Trả lời'}
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
                                            <span class="price-value text-primary" id="priceDisplay">
                                                <c:choose>
                                                    <c:when
                                                        test="${medicine.sellingPrice != null && medicine.sellingPrice > 0}">
                                                        <c:set var="roundedPrice"
                                                            value="${Math.ceil(medicine.sellingPrice)}" />
                                                        <fmt:formatNumber value="${roundedPrice}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" />₫
                                                    </c:when>
                                                    <c:otherwise>Giá tham khảo</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="price-unit" id="unitDisplay">/
                                                <c:out value='${medicine.unit}' />
                                            </span>
                                        </div>

                                        <!-- Unit Selector -->
                                        <c:if test="${not empty units}">
                                            <div class="mb-3 d-flex align-items-center gap-2 flex-wrap">
                                                <span class="form-label text-muted mb-0 me-1">Chọn đơn vị tính</span>
                                                <c:forEach var="u" items="${units}" varStatus="st">
                                                    <button type="button" class="unit-pill ${st.first ? 'active' : ''}"
                                                        data-price="${u.sellingPrice}" data-unit="${u.unitName}"
                                                        data-unitid="${u.unitId}" onclick="selectUnit(this)">
                                                        ${u.unitName}
                                                    </button>
                                                </c:forEach>
                                            </div>
                                        </c:if>


                                        <!-- Quantity Selection -->
                                        <div class="mb-3 d-flex align-items-center gap-3">
                                            <label class="form-label text-muted mb-0">Chọn số lượng</label>
                                            <div class="input-group rounded-pill border"
                                                style="max-width: 130px; overflow: hidden;">
                                                <button type="button" class="btn btn-light px-3"
                                                    onclick="decreaseQty()">−</button>
                                                <input type="text" id="quantity" value="1" min="1"
                                                    class="form-control text-center border-0 shadow-none qty-input">
                                                <button type="button" class="btn btn-light px-3"
                                                    onclick="increaseQty()">+</button>
                                            </div>
                                        </div>

                                        <!-- Info rows -->
                                        <div class="medicine-info-rows">
                                            <div class="info-row">
                                                <span class="info-label">Danh mục</span>
                                                <c:choose>
                                                    <c:when
                                                        test="${not empty medicine.category and not empty medicine.category.categoryId}">
                                                        <a href="${pageContext.request.contextPath}/category?id=${medicine.category.categoryId}"
                                                            class="info-value info-value--link text-decoration-none">
                                                            <c:out value="${medicine.category.categoryName}" />
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="info-value text-muted">Chưa phân loại</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${not empty ingredientNames}">
                                                <div class="info-row">
                                                    <span class="info-label">Thành phần</span>
                                                    <span class="info-value text-dark">
                                                        <c:forEach var="ing" items="${ingredientNames}" varStatus="st">
                                                            <c:out value="${ing}" />
                                                            <c:if test="${!st.last}">, </c:if>
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty conditionNames}">
                                                <div class="info-row">
                                                    <span class="info-label">Công dụng</span>
                                                    <span class="info-value text-dark">
                                                        <c:forEach var="con" items="${conditionNames}" varStatus="st">
                                                            <c:out value="${con}" />
                                                            <c:if test="${!st.last}">, </c:if>
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty medicine.brandOrigin}">
                                                <div class="info-row">
                                                    <span class="info-label">Nước sản xuất</span>
                                                    <span class="info-value text-dark">
                                                        <c:out value="${medicine.brandOrigin}" />
                                                    </span>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty medicine.shortDescription}">
                                                <div class="info-row">
                                                    <span class="info-label">Mô tả ngắn</span>
                                                    <span class="info-value text-dark">
                                                        <c:out value="${medicine.shortDescription}" />
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="action-buttons">
                                            <form id="addToCartForm" action="${pageContext.request.contextPath}/cart"
                                                method="POST" style="display: none;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="id" value="${medicine.medicineId}">
                                                <input type="hidden" name="quantity" id="formQuantity" value="1">
                                                <input type="hidden" name="unitId" id="formUnitId" value="">
                                            </form>

                                            <button class="btn-buy btn btn-primary"
                                                onclick="submitAddToCart()">Mua</button>

                                            <!-- Xóa nút đánh giá ở action-buttons cũ (nếu còn) -->

                                        </div>

                                        <c:if test="${param.reviewError eq 'notPurchased'}">
                                            <div class="alert alert-warning mt-3 mb-0" role="alert">
                                                Bạn chỉ có thể đánh giá sản phẩm sau khi đã mua và đơn hàng đã được
                                                giao.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <script
                                    src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                                <!-- Toast đã đánh giá -->
                                <div id="reviewed-toast"
                                    style="display:none;position:fixed;z-index:9999;top:80px;right:30px;min-width:320px;max-width:90vw;background:#fff;color:#333;border-radius:8px;box-shadow:0 4px 16px rgba(0,0,0,0.15);padding:18px 28px;font-size:1rem;align-items:center;gap:12px;border-left:5px solid #3b82f6;">
                                    <i class="fas fa-info-circle"
                                        style="color:#3b82f6;font-size:1.5rem;margin-right:10px;"></i>
                                    <span>Bạn đã đánh giá sản phẩm này rồi.</span>
                                </div>
                                <script>
                                    function showReviewedToast() {
                                        var toast = document.getElementById('reviewed-toast');
                                        if (!toast) return;
                                        toast.style.display = 'flex';
                                        setTimeout(function () {
                                            toast.style.display = 'none';
                                        }, 2500);
                                    }
                                </script>
                                <script src="${pageContext.request.contextPath}/assets/js/detail.js"></script>

                                <!-- Toast thông báo khi chưa mua mà bấm đánh giá -->
                                <div id="review-toast"
                                    style="display:none;position:fixed;z-index:9999;top:30px;right:30px;min-width:320px;max-width:90vw;background:#fff;color:#333;border-radius:8px;box-shadow:0 4px 16px rgba(0,0,0,0.15);padding:18px 28px;font-size:1rem;align-items:center;gap:12px;border-left:5px solid #f39c12;">
                                    <i class="fas fa-exclamation-triangle"
                                        style="color:#f39c12;font-size:1.5rem;margin-right:10px;"></i>
                                    <span>Bạn chỉ có thể đánh giá sản phẩm sau khi đã mua và đơn hàng đã được
                                        giao.</span>
                                </div>
                                <script>
                                    function showReviewToast() {
                                        var toast = document.getElementById('review-toast');
                                        if (!toast) return;
                                        toast.style.display = 'flex';
                                        setTimeout(function () {
                                            toast.style.display = 'none';
                                        }, 2500);
                                    }
                                </script>
                                <script>
                                    function validateReplyForm(form) {
                                        const textarea = form.querySelector('textarea[name="replyContent"]');
                                        if (!textarea || textarea.value.trim().length > 0) {
                                            return true;
                                        }
                                        alert('Nội dung trả lời không được để trống.');
                                        textarea.focus();
                                        return false;
                                    }

                                    function bindInlineReplyForms() {
                                        function createReplyElement(text, authorName) {
                                            const replyWrap = document.createElement('div');
                                            replyWrap.className = 'thread-reply-wrap';
                                            const displayName = authorName && authorName.trim().length > 0 ? authorName.trim() : 'Khách hàng';
                                            const avatarText = displayName.charAt(0).toUpperCase();
                                            replyWrap.innerHTML = '<div class="thread-reply-line"></div>'
                                                + '<div class="thread-reply">'
                                                + '<div class="thread-avatar staff-avatar">' + avatarText + '</div>'
                                                + '<div class="thread-reply-content">'
                                                + '<div class="reply-staff-name"></div>'
                                                + '<div class="thread-reply-text"></div>'
                                                + '</div>'
                                                + '</div>';
                                            replyWrap.querySelector('.reply-staff-name').textContent = displayName;
                                            replyWrap.querySelector('.thread-reply-text').textContent = text;
                                            return replyWrap;
                                        }

                                        document.querySelectorAll('.js-inline-reply-form').forEach(form => {
                                            if (form.dataset.bound === 'true') {
                                                return;
                                            }
                                            form.dataset.bound = 'true';

                                            form.addEventListener('submit', async function (event) {
                                                event.preventDefault();

                                                const textarea = form.querySelector('textarea[name="replyContent"]');
                                                if (!textarea || textarea.value.trim().length === 0) {
                                                    alert('Nội dung trả lời không được để trống.');
                                                    if (textarea) textarea.focus();
                                                    return;
                                                }

                                                const submitBtn = form.querySelector('button[type="submit"]');
                                                const originalText = submitBtn ? submitBtn.textContent : '';
                                                if (submitBtn) {
                                                    submitBtn.disabled = true;
                                                    submitBtn.textContent = 'Đang gửi...';
                                                }

                                                try {
                                                    const formData = new URLSearchParams(new FormData(form));
                                                    const response = await fetch(form.action, {
                                                        method: 'POST',
                                                        headers: {
                                                            'X-Requested-With': 'XMLHttpRequest',
                                                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                                        },
                                                        body: formData.toString()
                                                    });

                                                    const data = await response.json();
                                                    if (!response.ok || !data.success) {
                                                        throw new Error(data.message || 'Gửi trả lời thất bại');
                                                    }

                                                    const reviewId = form.dataset.reviewId;
                                                    const replierName = form.dataset.replierName || 'Khách hàng';
                                                    const replyDisplayText = replierName + ': ' + data.replyContent;
                                                    let replyList = document.getElementById('reply-list-' + reviewId);
                                                    if (replyList) {
                                                        replyList.appendChild(createReplyElement(replyDisplayText, replierName));
                                                    } else {
                                                        const reviewThread = form.closest('.review-thread');
                                                        if (reviewThread) {
                                                            replyList = document.createElement('div');
                                                            replyList.id = 'reply-list-' + reviewId;
                                                            replyList.appendChild(createReplyElement(replyDisplayText, replierName));
                                                            reviewThread.insertBefore(replyList, form);
                                                        }
                                                    }

                                                    textarea.value = '';
                                                } catch (error) {
                                                    alert(error.message || 'Có lỗi xảy ra khi gửi trả lời.');
                                                } finally {
                                                    if (submitBtn) {
                                                        submitBtn.disabled = false;
                                                        submitBtn.textContent = originalText;
                                                    }
                                                }
                                            });
                                        });
                                    }

                                    function submitAddToCart() {
                                        const currentUserType = '${sessionScope.userType}';
                                        if (currentUserType === 'staff' || currentUserType === 'admin') return;

                                        const qty = document.getElementById('quantity').value;
                                        const mainImg = document.querySelector('.main-img');
                                        const unitId = document.getElementById('formUnitId').value;

                                        const formData = new URLSearchParams();
                                        formData.append('action', 'add');
                                        formData.append('id', '${medicine.medicineId}');
                                        formData.append('quantity', qty);
                                        if (unitId) formData.append('unitId', unitId);

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
                                                    if (typeof animateFlyToCart === 'function') {
                                                        animateFlyToCart(mainImg);
                                                    }
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

                                    function selectUnit(btn) {
                                        // Deactivate all pills
                                        document.querySelectorAll('.unit-pill').forEach(function (p) {
                                            p.classList.remove('active');
                                        });
                                        btn.classList.add('active');

                                        // Update price display
                                        var price = Math.ceil(parseFloat(btn.dataset.price));
                                        var unitName = btn.dataset.unit;
                                        var unitId = btn.dataset.unitid;

                                        var priceEl = document.getElementById('priceDisplay');
                                        if (priceEl) {
                                            priceEl.textContent = price > 0
                                                ? price.toLocaleString('vi-VN') + '₫'
                                                : 'Giá tham khảo';
                                        }

                                        var unitEl = document.getElementById('unitDisplay');
                                        if (unitEl) unitEl.textContent = '/ ' + unitName;

                                        // Store unitId for cart
                                        var formUnitId = document.getElementById('formUnitId');
                                        if (formUnitId) formUnitId.value = unitId;
                                    }

                                    // Init: activate first pill on load
                                    document.addEventListener('DOMContentLoaded', function () {
                                        var firstPill = document.querySelector('.unit-pill');
                                        if (firstPill) selectUnit(firstPill);
                                        bindInlineReplyForms();
                                    });
                                </script>
                </body>

                </html>