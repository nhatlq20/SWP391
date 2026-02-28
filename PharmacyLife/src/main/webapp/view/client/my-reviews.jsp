<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá của tôi</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/cart.css" rel="stylesheet">
    <style>
        .reviews-page .cart-header h4 {
            font-size: 24px;
        }

        .reviews-page .reviews-count {
            font-size: 0.8rem;
            font-weight: 500;
        }

        .reviews-page .cart-card-inner {
            padding: 16px;
        }

        .reviews-page .reviews-table thead th {
            padding: 10px 10px;
            font-size: 12px;
        }

        .reviews-page .reviews-table tbody td {
            padding: 8px 10px;
            font-size: 19px;
        }

        .reviews-page .reviews-table td.comment-col,
        .reviews-page .reviews-table th.comment-col {
            padding-right: 6px;
        }

        .reviews-page .reviews-table td.date-col,
        .reviews-page .reviews-table th.date-col {
            padding-left: 6px;
        }

        .review-item {
            border: 1px solid #e9eef5;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
            background: #fbfdff;
            transition: all 0.2s ease;
        }

        .review-item:hover {
            background: #f8fbff;
            border-color: #dbeafe;
        }

        .review-item-body {
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .review-medicine-thumb {
            width: 64px;
            height: 64px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            flex-shrink: 0;
        }

        .review-content {
            flex: 1;
            min-width: 0;
        }

        .rating-stars {
            color: #ffc107;
            font-size: 14px;
            font-weight: 600;
        }

        .meta {
            color: #64748b;
            font-size: 13px;
        }

        .review-comment {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 8px;
            line-height: 1.55;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .review-medicine-link {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
            display: inline-block;
            max-width: 260px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .review-medicine-link:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }

        .review-actions {
            margin-top: 10px;
        }

        .btn-delete-review {
            border-radius: 10px;
            font-weight: 600;
            border-width: 1.5px;
        }

        .empty-reviews {
            padding: 48px 20px;
            text-align: center;
            color: #64748b;
        }

        .empty-reviews i {
            font-size: 52px;
            color: #cbd5e1;
            margin-bottom: 14px;
        }

        @media (max-width: 992px) {
            .reviews-page .cart-content-container {
                margin-left: 0 !important;
                width: 100% !important;
                padding: 16px;
            }
        }
    </style>
</head>
<!-- kiên -->
<body class="reviews-page">
<%@ include file="../common/header.jsp" %>
<div class="cart-page-layout">
    <jsp:include page="/view/common/sidebar.jsp" />
    <div class="cart-content-container">
        <div class="container-fluid py-4">
            <div class="cart-container">
                <div class="cart-header">
                    <h4 class="mb-0">
                        <i class="fas fa-star"></i>
                        Đánh giá của tôi
                        <span class="badge bg-light text-muted ms-2 reviews-count">
                            ${fn:length(reviews)} đánh giá
                        </span>
                    </h4>
                </div>

                <div class="cart-card-inner">

        <c:if test="${not empty message}">
            <div class="alert alert-info">${message}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty reviews}">
                <div class="empty-reviews">
                    <i class="fas fa-comment-slash"></i>
                    <h5 class="mb-2">Bạn chưa có đánh giá nào</h5>
                    <p class="mb-0">Hãy mua sản phẩm và chia sẻ trải nghiệm của bạn.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 reviews-table">
                        <thead>
                            <tr>
                                <th style="width: 92px;">Ảnh</th>
                                <th style="min-width: 270px;">Thuốc</th>
                                <th style="width: 270px;">Sao</th>
                                <th style="min-width: 120px;" class="comment-col">Bình luận</th>
                                <th style="width: 120px;" class="date-col">Ngày</th>
                                <th style="width: 70px;" class="text-center">Xóa</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="review" items="${reviews}">
                                <tr>
                                    <c:set var="med" value="${medicineMap[review.medicineId]}" />
                                    <c:set var="medImage" value="${not empty med ? med.imageUrl : null}" />
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty medImage}">
                                                <c:set var="imageUrlTrimmed" value="${fn:trim(medImage)}" />
                                                <c:set var="ctxPath" value="${pageContext.request.contextPath}" />
                                                <c:set var="ctxPrefix" value="${pageContext.request.contextPath}/" />
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://') or fn:startsWith(imageUrlTrimmed, '//')}">
                                                        <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                                    </c:when>
                                                    <c:when test="${fn:startsWith(imageUrlTrimmed, ctxPath) or fn:startsWith(imageUrlTrimmed, ctxPrefix)}">
                                                        <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                                    </c:when>
                                                    <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                    </c:when>
                                                    <c:when test="${fn:startsWith(imageUrlTrimmed, 'assets/')}">
                                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                    </c:when>
                                                    <c:when test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                                        <c:set var="relativeFromAssets" value="${fn:substringAfter(imageUrlTrimmed, 'assets/')}" />
                                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/${relativeFromAssets}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <a href="${pageContext.request.contextPath}/medicine/detail?id=${review.medicineId}">
                                                    <img class="review-medicine-thumb"
                                                        src="${imgSrc}"
                                                        alt="${not empty med ? med.medicineName : 'Medicine'}"
                                                        onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/no-image.png';">
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/medicine/detail?id=${review.medicineId}">
                                                    <img class="review-medicine-thumb"
                                                        src="${pageContext.request.contextPath}/assets/img/no-image.png"
                                                        alt="Medicine">
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a class="review-medicine-link" href="${pageContext.request.contextPath}/medicine/detail?id=${review.medicineId}">
                                            ${not empty med ? med.medicineName : 'N/A'}
                                        </a>
                                    </td>
                                    <td>
                                        <div class="rating-stars">
                                            <c:forEach var="i" begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span class="ms-1 text-dark">${review.rating}/5</span>
                                        </div>
                                    </td>
                                    <td class="comment-col">
                                        <div class="review-comment mb-0">${review.comment}</div>
                                    </td>
                                    <td class="date-col">
                                        <span class="meta">
                                            <fmt:formatDate value="${review.reviewCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <form method="post" action="${pageContext.request.contextPath}/reviews" onsubmit="return confirm('Bạn chắc chắn muốn xóa đánh giá này?');">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                            <input type="hidden" name="medicineId" value="${review.medicineId}" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger btn-delete-review" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>

</html>
