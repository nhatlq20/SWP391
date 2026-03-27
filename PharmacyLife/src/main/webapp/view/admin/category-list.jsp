<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lí danh mục</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
        
        </head>

        <body class="bg-light" data-open-add-category-modal="${not empty errorMessage}">
            <jsp:include page="/view/common/header.jsp" />
            <jsp:include page="/view/common/sidebar.jsp" />

          

            <div class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="page-title"><i class="fas fa-list me-2 text-primary"></i>Quản lí danh mục</h2>
                    <div class="category-actions d-flex align-items-center justify-content-end gap-3" style="gap: 18px;">
                        <form class="search-form mb-0" action="${pageContext.request.contextPath}/category" method="get">
                            <input type="hidden" name="action" value="search" />
                            <div class="search-box category-search">
                                <i class="fas fa-search"></i>
                                <input type="text" id="categorySearchInput" name="keyword"
                                    placeholder="Tìm tên danh mục, mã mục..." value="${param.keyword}"
                                    oninput="filterCategoryTable()"
                                    onkeydown="if(event.key==='Enter'){event.preventDefault(); filterCategoryTable();}">
                            </div>
                        </form>
                        <c:if
                            test="${sessionScope.userType eq 'staff' and fn:toLowerCase(fn:trim(sessionScope.roleName)) eq 'admin'}">
                            <button type="button" class="btn-add-medicine ms-2" data-bs-toggle="modal"
                                data-bs-target="#addCategoryModal">
                                <i class="fas fa-plus"></i> Thêm danh mục mới
                            </button>
                        </c:if>
                    </div>
                </div>
                  <c:if test="${not empty successMessage}">
                <div class="alert alert-success text-center" style="margin: 20px 0;">${successMessage}</div>
            </c:if>

                <div class="medicine-card">
                    <div class="table-responsive">
                        <table class="table medicine-table align-middle mb-0" id="categoryTable">
                                <thead>
                                    <tr>
                                        <th style="width: 220px;" class="ps-3">Mã mục</th>
                                        <th>Tên danh mục</th>
                                        <th style="width: 140px;" class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty categoryList}">
                                            <c:forEach items="${categoryList}" var="c">
                                                <tr class="category-row">
                                                    <td class="ps-3"><span class="category-code">${c.categoryCode}</span></td>
                                                    <td><span class="category-name-badge">${c.categoryName}</span></td>
                                                    <td class="text-center">
                                                        <div class="d-flex gap-1 justify-content-center">
                                                            <a href="${pageContext.request.contextPath}/category?action=detail&id=${c.categoryId}"
                                                                class="btn-action btn-view" title="Xem chi tiết" style="text-decoration:none"><i
                                                                    class="fas fa-eye"></i></a>
                                                            <c:if
                                                                test="${sessionScope.userType eq 'staff' and fn:toLowerCase(fn:trim(sessionScope.roleName)) eq 'admin'}">
                                                                <a href="${pageContext.request.contextPath}/category?action=delete&id=${c.categoryId}"
                                                                    class="btn-action btn-delete js-delete-btn" title="Xóa" style="text-decoration:none"><i
                                                                        class="fas fa-trash"></i></a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center py-4 text-muted">Không có danh mục
                                                    nào.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                    </div>
                </div>
            </div>

            <c:if
                test="${sessionScope.userType eq 'staff' and fn:toLowerCase(fn:trim(sessionScope.roleName)) eq 'admin'}">
                <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <div class="modal-header">
                                <h5 class="modal-title">Thêm danh mục mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/category" method="post">
                                <input type="hidden" name="action" value="insert" />
                                <div class="modal-body">
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger py-2 mb-3" role="alert">${errorMessage}</div>
                                    </c:if>

                                    <div class="mb-3">
                                        <label class="form-label" for="modalCategoryCode">Mã mục</label>
                                        <input type="text" id="modalCategoryCode" class="form-control"
                                            value="${nextCategoryCode}" readonly>
                                    </div>

                                    <div class="mb-0">
                                        <label class="form-label" for="modalCategoryName">Tên danh mục</label>
                                        <input type="text" id="modalCategoryName" name="categoryName"
                                            class="form-control" placeholder="Nhập tên danh mục"
                                            value="${categoryNameInput}" required />
                                    </div>
<!-- ============================================================================= -->
                                    <div class="mt-3 mb-0">
                                        <label class="form-label" for="modalCategoryImageSelect">Chọn ảnh có sẵn</label>
                                        <select id="modalCategoryImageSelect" name="categoryImageUrl" class="form-select">
                                            <option value="">-- Chọn ảnh từ danh sách --</option>
                                            <c:choose>
                                                <c:when test="${not empty categoryImageOptions}">
                                                    <c:forEach items="${categoryImageOptions}" var="imgPath">
                                                        <option value="${imgPath}" ${imgPath eq categoryImageUrlInput ? 'selected' : ''}>${imgPath}</option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach begin="1" end="18" var="i">
                                                        <c:set var="defaultPath" value="/assets/img/category/${i}.png" />
                                                        <option value="${defaultPath}" ${defaultPath eq categoryImageUrlInput ? 'selected' : ''}>${defaultPath}</option>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </div>

                                    <div class="mt-3 mb-0">
                                        <img id="categoryImagePreview" src="" alt="Preview ảnh danh mục"
                                            style="display:none; width: 90px; height: 90px; object-fit: cover; border: 1px solid #dee2e6; border-radius: 8px;" />
                                    </div>

                            <!-- ======================================================= -->
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Thêm</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

                <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <div class="modal-header">
                                <h5 class="modal-title">Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Bạn có chắc muốn xóa danh mục này không?
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xóa</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    (() => {
                        let deleteUrl = null;
                        const modalElement = document.getElementById('deleteCategoryModal');
                        const modal = new bootstrap.Modal(modalElement);
                        const confirmBtn = document.getElementById('confirmDeleteBtn');

                        document.querySelectorAll('.js-delete-btn').forEach((button) => {
                            button.addEventListener('click', (event) => {
                                event.preventDefault();
                                deleteUrl = button.getAttribute('href');
                                modal.show();
                            });
                        });

                        confirmBtn.addEventListener('click', () => {
                            if (deleteUrl) {
                                window.location.href = deleteUrl;
                            }
                        });

                        const shouldOpenAddModal = document.body.dataset.openAddCategoryModal === 'true';
                        if (shouldOpenAddModal) {
                            const addModalEl = document.getElementById('addCategoryModal');
                            if (addModalEl) {
                                new bootstrap.Modal(addModalEl).show();
                            }
                        }

                        const categoryImageSelect = document.getElementById('modalCategoryImageSelect');
                        const categoryImagePreview = document.getElementById('categoryImagePreview');
                        if (categoryImageSelect && categoryImagePreview) {
                            const setPreview = () => {
                                const selectedPath = categoryImageSelect.value;
                                if (!selectedPath) {
                                    categoryImagePreview.style.display = 'none';
                                    categoryImagePreview.src = '';
                                    return;
                                }
                                categoryImagePreview.src = '${pageContext.request.contextPath}' + selectedPath;
                                categoryImagePreview.style.display = 'block';
                            };

                            categoryImageSelect.addEventListener('change', setPreview);
                            setPreview();
                        }
                    })();

                    function filterCategoryTable() {
                        var input = document.getElementById('categorySearchInput').value.toLowerCase();
                        var rows = document.querySelectorAll('#categoryTable tbody .category-row');
                        var found = false;

                        if (rows.length === 0) {
                            return;
                        }

                        rows.forEach(function (row) {
                            var text = row.textContent.toLowerCase();
                            var show = text.includes(input);
                            row.style.display = show ? '' : 'none';
                            if (show) found = true;
                        });

                        var emptyRow = document.querySelector('#categoryTable tbody .empty-state-row');

                        if (!found && input !== '') {
                            if (!emptyRow) {
                                emptyRow = document.createElement('tr');
                                emptyRow.className = 'empty-state-row';
                                emptyRow.innerHTML = '<td colspan="3" class="text-center py-5 text-muted"><i class="fas fa-box-open fa-3x mb-3 d-block"></i><p class="mb-0">Không tìm thấy dữ liệu phù hợp</p></td>';
                                document.querySelector('#categoryTable tbody').appendChild(emptyRow);
                            }
                            emptyRow.style.display = '';
                        } else if (emptyRow) {
                            emptyRow.style.display = 'none';
                        }
                    }
                </script>
            </body>

            </html>