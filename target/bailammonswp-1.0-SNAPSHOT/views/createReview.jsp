<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đánh giá sản phẩm</title>

        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f2f5fb;
            }

            /* HEADER */
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

            /* REVIEW BOX */
            .review-wrapper {
                display: flex;
                justify-content: center;
                margin-top: 50px;
            }

            .review-box {
                background: white;
                width: 520px;
                border-radius: 14px;
                padding: 25px;
                box-shadow: 0 6px 14px rgba(0,0,0,0.12);
                text-align: center;
            }

            .review-title {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .product-info {
                font-size: 14px;
                margin-bottom: 20px;
                color: #333;
            }

            /* STAR RATING */
            .stars {
                display: flex;
                justify-content: center;
                gap: 6px;
                margin-bottom: 10px;
            }

            .stars input {
                display: none;
            }

            .stars label {
                font-size: 30px;
                color: #ccc;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            /* hover từ trái sang phải */
            .stars label:hover,
            .stars label:hover ~ label {
                color: #f5a623;
            }

            /* khi chọn */
            .stars input:checked ~ label {
                color: #f5a623;
            }

            .rating-text {
                color: #f5a623;
                font-weight: bold;
                margin-bottom: 18px;
            }

            textarea {
                width: 85%;
                height: 100px;
                border-radius: 20px;
                border: 1px solid #ccc;
                padding: 15px 20px;
                resize: none;
                outline: none;
                font-size: 14px;
            }

            .submit-btn {
                margin-top: 18px;
            }

            .submit-btn button {
                width: 100%;
                padding: 12px;
                background: #4f7ee3;
                border: none;
                color: white;
                font-size: 15px;
                border-radius: 22px;
                cursor: pointer;
            }

            .submit-btn button:hover {
                background: #3e6bd1;
            }
        </style>
    </head>

    <body>

        <!-- HEADER -->
        <div class="header">
            <div class="header-left">
                NHÀ THUỐC<br>PHARMACY LIFE
            </div>
            <div class="header-right">
                User Name
            </div>
        </div>

        <!-- REVIEW FORM -->
        <div class="review-wrapper">
            <div class="review-box">

                <div class="review-title">Đánh giá sản phẩm</div>

                <div class="product-info">
                    Thuốc Cetirizin 10mg – Trị ngứa, dị ứng
                </div>
                       
                
                
           
                <form action="${pageContext.request.contextPath}/CreatedReview" method="post">
                <input type="hidden" name="medicineId" value="1">
                    <!-- STAR RATING -->
                    <div class="stars">
                        <input type="radio" name="rating" value="1" id="star1" required>
                        <label for="star1">★</label>

                        <input type="radio" name="rating" value="2" id="star2">
                        <label for="star2">★</label>

                        <input type="radio" name="rating" value="3" id="star3">
                        <label for="star3">★</label>

                        <input type="radio" name="rating" value="4" id="star4">
                        <label for="star4">★</label>

                        <input type="radio" name="rating" value="5" id="star5">
                        <label for="star5">★</label>
                    </div>

                    <div class="rating-text">Chọn số sao để đánh giá</div>

      
                    <textarea name="comment"
                              placeholder="Nhập nội dung đánh giá(Vui lòng gõ tiếng việt có dấu...)"
                              required></textarea>

              
                    <div class="submit-btn">
                    <button type="submit" >Gửi</button>
                   </div>
                </form>
            </div>
        </div>

    </body>
</html>
