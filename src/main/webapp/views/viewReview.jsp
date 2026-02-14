<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết sản phẩm</title>
    <style>
        body {
            background: #eef3fb;
            font-family: Arial, sans-serif;
        }

        .header {
            background: #4f7ee3;
            color: white;
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .container {
            max-width: 1000px;
            margin: 60px auto;
            background: white;
            border-radius: 14px;
            padding: 30px;
            display: flex;
            gap: 40px;
            box-shadow: 0 6px 14px rgba(0,0,0,0.1);
        }

        /* LEFT */
        .left-box {
            width: 320px;
        }

        .product-img {
            width: 100%;
            border-radius: 10px;
        }

        .review-summary {
            margin-top: 15px;
        }

        .stars {
            color: #f5a623;
            font-size: 16px;
        }

        .review-btn {
            margin-top: 10px;
            padding: 6px 14px;
            font-size: 13px;
            border-radius: 16px;
            border: 1.5px solid #4f7ee3;
            background: white;
            color: #4f7ee3;
            cursor: pointer;
        }

        .review-btn:hover {
            background: #4f7ee3;
            color: white;
        }

        /* REVIEW LIST */
        .review-list {
            margin-top: 20px;
        }

        .review-item {
            border-top: 1px solid #eee;
            padding: 10px 0;
        }

        .review-rating {
            color: #f5a623;
            font-weight: bold;
        }

        .review-comment {
            font-size: 14px;
            margin: 4px 0;
        }

        .review-date {
            font-size: 12px;
            color: #777;
        }

        /* RIGHT */
        .product-info {
            flex: 1;
        }

        .price {
            font-size: 26px;
            color: #2d6cdf;
            font-weight: bold;
            margin: 15px 0;
        }

        .buy-btn {
            margin-top: 20px;
            padding: 12px 30px;
            border-radius: 25px;
            border: none;
            background: #4f7ee3;
            color: white;
            font-size: 15px;
            cursor: pointer;
        }
    </style>
</head>

<body>

<div class="header">
    <div>NHÀ THUỐC<br>PHARMACY LIFE</div>
    <div>User Name</div>
</div>

<div class="container">

    <!-- LEFT -->
    <div class="left-box">
        <img src="https://i.imgur.com/8ZQZQZ5.png" class="product-img">

        <!-- NÚT TẠO ĐÁNH GIÁ -->
        <form action="${pageContext.request.contextPath}/CreatedReview" method="get">
            <input type="hidden" name="medicineId" value="1">
            <button class="review-btn">Đánh giá</button>
        </form>

        <!-- DANH SÁCH ĐÁNH GIÁ -->
        <div class="review-list">
            <c:forEach items="${reviews}" var="r">
               
                <div class="review-item">
                     <p>${r.customerName}</p>
                    <div class="review-rating">
                        ${r.rating} ⭐
                    </div>
                    <div class="review-comment">
                        ${r.comment}
                    </div>
                    <div class="review-date">
                        ${r.createdAt}
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty reviews}">
                <p style="font-size:13px;color:#777">Chưa có đánh giá nào</p>
            </c:if>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="product-info">
        <h2>Thuốc Exopadin 60mg điều trị viêm mũi dị ứng</h2>
        <div class="price">80.000đ / Hộp</div>
        <p>
            Exopadin (Fexofenadin 60mg) là thuốc kháng histamin thế hệ 2,
            giúp giảm triệu chứng viêm mũi dị ứng.
        </p>
        <button class="buy-btn">Chọn mua</button>
    </div>

</div>

</body>
</html>
