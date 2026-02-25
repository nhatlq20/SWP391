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
                        <style>
                            /* Sync with Medicine Management Layout */
                            body .main-content.staff-main {
                                margin-top: 115px !important; 
                                margin-left: 290px !important; 
                                padding: 25px 30px !important;
                                min-height: calc(100vh - 115px) !important;
                            }
                            
                            .staff-page {
                                width: 100% !important;
                                max-width: none !important;
                                margin: 0 !important;
                                padding: 0 !important;
                            }

                            .staff-header {
                                display: flex !important;
                                flex-direction: row !important;
                                align-items: center !important;
                                justify-content: space-between !important;
                                gap: 20px !important;
                                margin-bottom: 24px !important;
                            }

                            /* Table Header Sync with Medicine */
                            table.staff-table th {
                                background: linear-gradient(90deg, #eef3ff, #e8efff) !important;
                                color: #1e3a8a !important;
                                font-weight: 600 !important;
                                font-size: 0.85rem !important;
                                padding: 14px 24px !important;
                                border-bottom: none !important;
                                white-space: nowrap !important;
                            }

                            /* Action Icon Styling */
                            .action-icons {
                                display: flex !important;
                                gap: 8px !important;
                                justify-content: center !important;
                            }
                            
                            .btn-action {
                                width: 34px !important;
                                height: 34px !important;
                                border-radius: 8px !important;
                                display: inline-flex !important;
                                align-items: center !important;
                                justify-content: center !important;
                                text-decoration: none !important;
                                transition: all 0.2s !important;
                            }

                            .btn-view {
                                background: #dbeafe !important;
                                color: #2563eb !important;
                            }

                            .btn-view:hover {
                                background: #bfdbfe !important;
                                color: #2563eb !important;
                            }

                            .btn-delete {
                                background: #fee2e2 !important;
                                color: #dc2626 !important;
                            }

                            .btn-delete:hover {
                                background: #fecaca !important;
                                color: #dc2626 !important;
                            }

                            .btn-add-staff {
                                background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
                                color: #fff !important;
                                border: none !important;
                                border-radius: 10px !important;
                                padding: 10px 22px !important;
                                font-weight: 600 !important;
                                font-size: 0.9rem !important;
                                transition: all 0.2s !important;
                                text-decoration: none !important;
                                display: inline-flex !important;
                                align-items: center !important;
                                gap: 8px !important;
                                box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2) !important;
                            }

                            .btn-add-staff:hover {
                                background: linear-gradient(135deg, #2563eb, #1d4ed8) !important;
                                color: #fff !important;
                                transform: translateY(-1px) !important;
                                box-shadow: 0 6px 10px -1px rgba(37, 99, 235, 0.3) !important;
                            }

                            /* Search Box Sync */
                            .search-box {
                                position: relative !important;
                                width: 280px !important;
                            }

                            .search-box input {
                                border: 1px solid #e5e7eb !important;
                                border-radius: 10px !important;
                                padding: 8px 14px 8px 38px !important;
                                font-size: 0.9rem !important;
                                width: 100% !important;
                            }

                            .search-box i {
                                position: absolute !important;
                                left: 12px !important;
                                top: 50% !important;
                                transform: translateY(-50%) !important;
                                color: #9ca3af !important;
                            }
                        </style>
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
                                        <button class="btn-action btn-view" title="Lọc" style="width:40px;height:40px;">
                                            <i class="fas fa-filter"></i>
                                        </button>
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