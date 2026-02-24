<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết đơn hàng #${order.orderId} - Quản trị nhà thuốc</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <style>
                    body {
                        background-color: #f4f6f9;
                    }

                    /* Adjust sidebar top position to account for header */
                    .sidebar-wrapper {
                        top: 115px !important;
                        /* Height of header */
                        height: calc(100vh - 115px) !important;
                        z-index: 100;
                    }

                    .main-content {
                        margin-left: 310px;
                        padding: 30px;
                        margin-top: 115px;
                    }

                    .order-header {
                        background-color: #fff;
                        padding: 20px;
                        border-bottom: 1px solid #e9ecef;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .status-badge {
                        font-size: 1rem;
                        padding: 8px 15px;
                    }

                    .card {
                        border: none;
                        box-shadow: 0 0 1px rgba(0, 0, 0, .125), 0 1px 3px rgba(0, 0, 0, .2);
                        margin-bottom: 20px;
                    }

                    .table img {
                        width: 50px;
                        height: 50px;
                        object-fit: cover;
                        border-radius: 4px;
                    }

                    :root {
                        --primary-theme: #4F81E1;
                    }

                    .text-theme {
                        color: var(--primary-theme) !important;
                    }

                    .bg-theme {
                        background-color: var(--primary-theme) !important;
                    }

                    .btn-primary {
                        background-color: var(--primary-theme);
                        border-color: var(--primary-theme);
                    }

                    .btn-primary:hover {
                        background-color: #3a6cc5;
                        border-color: #3a6cc5;
                    }

                    .btn-outline-theme {
                        color: var(--primary-theme);
                        border-color: var(--primary-theme);
                    }

                    .btn-outline-theme:hover {
                        background-color: var(--primary-theme);
                        color: white;
                    }
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/view/common/header.jsp" />

                <!-- Sidebar -->
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content container">
                    <!-- Alert Message -->
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                            ${sessionScope.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="message" scope="session" />
                        <c:remove var="messageType" scope="session" />
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">Chi tiết đơn hàng</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="orders-dashboard">Đơn hàng</a></li>
                                <li class="breadcrumb-item active" aria-current="page">#${order.orderId}</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="row">
                        <!-- Left Column: Order Info -->
                        <div class="col-lg-8">
                            <div class="card mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Sản phẩm trong đơn</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Sản phẩm</th>
                                                    <th class="text-center">Đơn giá</th>
                                                    <th class="text-center">Số lượng</th>
                                                    <th class="text-end pe-4">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${order.items}" var="item">
                                                    <tr>
                                                        <td class="ps-4">
                                                            <div class="d-flex align-items-center">
                                                                <img src="${pageContext.request.contextPath}/${item.medicine.imageUrl}"
                                                                    alt="${item.medicine.medicineName}" class="me-3"
                                                                    onerror="this.src='https://via.placeholder.com/50'">
                                                                <div>
                                                                    <h6 class="mb-0 text-dark">
                                                                        ${item.medicine.medicineName}</h6>
                                                                    <small class="text-muted">Mã:
                                                                        ${item.medicine.medicineCode}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${item.unitPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                        <td class="text-center fw-bold">x${item.quantity}</td>
                                                        <td class="text-end pe-4 fw-bold">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot class="bg-light">
                                                <tr>
                                                    <td colspan="3" class="text-end fw-bold pt-3">Tổng cộng:</td>
                                                    <td class="text-end fs-5 fw-bold text-danger pt-3 pe-4">
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

                        <!-- Right Column: Details & Actions -->
                        <div class="col-lg-4">
                            <!-- Status Card -->
                            <div class="card mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Trạng thái đơn hàng</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3 text-center">
                                        <span class="badge rounded-pill status-badge w-100
                                <c:choose>
                                    <c:when test=" ${order.status=='Pending' }">bg-warning text-dark</c:when>
                                            <c:when test="${order.status == 'Confirmed'}">bg-info text-dark</c:when>
                                            <c:when test="${order.status == 'Shipping'}">bg-primary</c:when>
                                            <c:when test="${order.status == 'Delivered'}">bg-success</c:when>
                                            <c:when test="${order.status == 'Cancelled'}">bg-danger</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose>
                                            ">
                                            <c:choose>
                                                <c:when test="${order.status == 'Pending'}">Chờ xử lý</c:when>
                                                <c:when test="${order.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${order.status == 'Shipping'}">Đang giao hàng</c:when>
                                                <c:when test="${order.status == 'Delivered'}">Đã giao hàng</c:when>
                                                <c:when test="${order.status == 'Cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>${order.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <hr>

                                    <form action="order-update-dashboard" method="POST">
                                        <input type="hidden" name="id" value="${order.orderId}">
                                        <div class="mb-3">
                                            <label for="statusSelect" class="form-label fw-bold">Cập nhật trạng
                                                thái</label>
                                            <select class="form-select" id="statusSelect" name="status">
                                                <option value="Pending" ${order.status=='Pending' ? 'selected' : '' }>
                                                    Chờ xử lý</option>
                                                <option value="Confirmed" ${order.status=='Confirmed' ? 'selected' : ''
                                                    }>Đã xác nhận</option>
                                                <option value="Shipping" ${order.status=='Shipping' ? 'selected' : '' }>
                                                    Đang giao hàng</option>
                                                <option value="Delivered" ${order.status=='Delivered' ? 'selected' : ''
                                                    }>Đã giao hàng</option>
                                                <option value="Cancelled" ${order.status=='Cancelled' ? 'selected' : ''
                                                    }>Đã hủy</option>
                                            </select>
                                        </div>
                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Customer Info Card -->
                            <div class="card mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Thông tin khách hàng</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Khách hàng</label>
                                        <div>${order.shippingName}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Liên hệ</label>
                                        <div><i class="fas fa-phone me-2 text-muted"></i>${order.shippingPhone}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Địa chỉ giao hàng</label>
                                        <div><i
                                                class="fas fa-map-marker-alt me-2 text-muted"></i>${order.shippingAddress}
                                        </div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="small text-muted text-uppercase fw-bold">Ngày đặt hàng</label>
                                        <div><i class="far fa-clock me-2 text-muted"></i>
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>