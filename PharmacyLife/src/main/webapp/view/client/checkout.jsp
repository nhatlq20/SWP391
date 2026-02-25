<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Thanh toán - PharmacyLife</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <link href="assets/css/cart.css" rel="stylesheet">
                    <style>
                        .checkout-container {
                            background-color: white;
                            border-radius: 8px;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            padding: 30px;
                        }

                        .order-summary {
                            background-color: #f8f9fa;
                            border-radius: 8px;
                            padding: 20px;
                        }

                        .form-label {
                            font-weight: 500;
                        }

                        .required::after {
                            content: " *";
                            color: red;
                        }
                    </style>
                </head>

                <body>
                    <!-- Include Header -->
                    <jsp:include page="/view/common/header.jsp" />

                    <div class="cart-page-layout">
                        <div class="cart-sidebar-container">
                            <jsp:include page="/view/common/sidebar.jsp" />
                        </div>

                        <div class="cart-content-container">
                            <div class="container py-4">
                                <div class="row">
                                    <!-- Checkout Form -->
                                    <div class="col-lg-8">
                                        <div class="checkout-container">
                                            <h4 class="mb-4"><i class="fas fa-money-check-alt me-2"></i>Thông tin giao
                                                hàng</h4>

                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                        aria-label="Close"></button>
                                                </div>
                                            </c:if>

                                            <form action="checkout" method="POST">
                                                <div class="row g-3">
                                                    <div class="col-12">
                                                        <label for="fullName" class="form-label required">Họ và
                                                            tên</label>
                                                        <input type="text" class="form-control" id="fullName"
                                                            name="fullName" required
                                                            placeholder="Nhập họ tên người nhận">
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="phone" class="form-label required">Số điện
                                                            thoại</label>
                                                        <input type="tel" class="form-control" id="phone" name="phone"
                                                            required placeholder="Nhập số điện thoại liên hệ">
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="address" class="form-label required">Địa chỉ nhận
                                                            hàng</label>
                                                        <textarea class="form-control" id="address" name="address"
                                                            rows="3" required
                                                            placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã...)"></textarea>
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="note" class="form-label">Ghi chú đơn hàng (Tùy
                                                            chọn)</label>
                                                        <textarea class="form-control" id="note" name="note" rows="2"
                                                            placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."></textarea>
                                                    </div>

                                                    <div class="col-12 mt-4">
                                                        <button class="btn btn-primary-custom w-100 py-3 fw-bold"
                                                            type="submit">
                                                            HOÀN TẤT ĐẶT HÀNG
                                                        </button>
                                                        <div class="text-center mt-3">
                                                            <a href="cart" class="text-decoration-none text-muted">
                                                                <i class="fas fa-arrow-left me-1"></i> Quay lại giỏ hàng
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Order Summary -->
                                    <div class="col-lg-4">
                                        <div class="order-summary shadow-sm sticky-top" style="top: 130px;">
                                            <h5 class="mb-3 fw-bold">Đơn hàng của bạn</h5>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="text-muted">Sản phẩm (${fn:length(cart.items)})</span>
                                                <a href="cart" class="text-decoration-none small">Sửa</a>
                                            </div>

                                            <ul class="list-group list-group-flush mb-3">
                                                <c:forEach items="${cart.items}" var="item">
                                                    <li
                                                        class="list-group-item d-flex justify-content-between lh-sm px-0 bg-transparent">
                                                        <div>
                                                            <h6 class="my-0 small">${item.medicine.medicineName}</h6>
                                                            <small class="text-muted">x ${item.quantity}</small>
                                                        </div>
                                                        <span class="text-muted small">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </span>
                                                    </li>
                                                </c:forEach>
                                            </ul>

                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Tạm tính</span>
                                                <strong>
                                                    <fmt:formatNumber value="${totalMoney}" type="currency"
                                                        currencySymbol="₫" maxFractionDigits="0" />
                                                </strong>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2 text-success">
                                                <span>Giảm giá</span>
                                                <span>-0 ₫</span>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <span class="h5 mb-0">Tổng cộng</span>
                                                <span class="h5 mb-0 text-danger fw-bold">
                                                    <fmt:formatNumber value="${totalMoney}" type="currency"
                                                        currencySymbol="₫" maxFractionDigits="0" />
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bootstrap Bundle with Popper -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>