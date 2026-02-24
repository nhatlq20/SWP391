<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Đặt hàng thành công - PharmacyLife</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

            <!-- Link header CSS to get variables -->
            <link href="assets/css/header.css" rel="stylesheet">

            <style>
                :root {
                    --primary-color: #4F81E1;
                    /* Same as header background */
                    --success-color: #4F81E1;
                    /* Override success to match theme */
                    --bg-light: #f8f9fa;
                }

                .success-page {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: calc(100vh - 115px);
                    /* Full height minus header */
                    padding: 40px 0;
                    background: var(--bg-light);
                    margin-top: 115px;
                    /* Offset for fixed header */
                }

                .success-card {
                    background: white;
                    padding: 60px;
                    border-radius: 12px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                    /* More subtle shadow */
                    display: inline-block;
                    margin: 0 auto;
                    max-width: 600px;
                    width: 90%;
                    text-align: center;
                    border: 1px solid #eef2f7;
                }

                .icon-box {
                    border-radius: 50%;
                    height: 120px;
                    width: 120px;
                    background: rgba(79, 129, 225, 0.1);
                    /* Light fade of primary color */
                    margin: 0 auto 30px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .checkmark {
                    color: var(--primary-color);
                    font-size: 60px;
                }

                .success-title {
                    color: var(--primary-color);
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    font-weight: 800;
                    font-size: 32px;
                    margin-bottom: 15px;
                }

                .success-message {
                    color: #6c757d;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    font-size: 18px;
                    margin: 0;
                    line-height: 1.6;
                    margin-bottom: 30px;
                }

                .btn-primary-custom {
                    background-color: var(--primary-color);
                    border-color: var(--primary-color);
                    color: white;
                    padding: 12px 30px;
                    font-weight: 600;
                    border-radius: 50px;
                    transition: all 0.3s;
                }

                .btn-primary-custom:hover {
                    background-color: #3b6ac5;
                    border-color: #3b6ac5;
                    color: white;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 10px rgba(79, 129, 225, 0.3);
                }
            </style>
        </head>

        <body>
            <!-- Include Header -->
            <jsp:include page="/view/common/header.jsp" />

            <div class="success-page">
                <div class="success-card">
                    <div class="icon-box">
                        <i class="fas fa-check checkmark"></i>
                    </div>
                    <h1 class="success-title">Đặt hàng thành công!</h1>
                    <p class="success-message">Cảm ơn bạn đã mua hàng.<br /> Chúng tôi sẽ liên hệ sớm nhất để xác nhận
                        đơn hàng.</p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/order-list"
                            class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold">
                            <i class="fas fa-list me-2"></i>Xem đơn hàng
                        </a>
                        <a href="home" class="btn btn-primary-custom text-decoration-none">
                            <i class="fas fa-home me-2"></i>Về trang chủ
                        </a>
                    </div>
                </div>
            </div>

            <!-- Bootstrap Bundle with Popper -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>