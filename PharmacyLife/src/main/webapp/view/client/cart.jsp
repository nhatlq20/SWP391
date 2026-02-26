<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Shopping Cart - PharmacyLife</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <link href="assets/css/cart.css" rel="stylesheet">
                </head>

                <body>
                    <!-- Include Header -->
                    <jsp:include page="/view/common/header.jsp" />

                    <div style="display: flex; padding-top: 115px;">
                        <jsp:include page="/view/common/sidebar.jsp" />

                        <div class="cart-content-container">
                            <div class="container-fluid py-4">
                                <div class="cart-container">
                                    <div class="cart-header">
                                        <h4 class="mb-0">
                                            <i class="fas fa-shopping-cart"></i>
                                            Giỏ hàng của bạn
                                            <span class="badge bg-light text-muted ms-2"
                                                style="font-size: 0.8rem; font-weight: 500;">
                                                ${fn:length(cart.items)} sản phẩm
                                            </span>
                                        </h4>
                                    </div>

                                    <div class="cart-card-inner">
                                        <c:if test="${empty cart.items}">
                                            <div class="empty-cart">
                                                <i class="fas fa-shopping-basket"></i>
                                                <h3>Giỏ hàng đang trống</h3>
                                                <p class="text-muted">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua
                                                    sắm.</p>
                                                <a href="home" class="btn btn-primary-custom mt-3">
                                                    <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                                                </a>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty cart.items}">
                                            <div class="row g-4">
                                                <div class="col-xl-9 col-lg-8">
                                                    <div class="mb-4">
                                                        <table class="table align-middle">
                                                            <thead>
                                                                <tr>
                                                                    <th scope="col">Sản phẩm</th>
                                                                    <th scope="col" class="text-center"
                                                                        style="width: 110px;">Đơn giá</th>
                                                                    <th scope="col" class="text-center"
                                                                        style="width: 120px;">Số lượng</th>
                                                                    <th scope="col" class="text-end"
                                                                        style="width: 130px;">Thành tiền</th>
                                                                    <th scope="col" class="text-center"
                                                                        style="width: 80px;">Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${cart.items}" var="item">
                                                                    <tr>
                                                                        <td>
                                                                            <div class="d-flex align-items-center">
                                                                                <img src="${pageContext.request.contextPath}${item.medicine.imageUrl}"
                                                                                    alt="${item.medicine.medicineName}"
                                                                                    class="cart-item-img me-3"
                                                                                    onerror="this.src='https://via.placeholder.com/80'">
                                                                                <div style="min-width: 0; flex: 1;">
                                                                                    <h6 class="cart-product-title mb-1"
                                                                                        title="${item.medicine.medicineName}">
                                                                                        ${item.medicine.medicineName}
                                                                                    </h6>
                                                                                    <small class="text-muted">Code:
                                                                                        ${item.medicine.medicineCode}</small>
                                                                                </div>
                                                                            </div>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <fmt:formatNumber value="${item.price}"
                                                                                type="currency" currencySymbol="₫"
                                                                                maxFractionDigits="0" />
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <form action="cart" method="POST"
                                                                                class="d-flex justify-content-center align-items-center">
                                                                                <input type="hidden" name="action"
                                                                                    value="update">
                                                                                <input type="hidden" name="id"
                                                                                    value="${item.medicine.medicineId}">

                                                                                <div
                                                                                    class="input-group input-group-sm quantity-group">
                                                                                    <button
                                                                                        class="btn btn-outline-secondary"
                                                                                        type="button"
                                                                                        onclick="updateQuantity(this, -1)">-</button>
                                                                                    <input type="text" name="quantity"
                                                                                        value="${item.quantity}"
                                                                                        class="form-control" readonly
                                                                                        style="background-color: white;">
                                                                                    <button
                                                                                        class="btn btn-outline-secondary"
                                                                                        type="button"
                                                                                        onclick="updateQuantity(this, 1)">+</button>
                                                                                </div>
                                                                            </form>
                                                                        </td>
                                                                        <td class="text-end price-text">
                                                                            <fmt:formatNumber value="${item.totalPrice}"
                                                                                type="currency" currencySymbol="₫"
                                                                                maxFractionDigits="0" />
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <form action="cart" method="POST"
                                                                                onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                                                                <input type="hidden" name="action"
                                                                                    value="remove">
                                                                                <input type="hidden" name="id"
                                                                                    value="${item.medicine.medicineId}">
                                                                                <button type="submit"
                                                                                    class="btn btn-outline-danger btn-sm rounded-circle btn-remove-item"
                                                                                    title="Xóa">
                                                                                    <i class="fas fa-trash-alt"></i>
                                                                                </button>
                                                                            </form>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                                <div class="col-xl-3 col-lg-4">
                                                    <div class="total-section shadow-sm">
                                                        <h5 class="summary-title">Thông tin đơn hàng</h5>

                                                        <div class="coupon-container">
                                                            <input type="text" class="coupon-input"
                                                                placeholder="Mã giảm giá">
                                                            <button class="btn-apply-coupon" type="button">
                                                                Áp dụng
                                                            </button>
                                                        </div>

                                                        <div class="price-calculations">
                                                            <div class="price-row">
                                                                <span>Tạm tính:</span>
                                                                <span class="fw-bold text-dark">
                                                                    <fmt:formatNumber value="${totalMoney}"
                                                                        type="currency" currencySymbol="₫"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                            <div class="price-row">
                                                                <span>Giảm giá:</span>
                                                                <span class="text-success">-0 ₫</span>
                                                            </div>
                                                            <div class="price-row total">
                                                                <span class="total-label">Tổng cộng:</span>
                                                                <span class="total-value" id="cart-total">
                                                                    <fmt:formatNumber value="${totalMoney}"
                                                                        type="currency" currencySymbol="₫"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </div>

                                                        <a href="checkout" class="btn-checkout">
                                                            Thanh toán
                                                            <i class="fas fa-arrow-right"></i>
                                                        </a>

                                                        <a href="home"
                                                            class="btn btn-outline-secondary w-100 mt-3 d-flex align-items-center justify-content-center"
                                                            style="border-radius: 10px; height: 44px; font-weight: 600; font-size: 0.9rem;">
                                                            <i class="fas fa-arrow-left me-2"></i> Mua thêm
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>




                    <!-- Bootstrap Bundle with Popper -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

                    <script>
                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(amount).replace(/\u20AB/g, '₫');
                        }

                        function updateQuantity(btn, change) {
                            const form = btn.closest('form');
                            const input = form.querySelector('input[name="quantity"]');
                            const id = form.querySelector('input[name="id"]').value;

                            let currentVal = parseInt(input.value);
                            if (isNaN(currentVal)) currentVal = 1;

                            let newVal = currentVal + change;
                            if (newVal < 1) newVal = 1;

                            if (newVal !== currentVal) {
                                input.value = newVal;

                                // Disable button to prevent double clicks
                                btn.disabled = true;

                                // Send AJAX request
                                const formData = new FormData(form);
                                fetch('cart', {
                                    method: 'POST',
                                    body: new URLSearchParams(formData),
                                    headers: {
                                        'X-Requested-With': 'XMLHttpRequest'
                                    }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        btn.disabled = false;
                                        if (data.success) {
                                            // Update Item Total in table
                                            const row = btn.closest('tr');
                                            const itemTotalEl = document.getElementById(`item-total-${id}`) || row.querySelector('.price-text');
                                            if (itemTotalEl) itemTotalEl.textContent = formatCurrency(data.itemTotal);

                                            // Update Subtotal and Total in Sidebar
                                            const sidebar = document.querySelector('.total-section');
                                            const subtotalEl = document.getElementById('cart-subtotal') || sidebar.querySelector('.price-row:not(.total) span:last-child');
                                            const totalEl = document.getElementById('cart-total') || sidebar.querySelector('.total-value');

                                            if (subtotalEl) subtotalEl.textContent = formatCurrency(data.cartTotal);
                                            if (totalEl) totalEl.textContent = formatCurrency(data.cartTotal);

                                            // Update Header Cart Count
                                            if (typeof updateHeaderCartCount === 'function') {
                                                updateHeaderCartCount(data.cartCount);
                                            } else {
                                                const badge = document.getElementById('cartCount');
                                                if (badge) badge.textContent = data.cartCount;
                                            }
                                        }
                                    })
                                    .catch(error => {
                                        btn.disabled = false;
                                        console.error('Error updating quantity:', error);
                                    });
                            }
                        }
                    </script>
                </body>

                </html>