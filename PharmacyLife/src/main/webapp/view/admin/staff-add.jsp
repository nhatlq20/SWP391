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
                <style>
                    /* Balanced Override: Lowered slightly to prevent header overlap */
                    body .main-content.staff-main {
                        margin-top: 115px !important;
                        margin-left: 290px !important;
                        padding: 25px 30px !important;
                        position: relative !important;
                        z-index: 1 !important;
                    }

                    .staff-page {
                        width: 100% !important;
                        max-width: none !important; /* Expansion to two sides as requested */
                    }

                    @media (max-width: 1024px) {
                        .staff-main {
                            margin-left: 290px !important;
                            margin-top: 115px !important;
                        }
                    }

                    .staff-title-main {
                        display: flex !important;
                        align-items: center !important;
                        gap: 15px !important;
                        font-size: 24px !important;
                        font-weight: 700 !important;
                        color: #1e293b !important;
                        margin-bottom: 25px !important;
                    }

                    /* Sync Button styles with medicine */
                    .btn-cancel {
                        background: #f59e0b !important;
                        color: #fff !important;
                        border-radius: 10px !important;
                        padding: 10px 24px !important;
                        text-decoration: none !important;
                        font-weight: 600 !important;
                        font-size: 15px !important;
                        display: inline-flex !important;
                        align-items: center !important;
                        gap: 8px !important;
                        transition: all 0.2s !important;
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #3b82f6, #2563eb) !important;
                        color: white !important;
                        border: none !important;
                        border-radius: 10px !important;
                        padding: 10px 24px !important;
                        font-weight: 600 !important;
                        font-size: 15px !important;
                        cursor: pointer !important;
                        display: inline-flex !important;
                        align-items: center !important;
                        gap: 8px !important;
                        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3) !important;
                        transition: all 0.2s !important;
                    }

                    .btn-cancel:hover {
                        background: #d97706 !important;
                        color: #fff !important;
                    }

                    .btn-submit:hover {
                        background: linear-gradient(135deg, #2563eb, #1d4ed8) !important;
                        transform: translateY(-1px) !important;
                    }

                    /* Remove obsolete custom styles as we now use medicine-dashboard.css classes */
                </style>
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