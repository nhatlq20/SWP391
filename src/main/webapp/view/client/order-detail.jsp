<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết đơn hàng - PharmacyLife</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <!-- Link header CSS for variables -->
                <link href="assets/css/header.css" rel="stylesheet">
                <link href="assets/css/cart.css" rel="stylesheet">

                <style>
                    .detail-header {
                        background-color: #f8f9fa;
                        padding: 20px;
                        border-bottom: 1px solid #dee2e6;
                        margin-bottom: 20px;
                    }

                    .product-img {
                        width: 80px;
                        height: 80px;
                        object-fit: contain;
                        border: 1px solid #ddd;
                        border-radius: 8px;
                    }

                    .order-info span {
                        display: block;
                        margin-bottom: 5px;
                        font-size: 0.95rem;
                    }

                    .back-btn {
                        color: #6c757d;
                        font-weight: 500;
                        text-decoration: none;
                    }

                    .back-btn:hover {
                        color: var(--primary-color);
                        text-decoration: underline;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />

                <div class="cart-page-layout">
                    <div class="cart-sidebar-container">
                        <jsp:include page="/view/common/sidebar.jsp" />
                    </div>

                    <div class="cart-content-container">
                        <div class="container py-4">
                            <div class="mb-3">
                                <a href="order-list" class="back-btn"><i class="fas fa-arrow-left me-2"></i>Quay lại
                                    danh
                                    sách</a>
                            </div>

                            <div class="card shadow-sm">
                                <div class="detail-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-1 text-primary">Đơn hàng #${order.orderId}</h5>
                                        <span class="text-muted small">Ngày đặt:
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </span>
                                    </div>
                                    <span class="badge bg-secondary p-2 fs-6
                            <c:choose>
                                <c:when test='${order.status == " Pending"}'>bg-warning text-dark</c:when>
                                        <c:when test='${order.status == "Completed"}'>bg-success</c:when>
                                        <c:when test='${order.status == "Cancelled"}'>bg-danger</c:when>
                                        <c:otherwise>bg-primary</c:otherwise>
                                        </c:choose>
                                        ">
                                        ${order.status}
                                    </span>
                                </div>

                                <div class="card-body">
                                    <!-- Customer Info -->
                                    <div class="row mb-4">
                                        <div class="col-md-6 order-info">
                                            <h6 class="fw-bold mb-3"><i
                                                    class="fas fa-map-marker-alt me-2 text-danger"></i>Thông tin nhận
                                                hàng</h6>
                                            <p class="mb-1"><strong>Người nhận:</strong> ${order.shippingName}</p>
                                            <p class="mb-1"><strong>SĐT:</strong> ${order.shippingPhone}</p>
                                            <p class="mb-0"><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                                        </div>
                                        <div class="col-md-6 order-info">
                                            <h6 class="fw-bold mb-3"><i
                                                    class="fas fa-file-invoice-dollar me-2 text-success"></i>Thanh toán
                                            </h6>
                                            <p class="mb-1"><strong>Phương thức:</strong> Thanh toán khi nhận hàng (COD)
                                            </p>
                                            <p class="mb-0"><strong>Trạng thái:</strong> <span class="text-muted">Chưa
                                                    thanh toán</span></p>
                                        </div>
                                    </div>

                                    <hr>

                                    <!-- Order Items -->
                                    <h6 class="fw-bold mb-3">Sản phẩm đã mua</h6>
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th scope="col" style="width: 50%">Sản phẩm</th>
                                                    <th scope="col" class="text-center">Đơn giá</th>
                                                    <th scope="col" class="text-center">Số lượng</th>
                                                    <th scope="col" class="text-end">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${order.items}" var="item">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="${item.medicine.imageUrl}"
                                                                    alt="${item.medicine.medicineName}"
                                                                    class="product-img me-3"
                                                                    onerror="this.src='https://via.placeholder.com/80'">
                                                                <div>
                                                                    <h6 class="mb-1 text-dark text-decoration-none">
                                                                        ${item.medicine.medicineName}</h6>
                                                                    <small class="text-muted">Code:
                                                                        ${item.medicine.medicineCode}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${item.unitPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                        <td class="text-center fw-bold">x${item.quantity}</td>
                                                        <td class="text-end fw-bold text-primary">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot class="bg-light">
                                                <tr>
                                                    <td colspan="3" class="text-end fw-bold pt-3">Tổng cộng:</td>
                                                    <td class="text-end fs-5 fw-bold text-danger pt-3">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" />
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>