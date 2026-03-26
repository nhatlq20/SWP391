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

                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4"
                                            style="border-radius: 12px; background-color: #fef2f2; color: #991b1b;">
                                            <div class="d-flex align-items-start">
                                                <i class="fas fa-exclamation-circle me-3 mt-1"
                                                    style="font-size: 1.1rem;"></i>
                                                <div>
                                                    <h6 class="fw-bold mb-1">Không thể tiếp tục thanh toán</h6>
                                                    <c:if test="${not empty errorList}">
                                                        <ul class="mb-0 ps-3">
                                                            <c:forEach items="${errorList}" var="err">
                                                                <li>${err}</li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:if>
                                                    <c:if test="${empty errorList}">
                                                        <p class="mb-0">${error}</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                    </c:if>

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
                                                                    <th scope="col" style="width: 50px;"
                                                                        class="text-center">
                                                                        <input type="checkbox" id="selectAll"
                                                                            class="form-check-input" checked>
                                                                    </th>
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
                                                                    <tr data-muid="${item.medicineUnitId}">
                                                                        <td class="text-center">
                                                                            <input type="checkbox" name="selectedItems"
                                                                                value="${item.medicineUnitId}"
                                                                                class="form-check-input item-checkbox"
                                                                                checked
                                                                                onchange="calculateSelectedTotal()">
                                                                        </td>
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
                                                                                    <div
                                                                                        class="d-flex flex-column gap-1">
                                                                                        <div class="cart-unit-info">
                                                                                            <span class="unit-label">Đơn
                                                                                                vị:</span>
                                                                                            <span
                                                                                                class="unit-badge">${item.unitName}</span>
                                                                                        </div>

                                                                                    </div>
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
                                                                                <input type="hidden" name="muid"
                                                                                    value="${item.medicineUnitId}">

                                                                                <div
                                                                                    class="input-group input-group-sm quantity-group">
                                                                                    <button
                                                                                        class="btn btn-outline-secondary"
                                                                                        type="button"
                                                                                        onclick="updateQuantity(this, -1)">-</button>
                                                                                    <input type="text" name="quantity"
                                                                                        value="${item.quantity}"
                                                                                        class="form-control quantity-input"
                                                                                        style="background-color: white;"
                                                                                        data-original="${item.quantity}"
                                                                                        onkeydown="handleQtyKeydown(event, this)"
                                                                                        onblur="handleQtyBlur(this)"
                                                                                        oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                                                                    <button
                                                                                        class="btn btn-outline-secondary"
                                                                                        type="button"
                                                                                        onclick="updateQuantity(this, 1)">+</button>
                                                                                </div>
                                                                            </form>
                                                                        </td>
                                                                        <td class="text-end price-text item-total-val"
                                                                            id="item-total-${item.medicineUnitId}"
                                                                            data-raw-value="${item.totalPrice}">
                                                                            <fmt:formatNumber value="${item.totalPrice}"
                                                                                type="currency" currencySymbol="₫"
                                                                                maxFractionDigits="0" />
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <form action="cart" method="POST">
                                                                                <input type="hidden" name="action"
                                                                                    value="remove">
                                                                                <input type="hidden" name="muid"
                                                                                    value="${item.medicineUnitId}">
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

                                                        <div class="price-calculations">
                                                            <div class="price-row total mt-0">
                                                                <span class="total-label">Tổng cộng:</span>
                                                                <span class="total-value" id="cart-total">
                                                                    <fmt:formatNumber value="${totalMoney}"
                                                                        type="currency" currencySymbol="₫"
                                                                        maxFractionDigits="0" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <button type="button" onclick="goToCheckout()"
                                                        class="btn-checkout w-100" id="btn-checkout">
                                                        Thanh toán
                                                        <i class="fas fa-arrow-right"></i>
                                                    </button>

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

                        function calculateSelectedTotal() {
                            let total = 0;
                            const checkboxes = document.querySelectorAll('.item-checkbox:checked');
                            checkboxes.forEach(cb => {
                                const row = cb.closest('tr');
                                const priceEl = row.querySelector('.item-total-val');
                                if (priceEl) {
                                    total += parseFloat(priceEl.getAttribute('data-raw-value'));
                                }
                            });

                            const cartTotalEl = document.getElementById('cart-total');
                            if (cartTotalEl) cartTotalEl.textContent = formatCurrency(total);

                            const btnCheckout = document.getElementById('btn-checkout');
                            if (btnCheckout) {
                                if (checkboxes.length === 0) {
                                    btnCheckout.classList.add('disabled');
                                    btnCheckout.style.opacity = '0.5';
                                    btnCheckout.style.cursor = 'not-allowed';
                                } else {
                                    btnCheckout.classList.remove('disabled');
                                    btnCheckout.style.opacity = '1';
                                    btnCheckout.style.cursor = 'pointer';
                                }
                            }
                        }

                        const selectAllCb = document.getElementById('selectAll');
                        if (selectAllCb) {
                            selectAllCb.addEventListener('change', function () {
                                const isChecked = this.checked;
                                document.querySelectorAll('.item-checkbox').forEach(cb => {
                                    cb.checked = isChecked;
                                });
                                calculateSelectedTotal();
                            });
                        }

                        const contextPath = '${pageContext.request.contextPath}';

                        function goToCheckout() {
                            const selected = Array.from(document.querySelectorAll('.item-checkbox:checked'))
                                .map(cb => cb.value)
                                .join(',');

                            if (selected) {
                                // Use absolute path and encode selected ids to keep query intact
                                window.location.href = contextPath + '/cart?mode=checkout&muids=' + encodeURIComponent(selected);
                            } else {
                                alert('Vui lòng chọn ít nhất một sản phẩm để thanh toán!');
                            }
                        }

                        function submitQuantityUpdate(form, newVal, inputEl) {
                            inputEl.setAttribute('data-original', newVal);
                            const formData = new FormData(form);

                            const btnMinus = form.querySelector('button[onclick*="-1"]');
                            const btnPlus  = form.querySelector('button[onclick*="1"]');
                            if (btnMinus) btnMinus.disabled = true;
                            if (btnPlus)  btnPlus.disabled  = true;
                            inputEl.disabled = true;

                            fetch('cart', {
                                method: 'POST',
                                body: new URLSearchParams(formData),
                                headers: { 'X-Requested-With': 'XMLHttpRequest' }
                            })
                            .then(response => response.json())
                            .then(data => {
                                if (btnMinus) btnMinus.disabled = false;
                                if (btnPlus)  btnPlus.disabled  = false;
                                inputEl.disabled = false;

                                if (data.success) {
                                    const row = form.closest('tr');
                                    const priceCell = row.querySelector('td:nth-child(3)');
                                    if (priceCell && data.itemPrice) {
                                        priceCell.textContent = formatCurrency(data.itemPrice);
                                    }
                                    const itemTotalEl = row.querySelector('.item-total-val');
                                    if (itemTotalEl && data.itemTotal !== undefined) {
                                        itemTotalEl.textContent = formatCurrency(data.itemTotal);
                                        itemTotalEl.setAttribute('data-raw-value', data.itemTotal);
                                    }
                                    calculateSelectedTotal();
                                    if (typeof updateHeaderCartCount === 'function') {
                                        updateHeaderCartCount(data.cartCount);
                                    } else {
                                        const badge = document.getElementById('cartCount');
                                        if (badge) badge.textContent = data.cartCount;
                                    }
                                } else {
                                    // Revert to original value if server rejects
                                    inputEl.value = inputEl.getAttribute('data-original');
                                }
                            })
                            .catch(error => {
                                if (btnMinus) btnMinus.disabled = false;
                                if (btnPlus)  btnPlus.disabled  = false;
                                inputEl.disabled = false;
                                inputEl.value = inputEl.getAttribute('data-original');
                                console.error('Error updating quantity:', error);
                            });
                        }

                        function updateQuantity(btn, change) {
                            const form = btn.closest('form');
                            const input = form.querySelector('input[name="quantity"]');

                            let currentVal = parseInt(input.value);
                            if (isNaN(currentVal)) currentVal = 1;

                            let newVal = currentVal + change;
                            if (newVal < 1) newVal = 1;

                            if (newVal !== currentVal) {
                                input.value = newVal;
                                submitQuantityUpdate(form, newVal, input);
                            }
                        }

                        function handleQtyKeydown(event, inputEl) {
                            if (event.key === 'Enter') {
                                event.preventDefault();
                                inputEl.blur();
                            }
                        }

                        function handleQtyBlur(inputEl) {
                            const form = inputEl.closest('form');
                            let newVal = parseInt(inputEl.value);
                            const originalVal = parseInt(inputEl.getAttribute('data-original'));

                            if (isNaN(newVal) || newVal < 1) {
                                inputEl.value = originalVal; // Restore if invalid
                                return;
                            }

                            if (newVal !== originalVal) {
                                submitQuantityUpdate(form, newVal, inputEl);
                            }
                        }

                        document.addEventListener('DOMContentLoaded', calculateSelectedTotal);
                    </script>
                </body>

                </html>