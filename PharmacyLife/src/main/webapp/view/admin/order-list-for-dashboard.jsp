<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Admin Dashboard - Order Management</title>
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
                        /* Push content down */
                    }

                    .card {
                        border: none;
                        box-shadow: 0 0 1px rgba(0, 0, 0, .125), 0 1px 3px rgba(0, 0, 0, .2);
                        margin-bottom: 30px;
                    }

                    .table th {
                        border-top: none;
                    }

                    .badge-status {
                        font-size: 90%;
                        padding: 5px 10px;
                    }
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/view/common/header.jsp" />

                <!-- Sidebar -->
                <jsp:include page="/view/common/sidebar.jsp" />

                <!-- Main Content -->
                <div class="main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Order Management</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Home</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Orders</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="card">
                        <div class="card-header bg-white py-3">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">All Orders</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="input-group input-group-sm">
                                        <input type="text" class="form-control" placeholder="Search orders...">
                                        <button class="btn btn-outline-secondary" type="button"><i
                                                class="fas fa-search"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th class="ps-4">Order ID</th>
                                            <th>Customer</th>
                                            <th>Date</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th class="text-end pe-4">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="o">
                                            <tr>
                                                <td class="ps-4 fw-bold">#${o.orderId}</td>
                                                <td>
                                                    <div>${o.shippingName}</div>
                                                    <small class="text-muted">${o.shippingPhone}</small>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                        currencySymbol="₫" maxFractionDigits="0" />
                                                </td>
                                                <td>
                                                    <span class="badge rounded-pill badge-status 
                                            <c:choose>
                                                <c:when test=" ${o.status=='Pending' }">bg-warning text-dark</c:when>
                                                        <c:when test="${o.status == 'Confirmed'}">bg-info text-dark
                                                        </c:when>
                                                        <c:when test="${o.status == 'Shipping'}">bg-primary</c:when>
                                                        <c:when test="${o.status == 'Delivered'}">bg-success</c:when>
                                                        <c:when test="${o.status == 'Cancelled'}">bg-danger</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                        </c:choose>
                                                        ">
                                                        ${o.status}
                                                    </span>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <a href="order-detail-dashboard?id=${o.orderId}"
                                                        class="btn btn-sm btn-outline-primary">
                                                        Manage
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>