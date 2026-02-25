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
    <style>
        body {
            background: #f5f5f5;
        }

        .page-wrap {
            margin-top: 130px;
            margin-left: 300px;
            padding: 24px 16px;
            width: calc(100% - 300px);
        }

        .content-box {
            max-width: 1040px;
            margin: 0 auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 24px;
        }

        @media (max-width: 992px) {
            .page-wrap {
                margin-left: 0;
                width: 100%;
            }
        }

        .review-item {
            border: 1px solid #ececec;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 12px;
            background: #fafafa;
        }

        .review-item-body {
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .review-medicine-thumb {
            width: 88px;
            height: 88px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
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
        }

        .meta {
            color: #6c757d;
            font-size: 13px;
        }

        .review-actions {
            margin-top: 10px;
        }
    </style>
</head>
<!-- kiên -->
<body>
<%@ include file="../common/header.jsp" %>
 <jsp:include page="/view/common/sidebar.jsp" />
<div class="page-wrap">
    <div class="content-box">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0">Đánh giá của tôi</h4>
            <span class="meta">Customer ID: ${customerId}</span>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-info">${message}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty reviews}">
                <div class="alert alert-info mb-0">Bạn chưa có đánh giá nào.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-item">
                        <div class="review-item-body">
                            <c:set var="med" value="${medicineMap[review.medicineId]}" />
                            <c:set var="medImage" value="${not empty med ? med.imageUrl : null}" />

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
                                    <!-- lấy id thuốc -->
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

                            <div class="review-content">
                                <div class="d-flex justify-content-between align-items-center mb-2">
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
                                    <span class="meta">
                                        <fmt:formatDate value="${review.reviewCreatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>

                                <div class="mb-2">${review.comment}</div>
                                <div class="meta">
                                    <!-- đây để lấy id thuốc  -->
                    
                                    <a href="${pageContext.request.contextPath}/medicine/detail?id=${review.medicineId}">
                                        ${not empty med ? med.medicineName : 'N/A'}
                                    </a>
                                    (ID: ${review.medicineId})
                                </div>
                                <div class="review-actions">
                                    <form method="post" action="${pageContext.request.contextPath}/reviews" onsubmit="return confirm('Bạn chắc chắn muốn xóa đánh giá này?');">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                        <input type="hidden" name="medicineId" value="${review.medicineId}" />
                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>

</html>
