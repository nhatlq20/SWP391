<%-- Document : staff-list Created on : Feb 13, 2026, 1:21:47 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Quản lý nhân viên - PharmacyLife</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    </head>

                    <body class="bg-light">

                        <jsp:include page="/view/common/header.jsp" />
                        <jsp:include page="/view/common/sidebar.jsp" />


                        <div class="main-content staff-main">
                            <div class="staff-page">
                                <div class="staff-header">
                                    <h3 class="fw-bold mb-0">
                                        <i class="fas fa-users me-2 text-primary"></i>Quản lí nhân viên
                                    </h3>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="search-box">
                                            <i class="fas fa-search"></i>
                                            <input type="text" name="q" id="staffSearchInput"
                                                placeholder="Tìm tên, mã nhân viên..."
                                                oninput="filterStaffTable()" />
                                        </div>
                                        <div class="filter-dropdown">
                                            <button class="btn-action btn-view" title="Lọc" 
                                                onclick="toggleFilterMenu(event)">
                                                <i class="fas fa-filter"></i>
                                            </button>
                                            <div class="filter-menu" id="filterMenu">
                                                <a href="${pageContext.request.contextPath}/admin/manage-staff?action=list" 
                                                   class="filter-item ${empty currentSort ? 'active' : ''}">Mặc định</a>
                                                <a href="${pageContext.request.contextPath}/admin/manage-staff?action=list&sort=asc" 
                                                   class="filter-item ${currentSort == 'asc' ? 'active' : ''}">
                                                   <i class="fas fa-arrow-up me-2"></i>Tăng dần
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/manage-staff?action=list&sort=desc" 
                                                   class="filter-item ${currentSort == 'desc' ? 'active' : ''}">
                                                   <i class="fas fa-arrow-down me-2"></i>Giảm dần
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end mb-3">
                                    <a href="${pageContext.request.contextPath}/admin/manage-staff?action=add"
                                        class="btn-add-staff">
                                        <i class="fas fa-plus"></i> Thêm nhân viên mới
                                    </a>
                                </div>

                                <div class="staff-card">
                                    <div class="table-responsive">
                                        <table class="staff-table" id="staffTable">
                                            <thead>
                                                <tr>
                                                    <th style="width:200px;">Mã nhân viên</th>
                                                    <th>Tên nhân viên</th>
                                                    <th style="width:160px; text-align:center;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <c:choose>
                                                <c:when test="${not empty staffList}">
                                                    <c:forEach var="s" items="${staffList}">
                                                        <tr>
                                                            <td><strong>${s.staffCode}</strong></td>
                                                            <td>${s.staffName}</td>
                                                            <td style="text-align:center;">
                                                                <div class="action-icons">
                                                                    <a href="${pageContext.request.contextPath}/admin/manage-staff?action=detail&id=${s.staffId}"
                                                                        class="btn-action btn-view" title="Xem chi tiết">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <a href="javascript:void(0)" 
                                                                        class="btn-action btn-delete" title="Xóa"
                                                                        onclick="showDeleteModal('${pageContext.request.contextPath}/admin/manage-staff?action=delete&id=${s.staffId}', '${s.staffName}');">
                                                                        <i class="fas fa-trash"></i>
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="3" style="text-align:center; padding:30px;">Không
                                                            tìm thấy nhân viên</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Confirmation Modal -->
                        <div id="deleteModal" class="delete-modal-overlay" style="display:none;">
                            <div class="delete-modal">
                                <button class="modal-close-btn" onclick="closeDeleteModal()">×</button>
                                <div class="modal-content">
                                    <div class="modal-icon-box" style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid #fee2e2; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                                        <i class="fas fa-times" style="font-size: 36px; color: #ef4444;"></i>
                                    </div>
                                    <h2 class="modal-title">Bạn có chắc không?</h2>
                                    <p class="modal-text">Bạn thực sự muốn xóa nhân viên <strong
                                            id="staffNameToDelete"></strong> sao? Quá trình này không thể hoàn tác.</p>
                                    <div class="modal-actions">
                                        <button class="btn-cancel" onclick="closeDeleteModal()">Hủy bỏ</button>
                                        <button class="btn-confirm" onclick="confirmDelete()">Xóa</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            function toggleFilterMenu(event) {
                                event.stopPropagation();
                                document.getElementById('filterMenu').classList.toggle('show');
                            }

                            window.onclick = function(event) {
                                if (!event.target.matches('.btn-view') && !event.target.matches('.fa-filter')) {
                                    var dropdowns = document.getElementsByClassName("filter-menu");
                                    for (var i = 0; i < dropdowns.length; i++) {
                                        var openDropdown = dropdowns[i];
                                        if (openDropdown.classList.contains('show')) {
                                            openDropdown.classList.remove('show');
                                        }
                                    }
                                }
                            }

                            function filterStaffTable() {
                                var input = document.getElementById('staffSearchInput').value.toLowerCase();
                                var rows = document.querySelectorAll('#staffTable tbody tr');
                                rows.forEach(function (row) {
                                    var text = row.textContent.toLowerCase();
                                    row.style.display = text.includes(input) ? '' : 'none';
                                });
                            }

                            var deleteUrl = '';

                            function showDeleteModal(url, staffName) {
                                deleteUrl = url;
                                document.getElementById('staffNameToDelete').textContent = staffName;
                                document.getElementById('deleteModal').style.display = 'flex';
                            }

                            function closeDeleteModal() {
                                document.getElementById('deleteModal').style.display = 'none';
                                deleteUrl = '';
                            }

                            function confirmDelete() {
                                if (deleteUrl) {
                                    window.location.href = deleteUrl;
                                }
                            }

                            // Close modal when clicking outside
                            document.getElementById('deleteModal').addEventListener('click', function (e) {
                                if (e.target === this) {
                                    closeDeleteModal();
                                }
                            });
                        </script>

                    </body>

                    </html>