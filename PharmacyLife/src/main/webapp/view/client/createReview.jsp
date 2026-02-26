<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tạo đánh giá sản phẩm</title>
        </head>
        <!-- kiên -->

        <body class="review-page">
            <%@ include file="../common/header.jsp" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-review.css?v=20260226">

                <div class="review-container">
                    <div class="form-header">
                        <h2 class="form-title">Đánh giá sản phẩm</h2>
                        <button type="button" class="close-x-btn" onclick="goBack()" aria-label="Đóng">×</button>
                    </div>

                    <form id="reviewForm" action="${pageContext.request.contextPath}/create-review" method="POST">

                        <!-- Medicine ID (hidden) -->
                        <input type="hidden" name="medicineId" value="${medicineId}">
                        <input type="hidden" name="customerId" value="${customerId}">

                        <div class="medicine-preview">
                            <c:choose>
                                <c:when test="${not empty medicine.imageUrl}">
                                    <c:set var="imageUrlTrimmed" value="${fn:trim(medicine.imageUrl)}" />
                                    <c:choose>
                                        <c:when
                                            test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                            <c:set var="imgSrc" value="${imageUrlTrimmed}" />
                                        </c:when>
                                        <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                            <c:set var="imgSrc"
                                                value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                        </c:when>
                                        <c:when test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                            <c:set var="imgSrc"
                                                value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="imgSrc"
                                                value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="<c:out value='${imgSrc}'/>" alt="<c:out value='${medicine.medicineName}'/>"
                                        class="medicine-preview-img" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="Không có ảnh"
                                        class="medicine-preview-img" />
                                </c:otherwise>
                            </c:choose>
                            <p class="medicine-preview-name"><c:out value="${medicine.medicineName}" /></p>
                        </div>

                        <!-- Rating -->
                        <div class="form-group">
                            <div class="star-rating" id="starRating">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                            <input type="hidden" id="ratingValue" name="rating" value="">
                            <div class="rating-value" id="ratingText"></div>
                        </div>

                        <!-- Comment -->
                        <div class="form-group">
                            <textarea class="form-input" name="comment" id="comment"
                                placeholder="Nhập nội dung trả lời (Vui lòng gõ tiếng việt có dấu...)\n"><c:if test="${not empty replyTo}">Trả lời @<c:out value="${replyTo}"/>: </c:if></textarea>
                            <div class="error-message" id="commentError"></div>
                        </div>

                        <!-- Actions -->
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">Gửi</button>
                        </div>
                    </form>
                </div>

                <script>
                    const ratingLabels = {
                        1: 'Rất tệ',
                        2: 'Tệ',
                        3: 'Bình thường',
                        4: 'Tốt',
                        5: 'Tuyệt vời'
                    };

                    // Rating stars interaction
                    document.querySelectorAll('#starRating .star').forEach(star => {
                        const rating = star.getAttribute('data-value');

                        star.addEventListener('click', function () {
                            document.getElementById('ratingValue').value = rating;
                            document.getElementById('ratingText').textContent = ratingLabels[rating] || (rating + ' sao');
                            updateStars(rating);
                        });

                        star.addEventListener('mouseover', function () {
                            updateStars(rating);
                            document.getElementById('ratingText').textContent = ratingLabels[rating] || (rating + ' sao');
                        });
                    });

                    document.getElementById('starRating').addEventListener('mouseout', function () {
                        const currentRating = document.getElementById('ratingValue').value;
                        if (currentRating) {
                            updateStars(currentRating);
                            document.getElementById('ratingText').textContent = ratingLabels[currentRating] || (currentRating + ' sao');
                        } else {
                            document.querySelectorAll('#starRating .star').forEach(s => {
                                s.classList.remove('active');
                            });
                            document.getElementById('ratingText').textContent = '';
                        }
                    });

                    function updateStars(rating) {
                        document.querySelectorAll('#starRating .star').forEach(star => {
                            const starValue = star.getAttribute('data-value');
                            if (starValue <= rating) {
                                star.classList.add('active');
                            } else {
                                star.classList.remove('active');
                            }
                        });
                    }

                    document.getElementById('ratingText').textContent = '';

                    // Form submission validation
                    document.getElementById('reviewForm').addEventListener('submit', function (e) {
                        const comment = document.getElementById('comment').value.trim();
                        const rating = document.getElementById('ratingValue').value;
                        const errorDiv = document.getElementById('commentError');

                        if (!rating) {
                            e.preventDefault();
                            errorDiv.textContent = 'Vui lòng chọn số sao đánh giá';
                            return false;
                        }

                        if (!comment) {
                            e.preventDefault();
                            errorDiv.textContent = 'Vui lòng nhập bình luận';
                            return false;
                        }
                        
                        errorDiv.textContent = '';
                    });

                    // Clear error when typing
                    document.getElementById('comment').addEventListener('input', function () {
                        document.getElementById('commentError').textContent = '';
                    });

                    // Go back to medicine detail
                    function goBack() {
                        const medicineId = document.querySelector('input[name="medicineId"]').value;
                        if (medicineId) {
                            window.location.href = '${pageContext.request.contextPath}/medicine/detail?id=' + medicineId;
                        } else {
                            history.back();
                        }
                    }
                </script>

        </body>

        </html>