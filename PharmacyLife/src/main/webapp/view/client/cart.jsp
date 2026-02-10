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

                    <div class="cart-page-layout">
                        <div class="cart-sidebar-container">
                            <jsp:include page="/view/common/sidebar.jsp" />
                        </div>

                        <div class="cart-content-container">
                            <div class="container py-4">
                                <div class="cart-container">
                                    <div class="cart-header d-flex justify-content-between align-items-center">
                                        <h4 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Giỏ hàng của bạn
                                        </h4>
                                        <span class="badge bg-light text-dark">${fn:length(cart.items)} sản
                                            phẩm</span>
                                    </div>

                                    <div class="p-4">
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
                                            <div class="row">
                                                <div class="col-lg-8">
                                                    <div class="table-responsive mb-4">
                                                        <table class="table align-middle">
                                                            <thead>
                                                                <tr>
                                                                    <th scope="col" width="40%">Sản phẩm</th>
                                                                    <th scope="col" class="text-center">Đơn giá</th>
                                                                    <th scope="col" class="text-center">Số lượng</th>
                                                                    <th scope="col" class="text-end">Thành tiền</th>
                                                                    <th scope="col" class="text-center">Thao tác</th>
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
                                                                                <div>
                                                                                    <h6 class="mb-1">
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
                                                                                    class="btn btn-outline-danger btn-sm rounded-circle"
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

                                                <div class="col-lg-4">
                                                    <div class="total-section shadow-sm">
                                                        <h5 class="mb-3 fw-bold">Thông tin đơn hàng</h5>

                                                        <div class="input-group mb-3">
                                                            <input type="text" class="form-control"
                                                                placeholder="Mã giảm giá">
                                                            <button class="btn btn-outline-primary-custom"
                                                                type="button">Áp
                                                                dụng</button>
                                                        </div>

                                                        <div class="d-flex justify-content-between mb-2">
                                                            <span>Tạm tính:</span>
                                                            <span class="fw-bold">
                                                                <fmt:formatNumber value="${totalMoney}" type="currency"
                                                                    currencySymbol="₫" maxFractionDigits="0" />
                                                            </span>
                                                        </div>
                                                        <div class="d-flex justify-content-between mb-3">
                                                            <span>Giảm giá:</span>
                                                            <span class="text-success">-0 ₫</span>
                                                        </div>
                                                        <hr>
                                                        <div class="d-flex justify-content-between mb-4">
                                                            <h5 class="mb-0">Tổng cộng:</h5>
                                                            <h4 class="mb-0 text-danger fw-bold">
                                                                <fmt:formatNumber value="${totalMoney}" type="currency"
                                                                    currencySymbol="₫" maxFractionDigits="0" />
                                                            </h4>
                                                        </div>

                                                        <div class="d-grid gap-2">
                                                            <a href="checkout" class="btn btn-primary-custom py-2">
                                                                Tiến hành thanh toán <i
                                                                    class="fas fa-arrow-right ms-1"></i>
                                                            </a>
                                                            <a href="home" class="btn btn-outline-secondary">
                                                                <i class="fas fa-arrow-left me-1"></i> Mua thêm
                                                            </a>
                                                        </div>
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
                        function updateQuantity(btn, change) {
                            const form = btn.closest('form');
                            const input = form.querySelector('input[name="quantity"]');
                            let currentVal = parseInt(input.value);
                            if (isNaN(currentVal)) currentVal = 1;

                            let newVal = currentVal + change;
                            if (newVal < 1) newVal = 1;

                            if (newVal !== currentVal) {
                                input.value = newVal;
                                form.submit();
                            }
                        }
                    </script>
                </body>

                </html>