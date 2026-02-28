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
    <style>
        .review-page-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 18px;
            color: #1e293b;
        }

        .review-page-title i {
            color: #3b82f6;
            margin-right: 8px;
        }

        .review-toolbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 16px;
        }

        .btn-back-product {
            border-radius: 10px;
            font-weight: 600;
            padding: 8px 14px;
        }

        .review-item.selected-review {
            border: 2px solid #0d6efd;
            box-shadow: 0 0 0 2px rgba(13, 110, 253, 0.1);
        }

        .review-item {
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            background: #fff;
            padding: 16px;
            margin-bottom: 12px;
        }

        .review-comment {
            margin-top: 10px;
            margin-bottom: 0;
            color: #334155;
            line-height: 1.55;
        }

        .reply-preview {
            margin-top: 12px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 12px;
            color: #475569;
            font-size: 13px;
        }

        .reply-dashboard-form {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px dashed #dbe2ea;
        }

        .reply-dashboard-form .form-control {
            border-radius: 10px;
            border-color: #dbe2ea;
        }

        .reply-dashboard-form .btn {
            border-radius: 9px;
            font-weight: 600;
        }

        .delete-review-form {
            margin-top: 8px;
        }

        .delete-review-form .btn {
            border-radius: 9px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <%@ include file="../common/header.jsp" %>

    <div class="detail-wrapper">
        <div class="detail-content">
            <h2 class="review-page-title"><i class="fas fa-comments"></i>Đánh giá sản phẩm</h2>

            <div class="review-toolbar">
                <a href="${pageContext.request.contextPath}/medicine/detail?id=${medicineId}" class="btn btn-secondary btn-back-product">
                    <i class="fas fa-arrow-left"></i> Quay lại sản phẩm
                </a>
            </div>

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
                            <div class="review-item ${selectedReviewId == review.reviewId ? 'selected-review' : ''}" id="review-${review.reviewId}">
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
                         <!-- của kiên form phản hồi -->
                                <c:if test="${not empty review.replyContent}">
                                    <div class="reply-preview">
                                        Đã phản hồi bởi
                                        <strong>
                                            <c:out value="${not empty review.replyStaffName ? review.replyStaffName : (review.replyBy lt 0 ? 'Khách hàng' : 'Nhân viên nhà thuốc')}" />
                                        </strong>
                                        (<c:out value="${review.replyBy lt 0 ? 'Khách hàng' : 'Dược sĩ'}" />):
                                        ${review.replyContent}
                                    </div>
                                </c:if>

                                <c:if test="${sessionScope.userType eq 'staff'}">
                                    <form class="reply-dashboard-form" action="${pageContext.request.contextPath}/reply-review" method="post">
                                        <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                        <input type="hidden" name="medicineId" value="${medicineId}" />
                                        <input type="hidden" name="returnTo" value="viewReviews" />
                                        <label class="form-label mb-1"><strong>Trả lời đánh giá</strong></label>
                                        <textarea class="form-control mb-2" name="replyContent" rows="3" placeholder="Nhập nội dung phản hồi..." required><c:out value="${review.replyContent}" /></textarea>
                                        <button type="submit" class="btn btn-primary btn-sm">${not empty review.replyContent ? 'Cập nhật phản hồi' : 'Gửi phản hồi'}</button>
                                    </form>

                                </c:if>

                                <c:if test="${sessionScope.userType eq 'staff'}">
                                    <form class="delete-review-form" action="${pageContext.request.contextPath}/view-reviews" method="post"
                                          onsubmit="return confirm('Bạn chắc chắn muốn xóa review này?');">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                        <input type="hidden" name="medicineId" value="${medicineId}" />
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-trash"></i> Xóa review
                                        </button>
                                    </form>
                                </c:if>
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
