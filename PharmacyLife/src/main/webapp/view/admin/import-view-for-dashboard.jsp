<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Chi tiết phiếu nhập - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Chi tiết phiếu nhập</h3>
                        </div>
                        <div class="medicine-card">
                            <c:if test="${empty importRecord}">
                                <div class="alert alert-danger" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>Không tìm thấy phiếu nhập
                                </div>
                                <a href="${pageContext.request.contextPath}/admin/imports" class="btn btn-secondary">
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
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Ngày nhập</label>
                                        <input type="text" class="form-control bg-light"
                                            value="<fmt:formatDate value='${importRecord.importDate}' pattern='dd/MM/yyyy'/>"
                                            readonly>
                                    </div>
                                </div>

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
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="mt-5 d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/admin/imports"
                                        class="btn btn-secondary px-4">
                                        <i class="fas fa-arrow-left me-2"></i>Trở lại
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/imports?action=edit&code=${importRecord.importCode}"
                                        class="btn btn-warning px-4">
                                        <i class="fas fa-edit me-2"></i>Chỉnh sửa
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>