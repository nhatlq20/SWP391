<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Customer Detail - Pharmacy Admin</title>
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

                    .card {
                        border: none;
                        box-shadow: 0 0 1px rgba(0, 0, 0, .125), 0 1px 3px rgba(0, 0, 0, .2);
                        margin-bottom: 20px;
                    }

                    .profile-header {
                        background: linear-gradient(135deg, #4F81E1 0%, #3a6cc5 100%);
                        color: white;
                        padding: 30px;
                        border-radius: 8px 8px 0 0;
                        margin-bottom: 0;
                    }

                    .avatar-lg {
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        border: 4px solid white;
                        object-fit: cover;
                        background-color: #fff;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        font-size: 3rem;
                        color: #4F81E1;
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
                        <h2 class="mb-0">Customer Profile</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="customers-dashboard">Customers</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${customer.fullName}</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="row">
                        <!-- Left Column: Profile Card -->
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-body text-center pt-5 pb-5">
                                    <div class="d-flex justify-content-center mb-3">
                                        <div class="avatar-lg">
                                            <i class="fas fa-user"></i>
                                        </div>
                                    </div>
                                    <h4 class="card-title fw-bold">${customer.fullName}</h4>
                                    <p class="text-muted">Customer #CUS
                                        <fmt:formatNumber value="${customer.customerId}" pattern="000" />
                                    </p>
                                    <span class="badge rounded-pill px-3 py-2
                            <c:choose>
                                <c:when test=" ${customer.status=='Active' }">bg-success</c:when>
                                        <c:when test="${customer.status == 'Inactive'}">bg-secondary</c:when>
                                        <c:when test="${customer.status == 'Banned'}">bg-danger</c:when>
                                        <c:otherwise>bg-info text-dark</c:otherwise>
                                        </c:choose>
                                        ">
                                        ${customer.status}
                                    </span>

                                    <div class="mt-4 d-grid gap-2">
                                        <button class="btn btn-primary"><i class="fas fa-edit me-2"></i>Edit
                                            Profile</button>
                                        <button class="btn btn-outline-danger"><i class="fas fa-ban me-2"></i>Block
                                            User</button>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Contact Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Email</label>
                                        <div><a href="mailto:${customer.email}"
                                                class="text-decoration-none">${customer.email}</a></div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Phone</label>
                                        <div>${customer.phone}</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small text-muted text-uppercase fw-bold">Address</label>
                                        <div>${customer.address}</div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="small text-muted text-uppercase fw-bold">Join Date</label>
                                        <div><i class="far fa-calendar-alt me-2 text-muted"></i>
                                            <fmt:formatDate value="${customer.joinDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Activity/Orders -->
                        <div class="col-lg-8">
                            <div class="card mb-4">
                                <div
                                    class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Recent Activity</h5>
                                </div>
                                <div class="card-body">
                                    <ul class="nav nav-tabs mb-3" id="myTab" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active" id="orders-tab" data-bs-toggle="tab"
                                                data-bs-target="#orders" type="button" role="tab">Orders</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab"
                                                data-bs-target="#reviews" type="button" role="tab">Reviews</button>
                                        </li>
                                    </ul>
                                    <div class="tab-content" id="myTabContent">
                                        <div class="tab-pane fade show active" id="orders" role="tabpanel">
                                            <div class="text-center py-5 text-muted">
                                                <i class="fas fa-shopping-basket fa-3x mb-3 opacity-50"></i>
                                                <p>No recent orders found for this customer.</p>
                                            </div>
                                        </div>
                                        <div class="tab-pane fade" id="reviews" role="tabpanel">
                                            <div class="text-center py-5 text-muted">
                                                <i class="far fa-comment-dots fa-3x mb-3 opacity-50"></i>
                                                <p>No reviews yet.</p>
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