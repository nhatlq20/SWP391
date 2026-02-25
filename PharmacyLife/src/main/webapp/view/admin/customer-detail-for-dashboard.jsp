<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết khách hàng - PharmacyLife</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-dashboard.css">

                <style>
                    .main-content {
                        margin-left: 290px !important;
                        padding: 25px 30px;
                    }

                    .avatar-lg {
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        border: 4px solid white;
                        object-fit: cover;
                        background-color: #f8fafc;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        font-size: 3rem;
                        color: #4F81E1;
                        box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
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
                </style>
            </head>

            <body>

                <!-- Header -->
                <jsp:include page="/view/common/header.jsp" />

                <!-- Sidebar -->
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold mb-0"><i class="fas fa-user-circle me-2 text-primary"></i>Hồ sơ khách hàng
                        </h3>
                        <div class="breadcrumb-custom">
                            <a href="customers-dashboard">Khách hàng</a> / <span
                                class="active">${customer.fullName}</span>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Left Column: Profile Card -->
                        <div class="col-lg-4">
                            <div class="detail-card">
                                <div class="detail-card-body text-center py-4">
                                    <div class="d-flex justify-content-center mb-3">
                                        <div class="avatar-lg">
                                            <i class="fas fa-user"></i>
                                        </div>
                                    </div>
                                    <h4 class="fw-bold mb-1">${customer.fullName}</h4>
                                    <p class="text-muted small">Mã KH: #${customer.customerCode}</p>
                                    <span class="badge ${customer.status ? 'badge-stock' : 'badge-out'} px-3 py-2">
                                        ${customer.status ? 'Hoạt động' : 'Không hoạt động'}
                                    </span>
                                </div>
                            </div>

                            <div class="detail-card">
                                <div class="detail-card-header">
                                    <h5 class="fw-bold mb-0" style="font-size: 1.1rem;">Thông tin liên hệ</h5>
                                </div>
                                <div class="detail-card-body">
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Email</label>
                                        <div class="fw-medium"><a href="mailto:${customer.email}"
                                                class="text-decoration-none text-primary">${customer.email}</a></div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Số điện
                                            thoại</label>
                                        <div class="fw-medium">${customer.phone}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Địa chỉ</label>
                                        <div class="fw-medium text-secondary" style="font-size: 0.95rem;">
                                            ${customer.address}</div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="small text-muted text-uppercase fw-bold mb-1">Ngày tham
                                            gia</label>
                                        <div class="fw-medium"><i class="far fa-calendar-alt me-2 text-muted"></i>
                                            <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Activity/Orders -->
                        <div class="col-lg-8">
                            <div class="detail-card">
                                <div class="detail-card-header">
                                    <h5 class="fw-bold mb-0" style="font-size: 1.1rem;">Hoạt động gần đây</h5>
                                </div>
                                <div class="detail-card-body">
                                    <ul class="nav nav-pills mb-4" id="myTab" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active px-4" id="orders-tab" data-bs-toggle="tab"
                                                data-bs-target="#orders" type="button" role="tab">Đơn hàng</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link px-4" id="reviews-tab" data-bs-toggle="tab"
                                                data-bs-target="#reviews" type="button" role="tab">Đánh giá</button>
                                        </li>
                                    </ul>
                                    <div class="tab-content" id="myTabContent">
                                        <div class="tab-pane fade show active" id="orders" role="tabpanel">
                                            <div class="text-center py-5">
                                                <i class="fas fa-shopping-basket fa-3x mb-3 text-light"
                                                    style="color: #e5e7eb !important;"></i>
                                                <p class="text-muted">Không tìm thấy đơn hàng nào gần đây của khách hàng
                                                    này.</p>
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                                            <div class="text-center py-5">
                                                <i class="far fa-comment-dots fa-3x mb-3 text-light"
                                                    style="color: #e5e7eb !important;"></i>
                                                <p class="text-muted">Chưa có đánh giá nào.</p>
                                            </div>
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