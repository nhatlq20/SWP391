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
                    </head>

                    <body>

                        <jsp:include page="/view/common/header.jsp" />
                        <jsp:include page="/view/common/sidebar.jsp" />


                        <div class="main-content staff-main" style="padding:20px; margin-top:110px;">
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
                                            <span style="display:inline-flex; align-items:center; gap:6px;">
                                                <img class="add-btn-icon"
                                                    src="${pageContext.request.contextPath}/assets/img/plus.png"
                                                    alt="plus" />
                                                <span>Thêm nhân viên mới</span>
                                            </span>
                                        </a>
                                    </div>
                                </div>

                                <div class="staff-card">
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

                        <style>
                            .delete-modal-overlay {
                                position: fixed;
                                top: 0;
                                left: 0;
                                right: 0;
                                bottom: 0;
                                background-color: rgba(0, 0, 0, 0.5);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 1000;
                            }

                            .delete-modal {
                                background: white;
                                border-radius: 12px;
                                padding: 40px 30px;
                                max-width: 380px;
                                width: 90%;
                                position: relative;
                                text-align: center;
                                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                            }

                            .modal-close-btn {
                                position: absolute;
                                top: 12px;
                                right: 12px;
                                background: none;
                                border: none;
                                font-size: 28px;
                                color: #999;
                                cursor: pointer;
                                width: 32px;
                                height: 32px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                            }

                            .modal-close-btn:hover {
                                color: #333;
                            }

                            .modal-icon {
                                width: 80px;
                                height: 80px;
                                margin: 0 auto 20px;
                                display: block;
                            }

                            .modal-title {
                                font-size: 20px;
                                font-weight: 700;
                                margin: 0 0 12px;
                                color: #333;
                            }

                            .modal-text {
                                font-size: 14px;
                                color: #666;
                                margin: 0 0 30px;
                                line-height: 1.6;
                            }

                            .modal-actions {
                                display: flex;
                                gap: 12px;
                                justify-content: center;
                            }

                            .btn-cancel {
                                background: #4B9BFF;
                                color: white;
                                border: none;
                                padding: 10px 28px;
                                border-radius: 18px;
                                font-size: 14px;
                                font-weight: 600;
                                cursor: pointer;
                                transition: background 0.3s;
                            }

                            .btn-cancel:hover {
                                background: #357ABD;
                            }

                            .btn-confirm {
                                background: #FF5252;
                                color: white;
                                border: none;
                                padding: 10px 28px;
                                border-radius: 18px;
                                font-size: 14px;
                                font-weight: 600;
                                cursor: pointer;
                                transition: background 0.3s;
                            }

                            .btn-confirm:hover {
                                background: #E63946;
                            }
                        </style>

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