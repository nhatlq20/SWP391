<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Đơn hàng của tôi - PharmacyLife</title>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                    <!-- Link header CSS for variables -->
                    <link href="assets/css/header.css" rel="stylesheet">
                    <link href="assets/css/cart.css" rel="stylesheet">

                    <style>
                        .order-card {
                            background-color: white;
                            border-radius: 8px;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                            margin-bottom: 20px;
                            transition: transform 0.2s;
                        }

                        .order-card:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
                        }

                        .status-badge {
                            padding: 5px 12px;
                            border-radius: 20px;
                            font-size: 0.85rem;
                            font-weight: 600;
                        }

                        .status-pending {
                            background-color: #fff3cd;
                            color: #856404;
                        }

                        .status-completed {
                            background-color: #d1e7dd;
                            color: #0f5132;
                        }

                        .status-cancelled {
                            background-color: #f8d7da;
                            color: #842029;
                        }

                        .status-shipping {
                            background-color: #cfe2ff;
                            color: #084298;
                        }

                        .btn-detail {
                            color: var(--primary-color);
                            border: 1px solid var(--primary-color);
                            border-radius: 20px;
                            padding: 5px 15px;
                            font-size: 0.9rem;
                            transition: all 0.2s;
                        }

                        .btn-detail:hover {
                            background-color: var(--primary-color);
                            color: white;
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
                                <h4 class="mb-4 text-secondary"><i class="fas fa-history me-2"></i>Lịch sử đơn hàng</h4>

                                <c:if test="${empty orders}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                                        <h5>Bạn chưa có đơn hàng nào</h5>
                                        <p class="text-muted">Hãy mua sắm để lấp đầy giỏ hàng của bạn nhé!</p>
                                        <a href="home" class="btn btn-primary-custom mt-2">Đến trang chủ</a>
                                    </div>
                                </c:if>

                                <c:if test="${not empty orders}">
                                    <div class="table-responsive bg-white rounded shadow-sm p-3">
                                        <table class="table table-hover align-middle">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th scope="col" style="width: 40%">Sản phẩm</th>
                                                    <th scope="col">Mã ĐH</th>
                                                    <th scope="col">Ngày đặt</th>
                                                    <th scope="col" class="text-end">Tổng tiền</th>
                                                    <th scope="col" class="text-center">Trạng thái</th>
                                                    <th scope="col" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${orders}" var="o">
                                                    <tr>
                                                        <td>
                                                            <c:if test="${not empty o.items}">
                                                                <div class="d-flex align-items-center">
                                                                    <img src="${o.items[0].medicine.imageUrl}" alt="Img"
                                                                        style="width: 50px; height: 50px; object-fit: contain; border-radius: 4px; border: 1px solid #eee; background: #fff;"
                                                                        class="me-3"
                                                                        onerror="this.src='https://via.placeholder.com/50'" />
                                                                    <div>
                                                                        <div
                                                                            style="font-weight: 600; font-size: 0.95rem; color: #333;">
                                                                            ${o.items[0].medicine.medicineName}</div>
                                                                        <c:if test="${fn:length(o.items) > 1}">
                                                                            <small class="text-muted"
                                                                                style="font-size: 0.85rem;">+
                                                                                ${fn:length(o.items) - 1} sản phẩm
                                                                                khác</small>
                                                                        </c:if>
                                                                        <c:if test="${fn:length(o.items) <= 1}">
                                                                            <small class="text-muted"
                                                                                style="font-size: 0.85rem;">x${o.items[0].quantity}</small>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td><span class="text-muted small">#${o.orderId}</span></td>
                                                        <td>
                                                            <span class="text-muted" style="font-size: 0.9rem;">
                                                                <fmt:formatDate value="${o.orderDate}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </span>
                                                        </td>
                                                        <td class="text-end text-danger fw-bold">
                                                            <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="status-badge 
                                                <c:choose>
                                                    <c:when test=" ${o.status=='Pending' }">status-pending</c:when>
                                                                <c:when test="${o.status == 'Completed'}">
                                                                    status-completed
                                                                </c:when>
                                                                <c:when test="${o.status == 'Cancelled'}">
                                                                    status-cancelled
                                                                </c:when>
                                                                <c:otherwise>status-shipping</c:otherwise>
                                                                </c:choose>
                                                                ">
                                                                ${o.status}
                                                            </span>
                                                        </td>
                                                        <td class="text-center">
                                                            <a href="order-detail?id=${o.orderId}"
                                                                class="btn btn-detail text-decoration-none">
                                                                Chi tiết
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>