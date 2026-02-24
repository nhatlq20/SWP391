<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

<<<<<<< HEAD
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Chi tiết phiếu nhập - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
=======
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Xem chi tiết phiếu nhập</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                <style>
                    /* Specific overrides for the View Details Card to match screenshot */
                    .view-card {
                        background-color: white;
                        border-radius: 12px;
                        padding: 40px;
                        max-width: 900px;
                        margin: 0 auto;
                        /* Center horizontally in the main content */
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    }
>>>>>>> main

                    <style>
                        body {
                            background-color: #f4f6f9;
                        }

                        .sidebar-wrapper {
                            top: 115px !important;
                            height: calc(100vh - 115px) !important;
                            z-index: 100;
                        }

                        .main-content-dashboard {
                            margin-left: 250px;
                            padding: 30px;
                            margin-top: 115px;
                            max-width: 100%;
                            width: calc(100% - 250px);
                        }

                        .page-title-dashboard {
                            font-size: 28px;
                            font-weight: 700;
                            color: #2c3e50;
                            margin-bottom: 30px;
                            display: flex;
                            align-items: center;
                            gap: 15px;
                        }

                        .card-custom {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                            border: 1px solid #eef2f7;
                            padding: 25px;
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content-dashboard">
                        <div class="page-title-dashboard">
                            <i class="fas fa-file-invoice" style="color: #4F81E1;"></i>
                            <span>Chi tiết phiếu nhập thuốc</span>
                        </div>

                        <div class="card-custom">
                            <c:if test="${empty importRecord}">
                                <div class="alert alert-danger" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>Không tìm thấy phiếu nhập
                                </div>
                                <a href="${pageContext.request.contextPath}/import" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Trở lại
                                </a>
                            </c:if>

                            <c:if test="${not empty importRecord}">
                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Mã phiếu nhập</label>
                                        <input type="text" class="form-control bg-light"
                                            value="${importRecord.importCode}" readonly>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Nhà cung cấp</label>
                                        <input type="text" class="form-control bg-light"
                                            value="${importRecord.supplierName != null ? importRecord.supplierName : importRecord.supplierId}"
                                            readonly>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Người nhập</label>
                                        <input type="text" class="form-control bg-light"
                                            value="${importRecord.staffName != null ? importRecord.staffName : importRecord.staffId}"
                                            readonly>
                                    </div>
<<<<<<< HEAD
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Ngày nhập</label>
                                        <input type="text" class="form-control bg-light"
                                            value="<fmt:formatDate value='${importRecord.importDate}' pattern='dd/MM/yyyy'/>"
                                            readonly>
                                    </div>
                                </div>
=======
                                    <a href="${pageContext.request.contextPath}/import" class="btn-secondary">Trở
                                        lại</a>
                                </c:if>
>>>>>>> main

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Tổng tiền</label>
                                        <div class="form-control bg-light text-success fw-bold">
                                            <fmt:formatNumber value="${importRecord.totalAmount}" type="number"
                                                groupingUsed="true" maxFractionDigits="0" />₫
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Trạng thái</label>
                                        <input type="text" class="form-control bg-light"
                                            value="${importRecord.status != null ? importRecord.status : 'Đã duyệt'}"
                                            readonly>
                                    </div>
                                </div>

                                <!-- Medicine List -->
                                <c:if test="${not empty details}">
                                    <div class="mt-5">
                                        <h5 class="fw-bold mb-3"><i class="fas fa-list me-2"></i>Danh sách thuốc nhập
                                        </h5>
                                        <div class="table-responsive">
                                            <table class="table table-hover border">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Mã thuốc</th>
                                                        <th>Tên thuốc</th>
                                                        <th>Số lượng</th>
                                                        <th>Giá</th>
                                                        <th>Thành tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="detail" items="${details}">
                                                        <tr>
                                                            <td><strong>${detail.medicineCode}</strong></td>
                                                            <td>${detail.medicineName != null ? detail.medicineName :
                                                                '-'}</td>
                                                            <td>${detail.quantity}</td>
                                                            <td class="text-success">
                                                                <fmt:formatNumber value="${detail.unitPrice}"
                                                                    type="number" maxFractionDigits="0" />₫
                                                            </td>
                                                            <td class="text-success fw-bold">
                                                                <fmt:formatNumber value="${detail.totalAmount}"
                                                                    type="number" maxFractionDigits="0" />₫
                                                            </td>
                                                        </tr>
<<<<<<< HEAD
                                                    </c:forEach>
                                                </tbody>
                                            </table>
=======
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="detail" items="${details}">
                                                            <tr>
                                                                <td>${detail.medicineCode}</td>
                                                                <td>${detail.medicineName != null ? detail.medicineName
                                                                    : '-'}</td>
                                                                <td>${detail.quantity}</td>
                                                                <td class="amount-green">
                                                                    <fmt:formatNumber value="${detail.price}"
                                                                        type="number" maxFractionDigits="0" />₫
                                                                </td>
                                                                <td class="amount-green">
                                                                    <fmt:formatNumber value="${detail.totalAmount}"
                                                                        type="number" maxFractionDigits="0" />₫
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:if>

                                        <div class="view-footer">
                                            <a href="${pageContext.request.contextPath}/import"
                                                class="view-close-btn">Đóng</a>
>>>>>>> main
                                        </div>
                                    </div>
                                </c:if>

                                <div class="mt-5 d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/import" class="btn btn-secondary px-4">
                                        <i class="fas fa-arrow-left me-2"></i>Trở lại
                                    </a>
                                    <a href="${pageContext.request.contextPath}/import?action=edit&code=${importRecord.importCode}"
                                        class="btn btn-warning px-4">
                                        <i class="fas fa-edit me-2"></i>Chỉnh sửa
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>