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
                                                <input type="hidden" name="selectedItems"
                                                    value="${empty selectedItems ? (empty sessionScope.checkoutItems ? param.muids : sessionScope.checkoutItems) : selectedItems}">
                                                <div class="row g-3">
                                                    <div class="col-12">
                                                        <label for="fullName" class="form-label required">Họ và
                                                            tên</label>
                                                        <input type="text" class="form-control" id="fullName"
                                                            name="fullName" required
                                                            placeholder="Nhập họ tên người nhận"
                                                            value="${not empty loggedInUser.fullName ? loggedInUser.fullName : ''}">
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="phone" class="form-label required">Số điện
                                                            thoại</label>
                                                        <input type="tel" class="form-control" id="phone" name="phone"
                                                            required placeholder="Nhập số điện thoại liên hệ"
                                                            value="${not empty loggedInUser.phone ? loggedInUser.phone : ''}">
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="address" class="form-label required">Địa chỉ nhận
                                                            hàng</label>
                                                        <textarea class="form-control" id="address" name="address"
                                                            rows="3" required
                                                            placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã...)">${not empty loggedInUser.address ? loggedInUser.address : ''}</textarea>
                                                    </div>

                                                    <div class="col-12">
                                                        <label for="note" class="form-label">Ghi chú đơn hàng (Tùy
                                                            chọn)</label>
                                                        <textarea class="form-control" id="note" name="note" rows="2"
                                                            placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."></textarea>
                                                    </div>

                                                    <div class="col-12 mt-4">
                                                        <input type="hidden" name="appliedVoucherId"
                                                            id="appliedVoucherId" value="0">
                                                        <button class="btn-checkout w-100" type="submit">
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
                                                <span class="text-muted">Sản phẩm (${fn:length(itemsToCheckout)})</span>
                                                <a href="cart" class="text-decoration-none small">Sửa</a>
                                            </div>

                                            <ul class="list-group list-group-flush mb-3">
                                                <c:forEach items="${itemsToCheckout}" var="item">
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
                                                <span>Tạm tính:</span>
                                                <span class="fw-bold">
                                                    <fmt:formatNumber value="${totalMoney}" type="currency"
                                                        currencySymbol="₫" maxFractionDigits="0" />
                                                </span>
                                            </div>

                                            <div class="voucher-section mb-3">
                                                <div class="d-flex">
                                                    <input type="text" id="voucherCode" name="voucherCode"
                                                        class="form-control" placeholder="Mã giảm giá"
                                                        style="border-radius: 8px 0 0 8px;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="applyVoucher()"
                                                        style="border-radius: 0 8px 8px 0; background-color: #2563eb; border: none; padding: 0 20px; font-weight: 600; white-space: nowrap; flex-shrink: 0;">
                                                        Áp dụng
                                                    </button>
                                                </div>
                                                <div id="voucherMessage" class="small mt-1"></div>
                                            </div>

                                            <div class="d-flex justify-content-between mb-2 text-success">
                                                <span>Giảm giá:</span>
                                                <span id="discountValueDisplay">-0 ₫</span>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <span class="h5 mb-0">Tổng cộng</span>
                                                <span class="h5 mb-0 text-danger fw-bold" id="finalTotalDisplay">
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

                    <script>
                        let _totalMoney = parseFloat("${totalMoney}") || 0;
                        let _discount = 0;

                        function applyVoucher() {
                            const code = document.getElementById('voucherCode').value;
                            if (!code) return;

                            fetch('${pageContext.request.contextPath}/check-voucher?code=' + encodeURIComponent(code) + '&total=' + _totalMoney)
                                .then(response => response.json())
                                .then(data => {
                                    const msgEl = document.getElementById('voucherMessage');
                                    if (data.success) {
                                        _discount = data.discount;
                                        document.getElementById('appliedVoucherId').value = data.voucherId;
                                        document.getElementById('discountValueDisplay').innerText = '-' + formatCurrency(_discount);
                                        document.getElementById('finalTotalDisplay').innerText = formatCurrency(_totalMoney - _discount);
                                        msgEl.innerText = data.message;
                                        msgEl.className = 'small mt-1 text-success';
                                    } else {
                                        _discount = 0;
                                        document.getElementById('appliedVoucherId').value = 0;
                                        document.getElementById('discountValueDisplay').innerText = '-0 ₫';
                                        document.getElementById('finalTotalDisplay').innerText = formatCurrency(_totalMoney);
                                        msgEl.innerText = data.message;
                                        msgEl.className = 'small mt-1 text-danger';
                                    }
                                });
                        }

                        function formatCurrency(n) {
                            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(n).replace('₫', '₫');
                        }
                    </script>

                    <!-- Bootstrap Bundle with Popper -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>