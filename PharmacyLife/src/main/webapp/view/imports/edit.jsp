<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Cập nhật phiếu nhập - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">

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
                            <i class="fas fa-edit" style="color: #4F81E1;"></i>
                            <span>Cập nhật phiếu nhập thuốc</span>
                        </div>

                        <div class="card-custom">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty import}">
                                <form action="${pageContext.request.contextPath}/import" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="importId" value="${import.importId}">

                                    <div class="row mb-4">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Mã phiếu nhập</label>
                                            <input type="text" class="form-control bg-light"
                                                value="${import.importCode}" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Nhà cung cấp</label>
                                            <input type="text" name="supplierId" class="form-control"
                                                value="${import.supplierName != null ? import.supplierName : import.supplierId}"
                                                placeholder="Nhập tên hoặc ID nhà cung cấp">
                                        </div>
                                    </div>

                                    <div class="row mb-4">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Người nhập</label>
                                            <input type="text" name="importerId" class="form-control"
                                                value="${import.staffName != null ? import.staffName : import.staffId}"
                                                placeholder="Nhập tên hoặc ID người nhập">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Ngày nhập</label>
                                            <input type="date" name="importDate" class="form-control"
                                                value="<fmt:formatDate value='${import.importDate}' pattern='yyyy-MM-dd'/>">
                                        </div>
                                    </div>

                                    <div class="row mb-4">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Tổng tiền (tự động cập nhật)</label>
                                            <div class="form-control bg-light text-success fw-bold">
                                                <fmt:formatNumber value="${import.totalAmount}" type="number"
                                                    groupingUsed="true" maxFractionDigits="0" />₫
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label fw-bold">Trạng thái</label>
                                            <select name="status" class="form-select">
                                                <option value="Đang chờ" ${import.status=='Đang chờ' ? 'selected' : ''
                                                    }>Đang chờ</option>
                                                <option value="Chưa duyệt" ${import.status=='Chưa duyệt' ? 'selected'
                                                    : '' }>Chưa duyệt</option>
                                                <option value="Đã duyệt" ${import.status=='Đã duyệt' ? 'selected' : ''
                                                    }>Đã duyệt</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Medicine List -->
                                    <div class="mt-5">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <h5 class="fw-bold"><i class="fas fa-list me-2"></i>Danh sách thuốc</h5>
                                            <button type="button" class="btn btn-primary btn-sm"
                                                onclick="alert('Thêm thuốc mới sẽ được cập nhật sau')">
                                                <i class="fas fa-plus me-1"></i>Thêm thuốc
                                            </button>
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table table-hover border">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Mã thuốc</th>
                                                        <th>Tên thuốc</th>
                                                        <th>Số lượng</th>
                                                        <th>Giá</th>
                                                        <th>Thành tiền</th>
                                                        <th class="text-center">Thao tác</th>
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
                                                                <fmt:formatNumber value="${detail.price}" type="number"
                                                                    maxFractionDigits="0" />₫
                                                            </td>
                                                            <td class="text-success fw-bold">
                                                                <fmt:formatNumber value="${detail.totalAmount}"
                                                                    type="number" maxFractionDigits="0" />₫
                                                            </td>
                                                            <td class="text-center">
                                                                <a href="${pageContext.request.contextPath}/import?action=deleteDetail&detailId=${detail.detailId}&id=${import.importId}"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Xóa thuốc này khỏi phiếu?')">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="mt-5 d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/import"
                                            class="btn btn-secondary px-4">
                                            <i class="fas fa-arrow-left me-2"></i>Trở lại
                                        </a>
                                        <button type="submit" class="btn btn-success px-5">
                                            <i class="fas fa-save me-2"></i>Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>