<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Quản lý khách hàng - Quản trị nhà thuốc</title>
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

                    :root {
                        --primary-theme: #4F81E1;
                    }

                    .text-theme {
                        color: var(--primary-theme) !important;
                    }

                    .bg-theme {
                        background-color: var(--primary-theme) !important;
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

                <!-- Main Content -->
                <div class="main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Quản lý khách hàng</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Khách hàng</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="card">
                        <div class="card-header bg-white py-3">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">Tất cả khách hàng</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="input-group input-group-sm">
                                        <input type="text" class="form-control" placeholder="Tìm kiếm khách hàng...">
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
                                            <th class="ps-4">Mã</th>
                                            <th>Tên</th>
                                            <th>Liên hệ</th>
                                            <th>Địa chỉ</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${customers}" var="c">
                                            <tr>
                                                <td class="ps-4 fw-bold">
                                                    ${c.customerCode}
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">

                                                        <div>${c.fullName}</div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div><i class="fas fa-envelope me-1 text-muted"></i> ${c.email}
                                                    </div>
                                                    <small class="text-muted"><i class="fas fa-phone me-1"></i>
                                                        ${c.phone}</small>
                                                </td>
                                                <td>${c.address}</td>
                                                <td>
                                                    <span class="badge rounded-pill badge-status 
                                            <c:choose>
                                                <c:when test=" ${c.status=='Active' }">bg-success</c:when>
                                                        <c:when test="${c.status == 'Inactive'}">bg-secondary</c:when>
                                                        <c:when test="${c.status == 'Banned'}">bg-danger</c:when>
                                                        <c:otherwise>bg-info text-dark</c:otherwise>
                                                        </c:choose>
                                                        ">
                                                        <c:choose>
                                                            <c:when test="${c.status == 'Active'}">Hoạt động</c:when>
                                                            <c:when test="${c.status == 'Inactive'}">Không hoạt động
                                                            </c:when>
                                                            <c:when test="${c.status == 'Banned'}">Đã khóa</c:when>
                                                            <c:otherwise>${c.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <a href="customer-detail-dashboard?id=${c.customerId}"
                                                        class="text-theme" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
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