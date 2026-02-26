<script>
    // Realtime filter for Import List
    document.addEventListener('DOMContentLoaded', function () {
        // filter is handled by filterImportTable()
    });
    function filterImportTable() {
        var input = document.getElementById('importSearchInput').value.toLowerCase();
        var rows = document.querySelectorAll('#importTable tbody tr');
        var found = false;
        rows.forEach(function (row) {
            if (row.classList.contains('empty-state-row')) return;
            var text = row.textContent.toLowerCase();
            var show = text.includes(input);
            row.style.display = show ? '' : 'none';
            if (show) found = true;
        });
        var emptyRow = document.querySelector('#importTable .empty-state-row');
        if (!found && input !== '') {
            if (!emptyRow) {
                emptyRow = document.createElement('tr');
                emptyRow.className = 'empty-state-row';
                emptyRow.innerHTML = '<td colspan="6" class="text-center py-5 text-muted"><i class="fas fa-box-open fa-3x mb-3 d-block"></i><p>Không tìm thấy dữ liệu phù hợp</p></td>';
                document.querySelector('#importTable tbody').appendChild(emptyRow);
            }
            emptyRow.style.display = '';
        } else if (emptyRow) {
            emptyRow.style.display = 'none';
        }
    }
</script>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Quản lý nhập thuốc - Dashboard</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <!-- Page Header: Title + Search -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-file-import me-2 text-primary"></i>Quản lý nhập
                                thuốc</h3>
                            <div class="d-flex align-items-center gap-2">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="importSearchInput"
                                        placeholder="Tìm mã phiếu, nhà cung cấp..." oninput="filterImportTable()"
                                        onkeydown="if(event.key==='Enter'){event.preventDefault(); filterImportTable();}">
                                </div>
                                <a href="${pageContext.request.contextPath}/admin/imports?action=create"
                                    class="btn-add-medicine">
                                    <i class="fas fa-plus"></i> Tạo phiếu nhập mới
                                </a>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="medicine-card">
                            <div class="table-responsive">
                                <table class="table medicine-table align-middle" id="importTable">
                                    <thead>
                                        <tr>
                                            <th>Mã</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Ngày nhập</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th style="width:130px">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty imports}">
                                                <c:forEach var="imp" items="${imports}">
                                                    <tr>
                                                        <td><strong>${imp.importCode}</strong></td>
                                                        <td>${imp.supplierName != null ? imp.supplierName :
                                                            imp.supplierId}</td>
                                                        <td>
                                                            <fmt:formatDate value="${imp.importDate}"
                                                                pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td><span class="price">
                                                                <fmt:formatNumber value="${imp.totalAmount}"
                                                                    type="number" groupingUsed="true"
                                                                    maxFractionDigits="0" />₫
                                                            </span></td>
                                                        <td>
                                                            <c:set var="statusClass" value="badge badge-pending" />
                                                            <c:if test="${imp.status == 'Đã duyệt'}">
                                                                <c:set var="statusClass"
                                                                    value="badge badge-confirmed" />
                                                            </c:if>
                                                            <c:if
                                                                test="${imp.status == 'Chưa duyệt' || imp.status == 'Đã hủy'}">
                                                                <c:set var="statusClass"
                                                                    value="badge badge-cancelled" />
                                                            </c:if>
                                                            <span class="${statusClass}">${imp.status != null ?
                                                                imp.status : 'Đang chờ'}</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-1">
                                                                <a href="${pageContext.request.contextPath}/admin/imports?action=view&code=${imp.importCode}"
                                                                    class="btn-action btn-view" title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/imports?action=edit&code=${imp.importCode}"
                                                                    class="btn-action btn-edit" title="Sửa">
                                                                    <i class="fas fa-pen"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/imports?action=delete&code=${imp.importCode}"
                                                                    class="btn-action btn-delete"
                                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa phiếu nhập này?')"
                                                                    title="Xóa">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${hasKeyword}">
                                                        <tr>
                                                            <td colspan="6" class="text-center py-5 text-muted">
                                                                <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                                                <p>Không tìm thấy dữ liệu phù hợp</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>