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
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Chi tiết phiếu nhập</h3>
                        </div>

                        <c:if test="${empty importRecord}">
                            <div class="form-card">
                                <div class="alert alert-danger mb-0" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>Không tìm thấy phiếu nhập
                                </div>
                                <div style="padding: 20px 0; text-align: center;">
                                    <a href="${pageContext.request.contextPath}/admin/imports" class="btn-back">
                                        <i class="fas fa-arrow-left me-2"></i>Trở lại
                                    </a>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty importRecord}">
                            <div class="form-card">
                                <div class="form-card-body">
                                    <!-- Info Grid -->
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <div class="info-label">Mã phiếu nhập</div>
                                            <div class="info-value">${importRecord.importCode}</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Nhà cung cấp</div>
                                            <div class="info-value">${importRecord.supplierName != null ? importRecord.supplierName : importRecord.supplierId}</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Người nhập</div>
                                            <div class="info-value">${importRecord.staffName != null ? importRecord.staffName : importRecord.staffId}</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Ngày nhập</div>
                                            <div class="info-value"><fmt:formatDate value="${importRecord.importDate}" pattern="dd/MM/yyyy"/></div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Tổng tiền</div>
                                            <div class="info-value price-value"><fmt:formatNumber value="${importRecord.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" />₫</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Trạng thái</div>
                                            <div class="info-value">
                                                <c:set var="statusClass" value="badge badge-pending" />
                                                <c:if test="${importRecord.status == 'Đã duyệt'}"><c:set var="statusClass" value="badge badge-confirmed" /></c:if>
                                                <c:if test="${importRecord.status == 'Chưa duyệt' || importRecord.status == 'Đã hủy'}"><c:set var="statusClass" value="badge badge-cancelled" /></c:if>
                                                <span class="${statusClass}">${importRecord.status != null ? importRecord.status : 'Đang chờ'}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Medicine List -->
                                    <c:if test="${not empty details}">
                                        <div style="margin-top: 36px;">
                                            <h5 class="fw-bold mb-3" style="color: #1e293b; font-size: 1.1rem;"><i class="fas fa-list me-2 text-primary"></i>Danh sách thuốc nhập</h5>
                                            <div class="table-responsive">
                                                <table class="table medicine-table align-middle" style="margin-bottom: 0;">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã thuốc</th>
                                                            <th>Tên thuốc</th>
                                                            <th>Số lượng</th>
                                                            <th>Đơn giá</th>
                                                            <th>Thành tiền</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="detail" items="${details}">
                                                            <tr>
                                                                <td><strong>${detail.medicineCode}</strong></td>
                                                                <td>${detail.medicineName != null ? detail.medicineName : '-'}</td>
                                                                <td>${detail.quantity}</td>
                                                                <td><span class="price"><fmt:formatNumber value="${detail.unitPrice}" type="number" maxFractionDigits="0" />₫</span></td>
                                                                <td><span class="price"><fmt:formatNumber value="${detail.totalAmount}" type="number" maxFractionDigits="0" />₫</span></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Footer Actions -->
                                    <div style="margin-top: 36px; padding-top: 24px; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">
                                        <a href="${pageContext.request.contextPath}/admin/imports" class="btn-back">
                                            <i class="fas fa-arrow-left me-2"></i>Trở lại
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/imports?action=edit&code=${importRecord.importCode}" class="btn-edit-detail">
                                            <i class="fas fa-pen me-2"></i>Chỉnh sửa
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>