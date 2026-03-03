<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý mã giảm giá - PharmacyLife</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                </head>

                <body class="bg-light">
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-ticket-alt me-2 text-primary"></i>Quản lý mã giảm
                                giá</h3>
                            <div class="d-flex align-items-center gap-2">
                                <a href="${pageContext.request.contextPath}/admin/voucher-add"
                                    class="btn btn-primary d-flex align-items-center">
                                    <i class="fas fa-plus me-2"></i> Thêm mã mới
                                </a>
                            </div>
                        </div>

                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <c:choose>
                                    <c:when test="${param.success == 'added'}">Thêm voucher mới thành công!</c:when>
                                    <c:when test="${param.success == 'updated'}">Cập nhật voucher thành công!</c:when>
                                    <c:when test="${param.success == 'deleted'}">Xóa voucher thành công!</c:when>
                                </c:choose>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="medicine-card">
                            <div class="table-responsive">
                                <table class="table medicine-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Mã</th>
                                            <th>Mô tả</th>
                                            <th>Loại giảm</th>
                                            <th>Giá trị</th>
                                            <th>Đơn hàng tối thiểu</th>
                                            <th>Hạn dùng</th>
                                            <th>Số lượng</th>
                                            <th>Trạng thái</th>
                                            <th style="width:130px">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="v" items="${vouchers}">
                                            <tr>
                                                <td><span class="badge bg-info text-dark fw-bold"
                                                        style="font-size: 0.9em;">${v.voucherCode}</span></td>
                                                <td style="max-width: 200px;" class="text-truncate"
                                                    title="${v.description}">${v.description}</td>
                                                <td>${v.discountType == 'Percent' ? 'Giảm %' : 'Giảm tiền cố định'}</td>
                                                <td class="fw-bold text-primary">
                                                    <c:choose>
                                                        <c:when test="${v.discountType == 'Percent'}">
                                                            ${v.discountValue}% (Tối đa
                                                            <fmt:formatNumber value="${v.maxDiscountAmount}"
                                                                type="number" />đ)
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${v.discountValue}"
                                                                type="number" />đ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${v.minOrderValue}" type="number" />đ
                                                </td>
                                                <td>
                                                    <div class="small">
                                                        BD:
                                                        <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy" />
                                                        <br>
                                                        KT:
                                                        <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="progress" style="height: 10px; width: 80px;">
                                                        <c:set var="usagePercent"
                                                            value="${(v.usedQuantity / v.quantity) * 100}" />
                                                        <c:set var="pbWidth"
                                                            value="${usagePercent > 100 ? 100 : usagePercent}" />
                                                        <div class="progress-bar ${usagePercent > 80 ? 'bg-danger' : 'bg-primary'}"
                                                            role="progressbar" style="width: ${pbWidth}%">
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">${v.usedQuantity} / ${v.quantity}</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.active}">
                                                            <span class="badge bg-success">Đang chạy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Tạm dừng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <a href="${pageContext.request.contextPath}/admin/voucher-toggle?id=${v.voucherId}"
                                                            class="btn-action ${v.active ? 'btn-view' : 'btn-edit'}"
                                                            title="${v.active ? 'Tạm dừng' : 'Kích hoạt'}">
                                                            <i class="fas ${v.active ? 'fa-pause' : 'fa-play'}"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/voucher-edit?id=${v.voucherId}"
                                                            class="btn-action btn-edit" title="Sửa">
                                                            <i class="fas fa-pen"></i>
                                                        </a>
                                                        <button class="btn-action btn-delete" title="Xóa"
                                                            onclick="confirmDelete('${v.voucherId}', '${v.voucherCode}')">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteModal" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered modal-sm">
                            <div class="modal-content">
                                <div class="modal-body text-center p-4">
                                    <i class="fas fa-exclamation-triangle text-warning fa-3x mb-3"></i>
                                    <h4>Xóa voucher?</h4>
                                    <p>Mã <strong id="deleteVoucherCode"></strong> sẽ bị xóa vĩnh viễn.</p>
                                    <div class="d-flex justify-content-center gap-2 mt-4">
                                        <button type="button" class="btn btn-light px-4"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <a href="#" id="deleteConfirmBtn" class="btn btn-danger px-4">Xóa ngay</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function confirmDelete(id, code) {
                            document.getElementById('deleteVoucherCode').innerText = code;
                            document.getElementById('deleteConfirmBtn').href = '${pageContext.request.contextPath}/admin/voucher-delete?id=' + id;
                            new bootstrap.Modal(document.getElementById('deleteModal')).show();
                        }
                    </script>
                </body>

                </html>