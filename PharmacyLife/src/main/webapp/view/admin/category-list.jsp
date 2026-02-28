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
            <style>
                body {
                    background: #f3f4f8;
                }

                .page-title {
                    font-size: 1.6rem;
                    font-weight: 700;
                    margin: 0;
                    color: #1e293b;
                }

                .category-actions {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .category-search {
                    width: 280px;
                }

                .category-code {
                    font-weight: 700;
                    color: #1e293b;
                    letter-spacing: .2px;
                }

                .category-name-badge {
                    display: inline-block;
                    background: #eef2ff;
                    color: #3b82f6;
                    border-radius: 6px;
                    padding: 4px 10px;
                    font-size: .85rem;
                    font-weight: 500;
                }
            </style>
        </head>

        <body class="bg-light">
            <jsp:include page="/view/common/header.jsp" />
            <jsp:include page="/view/common/sidebar.jsp" />

            <div class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="page-title"><i class="fas fa-list me-2 text-primary"></i>Quản lí danh mục</h2>
                    <div class="category-actions">
                        <form class="search-form" action="${pageContext.request.contextPath}/category" method="get">
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
                            <a href="${pageContext.request.contextPath}/category?action=show"
                                class="btn-add-medicine">
                                <i class="fas fa-plus"></i> Thêm danh mục mới
                            </a>
                        </c:if>
                    </div>
                </div>

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