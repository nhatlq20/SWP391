<%-- Document : staff-detail Created on : Feb 13, 2026, 1:21:06 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <title>Chi tiết nhân viên</title>
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
                                    <h3><i class="fas fa-user-circle me-2 text-primary"></i>Chi tiết nhân viên</h3>
                                </div>
                                
                                <div class="form-card-body">
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-id-card me-1"></i> Mã nhân viên</label>
                                            <div class="form-control-readonly">${staff.staffCode}</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-user-shield me-1"></i> Chức vụ</label>
                                            <div class="form-control-readonly">Nhân viên</div>
                                        </div>
                                        <div class="col-md-12">
                                            <label class="form-label"><i class="fas fa-user-tag me-1"></i> Họ và tên nhân viên</label>
                                            <div class="form-control-readonly">${staff.staffName}</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-phone me-1"></i> Số điện thoại</label>
                                            <div class="form-control-readonly">
                                                <c:choose>
                                                    <c:when test="${not empty staff.staffPhone}">${staff.staffPhone}</c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-venus-mars me-1"></i> Giới tính</label>
                                            <div class="form-control-readonly">
                                                <c:choose>
                                                    <c:when test="${not empty staff.staffGender}">${staff.staffGender}</c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-calendar-alt me-1"></i> Ngày sinh</label>
                                            <div class="form-control-readonly">
                                                <c:choose>
                                                    <c:when test="${not empty staff.staffDob}">
                                                        <fmt:formatDate value="${staff.staffDob}" pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label"><i class="fas fa-envelope me-1"></i> Email</label>
                                            <div class="form-control-readonly">${staff.staffEmail}</div>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label"><i class="fas fa-map-marker-alt me-1"></i> Địa chỉ</label>
                                            <div class="form-control-readonly">
                                                <c:choose>
                                                    <c:when test="${not empty staff.staffAddress}">${staff.staffAddress}</c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mt-5">
                                        <a href="${pageContext.request.contextPath}/admin/manage-staff" class="btn-back-sync">
                                            <i class="fas fa-chevron-left"></i> Quay lại
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </body>

                </html>