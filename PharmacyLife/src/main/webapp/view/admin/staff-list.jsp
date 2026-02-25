<%-- Document : staff-list Created on : Feb 13, 2026, 1:21:47 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Manage Staff</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                        <style>
                            /* Balanced Override: Lowered slightly to prevent header overlap */
                            body .main-content.staff-main {
                                margin-top: 110px !important; /* Balanced: was 85px (too high), 110px should clear header */
                                margin-left: 280px !important; 
                                padding-top: 20px !important; /* Moderate padding */
                                position: relative !important;
                                z-index: 1 !important;
                            }
                            
                            /* Adjust sidebar margin for list only if needed */
                            @media (min-width: 1025px) {
                                body .main-content.staff-main {
                                    margin-left: 280px !important;
                                }
                            }
                            
                            /* Force title, search and add button on the SAME horizontal line */
                            .staff-header {
                                display: flex !important;
                                flex-direction: row !important;
                                align-items: center !important;
                                justify-content: space-between !important;
                                flex-wrap: nowrap !important;
                                gap: 20px !important;
                                margin-bottom: 25px !important;
                            }

                            .staff-title {
                                display: flex !important;
                                align-items: center !important;
                                gap: 15px !important;
                                flex-shrink: 0 !important;
                                font-size: 24px !important;
                                font-weight: 700 !important;
                                color: #1e293b !important;
                            }

                            .staff-title img {
                                width: 32px !important;
                                height: 32px !important;
                                background: #1e293b;
                                border-radius: 6px;
                                padding: 4px;
                            }

                            .staff-actions {
                                display: flex !important;
                                align-items: center !important;
                                gap: 15px !important;
                                flex-grow: 1 !important;
                                justify-content: flex-end !important;
                            }

                            @media (max-width: 1100px) {
                                .staff-header {
                                    flex-wrap: wrap !important;
                                }
                            }

                            @media (max-width: 1024px) {
                                .staff-main {
                                    margin-left: 290px !important;
                                    margin-top: 115px !important;
                                }
                            }

                            /* Action Icon Styling */
                            .action-icons {
                                display: flex !important;
                                flex-direction: row !important;
                                justify-content: center !important;
                                gap: 12px !important;
                                align-items: center !important;
                            }
                            
                            .action-icons a {
                                display: inline-flex !important;
                                align-items: center !important;
                                justify-content: center !important;
                                width: 32px !important;
                                height: 32px !important;
                                border-radius: 50% !important;
                                transition: all 0.2s !important;
                            }

                            .action-icons a.view {
                                background-color: #e0f2fe !important;
                            }
                            
                            .action-icons a.view img {
                                width: 18px !important;
                                height: 18px !important;
                                filter: invert(58%) sepia(87%) saturate(1637%) hue-rotate(167deg) brightness(98%) contrast(97%);
                            }

                            .action-icons a.delete {
                                background-color: #fee2e2 !important;
                            }

                            .action-icons a.delete img {
                                width: 16px !important;
                                height: 16px !important;
                                filter: invert(27%) sepia(91%) saturate(5437%) hue-rotate(346deg) brightness(101%) contrast(106%);
                            }

                            .action-icons a:hover {
                                transform: scale(1.1) !important;
                            }
                        </style>
                    </head>

                    <body>

                        <jsp:include page="/view/common/header.jsp" />
                        <jsp:include page="/view/common/sidebar.jsp" />


                        <div class="main-content staff-main">
                            <div class="staff-page">
                                <div class="staff-header">
                                    <div class="staff-title">
                                        <img src="${pageContext.request.contextPath}/assets/img/Manage.png"
                                            alt="manage" />
                                        <div>Quản lí nhân viên</div>
                                    </div>
                                    <div class="staff-actions">
                                        <div class="staff-search">
                                            <input type="text" name="q" placeholder="Tìm tên, mã nhân viên" />
                                            <img src="${pageContext.request.contextPath}/assets/img/filter.png"
                                                alt="filter" style="width:20px;height:20px;" />
                                        </div>
                                        <a href="${pageContext.request.contextPath}/manage-staff?action=add"
                                            class="add-btn">
                                            <span style="display:inline-flex; align-items:center;">
                                                <img class="add-btn-icon"
                                                    src="${pageContext.request.contextPath}/assets/img/plus.png"
                                                    alt="plus" />
                                                <span>Thêm nhân viên mới</span>
                                            </span>
                                        </a>
                                    </div>
                                </div>

                                <div class="staff-card">
                                    <div class="table-responsive">
                                        <table class="staff-table">
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
                                                            <td>${s.staffCode}</td>
                                                            <td>${s.staffName}</td>
                                                            <td style="text-align:center;">
                                                                <span class="action-icons">
                                                                    <a href="${pageContext.request.contextPath}/manage-staff?action=detail&id=${s.staffId}"
                                                                        title="View" class="view">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/edit.svg"
                                                                            alt="view" />
                                                                    </a>
                                                                    <a href="javascript:void(0)" title="Delete"
                                                                        class="delete"
                                                                        onclick="showDeleteModal('${pageContext.request.contextPath}/manage-staff?action=delete&id=${s.staffId}', '${s.staffName}');">
                                                                        <img src="${pageContext.request.contextPath}/assets/img/delete.svg"
                                                                            alt="delete" />
                                                                    </a>
                                                                </span>
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
                                    <img src="${pageContext.request.contextPath}/assets/img/x.png" alt="delete"
                                        class="modal-icon" />
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