<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Đơn hàng của tôi - Pharmacy Life</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                    <!-- Link CSS -->
                    <link href="assets/css/header.css" rel="stylesheet">
                    <link href="assets/css/cart.css" rel="stylesheet">
                    <link href="assets/css/sidebar.css" rel="stylesheet">
                    <link href="assets/css/order-list.css" rel="stylesheet">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />

                    <div style="display: flex; padding-top: 115px;">
                        <jsp:include page="/view/common/sidebar.jsp" />

                        <div class="cart-content-container">
                            <div class="container-fluid">
                                <div class="page-title">
                                    <i class="fas fa-history"></i>
                                    Lịch sử đơn hàng
                                </div>

                                <c:if test="${empty orders}">
                                    <div class="order-list-card">
                                        <div class="empty-state">
                                            <i class="fas fa-box-open"></i>
                                            <h5 class="fw-bold" style="color: var(--text-slate);">Bạn chưa có đơn hàng
                                                nào</h5>
                                            <p class="text-muted">Hãy mua sắm để lấp đầy giỏ hàng của bạn nhé!</p>
                                            <a href="home" class="btn btn-primary-custom px-4 py-2 mt-3"
                                                style="border-radius: 12px; font-weight: 600;">Đến trang chủ</a>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty orders}">
                                    <div class="order-list-card p-0 overflow-hidden">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th style="border-top-left-radius: 16px;">Sản phẩm</th>
                                                        <th>Mã ĐH</th>
                                                        <th>Ngày đặt</th>
                                                        <th class="text-end">Tổng tiền</th>
                                                        <th class="text-center">Trạng thái</th>
                                                        <th class="text-center" style="border-top-right-radius: 16px;">
                                                            Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${orders}" var="o">
                                                        <tr>
                                                            <td>
                                                                <c:if test="${not empty o.items}">
                                                                    <div class="d-flex align-items-center">
                                                                        <img src="${o.items[0].medicine.imageUrl}"
                                                                            alt="Img" class="order-item-img me-3"
                                                                            onerror="this.src='https://via.placeholder.com/50'" />
                                                                        <div>
                                                                            <div
                                                                                style="font-weight: 700; font-size: 0.95rem; color: var(--text-slate);">
                                                                                ${o.items[0].medicine.medicineName}
                                                                            </div>
                                                                            <c:if test="${fn:length(o.items) > 1}">
                                                                                <small class="text-muted"
                                                                                    style="font-size: 0.8rem;">
                                                                                    + ${fn:length(o.items) - 1} sản phẩm
                                                                                    khác
                                                                                </small>
                                                                            </c:if>
                                                                            <c:if test="${fn:length(o.items) <= 1}">
                                                                                <small class="text-muted"
                                                                                    style="font-size: 0.8rem;">
                                                                                    x${o.items[0].quantity}
                                                                                </small>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </td>
                                                            <td><span
                                                                    class="fw-bold text-muted small">#${o.orderId}</span>
                                                            </td>
                                                            <td>
                                                                <span class="text-slate fw-500"
                                                                    style="font-size: 0.9rem;">
                                                                    <fmt:formatDate value="${o.orderDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </span>
                                                            </td>
                                                            <td class="text-end fw-bold"
                                                                style="color: #ef4444; font-size: 1rem;">
                                                                <fmt:formatNumber value="${o.totalAmount}"
                                                                    type="currency" currencySymbol="₫"
                                                                    maxFractionDigits="0" />
                                                            </td>
                                                            <td class="text-center">
                                                                <c:set var="stClass" value="status-pending" />
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${o.status == 'Confirmed' || o.status == 'Đã xác nhận'}">
                                                                        <c:set var="stClass" value="status-confirmed" />
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${o.status == 'Shipping' || o.status == 'Đang giao hàng'}">
                                                                        <c:set var="stClass" value="status-shipping" />
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${o.status == 'Completed' || o.status == 'Delivered' || o.status == 'Đã giao hàng'}">
                                                                        <c:set var="stClass" value="status-delivered" />
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${o.status == 'Cancelled' || o.status == 'Đã hủy'}">
                                                                        <c:set var="stClass" value="status-cancelled" />
                                                                    </c:when>
                                                                </c:choose>
                                                                <span class="status-badge ${stClass}">
                                                                    <c:choose>
                                                                        <c:when test="${o.status == 'Pending'}">Đang chờ
                                                                        </c:when>
                                                                        <c:when test="${o.status == 'Confirmed'}">Đã xác
                                                                            nhận</c:when>
                                                                        <c:when test="${o.status == 'Shipping'}">Đang
                                                                            giao hàng</c:when>
                                                                        <c:when
                                                                            test="${o.status == 'Completed' || o.status == 'Delivered'}">
                                                                            Đã giao hàng</c:when>
                                                                        <c:when test="${o.status == 'Cancelled'}">Đã hủy
                                                                        </c:when>
                                                                        <c:otherwise>${o.status}</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="order-detail?id=${o.orderId}"
                                                                    class="btn btn-detail" title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>