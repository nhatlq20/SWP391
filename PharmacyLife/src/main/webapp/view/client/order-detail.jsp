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

                <!-- Link CSS -->
                <link href="assets/css/header.css" rel="stylesheet">
                <link href="assets/css/cart.css" rel="stylesheet">
                <link href="assets/css/order-detail.css" rel="stylesheet">
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />

                <div style="display: flex; padding-top: 115px;">
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="cart-content-container">
                        <div class="container-fluid">
                            <a href="order-list" class="back-btn">
                                <i class="fas fa-chevron-left"></i>
                                Quay lại danh sách
                            </a>

                            <div class="page-title">
                                <i class="fas fa-shopping-bag"></i>
                                Chi tiết đơn hàng #${order.orderId}
                            </div>

                            <div class="order-detail-card">
                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <div class="info-label">Trạng thái đơn hàng</div>
                                        <c:set var="statusClass" value="bg-secondary text-white" />
                                        <c:choose>
                                            <c:when test='${order.status == "Pending" || order.status=="Đang chờ"}'>
                                                <c:set var="statusClass" value="bg-warning text-dark" />
                                            </c:when>
                                            <c:when
                                                test='${order.status == "Confirmed" || order.status == "Đã xác nhận"}'>
                                                <c:set var="statusClass" value="bg-info text-dark" />
                                            </c:when>
                                            <c:when
                                                test='${order.status == "Shipping" || order.status == "Đang giao hàng"}'>
                                                <c:set var="statusClass" value="bg-primary text-white" />
                                            </c:when>
                                            <c:when
                                                test='${order.status == "Completed" || order.status == "Delivered" || order.status == "Đã giao hàng"}'>
                                                <c:set var="statusClass" value="bg-success text-white" />
                                            </c:when>
                                            <c:when test='${order.status == "Cancelled" || order.status == "Đã hủy"}'>
                                                <c:set var="statusClass" value="bg-danger text-white" />
                                            </c:when>
                                        </c:choose>
                                        <div class="status-badge ${statusClass}">
                                            <c:choose>
                                                <c:when test="${order.status == 'Pending'}">Đang chờ</c:when>
                                                <c:when test="${order.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${order.status == 'Shipping'}">Đang giao hàng</c:when>
                                                <c:when
                                                    test="${order.status == 'Completed' || order.status == 'Delivered'}">
                                                    Đã giao hàng</c:when>
                                                <c:when test="${order.status == 'Cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>${order.status}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="info-label">Ngày đặt hàng</div>
                                        <div class="info-value">
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="info-label">Phương thức thanh toán</div>
                                        <div class="info-value">Thanh toán khi nhận hàng (COD)</div>
                                    </div>
                                </div>

                                <div class="section-divider"></div>

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <h6 class="fw-bold mb-3" style="color: var(--text-slate); font-size: 1rem;">
                                            <i class="fas fa-truck-loading me-2 text-primary"></i>Thông tin giao hàng
                                        </h6>
                                        <div class="mb-2">
                                            <span class="info-label d-inline-block" style="min-width: 100px;">Người
                                                nhận:</span>
                                            <span class="info-value">${order.shippingName}</span>
                                        </div>
                                        <div class="mb-2">
                                            <span class="info-label d-inline-block" style="min-width: 100px;">Điện
                                                thoại:</span>
                                            <span class="info-value">${order.shippingPhone}</span>
                                        </div>
                                        <div>
                                            <span class="info-label d-inline-block" style="min-width: 100px;">Địa
                                                chỉ:</span>
                                            <span class="info-value">${order.shippingAddress}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="fw-bold mb-3" style="color: var(--text-slate); font-size: 1rem;">
                                            <i class="fas fa-receipt me-2 text-success"></i>Trạng thái thanh toán
                                        </h6>
                                        <div class="mb-2">
                                            <span class="info-label d-inline-block" style="min-width: 100px;">Tổng
                                                tiền:</span>
                                            <span class="info-value text-danger">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                    currencySymbol="₫" maxFractionDigits="0" />
                                            </span>
                                        </div>
                                        <div>
                                            <span class="info-label d-inline-block" style="min-width: 100px;">Thanh
                                                toán:</span>
                                            <span class="badge bg-light text-dark fw-bold border">Chưa thanh toán</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="section-divider"></div>

                                <h6 class="fw-bold mb-4" style="color: var(--text-slate); font-size: 1rem;">
                                    <i class="fas fa-boxes me-2 text-warning"></i>Danh sách sản phẩm
                                </h6>
                                <div class="table-responsive">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th
                                                    style="border-top-left-radius: 12px; border-bottom-left-radius: 12px;">
                                                    Sản phẩm</th>
                                                <th class="text-center">Đơn giá</th>
                                                <th class="text-center">Số lượng</th>
                                                <th class="text-end"
                                                    style="border-top-right-radius: 12px; border-bottom-right-radius: 12px;">
                                                    Thành tiền</th>
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
                                                                <div class="fw-bold text-dark mb-1">
                                                                    ${item.medicine.medicineName}</div>
                                                                <div class="text-muted small">Mã:
                                                                    ${item.medicine.medicineCode}</div>
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
                                        <tfoot>
                                            <tr>
                                                <td colspan="3" class="text-end pt-4 border-0">
                                                    <span class="total-label">Tổng cộng:</span>
                                                </td>
                                                <td class="text-end pt-4 border-0">
                                                    <span class="total-amount">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" />
                                                    </span>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>