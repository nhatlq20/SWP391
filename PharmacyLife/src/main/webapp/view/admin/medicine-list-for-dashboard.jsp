<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý thuốc - PharmacyLife</title>
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
                        <!-- Page Header: Title + Search -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="fw-bold mb-0"><i class="fas fa-pills me-2 text-primary"></i>Quản lí thuốc</h3>
                            <div class="d-flex align-items-center gap-2">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="medicineSearchInput"
                                        placeholder="Tìm tên thuốc, mã thuốc,..." oninput="filterTable()"
                                        onkeydown="if(event.key==='Enter'){event.preventDefault(); filterTable();}">
                                </div>
                                <button class="btn-action btn-view" title="Lọc" style="width:40px;height:40px;">
                                    <i class="fas fa-filter"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Statistics -->
                        <div class="stats-row">
                            <div class="stat-card stat-total">
                                <div class="stat-number">${medicines.size()}</div>
                                <div class="stat-label">Tổng sản phẩm</div>
                            </div>
                            <div class="stat-card stat-instock">
                                <c:set var="inStockCount" value="0" />
                                <c:forEach var="med" items="${medicines}">
                                    <c:if test="${med.remainingQuantity > 20}">
                                        <c:set var="inStockCount" value="${inStockCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                <div class="stat-number">${inStockCount}</div>
                                <div class="stat-label">Còn hàng</div>
                            </div>
                            <div class="stat-card stat-low">
                                <c:set var="lowStockCount" value="0" />
                                <c:forEach var="med" items="${medicines}">
                                    <c:if test="${med.remainingQuantity > 0 && med.remainingQuantity <= 20}">
                                        <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                <div class="stat-number">${lowStockCount}</div>
                                <div class="stat-label">Sắp hết hàng</div>
                            </div>
                            <div class="stat-card stat-out">
                                <c:set var="outStockCount" value="0" />
                                <c:forEach var="med" items="${medicines}">
                                    <c:if test="${med.remainingQuantity == 0}">
                                        <c:set var="outStockCount" value="${outStockCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                <div class="stat-number">${outStockCount}</div>
                                <div class="stat-label">Hết hàng</div>
                            </div>
                        </div>

                        <!-- Add Button -->
                        <div class="d-flex justify-content-end mb-3">
                            <a href="${pageContext.request.contextPath}/admin/medicine-add-dashboard"
                                class="btn-add-medicine">
                                <i class="fas fa-plus"></i> Thêm thuốc mới
                            </a>
                        </div>

                        <!-- Medicine Table -->
                        <div class="medicine-card">

                            <c:choose>
                                <c:when test="${empty medicines}">
                                    <div class="empty-state">
                                        <i class="fas fa-inbox"></i>
                                        <h4>Chưa có thuốc nào</h4>
                                        <p>Hãy thêm thuốc đầu tiên của bạn</p>
                                        <a href="${pageContext.request.contextPath}/admin/medicine-add-dashboard"
                                            class="btn-add-medicine mt-3">
                                            <i class="fas fa-plus"></i> Thêm thuốc mới
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table medicine-table align-middle" id="medicineTable">
                                            <thead>
                                                <tr>
                                                    <th>Mã</th>
                                                    <th>Ảnh</th>
                                                    <th>Tên thuốc</th>
                                                    <th>Giá</th>
                                                    <th>Đơn vị</th>
                                                    <th>Danh mục</th>
                                                    <th>Số lượng</th>
                                                    <th>Trạng thái</th>
                                                    <th style="width:130px">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="medicine" items="${medicines}">
                                                    <tr>
                                                        <td><strong>${medicine.medicineCode}</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty medicine.imageUrl}">
                                                                    <c:set var="imageUrlTrimmed"
                                                                        value="${fn:trim(medicine.imageUrl)}" />
                                                                    <c:set var="imgSrc" value="" />
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                            <c:set var="imgSrc"
                                                                                value="${imageUrlTrimmed}" />
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                            <c:set var="imgSrc"
                                                                                value="${pageContext.request.contextPath}${imageUrlTrimmed}" />
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${fn:contains(imageUrlTrimmed, 'assets')}">
                                                                            <c:set var="imgSrc"
                                                                                value="${pageContext.request.contextPath}/${imageUrlTrimmed}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set var="imgSrc"
                                                                                value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <img src="<c:out value='${imgSrc}'/>"
                                                                        alt="${medicine.medicineName}"
                                                                        class="medicine-img"
                                                                        onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div class=\'medicine-img-placeholder\'><i class=\'fas fa-pills\'></i></div>';">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="medicine-img-placeholder"><i
                                                                            class="fas fa-pills"></i></div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="medicine-name-cell">
                                                                <div class="name">${medicine.medicineName}</div>
                                                                <c:if test="${not empty medicine.shortDescription}">
                                                                    <div class="desc">${medicine.shortDescription}</div>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="price">
                                                                <fmt:formatNumber value="${medicine.sellingPrice}"
                                                                    type="number" groupingUsed="true" />đ
                                                            </span>
                                                        </td>
                                                        <td>${medicine.unit}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty medicine.category}">
                                                                    <span
                                                                        class="category-badge">${medicine.category.categoryName}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">—</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><strong>${medicine.remainingQuantity}</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${medicine.remainingQuantity > 20}">
                                                                    <span class="badge badge-stock">Còn hàng</span>
                                                                </c:when>
                                                                <c:when test="${medicine.remainingQuantity > 0}">
                                                                    <span class="badge badge-low">Sắp hết</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-out">Hết hàng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-1">
                                                                <a href="${pageContext.request.contextPath}/medicine/detail?id=${medicine.medicineId}"
                                                                    class="btn-action btn-view" title="Xem chi tiết"
                                                                    style="text-decoration:none">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/medicine-edit-dashboard?id=${medicine.medicineId}"
                                                                    class="btn-action btn-edit" title="Sửa"
                                                                    style="text-decoration:none">
                                                                    <i class="fas fa-pen"></i>
                                                                </a>
                                                                <button class="btn-action btn-delete" title="Xóa"
                                                                    onclick="openDeleteModal('${medicine.medicineId}', '${medicine.medicineName}')">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade modal-confirm" id="deleteModal" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered modal-sm">
                            <div class="modal-content">
                                <div class="modal-body">
                                    <button type="button" class="btn-close position-absolute top-0 end-0 m-3"
                                        data-bs-dismiss="modal"></button>
                                    <div class="icon-box">
                                        <i class="fas fa-times"></i>
                                    </div>
                                    <h4>Bạn có chắc không?</h4>
                                    <p>Bạn thực sự muốn xóa thuốc này?<br>Quá trình này không thể hoàn tác.</p>
                                    <div class="d-flex justify-content-center gap-3 mt-3">
                                        <button type="button" class="btn-cancel-modal" data-bs-dismiss="modal">Hủy
                                            bỏ</button>
                                        <a href="#" id="deleteLink"
                                            class="btn-delete-modal text-decoration-none">Xóa</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function openDeleteModal(id, name) {
                            document.getElementById('deleteLink').href =
                                '${pageContext.request.contextPath}/admin/medicine-delete-dashboard?id=' + id;
                            var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
                            modal.show();
                        }

                        function filterTable() {
                            var input = document.getElementById('medicineSearchInput').value.toLowerCase();
                            var rows = document.querySelectorAll('#medicineTable tbody tr');
                            var found = false;
                            rows.forEach(function (row) {
                                if (row.classList.contains('empty-state-row')) return;
                                var text = row.textContent.toLowerCase();
                                var show = text.includes(input);
                                row.style.display = show ? '' : 'none';
                                if (show) found = true;
                            });
                            var emptyRow = document.querySelector('#medicineTable .empty-state-row');
                            if (!found && input !== '') {
                                if (!emptyRow) {
                                    emptyRow = document.createElement('tr');
                                    emptyRow.className = 'empty-state-row';
                                    emptyRow.innerHTML = '<td colspan="9" class="text-center py-5 text-muted"><i class="fas fa-box-open fa-3x mb-3 d-block"></i><p>Không tìm thấy dữ liệu phù hợp</p></td>';
                                    document.querySelector('#medicineTable tbody').appendChild(emptyRow);
                                }
                                emptyRow.style.display = '';
                            } else if (emptyRow) {
                                emptyRow.style.display = 'none';
                            }
                        }
                    </script>
                </body>

                </html>