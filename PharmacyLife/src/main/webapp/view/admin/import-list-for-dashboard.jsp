<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý nhập thuốc - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">

    <style>
        body { background-color: #f4f6f9; }
        .sidebar-wrapper { top: 115px !important; height: calc(100vh - 115px) !important; z-index: 100; }
        .main-content-dashboard { margin-left: 250px; padding: 30px; margin-top: 115px; max-width: 100%; width: calc(100% - 250px); }
        .action-bar { display:flex; justify-content:space-between; align-items:center; margin-bottom:25px; flex-wrap:wrap; gap:15px; }
        .table-container { overflow-x:auto; }
        .page-title-dashboard { font-size:28px; font-weight:700; color:#2c3e50; margin-bottom:30px; display:flex; align-items:center; gap:15px; }
        .btn-primary-theme { background-color:#4F81E1; color:white; border:none; padding:10px 24px; border-radius:8px; display:inline-flex; align-items:center; gap:10px; font-weight:500; }
    </style>
</head>

<body>
    <jsp:include page="/view/common/header.jsp" />
    <jsp:include page="/view/common/sidebar.jsp" />

    <div class="main-content-dashboard">
        <div class="page-title-dashboard">
            <i class="fas fa-file-import" style="color: #4F81E1;"></i>
            <span>Quản lý nhập thuốc</span>
        </div>

        <div class="action-bar">
            <form method="POST" action="${pageContext.request.contextPath}/admin/imports" class="search-input-group d-flex">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="form-control" placeholder="Tìm mã phiếu, nhà cung cấp..." value="${param.keyword != null ? param.keyword : ''}">
                <button type="submit" class="btn btn-link text-muted"><i class="fas fa-search"></i></button>
            </form>

            <a href="${pageContext.request.contextPath}/admin/imports?action=create" class="btn-primary-theme">
                <i class="fas fa-plus"></i>
                <span>Tạo phiếu nhập thuốc</span>
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="table-container">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th class="ps-4">Mã</th>
                        <th>Nhà cung cấp</th>
                        <th>Ngày nhập</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty imports}">
                            <c:forEach var="imp" items="${imports}">
                                <tr>
                                    <td class="ps-4 fw-bold text-primary">${imp.importCode}</td>
                                    <td>${imp.supplierName != null ? imp.supplierName : imp.supplierId}</td>
                                    <td><fmt:formatDate value="${imp.importDate}" pattern="dd/MM/yyyy" /></td>
                                    <td class="fw-bold text-success"><fmt:formatNumber value="${imp.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" />₫</td>
                                    <td>
                                        <c:set var="statusClass" value="status-pending" />
                                        <c:if test="${imp.status == 'Đã duyệt'}"><c:set var="statusClass" value="status-approved" /></c:if>
                                        <c:if test="${imp.status == 'Chưa duyệt' || imp.status == 'Đã hủy'}"><c:set var="statusClass" value="status-cancelled" /></c:if>
                                        <span class="status-badge ${statusClass}">${imp.status != null ? imp.status : 'Đang chờ'}</span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/imports?action=view&code=${imp.importCode}" class="btn btn-sm btn-outline-info" title="Xem chi tiết"><i class="fas fa-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/admin/imports?action=edit&code=${imp.importCode}" class="btn btn-sm btn-outline-warning" title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                            <a href="${pageContext.request.contextPath}/admin/imports?action=delete&code=${imp.importCode}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa phiếu nhập này?')" title="Xóa"><i class="fas fa-trash"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                    <p>Không có dữ liệu phiếu nhập</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
