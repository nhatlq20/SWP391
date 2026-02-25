<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết đơn hàng #${order.orderId} - PharmacyLife</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-dashboard.css">

                <style>
                    .main-content {
                        margin-left: 290px !important;
                        padding: 25px 30px;
                    }

                    .detail-card {
                        background: white;
                        border-radius: 12px;
                        box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                        border: 1px solid #e5e7eb;
                        margin-bottom: 24px;
                        overflow: hidden;
                    }

                    .detail-card-header {
                        padding: 16px 24px;
                        border-bottom: 1px solid #f3f4f6;
                        background-color: #fff;
                    }

                    .detail-card-body {
                        padding: 24px;
                    }

                    .breadcrumb-custom {
                        font-size: 0.875rem;
                    }

                    .breadcrumb-custom a {
                        color: #4F81E1;
                        text-decoration: none;
                    }

                    .breadcrumb-custom .active {
                        color: #6b7280;
                    }

                    .status-badge-custom {
                        font-size: 0.85rem;
                        padding: 8px 16px;
                        border-radius: 30px;
                        font-weight: 600;
                        display: inline-block;
                    }
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/view/common/header.jsp" />

                <!-- Sidebar -->
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <!-- Alert Message -->
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show mb-4"
                            role="alert">
                            <i class="fas fa-info-circle me-2"></i>${sessionScope.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="message" scope="session" />
                        <c:remove var="messageType" scope="session" />
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold mb-0"><i class="fas fa-shopping-cart me-2 text-primary"></i>Chi tiết đơn hàng
                        </h3>
                        <div class="breadcrumb-custom">
                            <a href="orders-dashboard">Đơn hàng</a> / <span class="active">#${order.orderId}</span>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Left Column: Order Info -->
                        <div class="col-lg-8">
                            <div class="detail-card">
                                <div class="detail-card-header">
                                    <h5 class="fw-bold mb-0" style="font-size: 1.1rem;">Sản phẩm trong đơn</h5>
                                </div>
                                <div class="detail-card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table medicine-table align-middle mb-0">
                                            <thead>
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
                                                                    alt="${item.medicine.medicineName}"
                                                                    style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px; border: 1px solid #f3f4f6;"
                                                                    class="me-3"
                                                                    onerror="this.src='https://via.placeholder.com/60'">
                                                                <div>
                                                                    <div class="fw-bold text-dark">
                                                                        ${item.medicine.medicineName}</div>
                                                                    <div class="text-muted small">Mã:
                                                                        ${item.medicine.medicineCode}</div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${item.unitPrice}" type="number"
                                                                groupingUsed="true" /> đ
                                                        </td>
                                                        <td class="text-center fw-bold">x${item.quantity}</td>
                                                        <td class="text-end pe-4 fw-bold" style="color: #22c55e;">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="number"
                                                                groupingUsed="true" /> đ
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot style="background-color: #f9fafb;">
                                                <tr>
                                                    <td colspan="3" class="text-end fw-bold py-3">Tổng cộng:</td>
                                                    <td class="text-end fs-5 fw-bold py-3 pe-4" style="color: #22c55e;">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                            groupingUsed="true" /> đ
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
                            <div class="detail-card">
                                <div class="detail-card-header">
                                    <h5 class="fw-bold mb-0" style="font-size: 1.1rem;">Trạng thái đơn hàng</h5>
                                </div>
                                <div class="detail-card-body">
                                    <div class="mb-4 text-center">
                                        <c:set var="statusClass" value="badge-pending" />
                                        <c:choose>
                                            <c:when test="${order.status == 'Delivered'}">
                                                <c:set var="statusClass" value="badge-delivered" />
                                            </c:when>
                                            <c:when test="${order.status == 'Cancelled'}">
                                                <c:set var="statusClass" value="badge-cancelled" />
                                            </c:when>
                                            <c:when test="${order.status == 'Shipping'}">
                                                <c:set var="statusClass" value="badge-shipping" />
                                            </c:when>
                                            <c:when test="${order.status == 'Confirmed'}">
                                                <c:set var="statusClass" value="badge-confirmed" />
                                            </c:when>
                                        </c:choose>
                                        <span class="badge ${statusClass} px-4 py-2 w-100" style="font-size: 0.9rem;">
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

                                    <form action="order-update-dashboard" method="POST">
                                        <input type="hidden" name="id" value="${order.orderId}">
                                        <div class="mb-3">
                                            <label for="statusSelect"
                                                class="form-label small fw-bold text-muted text-uppercase">Cập nhật
                                                trạng thái</label>
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
                                            <button type="submit" class="btn btn-primary fw-bold py-2">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Customer Info Card -->
                            <div class="detail-card">
                                <div class="detail-card-header">
                                    <h5 class="fw-bold mb-0" style="font-size: 1.1rem;">Thông tin khách hàng</h5>
                                </div>
                                <div class="detail-card-body">
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Khách hàng</label>
                                        <div class="fw-bold text-dark">${order.shippingName}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Liên hệ</label>
                                        <div class="fw-medium"><i
                                                class="fas fa-phone me-2 text-muted"></i>${order.shippingPhone}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Địa chỉ giao
                                            hàng</label>
                                        <div class="fw-medium text-secondary small"><i
                                                class="fas fa-map-marker-alt me-2 text-muted"></i>${order.shippingAddress}
                                        </div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Ngày đặt
                                            hàng</label>
                                        <div class="fw-medium small"><i class="far fa-clock me-2 text-muted"></i>
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