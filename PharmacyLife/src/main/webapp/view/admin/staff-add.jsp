<%-- Document : staff-add Created on : Feb 13, 2026, 1:20:29 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Thêm nhân viên</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

                        <div class="form-card">
                            <div class="form-card-header">
                                <h3><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm nhân viên mới</h3>
                            </div>
                            <div class="form-card-body">
                                <form method="POST" action="${pageContext.request.contextPath}/admin/manage-staff?action=insert"
                                    class="staff-form">

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffName" class="form-label">
                                                    <i class="fas fa-user-tag me-1"></i> Họ và tên nhân viên
                                                </label>
                                                <input type="text" id="staffName" name="staffName"
                                                    placeholder="Họ và tên nhân viên" required class="form-control">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-user-shield me-1"></i> Chức vụ
                                                </label>
                                                <input class="form-control" value="Nhân viên" readonly>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffEmail" class="form-label">
                                                    <i class="fas fa-envelope me-1"></i> Email
                                                </label>
                                                <input type="email" id="staffEmail" name="staffEmail"
                                                    placeholder="Email nhân viên" required class="form-control">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="staffPassword" class="form-label">
                                                    <i class="fas fa-lock me-1"></i> Mật khẩu
                                                </label>
                                                <input type="password" id="staffPassword" name="staffPassword"
                                                    placeholder="Mật khẩu" required class="form-control">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-actions d-flex justify-content-between mt-4">
                                        <a href="${pageContext.request.contextPath}/admin/manage-staff" class="btn-cancel">
                                            <i class="fas fa-chevron-left"></i> Trở lại
                                        </a>
                                        <button type="submit" class="btn-submit">
                                            <i class="fas fa-plus-circle"></i> Thêm nhân viên
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>

            </body>

            </html>