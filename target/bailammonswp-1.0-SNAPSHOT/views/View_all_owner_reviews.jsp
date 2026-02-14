<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Reviews</title>
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
                align-items: center;
                justify-content: space-between;
            }

            .header-left {
                font-size: 20px;
                font-weight: bold;
                line-height: 1.2;
            }

            .header-right {
                font-size: 14px;
            }


        h1 {
            margin: 20px;
        }

        .review-list {
            max-width: 700px;
            margin: 0 auto;
        }

        .review-box {
            background: #fff;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .medicine {
            font-weight: bold;
            color: #333;
        }

        .rating {
            color: #f5a623;
            font-weight: bold;
        }

        .comment {
            margin: 8px 0;
            color: #444;
        }

        .date {
            font-size: 12px;
            color: #777;
        }

        .delete-btn {
            margin-top: 8px;
        }

        .delete-btn button {
            background: #ff4d4f;
            border: none;
            color: #fff;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
        }

        .delete-btn button:hover {
            background: #d9363e;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">
        NHÀ THUỐC<br>PHARMACY LIFE
    </div>
    <div>User Name</div>
</div>
<h1>📝 Đánh giá của tôi</h1>

<div class="review-list">
    <c:forEach items="${reviews}" var="r">
        <div class="review-box">

            <div class="review-header">
                <div class="medicine">
                    Medicine ID: ${r.medicineId}
                </div>
                <div class="rating">
                    ${r.rating} ⭐
                </div>
            </div>

            <div class="comment">
                ${r.comment}
            </div>

            <div class="date">
                ${r.reviewCreatedAt}
            </div>

            <!-- DELETE -->
            <form action="Delete_owner_review" method="post" class="delete-btn"
                  onsubmit="return confirm('Bạn có chắc muốn xóa đánh giá này?');">
                <input type="hidden" name="reviewId" value="${r.reviewId}">
                <input type="hidden" name="medicineId" value="${r.medicineId}">
                <button type="submit">Delete</button>
            </form>

        </div>
    </c:forEach>
</div>

</body>
</html>
