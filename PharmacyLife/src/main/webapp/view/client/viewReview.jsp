<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá sản phẩm</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/client-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/detail.css" rel="stylesheet">
</head>
<body>
    <%@ include file="../common/header.jsp" %>

    <div class="detail-wrapper">
        <div class="detail-content">
            <h2>Đánh giá sản phẩm</h2>

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
                                            <i class="fas fa-star" style="color: #FFD700;"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-star" style="color: #ddd;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <p class="total-reviews">dựa trên <strong>${totalReviews}</strong> đánh giá</p>
                        </div>
                    </div>
                    
                    <div class="stats-right">
                        <a href="${pageContext.request.contextPath}/medicine/detail?id=${medicineId}" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại sản phẩm
                        </a>
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
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <h5 class="reviewer-name">${review.customerName}</h5>
                                        <div class="review-rating">
                                            <c:forEach var="i" begin="1" end="5">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}">
                                                        <i class="fas fa-star" style="color: #FFD700; margin-right: 2px;"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-star" style="color: #ddd; margin-right: 2px;"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span class="rating-text">${review.rating}/5</span>
                                        </div>
                                    </div>
                                    <span class="review-date">${review.createdAt}</span>
                                </div>
                                <p class="review-comment">${review.comment}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="../common/footer.jsp" %>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
