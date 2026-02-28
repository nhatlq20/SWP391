<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Quản lí danh mục</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">            
            <style>
                body {
                    background: #f3f4f8;
                }

                .sidebar-wrapper {
                    top: 115px !important;
                    height: calc(100vh - 115px) !important;
                    z-index: 100;
                }

                .main-content {
                    margin-left: 275px;
                    margin-top: 115px;
                    padding: 24px;
                }

                .page-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 18px;
                }

                .page-title {
                    font-size: 1.75rem;
                    font-weight: 700;
                    margin: 0;
                    color: #080808;
                }

                .actions {
                    display: flex;
                    gap: 12px;
                    align-items: center;
                }

                .search-form {
                    display: flex;
                    align-items: center;
                }

                .search-box {
                    position: relative;
                    max-width: 280px;
                    width: 280px;
                }

                .search-box input {
                    border: 1px solid #e5e7eb;
                    border-radius: 10px;
                    padding: 8px 14px 8px 38px;
                    font-size: 0.9rem;
                    width: 100%;
                }

                .search-box input:focus {
                    outline: none;
                    border-color: #3b82f6;
                    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                }

                .search-box i {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #9ca3af;
                }

                .btn-radius {
                    border-radius: 24px;
                }

                .card {

                    border: 0;
                    border-radius: 12px;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
                }

                .table thead th {
                    background: #f1f3f5;
                    border-top: 0;
                }

                .action-icons {
                    display: flex;
                    align-items: center;
                   margin-left: 100px;
                    gap: 4px;
        
                }

                .btn-action {
                    width: 34px;
                    height: 34px;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: none;
                    font-size: 14px;
                    transition: all 0.2s;
                    cursor: pointer;
                    text-decoration: none !important;
                  
                }

                .btn-action:hover,
                .btn-action:focus,
                .btn-action:active {
                    text-decoration: none !important;
                }

                .btn-view {
                    background: #dbeafe;
                    color: #2563eb;
                 
                }

                .btn-view:hover {
                    background: #bfdbfe;
                    color: #2563eb;
                }

                .btn-delete {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .btn-delete:hover {
                    background: #fecaca;
                    color: #dc2626;
                }
            </style>
        </head>

        <body>
            <jsp:include page="/view/common/header.jsp" />
            <jsp:include page="/view/common/sidebar.jsp" />

            <div class="main-content">
                <div class="page-header">
                    <h2 class="page-title"><i class="fas fa-list me-2 text-primary"></i>Quản lí danh mục</h2>
                    <div class="actions">
                        <form class="search-form" action="${pageContext.request.contextPath}/category" method="get">
                            <input type="hidden" name="action" value="search" />
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="categorySearchInput" name="keyword"
                                    placeholder="Tìm tên danh mục, mã mục..." value="${param.keyword}"
                                    oninput="filterCategoryTable()"
                                    onkeydown="if(event.key==='Enter'){event.preventDefault(); filterCategoryTable();}">
                            </div>
                     
                        </form>
                        <c:if
                            test="${sessionScope.userType eq 'staff' and fn:toLowerCase(fn:trim(sessionScope.roleName)) eq 'admin'}">
                            <a href="${pageContext.request.contextPath}/category?action=show"
                                class="btn btn-primary btn-radius">
                                <i class="fas fa-plus me-1 text-primary" ></i>Thêm danh mục mới
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" id="categoryTable">
                                <thead>
                                    <tr>
                                        <th style="width: 220px;" class="ps-3">Mã mục</th>
                                        <th>Tên danh mục</th>
                                        <th style="width: 220px;" class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty categoryList}">
                                            <c:forEach items="${categoryList}" var="c">
                                                <tr class="category-row">
                                                    <td class="ps-3">${c.categoryCode}</td>
                                                    <td>${c.categoryName}</td>
                                                    <td class="text-center">
                                                        <div class="action-icons">
                                                            <a href="${pageContext.request.contextPath}/category?action=detail&id=${c.categoryId}"
                                                                class="btn-action btn-view" title="Xem chi tiết"><i
                                                                    class="fas fa-eye"></i></a>
                                                            <c:if
                                                                test="${sessionScope.userType eq 'staff' and fn:toLowerCase(fn:trim(sessionScope.roleName)) eq 'admin'}">
                                                                <a href="${pageContext.request.contextPath}/category?action=delete&id=${c.categoryId}"
                                                                    class="btn-action btn-delete js-delete-btn" title="Xóa"><i
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
            </div>

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

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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