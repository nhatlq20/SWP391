<%-- Document : staff-detail Created on : Feb 13, 2026, 1:21:06 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <title>Chi tiết nhân viên</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                    <style>
                        /* Balanced Override: Lowered slightly to prevent header overlap */
                        body .main-content.staff-main {
                            margin-top: 110px !important;
                            margin-left: 280px !important;
                            padding-top: 15px !important;
                            position: relative !important;
                            z-index: 1 !important;
                        }
                        @media (max-width: 1024px) {
                            .staff-main {
                                margin-left: 290px !important;
                                margin-top: 115px !important;
                            }
                        }

                        .staff-title {
                            display: flex !important;
                            align-items: center !important;
                            gap: 15px !important;
                            font-size: 24px !important;
                            font-weight: 700 !important;
                            color: #1e293b !important;
                            margin-bottom: 25px !important;
                        }

                        .staff-title img {
                            width: 32px !important;
                            height: 32px !important;
                            background: #1e293b;
                            border-radius: 6px;
                            padding: 4px;
                        }

                        /* Make detail card more prominent */
                        .detail-card {
                            background: #ffffff !important;
                            padding: 30px !important;
                            margin: 0 auto 20px !important;
                            border-radius: 16px !important;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06) !important;
                            border: 1px solid #f1f5f9 !important;
                            max-width: 800px !important;
                        }

                        .detail-grid {
                            gap: 15px 25px !important;
                        }

                        .field-label {
                            font-size: 13px !important;
                            color: #64748b !important;
                            font-weight: 600 !important;
                            margin-bottom: 6px !important;
                        }

                        .field-box {
                            background: #f8fafc !important;
                            border: 1px solid #e2e8f0 !important;
                            border-radius: 8px !important;
                            min-height: 42px !important;
                            padding: 10px 15px !important;
                            color: #1e293b !important;
                            font-weight: 500 !important;
                        }

                        .detail-header-title {
                            margin-bottom: 20px !important;
                            font-size: 20px !important;
                            color: #1e293b !important;
                            border-bottom: 1px solid #f1f5f9 !important;
                            padding-bottom: 15px !important;
                        }

                        .back-link {
                            background: #f1f5f9 !important;
                            color: #475569 !important;
                            border-radius: 8px !important;
                            padding: 10px 24px !important;
                            text-decoration: none !important;
                            font-weight: 600 !important;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            margin-top: 20px !important;
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
                                    <img src="${pageContext.request.contextPath}/assets/img/Manage.png" alt="manage" />
                                    <div>Quản lí nhân viên</div>
                                </div>
                            </div>

                            <div class="detail-card">
                                <h2 class="detail-header-title">Xem chi tiết nhân viên</h2>

                                <div class="detail-grid">
                                    <div class="form-field">
                                        <label>Họ và tên</label>
                                        <div class="field-box">${staff.staffName}</div>
                                    </div>
                                    <div class="form-field">
                                        <label>Số điện thoại</label>
                                        <div class="field-box">${staff.staffPhone}</div>
                                    </div>

                                    <div class="form-field">
                                        <label>Giới tính</label>
                                        <div class="field-box">
                                            <c:choose>
                                                <c:when test="${not empty staff.staffGender}">${staff.staffGender}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="form-field">
                                        <label>Ngày sinh</label>
                                        <div class="field-box">
                                            <c:choose>
                                                <c:when test="${not empty staff.staffDob}">
                                                    <fmt:formatDate value="${staff.staffDob}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="form-field wide">
                                        <label>Email</label>
                                        <div class="field-box">${staff.staffEmail}</div>
                                    </div>

                                    <div class="form-field wide">
                                        <label>Địa chỉ</label>
                                        <div class="field-box">
                                            <c:choose>
                                                <c:when test="${not empty staff.staffAddress}">${staff.staffAddress}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                </div>

                                <div style="text-align:right; margin-top:18px;">
                                    <a class="add-btn detail-close-btn"
                                        href="${pageContext.request.contextPath}/manage-staff">Đóng</a>
                                </div>
                            </div>

                        </div>
                    </div>

                </body>

                </html>