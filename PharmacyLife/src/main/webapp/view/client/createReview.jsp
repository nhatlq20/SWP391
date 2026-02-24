<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tạo đánh giá sản phẩm</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-review.css">
        </head>
        <!-- kiên -->

        <body>
            <%@ include file="../common/header.jsp" %>

                <div class="container">
                    <h2 class="form-title">Đánh giá sản phẩm</h2>

                    <form id="reviewForm" action="${pageContext.request.contextPath}/create-review" method="POST">

                        <!-- Medicine ID (hidden) -->
                        <input type="hidden" name="medicineId" value="${medicineId}">
                        <input type="hidden" name="customerId" value="${customerId}">

                        <!-- Rating -->
                        <div class="form-group">
                            <label class="form-label">Xếp hạng <span class="required">*</span></label>
                            <div class="star-rating" id="starRating">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                            <input type="hidden" id="ratingValue" name="rating" value="5">
                            <div class="rating-value" id="ratingText"></div>
                        </div>

                        <!-- Comment -->
                        <div class="form-group">
                            <label class="form-label">Bình luận <span class="required">*</span></label>
                            <textarea class="form-input" name="comment" id="comment"
                                placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                            <div class="error-message" id="commentError"></div>
                        </div>

                        <!-- Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn btn-cancel" onclick="goBack()">Hủy</button>
                            <button type="submit" class="btn btn-submit">Gửi đánh giá</button>
                        </div>
                    </form>
                </div>

                <script>
                    // Rating stars interaction
                    document.querySelectorAll('#starRating .star').forEach(star => {
                        const rating = star.getAttribute('data-value');

                        star.addEventListener('click', function () {
                            document.getElementById('ratingValue').value = rating;
                            document.getElementById('ratingText').textContent = rating + ' sao';
                            updateStars(rating);
                        });

                        star.addEventListener('mouseover', function () {
                            updateStars(rating);
                            // Hiển thị text rating khi hover
                            document.getElementById('ratingText').textContent = rating + ' sao';
                        });
                    });

                    document.getElementById('starRating').addEventListener('mouseout', function () {
                        const currentRating = document.getElementById('ratingValue').value;
                        if (currentRating) {
                            updateStars(currentRating);
                            document.getElementById('ratingText').textContent = currentRating + ' sao';
                        } else {
                            // Xóa active class nhưng giữ ngôi sao màu xám mờ
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

                    // Set initial stars
                    // Không hiển thị ngôi sao mặc định, chỉ hiển thị khi hover

                    // Form submission validation
                    document.getElementById('reviewForm').addEventListener('submit', function (e) {
                        const comment = document.getElementById('comment').value.trim();
                        const errorDiv = document.getElementById('commentError');

                        if (!comment) {
                            e.preventDefault();
                            errorDiv.textContent = 'Vui lòng nhập bình luận';
                            return false;
                        }

                        if (comment.length < 5) {
                            e.preventDefault();
                            errorDiv.textContent = 'Bình luận phải có ít nhất 5 ký tự';
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