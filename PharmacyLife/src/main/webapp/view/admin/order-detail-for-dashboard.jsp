<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Order Detail #${order.orderId} - Admin Dashboard</title>
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
                        margin-left: 250px;
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
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/view/common/header.jsp" />

                <!-- Sidebar -->
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content container">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">Order Detail</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="orders-dashboard">Orders</a></li>
                                <li class="breadcrumb-item active" aria-current="page">#${order.orderId}</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="row">
                        <!-- Left Column: Order Info -->
                        <div class="col-lg-8">
                            <div class="card mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Order Items</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Product</th>
                                                    <th class="text-center">Price</th>
                                                    <th class="text-center">Quantity</th>
                                                    <th class="text-end pe-4">Total</th>
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
                                                        <td class="text-end pe-4 fw-bold">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot class="bg-light">
                                                <tr>
                                                    <td colspan="3" class="text-end fw-bold pt-3">Total Amount:</td>
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
                                    <h5 class="mb-0">Order Status</h5>
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
                                            ${order.status}
                                        </span>
                                    </div>

                                    <hr>

                                    <form action="order-update-dashboard" method="POST">
                                        <input type="hidden" name="id" value="${order.orderId}">
                                        <div class="mb-3">
                                            <label for="statusSelect" class="form-label fw-bold">Update Status</label>
                                            <select class="form-select" id="statusSelect" name="status">
                                                <option value="Pending" ${order.status=='Pending' ? 'selected' : '' }>
                                                    Pending</option>
                                                <option value="Confirmed" ${order.status=='Confirmed' ? 'selected' : ''
                                                    }>Confirmed</option>
                                                <option value="Shipping" ${order.status=='Shipping' ? 'selected' : '' }>
                                                    Shipping</option>
                                                <option value="Delivered" ${order.status=='Delivered' ? 'selected' : ''
                                                    }>Delivered</option>
                                                <option value="Cancelled" ${order.status=='Cancelled' ? 'selected' : ''
                                                    }>Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-primary">Update Status</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Customer Info Card -->
                            <div class="card mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Customer Details</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Customer</label>
                                        <div>${order.shippingName}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Contact Info</label>
                                        <div><i class="fas fa-phone me-2 text-muted"></i>${order.shippingPhone}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Shipping Address</label>
                                        <div><i
                                                class="fas fa-map-marker-alt me-2 text-muted"></i>${order.shippingAddress}
                                        </div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="small text-muted text-uppercase fw-bold">Order Date</label>
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